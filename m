Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:46170 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752963AbdDJKNm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 06:13:42 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id v3A9hcBH078461
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2017 02:43:40 -0700
Message-ID: <58EB53CA.7030608@tlinx.org>
Date: Mon, 10 Apr 2017 02:43:38 -0700
From: L A Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: allow mounting w/crc-checking disabled?  (was Re: filesystem dead,
 xfs_repair won't help)
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
In-Reply-To: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Avi Kivity wrote:
> Today my kernel complained that in memory metadata is corrupt and
> asked that I run xfs_repair.  But xfs_repair doesn't like the
> superblock and isn't able to find a secondary superblock.
>   
Why doesn't xfs have an option to mount with metadata checksumming
disabled so people can recover their data?

Seems like it should be easy to provide, no?

Or rather, if a disk is created with the crc option, is it possible
to later switch it off or mount it without with checking disabled?

Yes, I know the mantra is that they should have had backups, but
in practice it's seems not the case in a majority of uses outside
of enterprise usage.  It sure seems that disabling a particular file
or directory (if necessary) affected by a bad-crc, would be
preferable to losing the whole disk.  That said, how many crc
errors would be likely to make things unreadable or inaccessible?
Given that the default before crc-checking was that the disks
were still usable (often with no error being flagged or noticed),
I'd suspect that the crc-checking is causing many errors to be
be flagged that before wouldn't have even been noticed. 

Overall I'm wondering if the crc option won't cause more disk-losses
than would occur without the option.  Or, in other words, it seems
that since crc-checking seems to cause the disk to be lost, turning
on crc checking is almost guaranteed to cause a higher incidence of
data loss if it can't be disable. 



