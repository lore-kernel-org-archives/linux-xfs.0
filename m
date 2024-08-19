Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC9B1DD382
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 22:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724105809; cv=none; b=sLrszlvnHoc1Dgbt+9H1AMGofcbzuGEzk+cjA5Ej+4IoGNIaogoGIA1RY3yZMP+XZwcrQv0hOUmFtRPhqGeQHiwCxWW40bs7b9mnuThIolejXikEFgzuRkrlu/69Q8+z/bIJZNlNerIni7J0XHRpTRJP7MbaKQQYBg/JizOyRig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724105809; c=relaxed/simple;
	bh=D77h7pBmJaIao3eORJWKIV3ZMv+UbgvImXknw1Nz2eY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAQZKyWjN5gXcStYd8mWekw1DqnQSuLjDlUXBCEs3Rk29SyFrxNkYiUNso1YS9osx14C9G3myE402/Jit/oMCUhjxo/QYanCIkhkEltp6/gz18aB9Hz/wt/Mn3ssjQcVhUwHmf4/BNZOpQ8Tm3bayJ8XCxk2Cqqzo5k/vyk2hpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=CCvhVVrA; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="CCvhVVrA"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20231aa8908so13805845ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 15:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724105807; x=1724710607; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N/au4vGQhoGn9UetKPA7LukrmQexlvK/Tsm5BPGezUI=;
        b=CCvhVVrAmrZJ+6GXR3ATeg/5JY3TBSL61eOU1VIOipJ3uZCxLAtiFlnIeeCCJkqClq
         2unyqxbzmklhcNMwfArWxyajNigsZi6LTwxhdfjo+A34cf/TEqy0On7U40FHimJkCkNs
         eLJKh9uDQxJPh96wuaDAHulHhDodGCXnPmAhcTgFnoZ/1AIPwm53OWzpPIKtCcHXPXEi
         i15cLXnG7ZAN6Uiee8wTkWW6nLqZFZLvgb+cXV73s4ckOno6s5nXXdK1rVvkkjokwuVM
         Vl+GEDY25TfhDFKotq4ccnPI9rYzAhuoVW9eFXzY2hiJSwyGna8AGaZrSr44fhdLbRDv
         +aig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724105807; x=1724710607;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N/au4vGQhoGn9UetKPA7LukrmQexlvK/Tsm5BPGezUI=;
        b=isAsFZ2dlJW8oRxIgot0ol4cNlVFvrEMt5B5oZKi6XH5FvXQ//GWDrPwXMQnMUpXXs
         7e+g8YDh43Dhd7KfsZAW0J++w4ivnkuAD3FrQX3sg+jXWDuj+Qp2p7Pz/aauT4GKaOFd
         FzdTA17XVDfaaqlcxROHHR9r1vP9RIIweIlfmWHcw/tcTEGSm1HW26g7g5b3U5cU+NA7
         VHpt7XeqckykGvNuVvj+mjq3umn9y2VvRFKLQxw/YFsFhbO+KKJt++GjB2ug9LWWegJ/
         xPMjX/Mc2QcLXGxYcWpEbhkSeZ3VJB6W6Hd7DnUPaHiAQRLAGyMKM1WsroS92rncktET
         PuKg==
X-Forwarded-Encrypted: i=1; AJvYcCWEwFmRjsCaANd4hm45NeY0fAIcQM39cKAlk7xnmArKqaLUY/Me8uVSKnEdJB5BSc1vaO1hncq428s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyauKn/mfR/aqZyR8hT4fEu7kVjS/4u6IuALuvkd6hFYdYjiJ2m
	0/+CHmomHtcgB32mcmzPqZBBzA8ZBv00DJhqJWJvxiCKGNpZVTqr8bW7briQM2QIBZjMhJz810A
	g
X-Google-Smtp-Source: AGHT+IGfgnuZSDWnafemCvrXj6hQgzz1eqoQQciqUMGOGeM5FpILbGMtlACJqOVtqLBB8lz65PfHjA==
X-Received: by 2002:a17:902:f791:b0:202:13d7:92aa with SMTP id d9443c01a7336-20213d795cdmr98949815ad.24.1724105806730;
        Mon, 19 Aug 2024 15:16:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03795edsm66749105ad.153.2024.08.19.15.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 15:16:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sgAg7-005ZLT-1e;
	Tue, 20 Aug 2024 08:16:43 +1000
Date: Tue, 20 Aug 2024 08:16:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: syzbot <syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_buf_item_unpin (2)
Message-ID: <ZsPES2351eLXRYPz@dread.disaster.area>
References: <0000000000008905bf061fc61371@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000008905bf061fc61371@google.com>

On Thu, Aug 15, 2024 at 10:17:31PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1fb918967b56 Merge tag 'for-6.11-rc3-tag' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=115e1429980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=92c0312151c4e32e
> dashboard link: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/7b0e9f1a37aa/disk-1fb91896.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d554edb47a8e/vmlinux-1fb91896.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d1ec77d87b65/bzImage-1fb91896.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com
> 
> INFO: task kworker/1:1H:43 blocked for more than 143 seconds.
>       Not tainted 6.11.0-rc3-syzkaller-00066-g1fb918967b56 #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/1:1H    state:D stack:25320 pid:43    tgid:43    ppid:2      flags:0x00004000
> Workqueue: xfs-log/loop4 xlog_ioend_work
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5188 [inline]
>  __schedule+0x17ae/0x4a10 kernel/sched/core.c:6529
>  __schedule_loop kernel/sched/core.c:6606 [inline]
>  schedule+0x14b/0x320 kernel/sched/core.c:6621
>  schedule_timeout+0xb0/0x310 kernel/time/timer.c:2557
>  ___down_common kernel/locking/semaphore.c:225 [inline]
>  __down_common+0x343/0x7f0 kernel/locking/semaphore.c:246
>  down+0x84/0xc0 kernel/locking/semaphore.c:63
>  xfs_buf_lock+0x164/0x510 fs/xfs/xfs_buf.c:1196
>  xfs_buf_item_unpin+0x1dd/0x710 fs/xfs/xfs_buf_item.c:582
>  xlog_cil_committed+0x82f/0xf00 fs/xfs/xfs_log_cil.c:910
>  xlog_cil_process_committed+0x15c/0x1b0 fs/xfs/xfs_log_cil.c:941
>  xlog_state_shutdown_callbacks+0x2ba/0x3b0 fs/xfs/xfs_log.c:487
>  xlog_force_shutdown+0x32c/0x390 fs/xfs/xfs_log.c:3530
>  xlog_ioend_work+0xad/0x100 fs/xfs/xfs_log.c:1244
>  process_one_work kernel/workqueue.c:3231 [inline]
>  process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
>  worker_thread+0x86d/0xd40 kernel/workqueue.c:3390
>  kthread+0x2f0/0x390 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>  </TASK>
> INFO: task syz.4.26:5406 blocked for more than 144 seconds.
>       Not tainted 6.11.0-rc3-syzkaller-00066-g1fb918967b56 #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz.4.26        state:D stack:21208 pid:5406  tgid:5405  ppid:5216   flags:0x00004004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5188 [inline]
>  __schedule+0x17ae/0x4a10 kernel/sched/core.c:6529
>  __schedule_loop kernel/sched/core.c:6606 [inline]
>  schedule+0x14b/0x320 kernel/sched/core.c:6621
>  xlog_wait fs/xfs/xfs_log_priv.h:587 [inline]
>  xlog_wait_on_iclog+0x501/0x770 fs/xfs/xfs_log.c:840
>  xlog_force_lsn+0x523/0x9e0 fs/xfs/xfs_log.c:3066
>  xfs_log_force_seq+0x1da/0x450 fs/xfs/xfs_log.c:3103
>  __xfs_trans_commit+0xb98/0x1290 fs/xfs/xfs_trans.c:900
>  xfs_sync_sb_buf+0x2dc/0x370 fs/xfs/libxfs/xfs_sb.c:1178
>  xfs_ioc_setlabel fs/xfs/xfs_ioctl.c:1143 [inline]
>  xfs_file_ioctl+0x165b/0x19e0 fs/xfs/xfs_ioctl.c:1298
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:907 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f

That XFS deadlock looks to have been there for a while.

The test case is setting the loop dev to zero size immediately after
mount and then clearing the filesystem label. xfs_sync_sb_buf()
calls xfs_trans_bhold() so the transaction commit does not unlock
the buffer. The transaction is synchronous, so it issues the journal
IO then goes to sleep waiting for journal IO completion with the
superblock buffer locked.

The Journal IO errors out and runs a shutdown, which runs error
handling on the items to error them out. That requires taking the
buffer lock on buffer items, and that's already held by the log
force waiting for IO completion...

I think it can be fixed by doing something like this:

 static void
 xlog_state_shutdown_callbacks(
         struct xlog             *log)
 {
         struct xlog_in_core     *iclog;
         LIST_HEAD(cb_list);

         iclog = log->l_iclog;
         do {
                 if (atomic_read(&iclog->ic_refcnt)) {
                         /* Reference holder will re-run iclog callbacks. */
                         continue;
                 }
                 list_splice_init(&iclog->ic_callbacks, &cb_list);
+
+		/*
+		 * Wake waiters before processing callbacks as synchronous
+		 * transactions might waiting on completion whilst holding
+		 * locks we need to error out log items here.
+		 */
+                wake_up_all(&iclog->ic_write_wait);
+                wake_up_all(&iclog->ic_force_wait);
                 spin_unlock(&log->l_icloglock);

                 xlog_cil_process_committed(&cb_list);

                 spin_lock(&log->l_icloglock);
-                wake_up_all(&iclog->ic_write_wait);
-                wake_up_all(&iclog->ic_force_wait);
         } while ((iclog = iclog->ic_next) != log->l_iclog);

         wake_up_all(&log->l_flush_wait);
 }

The log is makred as shutdown before xlog_state_shutdown_callbacks()
is run and xlog_wait_on_iclog() checks if the log is shut down
after it is woken. Hence if we wake the waiters first, they'll see
the shutdown, get -EIO returned from xfs_trans_commit() and unlock
and release all the objects they have locked.

Once they do this, the xfs_buf_item_unpin() call that is stuck
waiting for the buffer lock to be released will gain the lock and
make progress. This will allow the journal shutdown to complete, and
the hang will go away.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
