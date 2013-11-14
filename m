Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D4987F50
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 07:44:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B241BAC00A
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 05:43:59 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4zianEWdnIVwnaX9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 05:43:58 -0800 (PST)
Date: Thu, 14 Nov 2013 05:43:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: stop special casing nfs and udf
Message-ID: <20131114134356.GA30313@infradead.org>
References: <20131107204635.GA22954@infradead.org>
	<52827113.3080609@sandeen.net> <52827239.9060307@sandeen.net>
	<20131112201343.GA31763@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131112201343.GA31763@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

I verified that xfstests still works fine on UDF.  There's a couple
failures that don't seem to be related to this patch:

076,100,124
	- complain about the missing UDF validator

225
	- udf does not support fiemap, and we don't seem to guard against it

258,309
	- timestamp update issues

277
	- udf does not seem to support the IOC_GET/SET_FLAGS ioctls

285:
	- udf misses proper SEEK_DATA/HOLE support


But we also hit a lockdep splat early on:

generic/005 1s ...[  175.706958] 
[  175.707546] =============================================
[  175.708790] [ INFO: possible recursive locking detected ]
[  175.709911] 3.12.0+ #16 Not tainted
[  175.710001] ---------------------------------------------
[  175.710001] ln/7386 is trying to acquire lock:
[  175.710001]  (&ei->i_data_sem){+.+...}, at: [<ffffffff8142f06d>] udf_get_block+0x8d/0x130
[  175.710001] 
[  175.710001] but task is already holding lock:
[  175.710001]  (&ei->i_data_sem){+.+...}, at: [<ffffffff81431a8d>] udf_symlink+0x8d/0x690
[  175.710001] 
[  175.710001] other info that might help us debug this:
[  175.710001]  Possible unsafe locking scenario:
[  175.710001] 
[  175.710001]        CPU0
[  175.710001]        ----
[  175.710001]   lock(&ei->i_data_sem);
[  175.710001]   lock(&ei->i_data_sem);
[  175.710001] 
[  175.710001]  *** DEADLOCK ***
[  175.710001] 
[  175.710001]  May be due to missing lock nesting notation
[  175.710001] 
[  175.710001] 3 locks held by ln/7386:
[  175.710001]  #0:  (sb_writers#9){.+.+.+}, at: [<ffffffff811a471f>] mnt_want_write+0x1f/0x50
[  175.710001]  #1:  (&type->i_mutex_dir_key#3/1){+.+.+.}, at:
[<ffffffff81192552>] kern_path_create+0x82/0x160
[  175.710001]  #2:  (&ei->i_data_sem){+.+...}, at: [<ffffffff81431a8d>] udf_symlink+0x8d/0x690
[  175.710001] 
[  175.710001] stack backtrace:
[  175.710001] CPU: 1 PID: 7386 Comm: ln Not tainted 3.12.0+ #16
[  175.710001] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  175.710001]  ffffffff82917cd0 ffff88007add9a78 ffffffff81c1f00d ffff88007b66c080
[  175.710001]  ffffffff82917cd0 ffff88007add9b68 ffffffff810f91b2 ffff88007add9b78
[  175.710001]  ffffffff810f8bb3 ffff88007add9b18 ffff88000000031b 0000000000000003
[  175.710001] Call Trace:
[  175.710001]  [<ffffffff81c1f00d>] dump_stack+0x46/0x58
[  175.710001]  [<ffffffff810f91b2>] __lock_acquire+0x8f2/0x1fa0
[  175.710001]  [<ffffffff810f8bb3>] ? __lock_acquire+0x2f3/0x1fa0
[  175.710001]  [<ffffffff810fae28>] lock_acquire+0x98/0x120
[  175.710001]  [<ffffffff8142f06d>] ? udf_get_block+0x8d/0x130
[  175.710001]  [<ffffffff810fb73a>] ? mark_held_locks+0x8a/0x120
[  175.710001]  [<ffffffff811b745f>] ? __find_get_block+0xaf/0x250
[  175.710001]  [<ffffffff81c2533c>] down_write+0x2c/0x50
[  175.710001]  [<ffffffff8142f06d>] ? udf_get_block+0x8d/0x130
[  175.710001]  [<ffffffff8142f06d>] udf_get_block+0x8d/0x130
[  175.710001]  [<ffffffff8142f13c>] udf_getblk+0x2c/0xc0
[  175.710001]  [<ffffffff811b9c60>] ? __getblk+0x20/0x2e0
[  175.710001]  [<ffffffff81c28306>] ? _raw_spin_unlock+0x26/0x30
[  175.710001]  [<ffffffff8142f1ec>] udf_bread+0x1c/0x90
[  175.710001]  [<ffffffff814305ca>] udf_add_entry+0x37a/0xbe0
[  175.710001]  [<ffffffff81431de2>] udf_symlink+0x3e2/0x690
[  175.710001]  [<ffffffff81190c10>] vfs_symlink+0x70/0xb0
[  175.710001]  [<ffffffff81195721>] SyS_symlinkat+0x61/0xc0
[  175.710001]  [<ffffffff81195791>] SyS_symlink+0x11/0x20
[  175.710001]  [<ffffffff81c30739>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
