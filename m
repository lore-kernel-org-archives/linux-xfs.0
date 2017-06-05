Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751453AbdFEI5F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Jun 2017 04:57:05 -0400
Date: Mon, 5 Jun 2017 10:57:01 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: My XFS volume died, please help!
Message-ID: <20170605085701.kw6avwixxdlqcinc@eorzea.usersys.redhat.com>
References: <CAG3eYYQMTdmCK9EdJA4hfYSSPStLSC=YBK+tvk67r6Vn4-UcxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG3eYYQMTdmCK9EdJA4hfYSSPStLSC=YBK+tvk67r6Vn4-UcxQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?iso-8859-1?Q?P=E9ter_Andr=E1s_Felv=E9gi?= <petschy@gmail.com>
Cc: linux-xfs@vger.kernel.org

Hi,

On Sat, Jun 03, 2017 at 01:21:31AM +0200, Péter András Felvégi wrote:
> Hello,
> 
> after a power outage, the mount replayed the journal and no errors
> were reported, but the mounted XFS volume had suspiciously little free
> space. So I unmounted, and ran xfs_repair which crashed in phase 5
> with a floating point exception. After that I was unable to mount
> again, due to metadata corruption, so the repair made things worse.
> Please help!
> 
> Linux 4.4.66 x86_64, Debian Jessie, xfsprogs 3.2.1
> 
> xps_repair output:
> Phase 5 - rebuild AG headers and trees...
>         - agno = 0
> traps: xfs_repair[4786] trap divide error ip:417fef sp:7ffe43770d60
> error:0 in xfs_repair[400000+7a000]
> Floating point exception
> 

Hmmm, I've seen this before, but honestly don't remember neither when nor what
happened with it.

> mount output:
> XFS (dm-2): Mounting V5 Filesystem
> XFS (dm-2): Corruption warning: Metadata has LSN (11:170112) ahead of
> current LSN (1:64). Please unmount and run xfs_repair (>= v4.3) to
> resolve.
> XFS (dm-2): log mount/recovery failed: error -22
> XFS (dm-2): log mount failed
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/storage-crypt,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> 
> I dumped the whole volume with dd so that I can revert to the current
> (hopefully not hopelessly screwed) state. Downloaded xfsprogs 4.11.0
> and checked the changelog. There are fixes for xfs_repair phase 5,
> though the FP exception is not mentioned. Is this bug already fixed?
> Should I try xfs_repair from 4.11?
>

Yes, you might want to run latest xfs_repair on it. If you are afraid of making
thins worse, you can actually take a metadump from your current broken fs, and
run xfs_repair on it, to see what it finds, or run it with -n to see what it
will find in your FS.

cheers

> Thanks & kind regards, Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
