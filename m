Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3569DEB64D9
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 03:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjGKDKS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jul 2023 23:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjGKDKR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jul 2023 23:10:17 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244F383
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2023 20:10:16 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b9c5e07c1bso29055635ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2023 20:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689045015; x=1691637015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IcCgMcD6GzdOClJDQ+NzNAN31Kk1zf941SO8HLeIlcw=;
        b=Tv1a51t690ni66/FTSkCGGuCBV8Hmh0TN9CD/76CUztQrlkzpSukBqShqQQtKrlSKh
         tvJylQz1/QITTCoz60R/mmYOIubtreg+QmSmoUIdU6izcsyK7pHzNhQxOJfTqrWjn6Tj
         711M83bqbMuO8sQi7TGaweJn+BpU7h0EbGAAvVCEEEkt7CU6Dwqv8OJ9vYQLKdkUQEOm
         1l5ugJr1S1XwzVzH516+1mKGy/ga/U0YBxoOoo5j1pW619NQXjYLeAt726S5EyVlP1LQ
         7B2Wmvob5KnJk/ukqihwnpf/lucZe7p1VzRcKaREOcNPkoIMii5Vpte7MMkS8NafMX7q
         5RkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689045015; x=1691637015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcCgMcD6GzdOClJDQ+NzNAN31Kk1zf941SO8HLeIlcw=;
        b=MjC4KN8rPI43Nb986SKnxLwDlStDaE1l16aPtDuCY93vCqqHguQAfDEmSdiuQ2TX/T
         2r7+A76xxgZVgNzxxtDa9/l6DoTgV7bERbywuhhUX2rHitYozFF5Rs13dUl5GymTrcrz
         kxKVWa33NTYcrYHqmSj33gONNdswEN5V0kfD09sxdcBrviCZ+sjS2EmzEumoOvImTUuh
         HP4qdjWrPUPH0VMWCNbBwmvUCx21WSuc3xCDOccflkACdV1F+eUd78ET0NF0hGCF+YwC
         q2RcL3WTNOwnehrPGE3WJ/JlWE6exsA1YmxZ3Ko5ZZNZVxZZ7681kQ7vl6RImudve7Rb
         fGGg==
X-Gm-Message-State: ABy/qLZMRWfxOeam9TS+3+17PdDqofkB7tk/ev+i9DEldCyezHh6IxWF
        K6+iMrfWPLRip9YC1c1EPp4+BuypQpWLQwm+J7I=
X-Google-Smtp-Source: APBJJlGLwc5w8MGoswF2uLepsJahXgGAM7z9IBz6fdODcd67vBGTNxCYaPNbs7wu9+CjVCUaL//O0g==
X-Received: by 2002:a17:903:1247:b0:1b6:6625:d3a8 with SMTP id u7-20020a170903124700b001b66625d3a8mr18761898plh.16.1689045015476;
        Mon, 10 Jul 2023 20:10:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id c18-20020a170902cb1200b001b890009634sm613987ply.139.2023.07.10.20.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 20:10:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qJ3lT-004dPk-1W;
        Tue, 11 Jul 2023 13:10:11 +1000
Date:   Tue, 11 Jul 2023 13:10:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: rm hanging, v6.1.35
Message-ID: <ZKzIE6m+iCEd+ZWk@dread.disaster.area>
References: <20230710215354.GA679018@onthe.net.au>
 <20230711001331.GA683098@onthe.net.au>
 <20230711015716.GA687252@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711015716.GA687252@onthe.net.au>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

FYI, Chris: google is classifying your email as spam because it
doesn't have any dkim/dmarc authentication on it. You're lucky I
even got this, because I know that gmail mostly just drops such
email in a black hole now....

On Tue, Jul 11, 2023 at 11:57:16AM +1000, Chris Dunlop wrote:
> On Tue, Jul 11, 2023 at 10:13:31AM +1000, Chris Dunlop wrote:
> > On Tue, Jul 11, 2023 at 07:53:54AM +1000, Chris Dunlop wrote:
> > > Hi,
> > > 
> > > This box is newly booted into linux v6.1.35 (2 days ago), it was
> > > previously running v5.15.118 without any problems (other than that
> > > fixed by "5e672cd69f0a xfs: non-blocking inodegc pushes", the reason
> > > for the upgrade).
> > > 
> > > I have rm operations on two files that have been stuck for in excess
> > > of 22 hours and 18 hours respectively:
> > ...
> > > ...subsequent to starting writing all this down I have another two
> > > sets of rms stuck, again on unremarkable files, and on two more
> > > separate filesystems.
> > > 
> > > ...oh. And an 'ls' on those files is hanging. The reboot has become
> > > more urgent.
> > 
> > FYI, it's not 'ls' that's hanging, it's bash, because I used a wildcard
> > on the command line. The bash stack:
> > 
> > $ cat /proc/24779/stack
> > [<0>] iterate_dir+0x3e/0x180
> > [<0>] __x64_sys_getdents64+0x71/0x100
> > [<0>] do_syscall_64+0x34/0x80
> > [<0>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > 
> > 'lsof' shows me it's trying to read one of the directories holding the
> > file that one of the newer hanging "rm"s is trying to remove.
> 
> Ugh. It wasn't just the "rm"s and bash hanging (and as it turns out,
> xfs_logprint), they were just obvious because that's what I was looking at.
> It turns out there was a whole lot more hanging.
> 
> Full sysrq-w output at:
> 
> https://file.io/tg7F5OqIWo1B

Ok, you have XFS on dm-writecache on md raid 5 and
everything is stuck in either dm-writecache or md.

For example, dm-writecache writeback is stuck waiting on md:

Jul 11 11:23:15 b2 kernel: task:kworker/40:1    state:D stack:0     pid:1801085 ppid:2      flags:0x00004000
Jul 11 11:23:15 b2 kernel: Workqueue: writecache-writeback writecache_flush_work [dm_writecache]
Jul 11 11:23:15 b2 kernel: Call Trace:
Jul 11 11:23:15 b2 kernel:  <TASK>
Jul 11 11:23:15 b2 kernel:  __schedule+0x245/0x7a0
Jul 11 11:23:15 b2 kernel:  schedule+0x50/0xa0
Jul 11 11:23:15 b2 kernel:  raid5_get_active_stripe+0x1de/0x480 [raid456]
Jul 11 11:23:15 b2 kernel:  raid5_make_request+0x290/0xe10 [raid456]
Jul 11 11:23:15 b2 kernel:  md_handle_request+0x196/0x240 [md_mod]
Jul 11 11:23:15 b2 kernel:  __submit_bio+0x125/0x250
Jul 11 11:23:15 b2 kernel:  submit_bio_noacct_nocheck+0x141/0x370
Jul 11 11:23:15 b2 kernel:  dispatch_io+0x16f/0x2e0 [dm_mod]
Jul 11 11:23:15 b2 kernel:  dm_io+0xf3/0x200 [dm_mod]
Jul 11 11:23:15 b2 kernel:  ssd_commit_flushed+0x12c/0x1c0 [dm_writecache]
Jul 11 11:23:15 b2 kernel:  writecache_flush+0xde/0x2a0 [dm_writecache]
Jul 11 11:23:15 b2 kernel:  writecache_flush_work+0x1f/0x30 [dm_writecache]
Jul 11 11:23:15 b2 kernel:  process_one_work+0x296/0x500
Jul 11 11:23:15 b2 kernel:  worker_thread+0x2a/0x3b0
Jul 11 11:23:15 b2 kernel:  kthread+0xe6/0x110
Jul 11 11:23:15 b2 kernel:  ret_from_fork+0x1f/0x30
Jul 11 11:23:15 b2 kernel:  </TASK>


This task holds the wc_lock() while it is doing this writeback
flush.

All the XFS filesystems are stuck in similar ways, such as trying to
push the journal and getting stuck in IO submission in
dm-writecache:

Jul 11 11:23:15 b2 kernel: Workqueue: xfs-cil/dm-128 xlog_cil_push_work [xfs]
Jul 11 11:23:15 b2 kernel: Call Trace:
Jul 11 11:23:15 b2 kernel:  <TASK>
Jul 11 11:23:15 b2 kernel:  __schedule+0x245/0x7a0
Jul 11 11:23:15 b2 kernel:  schedule+0x50/0xa0
Jul 11 11:23:15 b2 kernel:  schedule_preempt_disabled+0x14/0x20
Jul 11 11:23:15 b2 kernel:  __mutex_lock+0x72a/0xc80
Jul 11 11:23:15 b2 kernel:  writecache_map+0x2f/0x790 [dm_writecache]
Jul 11 11:23:15 b2 kernel:  __map_bio+0x46/0x1c0 [dm_mod]
Jul 11 11:23:15 b2 kernel:  __send_duplicate_bios+0x1d4/0x240 [dm_mod]
Jul 11 11:23:15 b2 kernel:  __send_empty_flush+0x95/0xd0 [dm_mod]
Jul 11 11:23:15 b2 kernel:  dm_submit_bio+0x3b5/0x5f0 [dm_mod]
Jul 11 11:23:15 b2 kernel:  __submit_bio+0x125/0x250
Jul 11 11:23:15 b2 kernel:  submit_bio_noacct_nocheck+0x141/0x370
Jul 11 11:23:15 b2 kernel:  xlog_state_release_iclog+0xfb/0x220 [xfs]
Jul 11 11:23:15 b2 kernel:  xlog_write_get_more_iclog_space+0x87/0x130 [xfs]
Jul 11 11:23:15 b2 kernel:  xlog_write+0x295/0x3d0 [xfs]
Jul 11 11:23:15 b2 kernel:  xlog_cil_push_work+0x5b5/0x760 [xfs]
Jul 11 11:23:15 b2 kernel:  process_one_work+0x296/0x500
Jul 11 11:23:15 b2 kernel:  worker_thread+0x2a/0x3b0
Jul 11 11:23:15 b2 kernel:  kthread+0xe6/0x110
Jul 11 11:23:15 b2 kernel:  ret_from_fork+0x1f/0x30

These are getting into dm-writecache, and the lock they are getting
stuck on is the wc_lock().

Directory reads are getting stuck in dm-write-cache:

Jul 11 11:23:16 b2 kernel: task:find            state:D stack:0     pid:1832634 ppid:1832627 flags:0x00000000
Jul 11 11:23:16 b2 kernel: Call Trace:
Jul 11 11:23:16 b2 kernel:  <TASK>
Jul 11 11:23:16 b2 kernel:  __schedule+0x245/0x7a0
Jul 11 11:23:16 b2 kernel:  schedule+0x50/0xa0
Jul 11 11:23:16 b2 kernel:  schedule_preempt_disabled+0x14/0x20
Jul 11 11:23:16 b2 kernel:  __mutex_lock+0x72a/0xc80
Jul 11 11:23:16 b2 kernel:  writecache_map+0x2f/0x790 [dm_writecache]
Jul 11 11:23:16 b2 kernel:  __map_bio+0x46/0x1c0 [dm_mod]
Jul 11 11:23:16 b2 kernel:  dm_submit_bio+0x273/0x5f0 [dm_mod]
Jul 11 11:23:16 b2 kernel:  __submit_bio+0x125/0x250
Jul 11 11:23:16 b2 kernel:  submit_bio_noacct_nocheck+0x141/0x370
Jul 11 11:23:16 b2 kernel:  _xfs_buf_ioapply+0x224/0x3c0 [xfs]
Jul 11 11:23:16 b2 kernel:  __xfs_buf_submit+0x88/0x1c0 [xfs]
Jul 11 11:23:16 b2 kernel:  xfs_buf_read_map+0x1a2/0x340 [xfs]
Jul 11 11:23:16 b2 kernel:  xfs_buf_readahead_map+0x23/0x30 [xfs]
Jul 11 11:23:16 b2 kernel:  xfs_da_reada_buf+0x76/0x80 [xfs]
Jul 11 11:23:16 b2 kernel:  xfs_dir2_leaf_readbuf+0x269/0x350 [xfs]
Jul 11 11:23:16 b2 kernel:  xfs_dir2_leaf_getdents+0xd5/0x3b0 [xfs]
Jul 11 11:23:16 b2 kernel:  xfs_readdir+0xff/0x1d0 [xfs]
Jul 11 11:23:16 b2 kernel:  iterate_dir+0x13f/0x180
Jul 11 11:23:16 b2 kernel:  __x64_sys_getdents64+0x71/0x100
Jul 11 11:23:16 b2 kernel:  ? __x64_sys_getdents64+0x100/0x100
Jul 11 11:23:16 b2 kernel:  do_syscall_64+0x34/0x80
Jul 11 11:23:16 b2 kernel:  entry_SYSCALL_64_after_hwframe+0x46/0xb0

Same lock.

File data reads are getting stuck the same way in dm-writecache.

File data writes (i.e. writeback) are getting stuck the same way
in dm-writecache.

Yup, everything is stuck on dm-writecache flushing to the underlying
RAID-5 device.

I don't see anything indicating a filesystem problem here. This
looks like a massively overloaded RAID 5 volume. i.e. the fast
storage that makes up the write cache has filled, and now everything
is stuck waiting for the fast cache to drain to the slow backing
store before new writes can be made to the fast cache. IOWs,
everything is running as RAID5 write speed and there's a huge
backlog of data being written to the RAID 5 volume(s) keeping them
100% busy.

If there is no IO going to the RAID 5 volumes, then you've got a
RAID 5 or physical IO hang of some kind. But I can't find any
indication of that - everything looks like it's waiting on RAID 5
stripe population to make write progress...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
