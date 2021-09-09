Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9EE4C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 02:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A30C603E9
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 02:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348278AbhIICz5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Sep 2021 22:55:57 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:38639 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230075AbhIICz5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Sep 2021 22:55:57 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 95946108F10;
        Thu,  9 Sep 2021 12:54:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mOAD7-00AKVd-6E; Thu, 09 Sep 2021 12:54:45 +1000
Date:   Thu, 9 Sep 2021 12:54:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     brian <a001@yakkadesign.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Repair Metadata corruption detected at xfs_inode_buf_verify on
 CentOS 7 virtual machine
Message-ID: <20210909025445.GC2361455@dread.disaster.area>
References: <055dbf6e-a9b5-08a1-43bc-59f93e77f67d@yakkadesign.com>
 <20210908213924.GB2361455@dread.disaster.area>
 <987fa28b-4928-8557-0f09-73839790e910@yakkadesign.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <987fa28b-4928-8557-0f09-73839790e910@yakkadesign.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=IkcTkHD0fZMA:10 a=7QKq2e-ADPsA:10 a=7-415B0cAAAA:8
        a=2bRdCREyfEply6phQkYA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 08, 2021 at 07:08:54PM -0400, brian wrote:
> Here is an update of the error.  If something looks off, let me know and
> I'll double check I transcribed correct.  Let me know if there is a way to
> post a screenshot.
> 
> ----------------------------------------------------------------------------
> 
> XFS (dm-2): Metadata corruption detected at xfs_inode_buf_verify+0x14d/0x160
> [xfs] xfs_inode block 0x1b5c1c0 xfs_inode_buf_verify
> XFS (dm-2): Unmount and run xfs_repair
> XFS (dm-2): First 128 bytes of corrupted metadata buffer:
> ffffae6842564000: 16 49 77 8a 32 7e 72 52 14 bb 51 98 7c a5 2c 9a
> .Iw.2~rR..Q.|.,.
> ffffae6842564010: dd 28 4d 94 88 03 2b 8c 99 33 67 ca 6a d5 aa c9
> .(M...+..3g.j...
> ffffae6842564020: f8 f8 78 c7 90 fc f5 af 7f 95 03 07 0e 0c 4a 37
> ..x...........J7
> ffffae6842564030: 7c f8 70 c7 09 14 c7 81 a5 a7 a7 cb a8 a8 28 b9
> |.p...........(.
> ffffae6842564040: 68 d1 a2 a0 73 f5 ae d5 73 94 23 3d 3d 5d 46 46
> h...s...s.#--]FF
> ffffae6842564050: 46 ca f9 f3 e7 3b 69 4c d3 94 6d db b6 75 14 3d
> F....;iL..m..u.=
> ffffae6842564060: 30 68 77 ec d8 e1 a4 d9 b7 6f 9f 0c 0b 0b 0b 32
> )hw......o.....2
> ffffae6842564070: 8e 9d 29 aa 03 4b 4c 4c 0c 52 66 29 a5 7c f4 d1
> ..)..KLL.Rf).|..
> XFS (dm-2): metadata I/O error in “xlog_recov_do..(read#2)” at daddr 0x1b32
> error 117

Ok, that doesn't contain inodes. It's not even recognisable
as filesystem metadata at all.

> ----------------------------------------------------------------------------
> 
> My computer is an older CentOS 6 box (on my todo list to replace).  I have
> an array of VirtualBox VMs.  All my data including VMs is in /home/brian
> directory.  I run rsync to backup /home/brian directory to a USB drive. 
> Rsync treats the files of the VM just like any other file.  I noticed that
> the VMs can get corrupted if I leave them running during back up with rsync
> so I normally shut them down.  For this instance, I didn't shut down the VM
> when I launched rsync.
> 
> @Dave
> Regarding your image file question, I don't believe the above is an image
> file.  Rsync copies file by file.  And I can navigate to the USB like my
> internal hdd.
> 
> Regarding the freeze files system, no I did not freeze the guest.
> 
> Regarding the older backups, I just have the rsync backup on a USB drive. 
> I've been working with a copy from the USB to try at get this machine back,
> thus the unmodified USB rsync that was taken while the machine was running
> exists.
> 
> While rsync was running, I had Selenium running web app tests in Chrome. 
> All the data from my program was being written to a shared folder.  Chrome
> has it's own internal cache that could be changing but overall, I wouldn't
> expect the file system to be changing too much especially the booting part.

Log recovery covers anything that changed in the filesystem - it has
nothing to do with what is being accessed by boot operations.

> My ultimate goal is to get to the data on this VM.  I've tried to mount this
> .vdi file in another instance of CentOS but have not been successful.  I may
> spin up an Ubuntu instance to try to get to the data.  The data on this VM
> can be recreated but I prefer not to have to redo the work.

'mount -o ro,norecovery <dev>' will allow you to skip log recovery
and hopefully let you navigate the filesystem. It will not be error
free, though, because log recovery is needed for that to occur.

If the filesystem looks mostly intact, copy all the data off it you
can. Then unmount it is and run xfs_repair -L <dev> on it to blow
away the log and repair any corruption found. This will cause data
loss, so don't do this unless you are prepared for it of have a
complete copy of the broken filesystem.

I'd highly recommend doing this with a recent xfs_repair, not the
tools that came with CentOS 6.

You could also do dry-run testing by taking a metadump of the broken
filesystem and restoring that to an image file and running reapir on
that image file. That will at least tell you how much of the
directory structure will be trashed and wht you'll be able to access
after repair.

It may be that mounting w/ norecovery is your best bet of recovering
the contents of the bad filesystems, so do that first...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
