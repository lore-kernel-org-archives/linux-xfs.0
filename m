Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0C2jDKv030436 for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 20:45:13 -0600
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 475897C45D
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 18:44:54 -0800 (PST)
Received: from an-out-0708.google.com (an-out-0708.google.com
	[209.85.132.244]) by cuda.sgi.com with ESMTP id
	xbxKGImFYVetEiKW for <xfs@oss.sgi.com>;
	Sun, 11 Jan 2009 18:44:54 -0800 (PST)
Received: by an-out-0708.google.com with SMTP id c37so4252622anc.32
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 18:44:54 -0800 (PST)
Message-ID: <a4423d670901111819p7fdada21k6c20363c63cbc10c@mail.gmail.com>
Date: Mon, 12 Jan 2009 05:19:21 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
In-Reply-To: <a4423d670901111648w26e86baajcf7b6d98ff37d043@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20090109044121.GA31280@orion>
	<a4423d670901091418j5c7fdfb2oeba2f4640f8e29d0@mail.gmail.com>
	<a4423d670901091511y68a53808rfaab8148526224c6@mail.gmail.com>
	<a4423d670901100419s2ae106bexac1a538caf654153@mail.gmail.com>
	<20090110143924.GA25900@infradead.org>
	<a4423d670901100709v1e7ce0bfs167547c5001787ac@mail.gmail.com>
	<20090110152803.GA7469@infradead.org> <20090110221459.GA8873@orion>
	<20090111104659.GB8071@disturbed>
	<a4423d670901111648w26e86baajcf7b6d98ff37d043@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, kernel-testers@vger.kernel.org

2009/1/12 Alexander Beregalov <a.beregalov@gmail.com>:
>> Hmmmm - this might be getting closer to the source of the bug.
>> It's being detecting when reading in the buffer to do a left shift
>> now, not during the delete of a record.
>>
>> I'd suggest that you treat this as the same failure and continue
>> the bisect to try to find when no problems show up at all.
>
> 687b890a184fef263ebb773926e1f4aa69240d01 is the first bad commit.
> Does it make sense?
> It can not be reverted from the current git to be sure it is guilty
> due to merge conflicts.
>

No! I got similar bug message on 9eaead5 two hours later.
9eaead5 is previous to 687b890. 9eaead5 might be the first bad commit
or earlier one.
It seems I need to test the kernel for few hours before mark it good.

Filesystem "sdb1": XFS internal error xfs_btree_check_lblock at line
200 of file fs/xfs/xfs_btree.c.  Caller 0xc024c132
Pid: 2481, comm: pdflush Not tainted 2.6.28-rc2-00208-g9eaead5 #4
Call Trace:
 [<c025f212>] ? xfs_cmn_err+0x32/0x60
 [<c025f28e>] xfs_error_report+0x4e/0x50
 [<c024c132>] ? xfs_btree_check_block+0x32/0x40
 [<c024bfbd>] xfs_btree_check_lblock+0x4d/0x190
 [<c024c132>] ? xfs_btree_check_block+0x32/0x40
<...>
Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP ||
cur->bc_private.b.allocated == 0, file: fs/xfs/xfs_btree.c, line: 348
------------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:81!
invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
last sysfs file: /sys/devices/platform/w83627hf.656/name
Modules linked in: w83627hf hwmon_vid i2c_nforce2
Pid: 2481, comm: pdflush Not tainted (2.6.28-rc2-00208-g9eaead5 #4)
EIP: 0060:[<c029d6ee>] EFLAGS: 00010282 CPU: 0
EIP is at assfail+0x1e/0x30
<..>
Call Trace:
 [<c024bcd0>] ? xfs_btree_del_cursor+0x60/0x80
 [<c02445be>] ? xfs_bmapi+0x48e/0x1c90
 [<c014b7a5>] ? __lock_acquire+0x2c5/0x1000
 [<c014b7a5>] ? __lock_acquire+0x2c5/0x1000
 [<c0270cd4>] ? xfs_iomap_write_allocate+0x254/0x450

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
