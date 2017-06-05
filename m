Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44226 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751338AbdFERaE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Jun 2017 13:30:04 -0400
Subject: Re: My XFS volume died, please help!
References: <CAG3eYYQMTdmCK9EdJA4hfYSSPStLSC=YBK+tvk67r6Vn4-UcxQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f7faea7d-4258-9310-4fcd-c75ed7455181@sandeen.net>
Date: Mon, 5 Jun 2017 12:29:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAG3eYYQMTdmCK9EdJA4hfYSSPStLSC=YBK+tvk67r6Vn4-UcxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?B?UMOpdGVyIEFuZHLDoXMgRmVsdsOpZ2k=?= <petschy@gmail.com>, linux-xfs@vger.kernel.org

On 6/2/17 6:21 PM, Péter András Felvégi wrote:
> Hello,
> 
> after a power outage, the mount replayed the journal and no errors
> were reported, but the mounted XFS volume had suspiciously little free
> space.

Did it happen to be your root filesystem, or some other?

> So I unmounted, and ran xfs_repair which crashed in phase 5

Did it happen to find corruption before that?

> with a floating point exception. After that I was unable to mount
> again, due to metadata corruption, so the repair made things worse.
> Please help!
> 
> Linux 4.4.66 x86_64, Debian Jessie, xfsprogs 3.2.1

3 years old :(

> xps_repair output:
> Phase 5 - rebuild AG headers and trees...
>         - agno = 0
> traps: xfs_repair[4786] trap divide error ip:417fef sp:7ffe43770d60
> error:0 in xfs_repair[400000+7a000]
> Floating point exception

> mount output:
> XFS (dm-2): Mounting V5 Filesystem
> XFS (dm-2): Corruption warning: Metadata has LSN (11:170112) ahead of
> current LSN (1:64). Please unmount and run xfs_repair (>= v4.3) to
> resolve.

I'd follow the advice as printed, and you'll probably be fine.

If you want a test run, do what Carlos suggested, after getting
a modern xfsprogs package:

# xfs_metadump -o /dev/dm-2 - | xfs_mdrestore - dm-2.img
# xfs_repair dm-2.img
# mkdir -p mnt/
# mount -o loop dm-2.img mnt/

and see how that looks (metadata only, the image created
above will contain no file data)

If current xfsprogs also segfaults, please provide a metadump
image:

# xfs_metadump /dev/dm-2 dm-2.metadump
# bzip2 dm-2.metadump

and provide the result to me or carlos (on a side channel, out
of an abundance of caution for privacy).

-Eric

> XFS (dm-2): log mount/recovery failed: error -22
> XFS (dm-2): log mount failed
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/storage-crypt,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.


> I dumped the whole volume with dd so that I can revert to the current
> (hopefully not hopelessly screwed) state. Downloaded xfsprogs 4.11.0
> and checked the changelog. There are fixes for xfs_repair phase 5,
> though the FP exception is not mentioned. Is this bug already fixed?
> Should I try xfs_repair from 4.11?
> 
> Thanks & kind regards, Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
