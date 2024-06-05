Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE3DBA38
	for <linux-xfs@vger.kernel.org>; Wed,  5 Jun 2024 23:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717628759; cv=none; b=E8uaIc56nhUd1uS5N2jAhtdTCo6esXhH4RgxjcPmy6T1gUUfKT4uXXc20e1f9K3oT+8exHAUIpV3iaLvc0sMExLR+6pnsrV8QnsP97AfTqzWvhMA6N5D2nSkvSUCOYD5lNjI1iCk94Yq2jsvPwXtDdZJFRPy/TkQ75Fel4Ts9iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717628759; c=relaxed/simple;
	bh=ED1Qqkz5Om/43NQVcbVL7adAb8o5p7YsljaJZo/mFio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u4pWblMY6SbuljJCCMz9yxEPwPRjJju+l8Dxd7jSV4FN8Kx2gtr98yKaSZ14o7ouXCro/HWPw3JXHJAPNn9FNwBVi+f48gqiSJzDZoA5eKsKSQAttheqCGcomfwtTaRy4F1dEtta5ULf6xzB+IvZTkNmF2BUCKb2fHChkFPxzHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AacduYkb; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AacduYkb"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-703e5a09c11so269781b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2024 16:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1717628756; x=1718233556; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UKv7W7gUcRdf1oHPT0zJPin+7I2Y/LiovxLeLiTBLjE=;
        b=AacduYkbANV0qX/5kxgJ7fKBBoMYVm7JxOn50LjS6XhYdi737QXJ52a7+LfHieKwB/
         H/sZFvzxwVwfSGB0ADnI51rcvnRQVw6wRT9QxZsgytWEUo0qJ6uwifUM0pzTd99RX2Si
         dpVLYE6z6l85LmFft0CD45ZG1nAZVEpk3UVifaBp0seOn4l48hzYggN56p7Gnx1W1mpY
         WvRnGyPYqGNX+kJD9C2UY4WGVW8fILJBJZv9EG0SSXF6P14j5NH2GCrf4B4IwuxseLmx
         fPLpJCeGqfefONcEwnmejlTr5GiSKqGGZ2V7IS5rpJx+DAXKp5AMjCPzCErTkaFlHCRW
         JueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717628756; x=1718233556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UKv7W7gUcRdf1oHPT0zJPin+7I2Y/LiovxLeLiTBLjE=;
        b=iSKlCrArGIUOG5DdkBQzb6boV3yo0BzSKBkT3JvRBhC658a1QIE9mCZF8lOLd7fVYC
         MSwZPhY+HA3hQYxq8mS9WAZVZeG8wkhe+4xtdKU2UDUX/EIrnfNjPG/BcqZLjWe+gfJZ
         CWqTJ8J6LitkM2h/4ZeCt6SpXdhft+z5boepcQKwedXWtMBIs6FRZShdgz582pFtt645
         JMsirYYqSOZt/hM4XRlN1nSnym1d5Oab/AO6VPleKJ0h9GFQHJY4Ssr7AtnGvfjbD171
         erfAlr7XTVs3mDAoB4VrXAajEiGtAuHF9WPv20vmBLBiKC76r9vaO7GnEysQp9NlsKZd
         IXmg==
X-Forwarded-Encrypted: i=1; AJvYcCUrspObJk027xB7V/MraT7PZvcbvTIMNucyG46oktjlIcjCNG2jGteeSeiKPIzcbfFEj9G4TEmxwn2Y2sMpThxWjgWSqe6EQAx6
X-Gm-Message-State: AOJu0Yz6tnH0K+fyUMlvwB74N3P9DP10XPriBmwQBfgnXVol03NvcTky
	7zv4iqsfXui3yiG0Yk75jLtdV3IK1YatUREbb8w6lK0nCZ5tyVmQLStNYctDnNc=
X-Google-Smtp-Source: AGHT+IGDPgF1Ew4W6FB2K/tZrcW1WgeNNR3ABR7LpaDyLK0tXo6sJFPLE11KjQeSy/AnQclMNh0C+Q==
X-Received: by 2002:a05:6a21:609:b0:1b2:b191:b05a with SMTP id adf61e73a8af0-1b2b712fbd7mr3593694637.44.1717628755962;
        Wed, 05 Jun 2024 16:05:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703fd394ea0sm32160b3a.59.2024.06.05.16.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 16:05:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sEzhX-005hYn-2i;
	Thu, 06 Jun 2024 09:05:51 +1000
Date: Thu, 6 Jun 2024 09:05:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zack Weinberg <zack@owlfolio.org>
Cc: dm-devel@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: Reproducible system lockup, extracting files into XFS on
 dm-raid5 on dm-integrity on HDD
Message-ID: <ZmDvT/oWgVBiCw9o@dread.disaster.area>
References: <1eb0ef1c-9703-43fd-9a51-bda24b9d2f1b@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1eb0ef1c-9703-43fd-9a51-bda24b9d2f1b@app.fastmail.com>

On Wed, Jun 05, 2024 at 02:40:45PM -0400, Zack Weinberg wrote:
> I am experimenting with the use of dm-integrity underneath dm-raid,
> to get around the problem where, if a RAID 1 or RAID 5 array is
> inconsistent, you may not know which copy is the good one.  I have found
> a reproducible hard lockup involving XFS, RAID 5 and dm-integrity.
> 
> My test array consists of three spinning HDDs (each 2 decimal
> terabytes), each with dm-integrity laid directly onto the disk
> (no partition table), using SHA-256 checksums.  On top of this is
> an MD-RAID array (raid5), and on top of *that* is an ordinary XFS
> filesystem.
> 
> Extracting a large tar archive (970 G) into the filesystem causes a hard
> lockup -- the entire system becomes unresponsive -- after some tens of
> gigabytes have been extracted.  I have reproduced the lockup using
> kernel versions 6.6.21 and 6.9.3.  No error messages make it to the
> console, but with 6.9.3 I was able to extract almost all of a lockdep
> report from pstore.  I don't fully understand lockdep reports, but it
> *looks* like it might be a livelock rather than a deadlock, with all
> available kworker threads so bogged down with dm-integrity chores that
> an XFS log flush is blocked long enough to hit the hung task timeout.
> 
> Attached are:
> 
> - what I have of the lockdep report (kernel 6.9.3) (only a couple
>   of lines at the very top are missing)
> - kernel .config (6.9.3, lockdep enabled)
> - dmesg up till userspace starts (6.6.21, lockdep not enabled)
> - details of the test array configuration
> 
> Please advise if there is any more information you need.  I am happy to
> test patches.  I'm not subscribed to either dm-devel or linux-xfs.

I don't think there's any lockup or kernel bug here - this just
looks to be a case of having a really, really slow storage setup and
everything waiting for a huge amount of IO to complete to make
forwards progress.

RAID 5 writes are slow with spinning disks. dm-integrity makes
writes even slower.  If you storage array can sustain more than 50
random 4kB writes a second, I'd be very surprised. It's going to be
-very slow-.

With this in mind, untarring a TB sized tarball is going to drive
lots of data IO and create lots of metadata. XFS will buffer most of
that metadata in memory until the journal fills, but once the
journal fills (a few seconds to a few minutes into the untar) it
will throttle metadata performance to the small random write speed
of the underlying storage....

The high speed collision with that brick wall looks like this:

Userspace stalls on on writes because there are too many dirty pages
in RAM. It throttles all incoming writes, waiting for background
writeback to clean dirty pages.  Data writeback requires block
allocation which requires metadata modification. Metadata
modification requires journal space reservations which block
waiting for metadata writeback IO to complete. There are hours of
metadata writeback needed to free journal space, so everything
pauses waiting for metadata IO completion.

> p.s. Incidentally, why doesn't the dm-integrity superblock record the
> checksum algorithm in use?

> # xfs_info /dev/md/sdr5p1
> meta-data=/dev/md/sdr5p1         isize=512    agcount=32, agsize=30283904 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> data     =                       bsize=4096   blocks=969084928, imaxpct=5
>          =                       sunit=128    swidth=256 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=473186, version=2

So a 1.6GB journal can buffer hundreds of thousands of dirty 4kb
metadata blocks with writeback pending. Once the journal is full,
however, the filesystem has to start writing them back to make space
in the journal for new incoming changes. At this point, the
filesystem with throttle incoming metadata modifications to the rate
at which it can remove dirty metadata from the journal. i.e. it will
throttle incoming modifications to the sustained random 4kB write
rate of your storage hardware.

With at least a quarter of a million random 4kB writes pending in
the journal when it starts throttling, I'd suggest that you're
looking at several hours of waiting just to flush the journal, let
alone complete the untar process which will be generating new
metadata all the time....

> [ 2213.559141]       Not tainted 6.9.3-gentoo-lockdep #2
> [ 2213.559146] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2213.559149] task:kworker/25:3    state:D stack:0     pid:13498 tgid:13498 ppid:2      flags:0x00004000
> [ 2213.559160] Workqueue: xfs-sync/md126p1 xfs_log_worker
> [ 2213.559169] Call Trace:
> [ 2213.559172]  <TASK>
> [ 2213.559177]  __schedule+0x49a/0x1900
> [ 2213.559183]  ? find_held_lock+0x32/0x90
> [ 2213.559190]  ? srso_return_thunk+0x5/0x5f
> [ 2213.559198]  schedule+0x31/0x130
> [ 2213.559204]  schedule_timeout+0x1cd/0x1e0
> [ 2213.559212]  __wait_for_common+0xbc/0x1e0
> [ 2213.559218]  ? usleep_range_state+0xc0/0xc0
> [ 2213.559226]  __flush_workqueue+0x15f/0x470
> [ 2213.559235]  ? __wait_for_common+0x4d/0x1e0
> [ 2213.559242]  xlog_cil_push_now.isra.0+0x59/0xa0
> [ 2213.559249]  xlog_cil_force_seq+0x7d/0x290
> [ 2213.559257]  xfs_log_force+0x86/0x2d0
> [ 2213.559263]  xfs_log_worker+0x36/0xd0
> [ 2213.559270]  process_one_work+0x210/0x640
> [ 2213.559279]  worker_thread+0x1c7/0x3c0

Yup, so that's the periodic log force that is run to help the
filesystem move to idle when nothing is happening (runs every 30s).

It's waiting on a CIL push, which writes all the current in memory
changes to the journal. 

> [ 2213.559287]  ? wq_sysfs_prep_attrs+0xa0/0xa0
> [ 2213.559294]  kthread+0xd2/0x100
> [ 2213.559301]  ? kthread_complete_and_exit+0x20/0x20
> [ 2213.559309]  ret_from_fork+0x2b/0x40
> [ 2213.559317]  ? kthread_complete_and_exit+0x20/0x20
> [ 2213.559324]  ret_from_fork_asm+0x11/0x20
> [ 2213.559332]  </TASK>
> [ 2213.559361] Showing all locks held in the system:
> [ 2213.559390] 2 locks held by kworker/u131:0/208:
> [ 2213.559395]  #0: ffff9aa10ffe2d58 ((wq_completion)xfs-cil/md126p1){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.559421]  #1: ffffb848c08dbe58 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640

That's a CIL push worker, and it's likely waiting on journal space
to write the new changes into the journal. i.e. it's waiting for
metadata writeback IO completion to occur so it can make progress.

> [ 2213.559446] 3 locks held by kworker/u130:13/223:
> [ 2213.559451]  #0: ffff9aa7cc1f8158 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.559474]  #1: ffffb848c0953e58 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.559497]  #2: ffff9aa0c25400e8 (&type->s_umount_key#32){++++}-{3:3}, at: super_trylock_shared+0x11/0x50
> [ 2213.559522] 1 lock held by khungtaskd/230:
> [ 2213.559526]  #0: ffffffff89ec2e20 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x2c/0x1d0
> [ 2213.559557] 1 lock held by usb-storage/414:
> [ 2213.559561]  #0: ffff9aa0cb15ace8 (&us_interface_key[i]){+.+.}-{3:3}, at: usb_stor_control_thread+0x43/0x2d0
> [ 2213.559591] 1 lock held by in:imklog/1997:
> [ 2213.559595]  #0: ffff9aa0db2258d8 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x84/0xd0
> [ 2213.559620] 2 locks held by kworker/u131:3/3226:
> [ 2213.559624]  #0: ffff9aa10ffe2d58 ((wq_completion)xfs-cil/md126p1){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.559664]  #1: ffffb848c47a7e58 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640

There's another CIL push worker - we can have 4 pushes in flight at
once.

> [ 2213.559706] 2 locks held by tar/5845:
> [ 2213.559710]  #0: ffff9aa0c2540420 (sb_writers#6){.+.+}-{0:0}, at: ksys_write+0x6c/0xf0
> [ 2213.559732]  #1: ffff9aa0e16c3f58 (&sb->s_type->i_mutex_key#8){++++}-{3:3}, at: xfs_ilock+0x144/0x180

There's the tar process, looking to be blocked during data IO,
likely on something like a timestamp update being blocked waiting
for journal space...

> [ 2213.559789] 2 locks held by kworker/14:28/6524:
> [ 2213.559793]  #0: ffff9aa0da45e758 ((wq_completion)dm-integrity-writer#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.559815]  #1: ffffb848c64e7e58 ((work_completion)(&ic->writer_work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.559882] 2 locks held by kworker/12:45/8171:
> [ 2213.559886]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.559908]  #1: ffffb848d6583e58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.559949] 2 locks held by kworker/12:81/8479:
> [ 2213.559953]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.559979]  #1: ffffb848d6ea3e58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.560006] 2 locks held by kworker/12:98/8496:
> [ 2213.560010]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.560036]  #1: ffffb848d6f2be58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.560062] 2 locks held by kworker/12:101/8499:
> [ 2213.560067]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.560093]  #1: ffffb848d6f43e58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.560118] 2 locks held by kworker/12:110/8508:
> [ 2213.560122]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.560149]  #1: ffffb848d6f8be58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.560175] 2 locks held by kworker/12:111/8509:
> [ 2213.560180]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.560206]  #1: ffffb848d6f93e58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.560230] 2 locks held by kworker/12:112/8510:
> [ 2213.560235]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.560261]  #1: ffffb848d6f9be58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640

A bunch of dm-integrity workers doing something.

> [ 2213.560307] 2 locks held by kworker/u131:5/9163:
> [ 2213.560312]  #0: ffff9aa10ffe2d58 ((wq_completion)xfs-cil/md126p1){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.560335]  #1: ffffb848d8803e58 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.560359] 2 locks held by kworker/u131:6/9166:
> [ 2213.560364]  #0: ffff9aa10ffe2d58 ((wq_completion)xfs-cil/md126p1){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.560387]  #1: ffffb848c44c7e58 ((work_completion)(&ctx->push_work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640

And there's the other two CIL push workers with pushes in progress.

So the journal is clearly bound waiting for space to write new
commits into the journal. Hence the system is clearly IO bound, and
that's why it suddenly goes slow.

> [ 2213.560429] 2 locks held by kworker/30:236/9664:
> [ 2213.560433]  #0: ffff9aa0e43c0b58 ((wq_completion)dm-integrity-writer#3){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.560455]  #1: ffffb848da42be58 ((work_completion)(&ic->writer_work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.560540] 2 locks held by kworker/12:128/11574:
> [ 2213.560544]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.560564]  #1: ffffb848de48be58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.648428] 2 locks held by kworker/12:175/11621:
> [ 2213.648431]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.648443]  #1: ffffb848de603e58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.651134] 2 locks held by kworker/12:177/11623:
> [ 2213.651136]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.651147]  #1: ffffb848c4c47e58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.651158] 2 locks held by kworker/12:179/11625:
> [ 2213.651159]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.651170]  #1: ffffb848de613e58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.651181] 2 locks held by kworker/12:180/11626:
> [ 2213.651183]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.651193]  #1: ffffb848de61be58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.651205] 2 locks held by kworker/12:182/11628:
> [ 2213.651206]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.651217]  #1: ffffb848de62be58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.651228] 2 locks held by kworker/12:184/11630:
> [ 2213.651230]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.651240]  #1: ffffb848d4793e58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.651257] 2 locks held by kworker/12:236/11682:
> [ 2213.651259]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.651270]  #1: ffffb848de7cbe58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.651280] 2 locks held by kworker/12:239/11685:
> [ 2213.651282]  #0: ffff9aa0da420358 ((wq_completion)dm-integrity-offload#5){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.651293]  #1: ffffb848de7e3e58 ((work_completion)(&dio->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640
> [ 2213.651341] 2 locks held by kworker/25:121/12751:
> [ 2213.651343]  #0: ffff9aa0c8122f58 ((wq_completion)dm-integrity-writer#4){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.651353]  #1: ffffb848e0c13e58 ((work_completion)(&ic->writer_work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640

Another large bunch of dm-integrity workers doing something. It
looks to me like dm-integrity is trying to do a lot at this point in
time...

> [ 2213.651425] 2 locks held by kworker/25:3/13498:
> [ 2213.651426]  #0: ffff9aa0c7bfe758 ((wq_completion)xfs-sync/md126p1){+.+.}-{0:0}, at: process_one_work+0x3cc/0x640
> [ 2213.651436]  #1: ffffb848e259be58 ((work_completion)(&(&log->l_work)->work)){+.+.}-{0:0}, at: process_one_work+0x1ca/0x640

And that's the periodic log worker that generated the log force
which trigger the hung task timer.

> [ 2213.651465] =============================================
> [ 2213.651467] Kernel panic - not syncing: hung_task: blocked tasks
> [ 2213.652654] Kernel Offset: 0x7000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

So the system has been up for just under an hour, and it's
configured to panic on warnings and/or hung tasks. If you want the
untar to complete, turn off the hung task timer or push it out so
far that it doesn't trigger (i.e. 12-24 hours). Don't expect it to
finish quickly, and when it does there's probably still hours of
metadata writeback pending which will block unmount until it's done.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
