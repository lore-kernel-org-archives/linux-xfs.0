Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44374 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbeKKDwS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 22:52:18 -0500
Date: Sat, 10 Nov 2018 10:06:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/6] xfs_scrub: move everything to /usr/sbin
Message-ID: <20181110180616.GC4235@magnolia>
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <154181075273.3727.12563703121689677996.stgit@magnolia>
 <5BE69A4E.2050902@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5BE69A4E.2050902@tlinx.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: L A Walsh <xfs@tlinx.org>
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

On Sat, Nov 10, 2018 at 12:43:58AM -0800, L A Walsh wrote:
> 
> 
> On 11/9/2018 4:45 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Recently, it was pointed out that xfs_scrub{,_all} depend on components
> > and libraries (libicu, python) that live in /usr.  /sbin binaries
> > shouldn't depend on /usr, so let's move the scrub binaries to /usr/sbin.
> ----
> 	As stated in the original comment, only "xfs_scrub_all"
> depends on /usr, as it depends on /usr/bin/python.
> 
> System binaries that might be used to repair problems should, IMO,
> reside on /sbin (or /bin) if they don't depend on /usr.
> 
> 
> xfs_scrub has no non-root dependencies on my version:
> > ldd /sbin/xfs_scrub
>  linux-vdso.so.1 (0x00007ffe275d1000)
>  libc.so.6 => /lib64/libc.so.6 (0x00007fd1c3561000)
>  libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fd1c3342000)
>  /lib64/ld-linux-x86-64.so.2 (0x00007fd1c3b32000)

Ahh, but xfs_scrub depends on /usr on my system:

$ ldd $(which xfs_scrub)
linux-vdso.so.1 (0x00007ffd610d5000)
libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fd40f1e2000)
libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fd40efc3000)
libicui18n.so.60 => /usr/lib/x86_64-linux-gnu/libicui18n.so.60 (0x00007fd40eb22000)
libicuuc.so.60 => /usr/lib/x86_64-linux-gnu/libicuuc.so.60 (0x00007fd40e76b000)
/lib64/ld-linux-x86-64.so.2 (0x00007fd40f7ea000)
libstdc++.so.6 => /usr/lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007fd40e3e2000)
libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fd40e044000)
libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fd40de2c000)
libicudata.so.60 => /usr/lib/x86_64-linux-gnu/libicudata.so.60 (0x00007fd40c283000)
libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fd40c07f000)

So that's why it moved too.

(The libraries from /usr are used to notify the sysadmin about
directories with file names that render in a deceptively similar
fashion, if the system locale settings indicate UTF-8 mode.)

> Ideally the same should go for xfs_restore (and dump), xfs.mkfs,
> xfs_repair, xfs_admin, maybe xfs_db (hopefully rare), and xfs_irecover.

mkfs and repair live in /sbin, at least on Debian.  I've variously
wondered if xfs_metadump (and therefore xfs_db) belong somewhere so that
you can metadump or debug any filesystem possible, though so far that's
only taken the form of an initramfs hook...

> Please don't _unnecessarily_ move binaries that might be needed for fs repair
> onto /usr if possible.   I've found that using 'xfs' for a root file system
> eliminates my need for an indirect boot off of a
> ram disk.

Please remember, scrub is the online fsck tool; if you can't get / and
/usr online then the recovery procedure (xfs_repair) for them is the
same as it always has been.

> xfs has been far more stable and easy to use than indirect methods involving
> a separate ramdisk.

Yeah, I noticed that still mostly works even these days. :)

(Granted that was the other day when I was test-booting a browser x86 vm
off a simple xfs image just to see if we could do 'xfstests in your
browser' but aside from the absurdly slow emulation it mostly worked.
:P)

--D

> Thanks,
> -linda
> 
