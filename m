Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56A4C74A5B
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Mar 2023 19:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjCRTVI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Mar 2023 15:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCRTVH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Mar 2023 15:21:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D71E7687
        for <linux-xfs@vger.kernel.org>; Sat, 18 Mar 2023 12:21:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9A4CB80861
        for <linux-xfs@vger.kernel.org>; Sat, 18 Mar 2023 19:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A37AC4339B;
        Sat, 18 Mar 2023 19:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679167259;
        bh=k3idzc2zTJ7xaAXIZqiGQPAgSsww4xkZPrUIQ2tOA+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xlw9cOXvJV373/1T8RYD3UHc4oYOH3nKF8geogAcghF7VR23mZb+KuTpuv+w936Qp
         YCozRuxUNKnVnwegb+n8+8pfHIiEyMVoiowPaP4akdb87+PCC6qM4CD7FMVcPuT8pf
         gedGfBqLWRriWXHypXoll1VEywcDHfabpuCPsjZzfCvtvJr0rWctiedN16FwZ9xrt5
         TebAyh/yP2lpKGbfc8sYohmm8p/ZHUNsruVCFHzfHc4D4vQC8ilwJnj1Q+jGLNh/Nw
         aMc0ctYmeT6mvhtaCj1o1/B1nP3UZcqNI18zkmdcjBpKGqKA6aQxHgyc10/6wBcIYc
         sCcUzMpz0WRiA==
Date:   Sat, 18 Mar 2023 12:20:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     shrikanth hegde <sshegde@linux.vnet.ibm.com>, dchinner@redhat.com,
        linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
Subject: Re: xfs: system fails to boot up due to Internal error
 xfs_trans_cancel
Message-ID: <20230318192059.GX11376@frogsfrogsfrogs>
References: <20230317204418.GQ11376@frogsfrogsfrogs>
 <87pm969f6z.fsf@doe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pm969f6z.fsf@doe.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 18, 2023 at 10:20:28PM +0530, Ritesh Harjani wrote:
> "Darrick J. Wong" <djwong@kernel.org> writes:
> 
> > On Wed, Mar 15, 2023 at 10:20:37PM -0700, Darrick J. Wong wrote:
> >> On Thu, Mar 16, 2023 at 10:16:02AM +0530, Ritesh Harjani wrote:
> >> > "Darrick J. Wong" <djwong@kernel.org> writes:
> >> > 
> >> > Hi Darrick,
> >> > 
> >> > Thanks for your analysis and quick help on this.
> >> > 
> >> > >>
> >> > >> Hi Darrick,
> >> > >>
> >> > >> Please find the information collected from the system. We added some
> >> > >> debug logs and looks like it is exactly what is happening which you
> >> > >> pointed out.
> >> > >>
> >> > >> We added a debug kernel patch to get more info from the system which
> >> > >> you had requested [1]
> >> > >>
> >> > >> 1. We first breaked into emergency shell where root fs is first getting
> >> > >> mounted on /sysroot as "ro" filesystem. Here are the logs.
> >> > >>
> >> > >> [  OK  ] Started File System Check on /dev/mapper/rhel_ltcden3--lp1-root.
> >> > >>          Mounting /sysroot...
> >> > >> [    7.203990] SGI XFS with ACLs, security attributes, quota, no debug enabled
> >> > >> [    7.205835] XFS (dm-0): Mounting V5 Filesystem 7b801289-75a7-4d39-8cd3-24526e9e9da7
> >> > >> [   ***] A start job is running for /sysroot (15s / 1min 35s)[   17.439377] XFS (dm-0): Starting recovery (logdev: internal)
> >> > >> [  *** ] A start job is running for /sysroot (16s / 1min 35s)[   17.771158] xfs_log_mount_finish: Recovery needed is set
> >> > >> [   17.771172] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:0
> >> > >> [   17.771179] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:1
> >> > >> [   17.771184] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:2
> >> > >> [   17.771190] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:3
> >> > >> [   17.771196] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:4
> >> > >> [   17.771201] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:5
> >> > >> [   17.801033] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:6
> >> > >> [   17.801041] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:7
> >> > >> [   17.801046] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:8
> >> > >> [   17.801052] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:9
> >> > >> [   17.801057] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:10
> >> > >> [   17.801063] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:11
> >> > >> [   17.801068] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:12
> >> > >> [   17.801272] xlog_recover_iunlink_bucket: bucket: 13, agino: 3064909, ino: 3064909, iget ret: 0, previno:18446744073709551615, prev_agino:4294967295
> >> > >>
> >> > >> <previno, prev_agino> is just <-1 %ull and -1 %u> in above. That's why
> >> > >> the huge value.
> >> > >
> >> > > Ok, so log recovery finds 3064909 and clears it...
> >> > >
> >> > >> [   17.801281] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:13
> >> > >> [   17.801287] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:14
> >> > >
> >> > > <snip the rest of these...>
> >> > >
> >> > >> [   17.844910] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:62
> >> > >> [   17.844916] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:63
> >> > >> [   17.886079] XFS (dm-0): Ending recovery (logdev: internal)
> >> > >> [  OK  ] Mounted /sysroot.
> >> > >> [  OK  ] Reached target Initrd Root File System.
> >> > >>
> >> > >>
> >> > >> 2. Then these are the logs from xfs_repair -n /dev/dm-0
> >> > >> Here you will notice the same agi 3064909 in bucket 13 (from phase-2) which got also
> >> > >> printed in above xlog_recover_iunlink_ag() function.
> >> > >>
> >> > >> switch_root:/# xfs_repair -n /dev/dm-0
> >> > >> Phase 1 - find and verify superblock...
> >> > >> Phase 2 - using internal log
> >> > >>         - zero log...
> >> > >>         - scan filesystem freespace and inode maps...
> >> > >> agi unlinked bucket 13 is 3064909 in ag 0 (inode=3064909)
> >> > >
> >> > > ...yet here we find that 3064909 is still on the unlinked list?
> >> > >
> >> > > Just to confirm -- you ran xfs_repair -n after the successful recovery
> >> > > above, right?
> >> > >
> >> > Yes, that's right.
> >> > 
> >> > >>         - found root inode chunk
> >> > >> Phase 3 - for each AG...
> >> > >>         - scan (but don't clear) agi unlinked lists...
> >> > >>         - process known inodes and perform inode discovery...
> >> > >>         - agno = 0
> >> > >>         - agno = 1
> >> > >>         - agno = 2
> >> > >>         - agno = 3
> >> > >>         - process newly discovered inodes...
> >> > >> Phase 4 - check for duplicate blocks...
> >> > >>         - setting up duplicate extent list...
> >> > >>         - check for inodes claiming duplicate blocks...
> >> > >>         - agno = 0
> >> > >>         - agno = 2
> >> > >>         - agno = 1
> >> > >>         - agno = 3
> >> > >> No modify flag set, skipping phase 5
> >> > >> Phase 6 - check inode connectivity...
> >> > >>         - traversing filesystem ...
> >> > >>         - traversal finished ...
> >> > >>         - moving disconnected inodes to lost+found ...
> >> > >> Phase 7 - verify link counts...
> >> > >> would have reset inode 3064909 nlinks from 4294967291 to 2
> >> > >
> >> > > Oh now that's interesting.  Inode on unlinked list with grossly nonzero
> >> > > (but probably underflowed) link count.  That might explain why iunlink
> >> > > recovery ignores the inode.  Is inode 3064909 reachable via the
> >> > > directory tree?
> >> > >
> >> > > Would you mind sending me a metadump to play with?  metadump -ago would
> >> > > be best, if filenames/xattrnames aren't sensitive customer data.
> >> > 
> >> > Sorry about the delay.
> >> > I am checking for any permissions part internally.
> >> > Meanwhile - I can help out if you would like me to try anything.
> >> 
> >> Ok.  I'll try creating a filesystem with a weirdly high refcount
> >> unlinked inode and I guess you can try it to see if you get the same
> >> symptoms.  I've finished with my parent pointers work for the time
> >> being, so I might have some time tomorrow (after I kick the tires on
> >> SETFSUUID) to simulate this and see if I can adapt the AGI repair code
> >> to deal with this.
> >
> > If you uncompress and mdrestore the attached file to a blockdev, mount
> > it, and run some creat() exerciser, do you get the same symptoms?  I've
> > figured out how to make online fsck deal with it. :)
> >
> > A possible solution for runtime would be to make it so that
> > xfs_iunlink_lookup could iget the inode if it's not in cache at all.
> >
> 
> Hello Darrick, 
> 
> I did xfs_mdrestore the metadump you provided on a loop mounted
> blockdev. I ran fsstress on the root dir of the mounted filesystem,
> but I was unable to hit the issue.
> 
> I tried the same with the original FS metadump as well and I am unable
> to hit the issue while running fsstress on the filesystem. 
> 
> I am thinking of identifying which file unlink operation was in progress
> when we see the issue during mounting. Maybe that will help in
> recreating the issue.

Yeah, creating a bunch of O_TMPFILE files will exercise the unlinked
lists, possibly enough to trip over the affected agi bucket.  See
t_open_tmpfiles.c in the fstests repo.

--D

> Although the xfs_repair -n does show a similar log of unlinked inode
> with the metadump you provided.
> 
> root@ubuntu:~# xfs_repair -n -o force_geometry /dev/loop7
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> agi unlinked bucket 3 is 6979 in ag 0 (inode=6979)
> agi unlinked bucket 4 is 6980 in ag 0 (inode=6980)
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> disconnected inode 6979, would move to lost+found
> disconnected inode 6980, would move to lost+found
> Phase 7 - verify link counts...
> would have reset inode 6979 nlinks from 5555 to 1
> would have reset inode 6980 nlinks from 0 to 1
> No modify flag set, skipping filesystem flush and exiting.
> 
> Thanks again for the help. Once I have more info I will update the
> thread!
> 
> -ritesh
