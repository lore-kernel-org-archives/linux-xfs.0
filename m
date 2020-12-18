Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06068C2BBD4
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 15:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C26F623B5F
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 15:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgLRPk2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 10:40:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726677AbgLRPk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 10:40:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608305941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zoSRLKrcoxe8sRVR20mD4Il6k/Xv9vBGON/jhnRKkkY=;
        b=YHcWuYc6V85R09rU7HKw3LgnXr7mLHXiQG3ko92Sl5Qve0sxMG/IK6sYI7/y+vhF5IuBaZ
        ORaX3Rd8LqEEf4t/Z40cPaxRai9EXSMuL6n1qlVUWyWMiyE++kb2dCKHHULHk2VrFn+dZ+
        tzP1deOsw5PzOWsbzq1WKH5Gov8CVYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-u2qBCpj_Nmq9aUguFHZ_jw-1; Fri, 18 Dec 2020 10:35:38 -0500
X-MC-Unique: u2qBCpj_Nmq9aUguFHZ_jw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF435CC620;
        Fri, 18 Dec 2020 15:35:37 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4266F2C01B;
        Fri, 18 Dec 2020 15:35:35 +0000 (UTC)
Date:   Fri, 18 Dec 2020 10:35:33 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Donald Buczek <buczek@molgen.mpg.de>
Cc:     linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
Subject: Re: v5.10.1 xfs deadlock
Message-ID: <20201218153533.GA2563439@bfoster>
References: <b8da4aed-ee44-5d9f-88dc-3d32f0298564@molgen.mpg.de>
 <20201217194317.GD2507317@bfoster>
 <39b92850-f2ff-e4b6-0b2e-477ab3ec3c87@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b92850-f2ff-e4b6-0b2e-477ab3ec3c87@molgen.mpg.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 17, 2020 at 10:30:37PM +0100, Donald Buczek wrote:
> On 17.12.20 20:43, Brian Foster wrote:
> > On Thu, Dec 17, 2020 at 06:44:51PM +0100, Donald Buczek wrote:
> > > Dear xfs developer,
> > > 
> > > I was doing some testing on a Linux 5.10.1 system with two 100 TB xfs filesystems on md raid6 raids.
> > > 
> > > The stress test was essentially `cp -a`ing a Linux source repository with two threads in parallel on each filesystem.
> > > 
> > > After about on hour, the processes to one filesystem (md1) blocked, 30 minutes later the process to the other filesystem (md0) did.
> > > 
> > >      root      7322  2167  0 Dec16 pts/1    00:00:06 cp -a /jbod/M8068/scratch/linux /jbod/M8068/scratch/1/linux.018.TMP
> > >      root      7329  2169  0 Dec16 pts/1    00:00:05 cp -a /jbod/M8068/scratch/linux /jbod/M8068/scratch/2/linux.019.TMP
> > >      root     13856  2170  0 Dec16 pts/1    00:00:08 cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/2/linux.028.TMP
> > >      root     13899  2168  0 Dec16 pts/1    00:00:05 cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/1/linux.027.TMP
> > > 

Do you have any indication of whether these workloads actually hung or
just became incredibly slow?

> > > Some info from the system (all stack traces, slabinfo) is available here: https://owww.molgen.mpg.de/~buczek/2020-12-16.info.txt
> > > 
> > > It stands out, that there are many (549 for md0, but only 10 for md1)  "xfs-conv" threads all with stacks like this
> > > 
> > >      [<0>] xfs_log_commit_cil+0x6cc/0x7c0
> > >      [<0>] __xfs_trans_commit+0xab/0x320
> > >      [<0>] xfs_iomap_write_unwritten+0xcb/0x2e0
> > >      [<0>] xfs_end_ioend+0xc6/0x110
> > >      [<0>] xfs_end_io+0xad/0xe0
> > >      [<0>] process_one_work+0x1dd/0x3e0
> > >      [<0>] worker_thread+0x2d/0x3b0
> > >      [<0>] kthread+0x118/0x130
> > >      [<0>] ret_from_fork+0x22/0x30
> > > 
> > > xfs_log_commit_cil+0x6cc is
> > > 
> > >    xfs_log_commit_cil()
> > >      xlog_cil_push_background(log)
> > >        xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
> > > 

This looks like the transaction commit throttling code. That was
introduced earlier this year in v5.7 via commit 0e7ab7efe7745 ("xfs:
Throttle commits on delayed background CIL push"). The purpose of that
change was to prevent the CIL from growing too large. FWIW, I don't
recall that being a functional problem so it should be possible to
simply remove that blocking point and see if that avoids the problem or
if we simply stall out somewhere else, if you wanted to give that a
test.

> > > Some other threads, including the four "cp" commands are also blocking at xfs_log_commit_cil+0x6cc
> > > 
> > > There are also single "flush" process for each md device with this stack signature:
> > > 
> > >      [<0>] xfs_map_blocks+0xbf/0x400
> > >      [<0>] iomap_do_writepage+0x15e/0x880
> > >      [<0>] write_cache_pages+0x175/0x3f0
> > >      [<0>] iomap_writepages+0x1c/0x40
> > >      [<0>] xfs_vm_writepages+0x59/0x80
> > >      [<0>] do_writepages+0x4b/0xe0
> > >      [<0>] __writeback_single_inode+0x42/0x300
> > >      [<0>] writeback_sb_inodes+0x198/0x3f0
> > >      [<0>] __writeback_inodes_wb+0x5e/0xc0
> > >      [<0>] wb_writeback+0x246/0x2d0
> > >      [<0>] wb_workfn+0x26e/0x490
> > >      [<0>] process_one_work+0x1dd/0x3e0
> > >      [<0>] worker_thread+0x2d/0x3b0
> > >      [<0>] kthread+0x118/0x130
> > >      [<0>] ret_from_fork+0x22/0x30
> > > 

Is writeback still blocked as such or was this just a transient stack?

> > > xfs_map_blocks+0xbf is the
> > > 
> > >      xfs_ilock(ip, XFS_ILOCK_SHARED);
> > > 
> > > in xfs_map_blocks().
> > > 
> > > The system is low on free memory
> > > 
> > >      MemTotal:       197587764 kB
> > >      MemFree:          2196496 kB
> > >      MemAvailable:   189895408 kB
> > > 
> > > but responsive.
> > > 
> > > I have an out of tree driver for the HBA ( smartpqi 2.1.6-005 pulled from linux-scsi) , but it is unlikely that this blocking is related to that, because the md block devices itself are responsive (`xxd /dev/md0` )
> > > 
> > > I can keep the system in the state for a while. Is there an idea what was going from or an idea what data I could collect from the running system to help? I have full debug info and could walk lists or retrieve data structures with gdb.
> > > 
> > 
> > It might be useful to dump the values under /sys/fs/xfs/<dev>/log/* for
> > each fs to get an idea of the state of the logs as well...
> 
> 
> root@deadbird:~# for f in /sys/fs/xfs/*/log/*; do echo $f : $(cat $f);done
> /sys/fs/xfs/md0/log/log_head_lsn : 5:714808
> /sys/fs/xfs/md0/log/log_tail_lsn : 5:581592
> /sys/fs/xfs/md0/log/reserve_grant_head : 5:365981696
> /sys/fs/xfs/md0/log/write_grant_head : 5:365981696

Hm, so it looks like the log is populated but not necessarily full. What
looks more interesting is that the grant heads (365981696 bytes) line up
with the physical log head (714808 512b sectors). That suggests there is
no outstanding transaction reservation and thus perhaps all workload
tasks are sitting at that throttling point just after the current
transaction commits and releases unused reservation. That certainly
shouldn't be such a longstanding blocking point as it only waits for the
CIL push to start.

Out of curiosity, have any of the above values changed since the sample
provided here was collected? As above, I'm curious if the filesystem
happens to be moving along slowly or not at all, whether the AIL has
been drained in the background, etc.

Could you post the xfs_info for the affected filesystems?

Also since it seems like you should have plenty of available log
reservation, are you able to perform any writable operations on the fs
(i.e., touch <file>)? If so, I wonder if you were able to start a new
copy workload on of the fs' capable of triggering the blocking threshold
again, if that might eventually unstick the currently blocked tasks when
the next CIL push occurs...

Brian

> /sys/fs/xfs/md1/log/log_head_lsn : 3:2963880
> /sys/fs/xfs/md1/log/log_tail_lsn : 3:2772656
> /sys/fs/xfs/md1/log/reserve_grant_head : 3:1517506560
> /sys/fs/xfs/md1/log/write_grant_head : 3:1517506560
> /sys/fs/xfs/sda1/log/log_head_lsn : 233:106253
> /sys/fs/xfs/sda1/log/log_tail_lsn : 233:106251
> /sys/fs/xfs/sda1/log/reserve_grant_head : 233:54403812
> /sys/fs/xfs/sda1/log/write_grant_head : 233:54403812
> /sys/fs/xfs/sda2/log/log_head_lsn : 84:5653
> /sys/fs/xfs/sda2/log/log_tail_lsn : 84:5651
> /sys/fs/xfs/sda2/log/reserve_grant_head : 84:2894336
> /sys/fs/xfs/sda2/log/write_grant_head : 84:2894336
> 
> 
> 
> > 
> > Brian
> > 
> > > Best
> > >    Donald
> > > 
> > 
> 
> -- 
> Donald Buczek
> buczek@molgen.mpg.de
> Tel: +49 30 8413 1433
> 

