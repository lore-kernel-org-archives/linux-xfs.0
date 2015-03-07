Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D8387F5A
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 08:07:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C40F8F8040
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 06:07:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bx77QxmjODCyC0ul (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Mar 2015 06:07:35 -0800 (PST)
Date: Sat, 7 Mar 2015 09:07:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS hangs with XFS: possible memory allocation deadlock in
	kmem_alloc
Message-ID: <20150307140721.GA9098@bfoster.bfoster>
References: <54FAAE16.6090505@fau.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54FAAE16.6090505@fau.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Michael Meier <michael.meier@fau.de>
Cc: xfs@oss.sgi.com

On Sat, Mar 07, 2015 at 08:51:50AM +0100, Michael Meier wrote:
> We've recently upgraded the OS on one of our servers, and since then
> have been experiencing frequent stalls of the XFS filesystem on it.
> Other filesystems on the machine seem to still respond fine while XFS
> hangs. The stalls sometimes last for around 30 minutes, during which all
> attempts to access that filesystem hang completely - after that, the
> filesystem suddenly responds instantly again, as if there had never been
> any problem. The dmesg is full of these messages while it stalls:
>  XFS: possible memory allocation deadlock in kmem_alloc (mode:0x8250)
> These also occour from time to time without the filesystem stalling (or
> at least it's not noticeable) - the messages appear about once in two
> hours, the stalls about once a day.
> 
> Google did point me to some reports of these messages occouring at the
> end of 2013, but the kernels in question should all have had the fixes
> proposed back then - although one message back then suggested there were
> more places where this problem could occour that were not fixed yet.
> 
> Kernels used were:
> - Ubuntu 3.13.0-44  - shows stalls, according to
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1382333 has the fix
> - Ubuntu 3.16.0-31  - shows stalls
> - Ubuntu 3.2.0-various - no stalls in more than 1 year
> We can actually still boot the machine with the 3.2.0 kernel, and it
> will run absolutely fine, but as that kernel will not be supported
> forever, I do not consider that a permanent solution.
> 
> The machine should not be low on memory, the disk array far from its
> limits, and the I/O-load is mostly reads with very little writes, as
> this is a public FTP server.
> 
> I have tried to collect some information, available at
> https://grid.rrze.uni-erlangen.de/~unrz191/syslog-with-xfs-hangs.log
> 

Thanks for the data. Some notes from the backtraces in the first
instance:

- xfsaild is down in xlog_cil_force_lsn()->flush_work(). So it's trying
  to push the log, but the workqueue worker is already running.
- The workqueue worker is here:

	[298163.482697] Workqueue: xfs-cil/dm-0 xlog_cil_push_work [xfs]

... and it appears to be blocked on the ctx lock. This means either a
transaction is completing or somebody else is pushing the cil.
- Writeback and one or two other transactions are backed up waiting on
  the ctx lock.
- rsync is running a transaction completion (e.g., holding ctx lock) and
  blocked on memory allocation:

rsync           D ffff88103f893440     0 44446  43197 0x00000000
 ffff8809e4f7b9f0 0000000000000086 ffff880801a15bb0 ffff8809e4f7bfd8
 0000000000013440 0000000000013440 ffff8810146428c0 ffff881013dd8000
 ffff8809e4f7ba20 00000001046f17ea ffff881013dd8000 000000000000d158
Call Trace:
 [<ffffffff817675c9>] schedule+0x29/0x70
 [<ffffffff817668e5>] schedule_timeout+0x165/0x2a0
 [<ffffffff8107a420>] ? ftrace_raw_event_tick_stop+0xc0/0xc0
 [<ffffffff81767c9b>] io_schedule_timeout+0x9b/0xf0
 [<ffffffff81180403>] congestion_wait+0x73/0x100
 [<ffffffff810b4d10>] ? prepare_to_wait_event+0x100/0x100
 [<ffffffffc01deaac>] kmem_alloc+0x6c/0xf0 [xfs]
 [<ffffffffc022399f>] xfs_log_commit_cil+0x34f/0x470 [xfs]
 [<ffffffffc01de37c>] xfs_trans_commit+0x11c/0x230 [xfs]
 [<ffffffffc0212c81>] xfs_rename+0x601/0x670 [xfs]
 [<ffffffffc01d41c2>] xfs_vn_rename+0x82/0x90 [xfs]
 [<ffffffff811e34de>] vfs_rename+0x56e/0x740
 [<ffffffff811e4383>] SYSC_renameat2+0x483/0x530
 [<ffffffff811d6451>] ? __sb_end_write+0x31/0x60
 [<ffffffff811f208f>] ? mnt_drop_write+0x1f/0x30
 [<ffffffff811f34b4>] ? mntput+0x24/0x40
 [<ffffffff811ea6ac>] ? dput+0x4c/0x180
 [<ffffffff811f34b4>] ? mntput+0x24/0x40
 [<ffffffff811dd39e>] ? path_put+0x1e/0x30
 [<ffffffff811e561e>] SyS_rename+0x1e/0x20
 [<ffffffff8176b66d>] system_call_fastpath+0x1a/0x1f

... so that appears to hold everything else up. 

This looks potentially related to the ongoing transaction context memory
allocation discussion, as this code implements a tight retry loop with
time-based task waits and "no fail" allocations. This is also the source
of the "possible memory allocation deadlock" warning.

Dave might be able to comment a bit further on that. I'm not totally
clear on the mm interaction here and if/what a workaround might be. It
might be a good idea to grab the meminfo data when the stall is actually
in effect.

Considering this is a large memory box (64g), I wonder if some vm tuning
might help mitigate this behavior..? For example, increase
/proc/sys/vm/min_free_kbytes in hopes of allowing more memory for these
allocations when under pressure, or tune down the
dirty_ratio/dirty_background_ratio thresholds to more aggressively get
data onto disk..?

Brian

> Regards,
> -- 
> Michael Meier, Zentrale Systeme
> Friedrich-Alexander-Universitaet Erlangen-Nuernberg
> Regionales Rechenzentrum Erlangen
> Martensstrasse 1, 91058 Erlangen, Germany
> Tel.: +49 9131 85-28973, Fax: +49 9131 302941
> michael.meier@fau.de
> www.rrze.fau.de
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
