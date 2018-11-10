Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:58134 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbeKJS2V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 13:28:21 -0500
Message-ID: <5BE69A4E.2050902@tlinx.org>
Date: Sat, 10 Nov 2018 00:43:58 -0800
From: L A Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: [PATCH 6/6] xfs_scrub: move everything to /usr/sbin
References: <154181071499.3727.3910572718199592407.stgit@magnolia> <154181075273.3727.12563703121689677996.stgit@magnolia>
In-Reply-To: <154181075273.3727.12563703121689677996.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: allison.henderson@oracle.com



On 11/9/2018 4:45 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Recently, it was pointed out that xfs_scrub{,_all} depend on components
> and libraries (libicu, python) that live in /usr.  /sbin binaries
> shouldn't depend on /usr, so let's move the scrub binaries to /usr/sbin.
----
	As stated in the original comment, only "xfs_scrub_all"
depends on /usr, as it depends on /usr/bin/python.

System binaries that might be used to repair problems should, IMO,
reside on /sbin (or /bin) if they don't depend on /usr.


xfs_scrub has no non-root dependencies on my version:
> ldd /sbin/xfs_scrub                                                
  linux-vdso.so.1 (0x00007ffe275d1000)
  libc.so.6 => /lib64/libc.so.6 (0x00007fd1c3561000)
  libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fd1c3342000)
  /lib64/ld-linux-x86-64.so.2 (0x00007fd1c3b32000)


Ideally the same should go for xfs_restore (and dump), xfs.mkfs,
xfs_repair, xfs_admin, maybe xfs_db (hopefully rare), and xfs_irecover.

Please don't _unnecessarily_ move binaries that might be needed for fs repair
onto /usr if possible.   I've found that using 'xfs' for a root 
file system eliminates my need for an indirect boot off of a
ram disk.

xfs has been far more stable and easy to use than indirect methods involving
a separate ramdisk.

Thanks,
-linda
