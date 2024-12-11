Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609801A83E4
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 11:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733918139; cv=none; b=MTRNzUz/nLXSq6G+mHgQrHNe23Xd76fGy49YR0/52f6xIypD/GduQTpwlKOH3qNFRbC6CwWyaXAs2JUBj+qTDInKhYbAwb8TEcS64Kcj3eH729A7lyRLeozzwhxul3+PF42IX9+mcmnwGHD0bSYAruMq/5oIDbqWlomRoJMTATI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733918139; c=relaxed/simple;
	bh=puHM48bA8lxhdaMsc7Lq6Cb9qCZVh9NpISKuO4kwUfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YCcjYo6nx1LSR3FHUYdMUrW2mVAdWdBdK4gwDO73ro/+6GL5aiVrGxjmcMRXV647uKd+sCLxNUAJ70p4VBkRjObUgt0syYnhCyig62ZucFRa2/QQRzZQv92APGz/STHIgyqX7RYLZExwTYLNhckVHpJCpBkNyF63gyHAAdqRjpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rX6lfNUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rX6lfNUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B41C4CED2;
	Wed, 11 Dec 2024 11:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733918139;
	bh=puHM48bA8lxhdaMsc7Lq6Cb9qCZVh9NpISKuO4kwUfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rX6lfNUsRorn4z9D4cmC6hxVPDxGYlokMdoNWjJayVI8/KR6UViPkKqdNtWo8SNeL
	 TVwHF0tDSPY8udBAwRDBblS64O62FMTNpnpb6PLB/bt3hZXx7awr272u8Q3pX7ye2v
	 M8H49T57VMQnl3/lNVM540M6UfzsSAusqdQERrNa+CztV8/YKTdeMlq09N4/eyh1uK
	 PBo2n2SrUB+Ohc1As8aPSJY/ALvjPEGknaK/87z6j6lfbggJNxnC+N5ar9BRhmuNq+
	 79r3VObz66DbliNo+E1LbXllL6gkQgkIoQ3aaHj5byCLb7GhAdpLVrqfcXOw4qFQfY
	 xQageWtnufmpg==
Date: Wed, 11 Dec 2024 12:55:30 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org, 
	dchinner@fromorbit.com
Subject: Re: [PATCH] xfs: fix integer overflow in xlog_grant_head_check
Message-ID: <xxvk3ckwdnz2h6vyaizsepwp2cv7hig5kspfveg636mj2b4kmu@hupkcvrltvkg>
References: <20241210124628.578843-1-cem@kernel.org>
 <Z1jG_4IRUaFmwT_E@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mey5jkbmjx4f3grm"
Content-Disposition: inline
In-Reply-To: <Z1jG_4IRUaFmwT_E@dread.disaster.area>


--mey5jkbmjx4f3grm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave.

On Wed, Dec 11, 2024 at 09:55:59AM +1100, Dave Chinner wrote:
> On Tue, Dec 10, 2024 at 12:54:39PM +0100, cem@kernel.org wrote:
> > From: Carlos Maiolino <cmaiolino@redhat.com>
> > 
> > I tripped over an integer overflow when using a big journal size.
> > 
> > Essentially I can reliably reproduce it using:
> > 
> > mkfs.xfs -f -lsize=393216b -f -b size=4096 -m crc=1,reflink=1,rmapbt=1, \
> > -i sparse=1 /dev/vdb2 > /dev/null
> 
> So that's a 1.2GB log, well within the log size overflow point of
> 2^31 - 1 bytes.

Indeed it is, I basically got the biggest allowed size returned by mkfs when it
initially failed to use an 1.6G external log dev, this size isn't really "that
important", I can also reproduce it using smaller sizes, I previously tested
with 1100M, but just a quick test now does seem the threshold is exactly 1GiB.
-lsize=1024M works fine, -lsize=1025M locks up, I'll use 1025M to gather the
information below.
> 
> What version of xfsprogs are you using here?

I initially used 6.10 and 6.11, I just tested on TOT, nothing different.

> 
> > mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt
> > xfs_io -x -c 'shutdown -f' /mnt
> 
> Ok, so a shutdown with a log flush to leave the log dirty. What is
> in the log at this point?

I'm attaching the logprint here, nothing stands out to me, but I'm not sure
exactly what I'm looking for.

I
> 
> > umount /mnt
> > mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt
> > 
> > The last mount command get stuck on the following path:
> > 
> > [<0>] xlog_grant_head_wait+0x5d/0x2a0 [xfs]
> > [<0>] xlog_grant_head_check+0x112/0x180 [xfs]
> > [<0>] xfs_log_reserve+0xe3/0x260 [xfs]
> > [<0>] xfs_trans_reserve+0x179/0x250 [xfs]
> > [<0>] xfs_trans_alloc+0x101/0x260 [xfs]
> > [<0>] xfs_sync_sb+0x3f/0x80 [xfs]
> > [<0>] xfs_qm_mount_quotas+0xe3/0x2f0 [xfs]
> > [<0>] xfs_mountfs+0x7ad/0xc20 [xfs]
> > [<0>] xfs_fs_fill_super+0x762/0xa50 [xfs]
> > [<0>] get_tree_bdev_flags+0x131/0x1d0
> > [<0>] vfs_get_tree+0x26/0xd0
> > [<0>] vfs_cmd_create+0x59/0xe0
> > [<0>] __do_sys_fsconfig+0x4e3/0x6b0
> > [<0>] do_syscall_64+0x82/0x160
> > [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > 
> > By investigating it a bit, I noticed that xlog_grant_head_check (called
> > from xfs_log_reserve), defines free_bytes as an integer, which in turn
> > is used to store the value from xlog_grant_space_left().
> > xlog_grant_space_left() however, does return a uint64_t, and, giving a
> > big enough journal size, it can overflow the free_bytes in
> > xlog_grant_head_check(),
> 
> I can see that an overflow definitely appears to be occurring, but I
> cannot explain how it is occurring from the information in commit
> message.

Me neither.

> 
> That is, the return value of xlog_grant_space_left() is supposed to
> be clamped to 0 <= space <= log->l_logsize. If the return value is
> out of that range, (i.e. can overflow a signed int) it means there
> is some other problem with the xlog_grant_space_left() calculation
> and the overflow of the return value is a downstream symptom and
> not the root cause.

Yes, that's what I'm afraid of, as I initially stated on the patch (and we spoke
previously about it), I'm afraid I've been just fixing a symptom. Even though
the overflow is indeed real, it seems mostly a symptom of something else going
wrong.

> 
> i.e. by definition xlog_grant_space_left() must be returning
> free_bytes > log->l_logsize to overflow an int. The cause of that
> behaviour is what we need to find and fix....
> 
> We should have enough trace points in the AIL and log head/tail
> accounting to see where the head, tail or space calculation is going
> wrong during the mount - do you have a trace from the failed mount
> that I can look at?  i.e. run 'trace-cmd record -e xfs\* sleep 60'
> in one terminal, then run the reproducer in another. Then when
> the trace finishes, run `trace-cmd report > t.txt` and point me at
> the generated report...

Yes, indeed I tried to look into the trace, but I couldn't find anything that
stands out to me, but, as I said, I don't have enough knowledge in the logging
mechanism yet to get something meaningful out of it.

One thing that stands out to me, but it doesn't seem to be the cause of it. was
the size of the grant heads, but IIRC, you mentioned this is correct as they are
not initialized at the time:

mount-1504  [009]   146.457545: xfs_log_reserve:      dev 252:18 tic 0xffffa084d7e93900    \
t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags reserveq empty writeq empty tail  \
space 0 grant_reserve_bytes 18446744072634764800 grant_write_bytes 18446744072634764800    \
curr_cycle 1 curr_block 7 tail_cycle 1 tail_block 0

mount-1504  [009]   146.457548: xfs_log_grant_sleep:  dev 252:18 tic 0xffffa084d7e93900    \
t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags reserveq active writeq empty tail \
 space 0 grant_reserve_bytes 18446744072634764800 grant_write_bytes 18446744072634764800   \
curr_cycle 1 curr_block 7 tail_cycle 1 tail_block 0


> 
> > in xlog_grant_head_check() to evaluate to true and cause xfsaild to try
> > to flush the log indefinitely, which seems to be causing xfs to get
> > stuck in xlog_grant_head_wait() indefinitely.
> > 
> > I'm adding a fixes tag as a suggestion from hch, giving that after the
> > aforementioned patch, all xlog_grant_space_left() callers should store
> > the return value on a 64bit type.
> > 
> > Fixes: c1220522ef40 ("xfs: grant heads track byte counts, not LSNs")
> 
> I'm not sure this is actually the source of the issue, or
> whether it simply exposed some other underlying problem we aren't
> yet aware of....

Indeed, it does feel like the overflow is just a symptom.

I just ran the reproducer on the current TOT, and both the logprint and
the full trace are attached.

Cheers.

-Carlos

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

--mey5jkbmjx4f3grm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="logprint.txt"

xfs_logprint:
    data device: 0xfc12
    log device: 0xfc12 daddr: 20971576 length: 2099200

cycle: 1	version: 2		lsn: 1,0	tail_lsn: 1,0
length of Log Record: 512	prev offset: -1		num ops: 1
uuid: 840ca3d6-eb0e-4fec-9d7a-6932ecafb754   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: b0c0d0d0  len: 8  clientid: LOG  flags: UNMOUNT 
Unmount filesystem

============================================================================
cycle: 1	version: 2		lsn: 1,2	tail_lsn: 1,2
length of Log Record: 3072	prev offset: 0		num ops: 28
uuid: 840ca3d6-eb0e-4fec-9d7a-6932ecafb754   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 4a9e86ff  len: 0  clientid: TRANS  flags: START 
----------------------------------------------------------------------------
Oper (1): tid: 4a9e86ff  len: 16  clientid: TRANS  flags: none
TRAN:     tid: 4a9e86ff  num_items: 25
----------------------------------------------------------------------------
Oper (2): tid: 4a9e86ff  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 2 (0x2)  len: 1  bmap size: 1  flags: 0x3800
Oper (3): tid: 4a9e86ff  len: 128  clientid: TRANS  flags: none
AGI Buffer: XAGI  
ver: 1  seq#: 0  len: 1310720  cnt: 64  root: 3
level: 1  free#: 0x3a  newino: 0x80
bucket[0 - 3]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff 
bucket[4 - 7]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff 
bucket[8 - 11]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff 
bucket[12 - 15]: 0xffffffff 0xffffffff 0xffffffff 0xffffffff 
bucket[16 - 19]: 0xffffffff 
----------------------------------------------------------------------------
Oper (4): tid: 4a9e86ff  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 32 (0x20)  len: 8  bmap size: 1  flags: 0x2000
Oper (5): tid: 4a9e86ff  len: 128  clientid: TRANS  flags: none
BUF DATA
----------------------------------------------------------------------------
Oper (6): tid: 4a9e86ff  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 24 (0x18)  len: 8  bmap size: 1  flags: 0x2000
Oper (7): tid: 4a9e86ff  len: 128  clientid: TRANS  flags: none
BUF DATA
----------------------------------------------------------------------------
Oper (8): tid: 4a9e86ff  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 0 (0x0)  len: 1  bmap size: 1  flags: 0x9000
Oper (9): tid: 4a9e86ff  len: 384  clientid: TRANS  flags: none
SUPER BLOCK Buffer: 
icount: 6360863066640355328  ifree: 5242880  fdblks: 0  frext: 0
----------------------------------------------------------------------------
Oper (10): tid: 4a9e86ff  len: 56  clientid: TRANS  flags: none
INODE: #regs: 3   ino: 0x83  flags: 0x5   dsize: 16
        blkno: 128  len: 32  boff: 1536
Oper (11): tid: 4a9e86ff  len: 176  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100000 version 3 format 2
nlink 1 uid 0 gid 0
atime 0x7d3ab25a mtime 0x7d3ab25a ctime 0x7d3ab25a
size 0x0 nblocks 0x1 extsize 0x0 nextents 0x1
naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
flags 0x0 gen 0x6c505029
flags2 0x18 cowextsize 0x0
Oper (12): tid: 4a9e86ff  len: 16  clientid: TRANS  flags: none
EXTENTS inode data
----------------------------------------------------------------------------
Oper (13): tid: 4a9e86ff  len: 56  clientid: TRANS  flags: none
INODE: #regs: 3   ino: 0x84  flags: 0x5   dsize: 16
        blkno: 128  len: 32  boff: 2048
Oper (14): tid: 4a9e86ff  len: 176  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100000 version 3 format 2
nlink 1 uid 0 gid 0
atime 0x7d3ab25a mtime 0x7d3ab25a ctime 0x7d3ab25a
size 0x0 nblocks 0x1 extsize 0x0 nextents 0x1
naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
flags 0x0 gen 0xa32114b7
flags2 0x18 cowextsize 0x0
Oper (15): tid: 4a9e86ff  len: 16  clientid: TRANS  flags: none
EXTENTS inode data
----------------------------------------------------------------------------
Oper (16): tid: 4a9e86ff  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 1 (0x1)  len: 1  bmap size: 1  flags: 0x2800
Oper (17): tid: 4a9e86ff  len: 128  clientid: TRANS  flags: none
AGF Buffer: XAGF  
ver: 1  seq#: 0  len: 1310720  
root BNO: 1  CNT: 2
level BNO: 1  CNT: 1
1st: 1  last: 6  cnt: 6  freeblks: 1310696  longest: 1310696
----------------------------------------------------------------------------
Oper (18): tid: 4a9e86ff  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 16 (0x10)  len: 8  bmap size: 1  flags: 0x2000
Oper (19): tid: 4a9e86ff  len: 128  clientid: TRANS  flags: none
BUF DATA
----------------------------------------------------------------------------
Oper (20): tid: 4a9e86ff  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 8 (0x8)  len: 8  bmap size: 1  flags: 0x2000
Oper (21): tid: 4a9e86ff  len: 128  clientid: TRANS  flags: none
BUF DATA
----------------------------------------------------------------------------
Oper (22): tid: 4a9e86ff  len: 56  clientid: TRANS  flags: none
INODE: #regs: 3   ino: 0x85  flags: 0x5   dsize: 16
        blkno: 128  len: 32  boff: 2560
Oper (23): tid: 4a9e86ff  len: 176  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100000 version 3 format 2
nlink 1 uid 0 gid 0
atime 0x7d3ab25a mtime 0x7d3ab25a ctime 0x7d3ab25a
size 0x0 nblocks 0x1 extsize 0x0 nextents 0x1
naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
flags 0x0 gen 0x2aea5fc7
flags2 0x18 cowextsize 0x0
Oper (24): tid: 4a9e86ff  len: 16  clientid: TRANS  flags: none
EXTENTS inode data
----------------------------------------------------------------------------
Oper (25): tid: 4a9e86ff  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 40 (0x28)  len: 8  bmap size: 1  flags: 0x2000
Oper (26): tid: 4a9e86ff  len: 384  clientid: TRANS  flags: none
BUF DATA
----------------------------------------------------------------------------
Oper (27): tid: 4a9e86ff  len: 0  clientid: TRANS  flags: COMMIT 

============================================================================
cycle: 1	version: 2		lsn: 1,9	tail_lsn: 1,2
length of Log Record: 512	prev offset: 2		num ops: 5
uuid: 840ca3d6-eb0e-4fec-9d7a-6932ecafb754   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 862dfc2e  len: 0  clientid: TRANS  flags: START 
----------------------------------------------------------------------------
Oper (1): tid: 862dfc2e  len: 16  clientid: TRANS  flags: none
TRAN:     tid: 862dfc2e  num_items: 2
----------------------------------------------------------------------------
Oper (2): tid: 862dfc2e  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 0 (0x0)  len: 1  bmap size: 1  flags: 0x9000
Oper (3): tid: 862dfc2e  len: 384  clientid: TRANS  flags: none
SUPER BLOCK Buffer: 
icount: 6360863066640355328  ifree: 5242880  fdblks: 0  frext: 0
----------------------------------------------------------------------------
Oper (4): tid: 862dfc2e  len: 0  clientid: TRANS  flags: COMMIT 

============================================================================
xfs_logprint: skipped 4087 cleared blocks in range: 11 - 4097
xfs_logprint: skipped 2095102 zeroed blocks in range: 4098 - 2099199
xfs_logprint: physical end of log
============================================================================
xfs_logprint: logical end of log
============================================================================

--mey5jkbmjx4f3grm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trace.txt"

           mount-1504  [009]   146.449458: xfs_buf_init:         dev 252:18 daddr 0xffffffffffffffff bbcount 0x1 hold 1 pincount 0 lock 0 flags NO_IOACCT bufops 0x0 caller xfs_buf_get_uncached+0x5c
           mount-1504  [009]   146.449461: xfs_buf_get_uncached: dev 252:18 daddr 0xffffffffffffffff bbcount 0x1 hold 1 pincount 0 lock 0 flags NO_IOACCT|PAGES bufops 0x0 caller xfs_buf_read_uncached+0x40
           mount-1504  [009]   146.449461: xfs_buf_submit:       dev 252:18 daddr 0x0 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|NO_IOACCT|PAGES bufops 0x0 caller xfs_buf_read_uncached+0x87
           mount-1504  [009]   146.449462: xfs_buf_hold:         dev 252:18 daddr 0x0 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|NO_IOACCT|PAGES bufops 0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.449475: xfs_buf_iowait:       dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|NO_IOACCT|PAGES bufops 0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.449684: xfs_buf_iodone:       dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|NO_IOACCT|PAGES bufops 0x0 caller process_one_work+0x176
           mount-1504  [009]   146.449692: xfs_buf_iowait_done:  dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES bufops 0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.449693: xfs_buf_rele:         dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES bufops 0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.449694: xfs_buf_unlock:       dev 252:18 daddr 0x0 bbcount 0x1 hold 1 pincount 0 lock 1 flags NO_IOACCT|DONE|PAGES bufops 0x0 caller xfs_readsb+0xbe
           mount-1504  [009]   146.449695: xfs_buf_rele:         dev 252:18 daddr 0x0 bbcount 0x1 hold 1 pincount 0 lock 1 flags NO_IOACCT|DONE|PAGES bufops 0x0 caller xfs_readsb+0xc6
           mount-1504  [009]   146.449695: xfs_buf_free:         dev 252:18 daddr 0x0 bbcount 0x1 hold 0 pincount 0 lock 1 flags NO_IOACCT|DONE|PAGES bufops 0x0 caller xfs_readsb+0xc6
           mount-1504  [009]   146.449697: xfs_buf_init:         dev 252:18 daddr 0xffffffffffffffff bbcount 0x1 hold 1 pincount 0 lock 0 flags NO_IOACCT bufops 0x0 caller xfs_buf_get_uncached+0x5c
           mount-1504  [009]   146.449698: xfs_buf_get_uncached: dev 252:18 daddr 0xffffffffffffffff bbcount 0x1 hold 1 pincount 0 lock 0 flags NO_IOACCT|PAGES bufops 0x0 caller xfs_buf_read_uncached+0x40
           mount-1504  [009]   146.449699: xfs_buf_submit:       dev 252:18 daddr 0x0 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|NO_IOACCT|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_buf_read_uncached+0x87
           mount-1504  [009]   146.449699: xfs_buf_hold:         dev 252:18 daddr 0x0 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|NO_IOACCT|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.449705: xfs_buf_iowait:       dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|NO_IOACCT|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.449808: xfs_buf_iodone:       dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|NO_IOACCT|PAGES bufops xfs_sb_buf_ops+0x0 caller process_one_work+0x176
           mount-1504  [009]   146.449818: xfs_buf_iowait_done:  dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.449819: xfs_buf_rele:         dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.449822: xfs_buf_unlock:       dev 252:18 daddr 0x0 bbcount 0x1 hold 1 pincount 0 lock 1 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_readsb+0x1ae
           mount-1504  [009]   146.449826: xfs_inode_timestamp_range: dev 252:18 min -2147483648 max 16299260424
           mount-1504  [009]   146.449907: xfs_buf_init:         dev 252:18 daddr 0xffffffffffffffff bbcount 0x1 hold 1 pincount 0 lock 0 flags  bufops 0x0 caller xfs_buf_get_uncached+0x5c
           mount-1504  [009]   146.449908: xfs_buf_get_uncached: dev 252:18 daddr 0xffffffffffffffff bbcount 0x1 hold 1 pincount 0 lock 0 flags PAGES bufops 0x0 caller xfs_buf_read_uncached+0x40
           mount-1504  [009]   146.449909: xfs_buf_submit:       dev 252:18 daddr 0x27fffff bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|PAGES bufops 0x0 caller xfs_buf_read_uncached+0x87
           mount-1504  [009]   146.449909: xfs_buf_hold:         dev 252:18 daddr 0x27fffff bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|PAGES bufops 0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.449916: xfs_buf_iowait:       dev 252:18 daddr 0x27fffff bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|PAGES bufops 0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.450027: xfs_buf_iodone:       dev 252:18 daddr 0x27fffff bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|PAGES bufops 0x0 caller process_one_work+0x176
           mount-1504  [009]   146.450032: xfs_buf_iowait_done:  dev 252:18 daddr 0x27fffff bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops 0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.450032: xfs_buf_rele:         dev 252:18 daddr 0x27fffff bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops 0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.450033: xfs_buf_unlock:       dev 252:18 daddr 0x27fffff bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops 0x0 caller xfs_check_sizes+0xcd
           mount-1504  [009]   146.450033: xfs_buf_rele:         dev 252:18 daddr 0x27fffff bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops 0x0 caller xfs_check_sizes+0xd5
           mount-1504  [009]   146.450033: xfs_buf_free:         dev 252:18 daddr 0x27fffff bbcount 0x1 hold 0 pincount 0 lock 1 flags DONE|PAGES bufops 0x0 caller xfs_check_sizes+0xd5
           mount-1504  [009]   146.450038: xfs_trans_resv_calc:  dev 252:18 type 0 logres 193528 logcount 5 flags 0x4
           mount-1504  [009]   146.450039: xfs_trans_resv_calc:  dev 252:18 type 1 logres 327552 logcount 5 flags 0x4
           mount-1504  [009]   146.450039: xfs_trans_resv_calc:  dev 252:18 type 2 logres 426968 logcount 2 flags 0x4
           mount-1504  [009]   146.450039: xfs_trans_resv_calc:  dev 252:18 type 3 logres 246896 logcount 2 flags 0x4
           mount-1504  [009]   146.450039: xfs_trans_resv_calc:  dev 252:18 type 4 logres 230512 logcount 2 flags 0x4
           mount-1504  [009]   146.450040: xfs_trans_resv_calc:  dev 252:18 type 5 logres 312304 logcount 3 flags 0x4
           mount-1504  [009]   146.450040: xfs_trans_resv_calc:  dev 252:18 type 6 logres 311152 logcount 2 flags 0x4
           mount-1504  [009]   146.450040: xfs_trans_resv_calc:  dev 252:18 type 7 logres 285696 logcount 2 flags 0x4
           mount-1504  [009]   146.450040: xfs_trans_resv_calc:  dev 252:18 type 8 logres 311152 logcount 3 flags 0x4
           mount-1504  [009]   146.450041: xfs_trans_resv_calc:  dev 252:18 type 9 logres 303992 logcount 2 flags 0x4
           mount-1504  [009]   146.450041: xfs_trans_resv_calc:  dev 252:18 type 10 logres 2168 logcount 0 flags 0x0
           mount-1504  [009]   146.450041: xfs_trans_resv_calc:  dev 252:18 type 11 logres 82176 logcount 2 flags 0x4
           mount-1504  [009]   146.450041: xfs_trans_resv_calc:  dev 252:18 type 12 logres 116856 logcount 2 flags 0x4
           mount-1504  [009]   146.450042: xfs_trans_resv_calc:  dev 252:18 type 13 logres 760 logcount 0 flags 0x0
           mount-1504  [009]   146.450042: xfs_trans_resv_calc:  dev 252:18 type 14 logres 326784 logcount 1 flags 0x4
           mount-1504  [009]   146.450042: xfs_trans_resv_calc:  dev 252:18 type 15 logres 23288 logcount 3 flags 0x4
           mount-1504  [009]   146.450042: xfs_trans_resv_calc:  dev 252:18 type 16 logres 21760 logcount 0 flags 0x0
           mount-1504  [009]   146.450042: xfs_trans_resv_calc:  dev 252:18 type 17 logres 164480 logcount 3 flags 0x4
           mount-1504  [009]   146.450043: xfs_trans_resv_calc:  dev 252:18 type 18 logres 640 logcount 0 flags 0x0
           mount-1504  [009]   146.450043: xfs_trans_resv_calc:  dev 252:18 type 19 logres 111864 logcount 2 flags 0x4
           mount-1504  [009]   146.450043: xfs_trans_resv_calc:  dev 252:18 type 20 logres 4224 logcount 0 flags 0x0
           mount-1504  [009]   146.450043: xfs_trans_resv_calc:  dev 252:18 type 21 logres 6512 logcount 0 flags 0x0
           mount-1504  [009]   146.450044: xfs_trans_resv_calc:  dev 252:18 type 22 logres 232 logcount 1 flags 0x0
           mount-1504  [009]   146.450044: xfs_trans_resv_calc:  dev 252:18 type 23 logres 197751 logcount 5 flags 0x4
           mount-1504  [009]   146.450044: xfs_trans_resv_calc:  dev 252:18 type 24 logres 640 logcount 1 flags 0x0
           mount-1504  [009]   146.450044: xfs_trans_resv_calc:  dev 252:18 type 25 logres 760 logcount 0 flags 0x0
           mount-1504  [009]   146.450052: xfs_group_get:        dev 252:18 agno 0x0 passive refs 0 active refs 1 caller xfs_set_inode_alloc+0x123
           mount-1504  [009]   146.450052: xfs_group_put:        dev 252:18 agno 0x0 passive refs 1 active refs 1 caller xfs_set_inode_alloc+0x149
           mount-1504  [009]   146.450052: xfs_group_get:        dev 252:18 agno 0x1 passive refs 0 active refs 1 caller xfs_set_inode_alloc+0x123
           mount-1504  [009]   146.450053: xfs_group_put:        dev 252:18 agno 0x1 passive refs 1 active refs 1 caller xfs_set_inode_alloc+0x149
           mount-1504  [009]   146.450053: xfs_group_get:        dev 252:18 agno 0x2 passive refs 0 active refs 1 caller xfs_set_inode_alloc+0x123
           mount-1504  [009]   146.450053: xfs_group_put:        dev 252:18 agno 0x2 passive refs 1 active refs 1 caller xfs_set_inode_alloc+0x149
           mount-1504  [009]   146.450054: xfs_group_get:        dev 252:18 agno 0x3 passive refs 0 active refs 1 caller xfs_set_inode_alloc+0x123
           mount-1504  [009]   146.450054: xfs_group_put:        dev 252:18 agno 0x3 passive refs 1 active refs 1 caller xfs_set_inode_alloc+0x149
           mount-1504  [009]   146.452415: xfs_trans_resv_calc_minlogsize: dev 252:18 type 0 logres 303352 logcount 8 flags 0x4
           mount-1504  [009]   146.452415: xfs_trans_resv_calc_minlogsize: dev 252:18 type 1 logres 547200 logcount 8 flags 0x4
           mount-1504  [009]   146.452416: xfs_trans_resv_calc_minlogsize: dev 252:18 type 2 logres 426968 logcount 2 flags 0x4
           mount-1504  [009]   146.452416: xfs_trans_resv_calc_minlogsize: dev 252:18 type 3 logres 246896 logcount 2 flags 0x4
           mount-1504  [009]   146.452416: xfs_trans_resv_calc_minlogsize: dev 252:18 type 4 logres 248448 logcount 2 flags 0x4
           mount-1504  [009]   146.452416: xfs_trans_resv_calc_minlogsize: dev 252:18 type 5 logres 371200 logcount 3 flags 0x4
           mount-1504  [009]   146.452416: xfs_trans_resv_calc_minlogsize: dev 252:18 type 6 logres 370048 logcount 2 flags 0x4
           mount-1504  [009]   146.452416: xfs_trans_resv_calc_minlogsize: dev 252:18 type 7 logres 387072 logcount 2 flags 0x4
           mount-1504  [009]   146.452416: xfs_trans_resv_calc_minlogsize: dev 252:18 type 8 logres 370048 logcount 3 flags 0x4
           mount-1504  [009]   146.452417: xfs_trans_resv_calc_minlogsize: dev 252:18 type 9 logres 405368 logcount 2 flags 0x4
           mount-1504  [009]   146.452417: xfs_trans_resv_calc_minlogsize: dev 252:18 type 10 logres 2168 logcount 0 flags 0x0
           mount-1504  [009]   146.452417: xfs_trans_resv_calc_minlogsize: dev 252:18 type 11 logres 115968 logcount 2 flags 0x4
           mount-1504  [009]   146.452417: xfs_trans_resv_calc_minlogsize: dev 252:18 type 12 logres 150648 logcount 2 flags 0x4
           mount-1504  [009]   146.452417: xfs_trans_resv_calc_minlogsize: dev 252:18 type 13 logres 760 logcount 0 flags 0x0
           mount-1504  [009]   146.452417: xfs_trans_resv_calc_minlogsize: dev 252:18 type 14 logres 461952 logcount 1 flags 0x4
           mount-1504  [009]   146.452418: xfs_trans_resv_calc_minlogsize: dev 252:18 type 15 logres 23288 logcount 3 flags 0x4
           mount-1504  [009]   146.452418: xfs_trans_resv_calc_minlogsize: dev 252:18 type 16 logres 21760 logcount 0 flags 0x0
           mount-1504  [009]   146.452418: xfs_trans_resv_calc_minlogsize: dev 252:18 type 17 logres 232064 logcount 3 flags 0x4
           mount-1504  [009]   146.452418: xfs_trans_resv_calc_minlogsize: dev 252:18 type 18 logres 640 logcount 0 flags 0x0
           mount-1504  [009]   146.452418: xfs_trans_resv_calc_minlogsize: dev 252:18 type 19 logres 145656 logcount 2 flags 0x4
           mount-1504  [009]   146.452418: xfs_trans_resv_calc_minlogsize: dev 252:18 type 20 logres 4224 logcount 0 flags 0x0
           mount-1504  [009]   146.452418: xfs_trans_resv_calc_minlogsize: dev 252:18 type 21 logres 6512 logcount 0 flags 0x0
           mount-1504  [009]   146.452418: xfs_trans_resv_calc_minlogsize: dev 252:18 type 22 logres 232 logcount 1 flags 0x0
           mount-1504  [009]   146.452419: xfs_trans_resv_calc_minlogsize: dev 252:18 type 23 logres 307575 logcount 8 flags 0x4
           mount-1504  [009]   146.452419: xfs_trans_resv_calc_minlogsize: dev 252:18 type 24 logres 640 logcount 1 flags 0x0
           mount-1504  [009]   146.452419: xfs_trans_resv_calc_minlogsize: dev 252:18 type 25 logres 760 logcount 0 flags 0x0
           mount-1504  [009]   146.452419: xfs_log_get_max_trans_res: dev 252:18 logres 547200 logcount 8
           mount-1504  [009]   146.452585: xfs_inodegc_start:    dev 252:18 m_features 0x40000000059ff6aa opstate (read_only|inodegc) s_flags 0x10810001 caller xfs_mountfs+0x64e
           mount-1504  [009]   146.452585: xfs_blockgc_start:    dev 252:18 m_features 0x40000000059ff6aa opstate (read_only|inodegc|blockgc) s_flags 0x10810001 caller xfs_mountfs+0x656
           mount-1504  [009]   146.452587: xfs_group_get:        dev 252:18 agno 0x0 passive refs 0 active refs 1 caller xfs_iget+0xd6
           mount-1504  [009]   146.452592: xfs_ialloc_read_agi:  dev 252:18 agno 0x0
           mount-1504  [009]   146.452593: xfs_read_agi:         dev 252:18 agno 0x0
           mount-1504  [009]   146.452594: xfs_group_get:        dev 252:18 agno 0x0 passive refs 1 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.452594: xfs_buf_init:         dev 252:18 daddr 0x2 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
           mount-1504  [009]   146.452595: xfs_buf_get:          dev 252:18 daddr 0x2 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.452596: xfs_buf_read:         dev 252:18 daddr 0x2 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.452596: xfs_buf_submit:       dev 252:18 daddr 0x2 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_read_map+0x11f
           mount-1504  [009]   146.452597: xfs_buf_hold:         dev 252:18 daddr 0x2 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.452606: xfs_buf_iowait:       dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.452773: xfs_buf_iodone:       dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller process_one_work+0x176
           mount-1504  [009]   146.452782: xfs_buf_iowait_done:  dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.452782: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.452782: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.452783: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 2 active refs 1 caller xfs_inobt_init_cursor+0x67
           mount-1504  [009]   146.452785: xfs_group_get:        dev 252:18 agno 0x0 passive refs 3 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.452785: xfs_buf_init:         dev 252:18 daddr 0x18 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
           mount-1504  [009]   146.452787: xfs_buf_get:          dev 252:18 daddr 0x18 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.452787: xfs_buf_read:         dev 252:18 daddr 0x18 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.452787: xfs_buf_submit:       dev 252:18 daddr 0x18 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_read_map+0x11f
           mount-1504  [009]   146.452788: xfs_buf_hold:         dev 252:18 daddr 0x18 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.452794: xfs_buf_iowait:       dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.452876: xfs_buf_iodone:       dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller process_one_work+0x176
           mount-1504  [009]   146.452889: xfs_buf_iowait_done:  dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.452889: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.452889: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.452892: xfs_buf_unlock:       dev 252:18 daddr 0x2 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.452892: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_imap_lookup+0x172
           mount-1504  [009]   146.452892: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_imap_lookup+0x172
           mount-1504  [009]   146.452893: xfs_buf_unlock:       dev 252:18 daddr 0x18 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.452893: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_btree_del_cursor+0x26
           mount-1504  [009]   146.452894: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_btree_del_cursor+0x26
           mount-1504  [009]   146.452894: xfs_group_put:        dev 252:18 agno 0x0 passive refs 4 active refs 1 caller xfs_btree_del_cursor+0x5f
           mount-1504  [009]   146.452894: xfs_group_get:        dev 252:18 agno 0x0 passive refs 3 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.452895: xfs_buf_init:         dev 252:18 daddr 0x80 bbcount 0x20 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
           mount-1504  [009]   146.452897: xfs_buf_get:          dev 252:18 daddr 0x80 bbcount 0x20 hold 1 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.452898: xfs_buf_read:         dev 252:18 daddr 0x80 bbcount 0x20 hold 1 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.452898: xfs_buf_submit:       dev 252:18 daddr 0x80 bbcount 0x20 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_read_map+0x11f
           mount-1504  [009]   146.452898: xfs_buf_hold:         dev 252:18 daddr 0x80 bbcount 0x20 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_inode_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.452903: xfs_buf_iowait:       dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_inode_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.453007: xfs_buf_iodone:       dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_inode_buf_ops+0x0 caller process_one_work+0x176
           mount-1504  [009]   146.453011: xfs_buf_iowait_done:  dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.453012: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453012: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453021: xfs_buf_unlock:       dev 252:18 daddr 0x80 bbcount 0x20 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453021: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_iget+0x622
           mount-1504  [009]   146.453021: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_iget+0x622
           mount-1504  [009]   146.453022: xfs_iget_miss:        dev 252:18 ino 0x80 iflags 0x0
           mount-1504  [009]   146.453022: xfs_ilock_nowait:     dev 252:18 ino 0x80 flags ILOCK_EXCL caller xfs_iget+0xa85
           mount-1504  [009]   146.453023: xfs_group_put:        dev 252:18 agno 0x0 passive refs 4 active refs 1 caller xfs_iget+0x725
           mount-1504  [009]   146.453024: xfs_iunlock:          dev 252:18 ino 0x80 flags ILOCK_EXCL caller xfs_mountfs+0x6e9
           mount-1504  [009]   146.453026: xfs_trans_alloc:      dev 252:18 trans 0 flags 0x20 caller xfs_trans_alloc_empty+0x43
           mount-1504  [009]   146.453026: xfs_group_grab:       dev 252:18 rtgno 0x0 passive refs 0 active refs 1 caller xfs_rtmount_inodes+0xba
           mount-1504  [009]   146.453027: xfs_group_get:        dev 252:18 agno 0x0 passive refs 3 active refs 1 caller xfs_iget+0xd6
           mount-1504  [009]   146.453029: xfs_group_get:        dev 252:18 agno 0x0 passive refs 4 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453030: xfs_buf_lock:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453030: xfs_buf_lock_done:    dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453030: xfs_buf_find:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453030: xfs_group_put:        dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453031: xfs_buf_get:          dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453031: xfs_buf_read:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453031: xfs_buf_hold:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
           mount-1504  [009]   146.453032: xfs_trans_add_item:   dev 252:18 trans 0 flags 0x20 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.453032: xfs_trans_read_buf:   dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.453034: xfs_trans_brelse:     dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.453034: xfs_buf_item_relse:   dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_put+0x39
           mount-1504  [009]   146.453034: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_relse+0x88
           mount-1504  [009]   146.453035: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_relse+0x88
           mount-1504  [009]   146.453035: xfs_buf_unlock:       dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453035: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_iget+0x622
           mount-1504  [009]   146.453036: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_iget+0x622
           mount-1504  [009]   146.453036: xfs_iget_miss:        dev 252:18 ino 0x81 iflags 0x0
           mount-1504  [009]   146.453036: xfs_group_put:        dev 252:18 agno 0x0 passive refs 4 active refs 1 caller xfs_iget+0x725
           mount-1504  [009]   146.453037: xfs_ilock:            dev 252:18 ino 0x81 flags ILOCK_EXCL caller xfs_rtmount_inodes+0xf6
           mount-1504  [009]   146.453037: xfs_iunlock:          dev 252:18 ino 0x81 flags ILOCK_EXCL caller xfs_rtmount_inodes+0x79
           mount-1504  [009]   146.453037: xfs_group_get:        dev 252:18 agno 0x0 passive refs 3 active refs 1 caller xfs_iget+0xd6
           mount-1504  [009]   146.453038: xfs_group_get:        dev 252:18 agno 0x0 passive refs 4 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453038: xfs_buf_lock:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453038: xfs_buf_lock_done:    dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453039: xfs_buf_find:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453039: xfs_group_put:        dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453039: xfs_buf_get:          dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453039: xfs_buf_read:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453039: xfs_buf_hold:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
           mount-1504  [009]   146.453039: xfs_trans_add_item:   dev 252:18 trans 0 flags 0x20 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.453039: xfs_trans_read_buf:   dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.453040: xfs_trans_brelse:     dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.453040: xfs_buf_item_relse:   dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_put+0x39
           mount-1504  [009]   146.453041: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_relse+0x88
           mount-1504  [009]   146.453041: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_relse+0x88
           mount-1504  [009]   146.453041: xfs_buf_unlock:       dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453041: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_iget+0x622
           mount-1504  [009]   146.453041: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_iget+0x622
           mount-1504  [009]   146.453042: xfs_iget_miss:        dev 252:18 ino 0x82 iflags 0x0
           mount-1504  [009]   146.453042: xfs_group_put:        dev 252:18 agno 0x0 passive refs 4 active refs 1 caller xfs_iget+0x725
           mount-1504  [009]   146.453042: xfs_ilock:            dev 252:18 ino 0x82 flags ILOCK_EXCL caller xfs_rtmount_inodes+0xf6
           mount-1504  [009]   146.453043: xfs_iunlock:          dev 252:18 ino 0x82 flags ILOCK_EXCL caller xfs_rtmount_inodes+0x79
           mount-1504  [009]   146.453043: xfs_group_rele:       dev 252:18 rtgno 0x0 passive refs 0 active refs 2 caller xfs_group_next_range+0x2d
           mount-1504  [009]   146.453044: xfs_trans_cancel:     dev 252:18 trans 0 flags 0x20 caller xfs_rtmount_inodes+0x146
           mount-1504  [009]   146.453045: xfs_trans_free_items: dev 252:18 trans 0 flags 0x20 caller xfs_trans_cancel+0x9d
           mount-1504  [009]   146.453045: xfs_trans_free:       dev 252:18 trans 0 flags 0x20 caller xfs_rtmount_inodes+0x146
           mount-1504  [009]   146.453045: xfs_group_get:        dev 252:18 agno 0x0 passive refs 3 active refs 1 caller xfs_initialize_perag_data+0xa3
           mount-1504  [009]   146.453046: xfs_alloc_read_agf:   dev 252:18 agno 0x0
           mount-1504  [009]   146.453047: xfs_read_agf:         dev 252:18 agno 0x0
           mount-1504  [009]   146.453047: xfs_group_get:        dev 252:18 agno 0x0 passive refs 4 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453047: xfs_buf_init:         dev 252:18 daddr 0x1 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
           mount-1504  [009]   146.453048: xfs_buf_get:          dev 252:18 daddr 0x1 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453048: xfs_buf_read:         dev 252:18 daddr 0x1 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453048: xfs_buf_submit:       dev 252:18 daddr 0x1 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_read_map+0x11f
           mount-1504  [009]   146.453048: xfs_buf_hold:         dev 252:18 daddr 0x1 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.453052: xfs_buf_iowait:       dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.453183: xfs_buf_iodone:       dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller process_one_work+0x176
           mount-1504  [009]   146.453187: xfs_buf_iowait_done:  dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.453188: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453188: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453188: xfs_buf_unlock:       dev 252:18 daddr 0x1 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453188: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453189: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453189: xfs_ialloc_read_agi:  dev 252:18 agno 0x0
           mount-1504  [009]   146.453189: xfs_read_agi:         dev 252:18 agno 0x0
           mount-1504  [009]   146.453190: xfs_group_get:        dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453190: xfs_buf_lock:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453190: xfs_buf_lock_done:    dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453190: xfs_buf_find:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453190: xfs_group_put:        dev 252:18 agno 0x0 passive refs 6 active refs 1 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453191: xfs_buf_get:          dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453191: xfs_buf_read:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453191: xfs_buf_unlock:       dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453191: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_ialloc_read_agi+0x134
           mount-1504  [009]   146.453191: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_ialloc_read_agi+0x134
           mount-1504  [009]   146.453192: xfs_group_put:        dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_initialize_perag_data+0x90
           mount-1504  [009]   146.453192: xfs_group_get:        dev 252:18 agno 0x1 passive refs 0 active refs 1 caller xfs_initialize_perag_data+0xa3
           mount-1504  [009]   146.453192: xfs_alloc_read_agf:   dev 252:18 agno 0x1
           mount-1504  [009]   146.453192: xfs_read_agf:         dev 252:18 agno 0x1
           mount-1504  [009]   146.453192: xfs_group_get:        dev 252:18 agno 0x1 passive refs 1 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453193: xfs_buf_init:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
           mount-1504  [009]   146.453194: xfs_buf_get:          dev 252:18 daddr 0xa00001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453194: xfs_buf_read:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453194: xfs_buf_submit:       dev 252:18 daddr 0xa00001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_read_map+0x11f
           mount-1504  [009]   146.453194: xfs_buf_hold:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.453198: xfs_buf_iowait:       dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.453281: xfs_buf_iodone:       dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller process_one_work+0x176
           mount-1504  [009]   146.453285: xfs_buf_iowait_done:  dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.453285: xfs_buf_rele:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453285: xfs_buf_rele:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453285: xfs_buf_unlock:       dev 252:18 daddr 0xa00001 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453286: xfs_buf_rele:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453286: xfs_buf_rele:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453286: xfs_ialloc_read_agi:  dev 252:18 agno 0x1
           mount-1504  [009]   146.453286: xfs_read_agi:         dev 252:18 agno 0x1
           mount-1504  [009]   146.453286: xfs_group_get:        dev 252:18 agno 0x1 passive refs 2 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453287: xfs_buf_init:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
           mount-1504  [009]   146.453287: xfs_buf_get:          dev 252:18 daddr 0xa00002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453287: xfs_buf_read:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453288: xfs_buf_submit:       dev 252:18 daddr 0xa00002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_read_map+0x11f
           mount-1504  [009]   146.453288: xfs_buf_hold:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.453291: xfs_buf_iowait:       dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.453379: xfs_buf_iodone:       dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller process_one_work+0x176
           mount-1504  [009]   146.453383: xfs_buf_iowait_done:  dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.453383: xfs_buf_rele:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453383: xfs_buf_rele:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453397: xfs_buf_unlock:       dev 252:18 daddr 0xa00002 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453397: xfs_buf_rele:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_ialloc_read_agi+0x134
           mount-1504  [009]   146.453398: xfs_buf_rele:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_ialloc_read_agi+0x134
           mount-1504  [009]   146.453398: xfs_group_put:        dev 252:18 agno 0x1 passive refs 3 active refs 1 caller xfs_initialize_perag_data+0x90
           mount-1504  [009]   146.453398: xfs_group_get:        dev 252:18 agno 0x2 passive refs 0 active refs 1 caller xfs_initialize_perag_data+0xa3
           mount-1504  [009]   146.453398: xfs_alloc_read_agf:   dev 252:18 agno 0x2
           mount-1504  [009]   146.453398: xfs_read_agf:         dev 252:18 agno 0x2
           mount-1504  [009]   146.453399: xfs_group_get:        dev 252:18 agno 0x2 passive refs 1 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453399: xfs_buf_init:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
           mount-1504  [009]   146.453400: xfs_buf_get:          dev 252:18 daddr 0x1400001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453400: xfs_buf_read:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453400: xfs_buf_submit:       dev 252:18 daddr 0x1400001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_read_map+0x11f
           mount-1504  [009]   146.453400: xfs_buf_hold:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.453403: xfs_buf_iowait:       dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.453490: xfs_buf_iodone:       dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller process_one_work+0x176
           mount-1504  [009]   146.453493: xfs_buf_iowait_done:  dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.453494: xfs_buf_rele:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453494: xfs_buf_rele:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453494: xfs_buf_unlock:       dev 252:18 daddr 0x1400001 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453494: xfs_buf_rele:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453494: xfs_buf_rele:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453495: xfs_ialloc_read_agi:  dev 252:18 agno 0x2
           mount-1504  [009]   146.453495: xfs_read_agi:         dev 252:18 agno 0x2
           mount-1504  [009]   146.453495: xfs_group_get:        dev 252:18 agno 0x2 passive refs 2 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453495: xfs_buf_init:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
           mount-1504  [009]   146.453496: xfs_buf_get:          dev 252:18 daddr 0x1400002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453496: xfs_buf_read:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453496: xfs_buf_submit:       dev 252:18 daddr 0x1400002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_read_map+0x11f
           mount-1504  [009]   146.453496: xfs_buf_hold:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.453499: xfs_buf_iowait:       dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.453591: xfs_buf_iodone:       dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller process_one_work+0x176
           mount-1504  [009]   146.453593: xfs_buf_iowait_done:  dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.453594: xfs_buf_rele:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453594: xfs_buf_rele:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453594: xfs_buf_unlock:       dev 252:18 daddr 0x1400002 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453594: xfs_buf_rele:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_ialloc_read_agi+0x134
           mount-1504  [009]   146.453594: xfs_buf_rele:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_ialloc_read_agi+0x134
           mount-1504  [009]   146.453595: xfs_group_put:        dev 252:18 agno 0x2 passive refs 3 active refs 1 caller xfs_initialize_perag_data+0x90
           mount-1504  [009]   146.453595: xfs_group_get:        dev 252:18 agno 0x3 passive refs 0 active refs 1 caller xfs_initialize_perag_data+0xa3
           mount-1504  [009]   146.453595: xfs_alloc_read_agf:   dev 252:18 agno 0x3
           mount-1504  [009]   146.453595: xfs_read_agf:         dev 252:18 agno 0x3
           mount-1504  [009]   146.453595: xfs_group_get:        dev 252:18 agno 0x3 passive refs 1 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453596: xfs_buf_init:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
           mount-1504  [009]   146.453596: xfs_buf_get:          dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453596: xfs_buf_read:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453597: xfs_buf_submit:       dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_read_map+0x11f
           mount-1504  [009]   146.453597: xfs_buf_hold:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.453599: xfs_buf_iowait:       dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.453683: xfs_buf_iodone:       dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agf_buf_ops+0x0 caller process_one_work+0x176
           mount-1504  [009]   146.453686: xfs_buf_iowait_done:  dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.453686: xfs_buf_rele:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453686: xfs_buf_rele:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453686: xfs_buf_unlock:       dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453687: xfs_buf_rele:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453687: xfs_buf_rele:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453687: xfs_ialloc_read_agi:  dev 252:18 agno 0x3
           mount-1504  [009]   146.453687: xfs_read_agi:         dev 252:18 agno 0x3
           mount-1504  [009]   146.453687: xfs_group_get:        dev 252:18 agno 0x3 passive refs 2 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453688: xfs_buf_init:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
           mount-1504  [009]   146.453688: xfs_buf_get:          dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453688: xfs_buf_read:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453688: xfs_buf_submit:       dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_read_map+0x11f
           mount-1504  [009]   146.453689: xfs_buf_hold:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.453691: xfs_buf_iowait:       dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.453805: xfs_buf_iodone:       dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agi_buf_ops+0x0 caller process_one_work+0x176
           mount-1504  [009]   146.453808: xfs_buf_iowait_done:  dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.453808: xfs_buf_rele:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453808: xfs_buf_rele:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453809: xfs_buf_unlock:       dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453809: xfs_buf_rele:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_ialloc_read_agi+0x134
           mount-1504  [009]   146.453809: xfs_buf_rele:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_ialloc_read_agi+0x134
           mount-1504  [009]   146.453809: xfs_group_put:        dev 252:18 agno 0x3 passive refs 3 active refs 1 caller xfs_initialize_perag_data+0x90
           mount-1504  [009]   146.453813: xfs_fs_mark_healthy:  dev 252:18 flags 0x1
           mount-1504  [009]   146.453813: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 4 active refs 1 caller xfs_fs_reserve_ag_blocks+0x32
           mount-1504  [009]   146.453814: xfs_alloc_read_agf:   dev 252:18 agno 0x0
           mount-1504  [009]   146.453814: xfs_read_agf:         dev 252:18 agno 0x0
           mount-1504  [009]   146.453814: xfs_group_get:        dev 252:18 agno 0x0 passive refs 4 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453814: xfs_buf_lock:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453815: xfs_buf_lock_done:    dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453815: xfs_buf_find:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453815: xfs_group_put:        dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453815: xfs_buf_get:          dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453815: xfs_buf_read:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453816: xfs_buf_unlock:       dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453816: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_refcountbt_calc_reserves+0xaa
           mount-1504  [009]   146.453816: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_refcountbt_calc_reserves+0xaa
           mount-1504  [009]   146.453816: xfs_ialloc_read_agi:  dev 252:18 agno 0x0
           mount-1504  [009]   146.453816: xfs_read_agi:         dev 252:18 agno 0x0
           mount-1504  [009]   146.453817: xfs_group_get:        dev 252:18 agno 0x0 passive refs 4 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453817: xfs_buf_lock:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453817: xfs_buf_lock_done:    dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453817: xfs_buf_find:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453817: xfs_group_put:        dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453817: xfs_buf_get:          dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453817: xfs_buf_read:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453817: xfs_buf_unlock:       dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453818: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_finobt_calc_reserves+0x11c
           mount-1504  [009]   146.453818: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_finobt_calc_reserves+0x11c
           mount-1504  [009]   146.453823: xfs_ag_resv_init:     dev 252:18 agno 0x0 resv 2 freeblks 1310699 flcount 6 resv 9140 ask 9142 len 9142
           mount-1504  [009]   146.453823: xfs_alloc_read_agf:   dev 252:18 agno 0x0
           mount-1504  [009]   146.453823: xfs_read_agf:         dev 252:18 agno 0x0
           mount-1504  [009]   146.453823: xfs_group_get:        dev 252:18 agno 0x0 passive refs 4 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453823: xfs_buf_lock:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453823: xfs_buf_lock_done:    dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453824: xfs_buf_find:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453824: xfs_group_put:        dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453824: xfs_buf_get:          dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453824: xfs_buf_read:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453824: xfs_buf_unlock:       dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453824: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_rmapbt_calc_reserves+0xa7
           mount-1504  [009]   146.453824: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_rmapbt_calc_reserves+0xa7
           mount-1504  [009]   146.453825: xfs_ag_resv_init:     dev 252:18 agno 0x0 resv 3 freeblks 1310699 flcount 6 resv 15959 ask 15960 len 15960
           mount-1504  [009]   146.453825: xfs_alloc_read_agf:   dev 252:18 agno 0x0
           mount-1504  [009]   146.453825: xfs_read_agf:         dev 252:18 agno 0x0
           mount-1504  [009]   146.453825: xfs_group_get:        dev 252:18 agno 0x0 passive refs 4 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453825: xfs_buf_lock:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453825: xfs_buf_lock_done:    dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453825: xfs_buf_find:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453826: xfs_group_put:        dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453826: xfs_buf_get:          dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453826: xfs_buf_read:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453826: xfs_buf_unlock:       dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453826: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453826: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453826: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 4 active refs 2 caller xfs_group_next_range+0x2d
           mount-1504  [009]   146.453827: xfs_group_grab:       dev 252:18 agno 0x1 passive refs 2 active refs 1 caller xfs_fs_reserve_ag_blocks+0x32
           mount-1504  [009]   146.453827: xfs_alloc_read_agf:   dev 252:18 agno 0x1
           mount-1504  [009]   146.453827: xfs_read_agf:         dev 252:18 agno 0x1
           mount-1504  [009]   146.453827: xfs_group_get:        dev 252:18 agno 0x1 passive refs 2 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453827: xfs_buf_lock:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453827: xfs_buf_lock_done:    dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453827: xfs_buf_find:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453828: xfs_group_put:        dev 252:18 agno 0x1 passive refs 3 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453828: xfs_buf_get:          dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453828: xfs_buf_read:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453828: xfs_buf_unlock:       dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453828: xfs_buf_rele:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_refcountbt_calc_reserves+0xaa
           mount-1504  [009]   146.453828: xfs_buf_rele:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_refcountbt_calc_reserves+0xaa
           mount-1504  [009]   146.453828: xfs_ialloc_read_agi:  dev 252:18 agno 0x1
           mount-1504  [009]   146.453828: xfs_read_agi:         dev 252:18 agno 0x1
           mount-1504  [009]   146.453828: xfs_group_get:        dev 252:18 agno 0x1 passive refs 2 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453829: xfs_buf_lock:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453829: xfs_buf_lock_done:    dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453829: xfs_buf_find:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453829: xfs_group_put:        dev 252:18 agno 0x1 passive refs 3 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453829: xfs_buf_get:          dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453829: xfs_buf_read:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453829: xfs_buf_unlock:       dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453830: xfs_buf_rele:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_finobt_calc_reserves+0x11c
           mount-1504  [009]   146.453830: xfs_buf_rele:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_finobt_calc_reserves+0x11c
           mount-1504  [009]   146.453830: xfs_ag_resv_init:     dev 252:18 agno 0x1 resv 2 freeblks 1310707 flcount 6 resv 9140 ask 9142 len 9142
           mount-1504  [009]   146.453830: xfs_alloc_read_agf:   dev 252:18 agno 0x1
           mount-1504  [009]   146.453830: xfs_read_agf:         dev 252:18 agno 0x1
           mount-1504  [009]   146.453830: xfs_group_get:        dev 252:18 agno 0x1 passive refs 2 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453830: xfs_buf_lock:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453831: xfs_buf_lock_done:    dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453831: xfs_buf_find:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453831: xfs_group_put:        dev 252:18 agno 0x1 passive refs 3 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453831: xfs_buf_get:          dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453831: xfs_buf_read:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453831: xfs_buf_unlock:       dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453831: xfs_buf_rele:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_rmapbt_calc_reserves+0xa7
           mount-1504  [009]   146.453832: xfs_buf_rele:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_rmapbt_calc_reserves+0xa7
           mount-1504  [009]   146.453832: xfs_ag_resv_init:     dev 252:18 agno 0x1 resv 3 freeblks 1310707 flcount 6 resv 15959 ask 15960 len 15960
           mount-1504  [009]   146.453832: xfs_alloc_read_agf:   dev 252:18 agno 0x1
           mount-1504  [009]   146.453832: xfs_read_agf:         dev 252:18 agno 0x1
           mount-1504  [009]   146.453832: xfs_group_get:        dev 252:18 agno 0x1 passive refs 2 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453832: xfs_buf_lock:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453832: xfs_buf_lock_done:    dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453832: xfs_buf_find:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453833: xfs_group_put:        dev 252:18 agno 0x1 passive refs 3 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453833: xfs_buf_get:          dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453833: xfs_buf_read:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453833: xfs_buf_unlock:       dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453833: xfs_buf_rele:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453833: xfs_buf_rele:         dev 252:18 daddr 0xa00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453833: xfs_group_rele:       dev 252:18 agno 0x1 passive refs 2 active refs 2 caller xfs_group_next_range+0x2d
           mount-1504  [009]   146.453833: xfs_group_grab:       dev 252:18 agno 0x2 passive refs 2 active refs 1 caller xfs_fs_reserve_ag_blocks+0x32
           mount-1504  [009]   146.453833: xfs_alloc_read_agf:   dev 252:18 agno 0x2
           mount-1504  [009]   146.453833: xfs_read_agf:         dev 252:18 agno 0x2
           mount-1504  [009]   146.453834: xfs_group_get:        dev 252:18 agno 0x2 passive refs 2 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453834: xfs_buf_lock:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453834: xfs_buf_lock_done:    dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453834: xfs_buf_find:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453834: xfs_group_put:        dev 252:18 agno 0x2 passive refs 3 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453834: xfs_buf_get:          dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453834: xfs_buf_read:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453834: xfs_buf_unlock:       dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453835: xfs_buf_rele:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_refcountbt_calc_reserves+0xaa
           mount-1504  [009]   146.453835: xfs_buf_rele:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_refcountbt_calc_reserves+0xaa
           mount-1504  [009]   146.453835: xfs_ialloc_read_agi:  dev 252:18 agno 0x2
           mount-1504  [009]   146.453835: xfs_read_agi:         dev 252:18 agno 0x2
           mount-1504  [009]   146.453835: xfs_group_get:        dev 252:18 agno 0x2 passive refs 2 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453835: xfs_buf_lock:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453835: xfs_buf_lock_done:    dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453835: xfs_buf_find:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453835: xfs_group_put:        dev 252:18 agno 0x2 passive refs 3 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453836: xfs_buf_get:          dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453836: xfs_buf_read:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453836: xfs_buf_unlock:       dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453836: xfs_buf_rele:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_finobt_calc_reserves+0x11c
           mount-1504  [009]   146.453836: xfs_buf_rele:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_finobt_calc_reserves+0x11c
           mount-1504  [009]   146.453836: xfs_ag_resv_init:     dev 252:18 agno 0x2 resv 2 freeblks 1048307 flcount 6 resv 7310 ask 7312 len 7312
           mount-1504  [009]   146.453836: xfs_alloc_read_agf:   dev 252:18 agno 0x2
           mount-1504  [009]   146.453836: xfs_read_agf:         dev 252:18 agno 0x2
           mount-1504  [009]   146.453837: xfs_group_get:        dev 252:18 agno 0x2 passive refs 2 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453837: xfs_buf_lock:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453837: xfs_buf_lock_done:    dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453837: xfs_buf_find:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453837: xfs_group_put:        dev 252:18 agno 0x2 passive refs 3 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453837: xfs_buf_get:          dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453837: xfs_buf_read:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453837: xfs_buf_unlock:       dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453837: xfs_buf_rele:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_rmapbt_calc_reserves+0xa7
           mount-1504  [009]   146.453837: xfs_buf_rele:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_rmapbt_calc_reserves+0xa7
           mount-1504  [009]   146.453838: xfs_ag_resv_init:     dev 252:18 agno 0x2 resv 3 freeblks 1048307 flcount 6 resv 12765 ask 12766 len 12766
           mount-1504  [009]   146.453838: xfs_alloc_read_agf:   dev 252:18 agno 0x2
           mount-1504  [009]   146.453838: xfs_read_agf:         dev 252:18 agno 0x2
           mount-1504  [009]   146.453838: xfs_group_get:        dev 252:18 agno 0x2 passive refs 2 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453838: xfs_buf_lock:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453838: xfs_buf_lock_done:    dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453838: xfs_buf_find:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453838: xfs_group_put:        dev 252:18 agno 0x2 passive refs 3 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453839: xfs_buf_get:          dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453839: xfs_buf_read:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453839: xfs_buf_unlock:       dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453839: xfs_buf_rele:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453839: xfs_buf_rele:         dev 252:18 daddr 0x1400001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453840: xfs_group_rele:       dev 252:18 agno 0x2 passive refs 2 active refs 2 caller xfs_group_next_range+0x2d
           mount-1504  [009]   146.453840: xfs_group_grab:       dev 252:18 agno 0x3 passive refs 2 active refs 1 caller xfs_fs_reserve_ag_blocks+0x32
           mount-1504  [009]   146.453840: xfs_alloc_read_agf:   dev 252:18 agno 0x3
           mount-1504  [009]   146.453840: xfs_read_agf:         dev 252:18 agno 0x3
           mount-1504  [009]   146.453840: xfs_group_get:        dev 252:18 agno 0x3 passive refs 2 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453840: xfs_buf_lock:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453840: xfs_buf_lock_done:    dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453840: xfs_buf_find:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453841: xfs_group_put:        dev 252:18 agno 0x3 passive refs 3 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453841: xfs_buf_get:          dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453841: xfs_buf_read:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453841: xfs_buf_unlock:       dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453841: xfs_buf_rele:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_refcountbt_calc_reserves+0xaa
           mount-1504  [009]   146.453841: xfs_buf_rele:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_refcountbt_calc_reserves+0xaa
           mount-1504  [009]   146.453841: xfs_ialloc_read_agi:  dev 252:18 agno 0x3
           mount-1504  [009]   146.453841: xfs_read_agi:         dev 252:18 agno 0x3
           mount-1504  [009]   146.453841: xfs_group_get:        dev 252:18 agno 0x3 passive refs 2 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453842: xfs_buf_lock:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453842: xfs_buf_lock_done:    dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453842: xfs_buf_find:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453842: xfs_group_put:        dev 252:18 agno 0x3 passive refs 3 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453842: xfs_buf_get:          dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453842: xfs_buf_read:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453842: xfs_buf_unlock:       dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453842: xfs_buf_rele:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_finobt_calc_reserves+0x11c
           mount-1504  [009]   146.453842: xfs_buf_rele:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_finobt_calc_reserves+0x11c
           mount-1504  [009]   146.453843: xfs_ag_resv_init:     dev 252:18 agno 0x3 resv 2 freeblks 1310707 flcount 6 resv 9140 ask 9142 len 9142
           mount-1504  [009]   146.453843: xfs_alloc_read_agf:   dev 252:18 agno 0x3
           mount-1504  [009]   146.453843: xfs_read_agf:         dev 252:18 agno 0x3
           mount-1504  [009]   146.453843: xfs_group_get:        dev 252:18 agno 0x3 passive refs 2 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453843: xfs_buf_lock:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453843: xfs_buf_lock_done:    dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453843: xfs_buf_find:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453843: xfs_group_put:        dev 252:18 agno 0x3 passive refs 3 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453844: xfs_buf_get:          dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453844: xfs_buf_read:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453844: xfs_buf_unlock:       dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453844: xfs_buf_rele:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_rmapbt_calc_reserves+0xa7
           mount-1504  [009]   146.453844: xfs_buf_rele:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_rmapbt_calc_reserves+0xa7
           mount-1504  [009]   146.453844: xfs_ag_resv_init:     dev 252:18 agno 0x3 resv 3 freeblks 1310707 flcount 6 resv 15959 ask 15960 len 15960
           mount-1504  [009]   146.453844: xfs_alloc_read_agf:   dev 252:18 agno 0x3
           mount-1504  [009]   146.453844: xfs_read_agf:         dev 252:18 agno 0x3
           mount-1504  [009]   146.453844: xfs_group_get:        dev 252:18 agno 0x3 passive refs 2 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453845: xfs_buf_lock:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453845: xfs_buf_lock_done:    dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453845: xfs_buf_find:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453845: xfs_group_put:        dev 252:18 agno 0x3 passive refs 3 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453845: xfs_buf_get:          dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453845: xfs_buf_read:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453845: xfs_buf_unlock:       dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453845: xfs_buf_rele:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453845: xfs_buf_rele:         dev 252:18 daddr 0x1e00001 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_alloc_read_agf+0x28c
           mount-1504  [009]   146.453846: xfs_group_rele:       dev 252:18 agno 0x3 passive refs 2 active refs 2 caller xfs_group_next_range+0x2d
           mount-1504  [009]   146.453846: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 4 active refs 1 caller xfs_fs_unreserve_ag_blocks+0x30
           mount-1504  [009]   146.453846: xfs_ag_resv_free:     dev 252:18 agno 0x0 resv 3 freeblks 1310699 flcount 6 resv 15959 ask 15960 len 0
           mount-1504  [009]   146.453847: xfs_ag_resv_free:     dev 252:18 agno 0x0 resv 2 freeblks 1310699 flcount 6 resv 9140 ask 9142 len 0
           mount-1504  [009]   146.453847: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 4 active refs 2 caller xfs_group_next_range+0x2d
           mount-1504  [009]   146.453847: xfs_group_grab:       dev 252:18 agno 0x1 passive refs 2 active refs 1 caller xfs_fs_unreserve_ag_blocks+0x30
           mount-1504  [009]   146.453847: xfs_ag_resv_free:     dev 252:18 agno 0x1 resv 3 freeblks 1310707 flcount 6 resv 15959 ask 15960 len 0
           mount-1504  [009]   146.453847: xfs_ag_resv_free:     dev 252:18 agno 0x1 resv 2 freeblks 1310707 flcount 6 resv 9140 ask 9142 len 0
           mount-1504  [009]   146.453847: xfs_group_rele:       dev 252:18 agno 0x1 passive refs 2 active refs 2 caller xfs_group_next_range+0x2d
           mount-1504  [009]   146.453847: xfs_group_grab:       dev 252:18 agno 0x2 passive refs 2 active refs 1 caller xfs_fs_unreserve_ag_blocks+0x30
           mount-1504  [009]   146.453848: xfs_ag_resv_free:     dev 252:18 agno 0x2 resv 3 freeblks 1048307 flcount 6 resv 12765 ask 12766 len 0
           mount-1504  [009]   146.453848: xfs_ag_resv_free:     dev 252:18 agno 0x2 resv 2 freeblks 1048307 flcount 6 resv 7310 ask 7312 len 0
           mount-1504  [009]   146.453848: xfs_group_rele:       dev 252:18 agno 0x2 passive refs 2 active refs 2 caller xfs_group_next_range+0x2d
           mount-1504  [009]   146.453848: xfs_group_grab:       dev 252:18 agno 0x3 passive refs 2 active refs 1 caller xfs_fs_unreserve_ag_blocks+0x30
           mount-1504  [009]   146.453848: xfs_ag_resv_free:     dev 252:18 agno 0x3 resv 3 freeblks 1310707 flcount 6 resv 15959 ask 15960 len 0
           mount-1504  [009]   146.453848: xfs_ag_resv_free:     dev 252:18 agno 0x3 resv 2 freeblks 1310707 flcount 6 resv 9140 ask 9142 len 0
           mount-1504  [009]   146.453848: xfs_group_rele:       dev 252:18 agno 0x3 passive refs 2 active refs 2 caller xfs_group_next_range+0x2d
           mount-1504  [009]   146.453851: xfs_log_reserve:      dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 2 t_curr_res 317968 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 0 grant_write_bytes 0 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.453852: xfs_log_reserve_exit: dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 2 t_curr_res 317968 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 635936 grant_write_bytes 635936 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.453852: xfs_trans_alloc:      dev 252:18 trans 9875ab70 flags 0x4 caller xfs_qm_qino_alloc+0x97
           mount-1504  [009]   146.453852: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 4 active refs 1 caller xfs_dialloc+0x122
           mount-1504  [009]   146.453852: xfs_ialloc_read_agi:  dev 252:18 agno 0x0
           mount-1504  [009]   146.453852: xfs_read_agi:         dev 252:18 agno 0x0
           mount-1504  [009]   146.453853: xfs_group_get:        dev 252:18 agno 0x0 passive refs 4 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453853: xfs_buf_lock:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453853: xfs_buf_lock_done:    dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453853: xfs_buf_find:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453853: xfs_group_put:        dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453853: xfs_buf_get:          dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453853: xfs_buf_read:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453854: xfs_buf_hold:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
           mount-1504  [009]   146.453854: xfs_trans_add_item:   dev 252:18 trans 9875ab70 flags 0x4 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.453854: xfs_trans_read_buf:   dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.453854: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 4 active refs 2 caller xfs_finobt_init_cursor+0x67
           mount-1504  [009]   146.453855: xfs_group_get:        dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453855: xfs_buf_init:         dev 252:18 daddr 0x20 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
           mount-1504  [009]   146.453857: xfs_buf_get:          dev 252:18 daddr 0x20 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453857: xfs_buf_read:         dev 252:18 daddr 0x20 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453857: xfs_buf_submit:       dev 252:18 daddr 0x20 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_read_map+0x11f
           mount-1504  [009]   146.453857: xfs_buf_hold:         dev 252:18 daddr 0x20 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_finobt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.453861: xfs_buf_iowait:       dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_finobt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.453970: xfs_buf_iodone:       dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_finobt_buf_ops+0x0 caller process_one_work+0x176
           mount-1504  [009]   146.453975: xfs_buf_iowait_done:  dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
           mount-1504  [009]   146.453975: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453976: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.453976: xfs_buf_hold:         dev 252:18 daddr 0x20 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
           mount-1504  [009]   146.453976: xfs_trans_add_item:   dev 252:18 trans 9875ab70 flags 0x4 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.453976: xfs_trans_read_buf:   dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.453979: xfs_trans_log_buf:    dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.453980: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_inobt_init_cursor+0x67
           mount-1504  [009]   146.453980: xfs_group_get:        dev 252:18 agno 0x0 passive refs 7 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453980: xfs_buf_lock:         dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453980: xfs_buf_lock_done:    dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453980: xfs_buf_find:         dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453980: xfs_group_put:        dev 252:18 agno 0x0 passive refs 8 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453981: xfs_buf_get:          dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453981: xfs_buf_read:         dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453981: xfs_buf_hold:         dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
           mount-1504  [009]   146.453981: xfs_trans_add_item:   dev 252:18 trans 9875ab70 flags 0x5 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.453981: xfs_trans_read_buf:   dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.453982: xfs_trans_log_buf:    dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.453982: xfs_trans_log_buf:    dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.453983: xfs_trans_brelse:     dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.453983: xfs_group_put:        dev 252:18 agno 0x0 passive refs 7 active refs 2 caller xfs_btree_del_cursor+0x5f
           mount-1504  [009]   146.453983: xfs_trans_brelse:     dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.453983: xfs_group_put:        dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_btree_del_cursor+0x5f
           mount-1504  [009]   146.453983: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_dialloc+0x648
           mount-1504  [009]   146.453984: xfs_group_get:        dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_iget+0xd6
           mount-1504  [009]   146.453985: xfs_iget_miss:        dev 252:18 ino 0x83 iflags 0x0
           mount-1504  [009]   146.453985: xfs_ilock_nowait:     dev 252:18 ino 0x83 flags ILOCK_EXCL caller xfs_iget+0xa85
           mount-1504  [009]   146.453986: xfs_group_put:        dev 252:18 agno 0x0 passive refs 6 active refs 1 caller xfs_iget+0x725
           mount-1504  [009]   146.453987: xfs_trans_add_item:   dev 252:18 trans 9875ab70 flags 0x5 caller xfs_icreate+0x68
           mount-1504  [009]   146.453988: xfs_buf_lock:         dev 252:18 daddr 0x0 bbcount 0x1 hold 1 pincount 0 lock 1 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_trans_getsb+0x1e
           mount-1504  [009]   146.453988: xfs_buf_lock_done:    dev 252:18 daddr 0x0 bbcount 0x1 hold 1 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_trans_getsb+0x1e
           mount-1504  [009]   146.453988: xfs_buf_hold:         dev 252:18 daddr 0x0 bbcount 0x1 hold 1 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_trans_getsb+0x26
           mount-1504  [009]   146.453989: xfs_buf_hold:         dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
           mount-1504  [009]   146.453989: xfs_trans_add_item:   dev 252:18 trans 9875ab70 flags 0x5 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.453989: xfs_trans_getsb:      dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.453990: xfs_trans_log_buf:    dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.453991: xfs_defer_finish:     dev 252:18 tp 0xffffa084d8a68c30 caller xfs_trans_commit+0x4f
           mount-1504  [009]   146.453992: xfs_defer_finish_done: dev 252:18 tp 0xffffa084d8a68c30 caller xfs_trans_commit+0x4f
           mount-1504  [009]   146.453992: xfs_trans_commit:     dev 252:18 trans 9875ab70 flags 0x5 caller xfs_trans_commit+0x38
           mount-1504  [009]   146.453993: xfs_group_get:        dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.453993: xfs_buf_lock:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453993: xfs_buf_lock_done:    dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.453993: xfs_buf_find:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453993: xfs_group_put:        dev 252:18 agno 0x0 passive refs 6 active refs 1 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.453994: xfs_buf_get:          dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.453994: xfs_buf_read:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.453994: xfs_buf_hold:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
           mount-1504  [009]   146.453994: xfs_trans_add_item:   dev 252:18 trans 9875ab70 flags 0x5 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.453994: xfs_trans_read_buf:   dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.453994: xfs_buf_hold:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_precommit+0x1c9
           mount-1504  [009]   146.453995: xfs_trans_brelse:     dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags DONE|INODES|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.453995: xfs_buf_item_relse:   dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_put+0x39
           mount-1504  [009]   146.453995: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_relse+0x88
           mount-1504  [009]   146.453995: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_relse+0x88
           mount-1504  [009]   146.453996: xfs_buf_unlock:       dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.453996: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_precommit+0x238
           mount-1504  [009]   146.453996: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_precommit+0x238
           mount-1504  [009]   146.453998: xfs_buf_item_size:    dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.453998: xfs_buf_item_size:    dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.453999: xfs_buf_item_size:    dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.453999: xfs_buf_item_size:    dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454000: xfs_inode_pin:        dev 252:18 ino 0x83 count 1 pincount 0 caller xfs_cil_prepare_item+0x8b
           mount-1504  [009]   146.454001: xfs_buf_item_format:  dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454002: xfs_buf_item_pin:     dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454002: xfs_buf_hold:         dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_pin+0x32
           mount-1504  [009]   146.454002: xfs_buf_item_format:  dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454002: xfs_buf_item_pin:     dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454002: xfs_buf_hold:         dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_item_pin+0x32
           mount-1504  [009]   146.454002: xfs_buf_item_format:  dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454002: xfs_buf_item_pin:     dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454002: xfs_buf_hold:         dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_pin+0x32
           mount-1504  [009]   146.454003: xfs_buf_item_format:  dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454003: xfs_buf_item_pin:     dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454003: xfs_buf_hold:         dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_buf_item_pin+0x32
           mount-1504  [009]   146.454004: xfs_log_ticket_ungrant: dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 2 t_curr_res 309936 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 635936 grant_write_bytes 635936 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454004: xfs_log_ticket_ungrant_sub: dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 1 t_curr_res 309936 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 635936 grant_write_bytes 635936 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454004: xfs_log_ticket_ungrant_exit: dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 1 t_curr_res 309936 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 8032 grant_write_bytes 8032 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454005: xfs_trans_commit_items: dev 252:18 trans 0 flags 0x5 caller __xfs_trans_commit+0x11f
           mount-1504  [009]   146.454006: xfs_buf_item_release: dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
           mount-1504  [009]   146.454006: xfs_buf_unlock:       dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_release+0xec
           mount-1504  [009]   146.454006: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454006: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454006: xfs_buf_item_release: dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
           mount-1504  [009]   146.454006: xfs_buf_unlock:       dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_item_release+0xec
           mount-1504  [009]   146.454006: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454006: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454006: xfs_buf_item_release: dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
           mount-1504  [009]   146.454007: xfs_buf_unlock:       dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_release+0xec
           mount-1504  [009]   146.454007: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454007: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454007: xfs_buf_item_release: dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
           mount-1504  [009]   146.454007: xfs_buf_unlock:       dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 1 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_buf_item_release+0xec
           mount-1504  [009]   146.454007: xfs_buf_rele:         dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 1 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454007: xfs_trans_free:       dev 252:18 trans 0 flags 0x5 caller __xfs_trans_commit+0x127
           mount-1504  [009]   146.454008: xfs_iunlock:          dev 252:18 ino 0x83 flags ILOCK_EXCL caller xfs_qm_qino_alloc+0x35c
           mount-1504  [009]   146.454009: xfs_log_reserve:      dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 2 t_curr_res 317968 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 8032 grant_write_bytes 8032 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454009: xfs_log_reserve_exit: dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 2 t_curr_res 317968 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 643968 grant_write_bytes 643968 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454009: xfs_trans_alloc:      dev 252:18 trans f36a0bfd flags 0x4 caller xfs_qm_qino_alloc+0x97
           mount-1504  [009]   146.454009: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_dialloc+0x122
           mount-1504  [009]   146.454010: xfs_ialloc_read_agi:  dev 252:18 agno 0x0
           mount-1504  [009]   146.454010: xfs_read_agi:         dev 252:18 agno 0x0
           mount-1504  [009]   146.454010: xfs_group_get:        dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.454010: xfs_buf_lock:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454010: xfs_buf_lock_done:    dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454010: xfs_buf_find:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454010: xfs_group_put:        dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.454010: xfs_buf_get:          dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454011: xfs_buf_read:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.454011: xfs_trans_add_item:   dev 252:18 trans f36a0bfd flags 0x4 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.454011: xfs_trans_read_buf:   dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
           mount-1504  [009]   146.454011: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_finobt_init_cursor+0x67
           mount-1504  [009]   146.454011: xfs_group_get:        dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.454011: xfs_buf_lock:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454012: xfs_buf_lock_done:    dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454012: xfs_buf_find:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454012: xfs_group_put:        dev 252:18 agno 0x0 passive refs 7 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.454012: xfs_buf_get:          dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454012: xfs_buf_read:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.454012: xfs_trans_add_item:   dev 252:18 trans f36a0bfd flags 0x4 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.454013: xfs_trans_read_buf:   dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
           mount-1504  [009]   146.454013: xfs_trans_log_buf:    dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454013: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_inobt_init_cursor+0x67
           mount-1504  [009]   146.454014: xfs_group_get:        dev 252:18 agno 0x0 passive refs 7 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.454014: xfs_buf_lock:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454014: xfs_buf_lock_done:    dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454014: xfs_buf_find:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454014: xfs_group_put:        dev 252:18 agno 0x0 passive refs 8 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.454014: xfs_buf_get:          dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454014: xfs_buf_read:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.454014: xfs_trans_add_item:   dev 252:18 trans f36a0bfd flags 0x5 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.454014: xfs_trans_read_buf:   dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
           mount-1504  [009]   146.454015: xfs_trans_log_buf:    dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454015: xfs_trans_log_buf:    dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454015: xfs_trans_brelse:     dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454016: xfs_group_put:        dev 252:18 agno 0x0 passive refs 7 active refs 2 caller xfs_btree_del_cursor+0x5f
           mount-1504  [009]   146.454016: xfs_trans_brelse:     dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454016: xfs_group_put:        dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_btree_del_cursor+0x5f
           mount-1504  [009]   146.454016: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_dialloc+0x648
           mount-1504  [009]   146.454016: xfs_group_get:        dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_iget+0xd6
           mount-1504  [009]   146.454017: xfs_iget_miss:        dev 252:18 ino 0x84 iflags 0x0
           mount-1504  [009]   146.454017: xfs_ilock_nowait:     dev 252:18 ino 0x84 flags ILOCK_EXCL caller xfs_iget+0xa85
           mount-1504  [009]   146.454018: xfs_group_put:        dev 252:18 agno 0x0 passive refs 6 active refs 1 caller xfs_iget+0x725
           mount-1504  [009]   146.454018: xfs_trans_add_item:   dev 252:18 trans f36a0bfd flags 0x5 caller xfs_icreate+0x68
           mount-1504  [009]   146.454018: xfs_buf_lock:         dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 1 lock 1 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_trans_getsb+0x1e
           mount-1504  [009]   146.454018: xfs_buf_lock_done:    dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_trans_getsb+0x1e
           mount-1504  [009]   146.454018: xfs_buf_hold:         dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_trans_getsb+0x26
           mount-1504  [009]   146.454019: xfs_trans_add_item:   dev 252:18 trans f36a0bfd flags 0x5 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.454019: xfs_trans_getsb:      dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
           mount-1504  [009]   146.454019: xfs_trans_log_buf:    dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454019: xfs_defer_finish:     dev 252:18 tp 0xffffa084d8a68c30 caller xfs_trans_commit+0x4f
           mount-1504  [009]   146.454019: xfs_defer_finish_done: dev 252:18 tp 0xffffa084d8a68c30 caller xfs_trans_commit+0x4f
           mount-1504  [009]   146.454020: xfs_trans_commit:     dev 252:18 trans f36a0bfd flags 0x5 caller xfs_trans_commit+0x38
           mount-1504  [009]   146.454020: xfs_group_get:        dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.454020: xfs_buf_lock:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454020: xfs_buf_lock_done:    dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454020: xfs_buf_find:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454020: xfs_group_put:        dev 252:18 agno 0x0 passive refs 6 active refs 1 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.454020: xfs_buf_get:          dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454021: xfs_buf_read:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.454021: xfs_buf_hold:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
           mount-1504  [009]   146.454021: xfs_trans_add_item:   dev 252:18 trans f36a0bfd flags 0x5 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.454021: xfs_trans_read_buf:   dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags DONE|INODES|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.454021: xfs_buf_hold:         dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_precommit+0x1c9
           mount-1504  [009]   146.454021: xfs_trans_brelse:     dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags DONE|INODES|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.454021: xfs_buf_item_relse:   dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_put+0x39
           mount-1504  [009]   146.454021: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_relse+0x88
           mount-1504  [009]   146.454021: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_relse+0x88
           mount-1504  [009]   146.454022: xfs_buf_unlock:       dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.454022: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_precommit+0x238
           mount-1504  [009]   146.454022: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_precommit+0x238
           mount-1504  [009]   146.454022: xfs_buf_item_size:    dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454023: xfs_buf_item_size:    dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454023: xfs_buf_item_size:    dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454024: xfs_buf_item_size:    dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454024: xfs_inode_pin:        dev 252:18 ino 0x84 count 1 pincount 0 caller xfs_cil_prepare_item+0x8b
           mount-1504  [009]   146.454024: xfs_buf_item_format:  dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454024: xfs_buf_item_format:  dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454024: xfs_buf_item_format:  dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454025: xfs_buf_item_format:  dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454025: xfs_log_ticket_ungrant: dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 2 t_curr_res 312472 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 643968 grant_write_bytes 643968 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454025: xfs_log_ticket_ungrant_sub: dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 1 t_curr_res 312472 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 643968 grant_write_bytes 643968 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454025: xfs_log_ticket_ungrant_exit: dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 1 t_curr_res 312472 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 13528 grant_write_bytes 13528 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454026: xfs_trans_commit_items: dev 252:18 trans 0 flags 0x5 caller __xfs_trans_commit+0x11f
           mount-1504  [009]   146.454026: xfs_buf_item_release: dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
           mount-1504  [009]   146.454026: xfs_buf_unlock:       dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_release+0xec
           mount-1504  [009]   146.454026: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454026: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454027: xfs_buf_item_release: dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
           mount-1504  [009]   146.454027: xfs_buf_unlock:       dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_item_release+0xec
           mount-1504  [009]   146.454027: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454027: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454027: xfs_buf_item_release: dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
           mount-1504  [009]   146.454027: xfs_buf_unlock:       dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_release+0xec
           mount-1504  [009]   146.454027: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454027: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454028: xfs_buf_item_release: dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
           mount-1504  [009]   146.454028: xfs_buf_unlock:       dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 1 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_buf_item_release+0xec
           mount-1504  [009]   146.454028: xfs_buf_rele:         dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 1 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454028: xfs_trans_free:       dev 252:18 trans 0 flags 0x5 caller __xfs_trans_commit+0x127
           mount-1504  [009]   146.454028: xfs_iunlock:          dev 252:18 ino 0x84 flags ILOCK_EXCL caller xfs_qm_qino_alloc+0x35c
           mount-1504  [009]   146.454028: xfs_log_reserve:      dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 2 t_curr_res 317968 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 13528 grant_write_bytes 13528 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454029: xfs_log_reserve_exit: dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 2 t_curr_res 317968 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 649464 grant_write_bytes 649464 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454029: xfs_trans_alloc:      dev 252:18 trans 8de07c60 flags 0x4 caller xfs_qm_qino_alloc+0x97
           mount-1504  [009]   146.454029: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_dialloc+0x122
           mount-1504  [009]   146.454029: xfs_ialloc_read_agi:  dev 252:18 agno 0x0
           mount-1504  [009]   146.454029: xfs_read_agi:         dev 252:18 agno 0x0
           mount-1504  [009]   146.454029: xfs_group_get:        dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.454029: xfs_buf_lock:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454029: xfs_buf_lock_done:    dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454030: xfs_buf_find:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454030: xfs_group_put:        dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.454030: xfs_buf_get:          dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454030: xfs_buf_read:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.454030: xfs_trans_add_item:   dev 252:18 trans 8de07c60 flags 0x4 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.454030: xfs_trans_read_buf:   dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
           mount-1504  [009]   146.454030: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_finobt_init_cursor+0x67
           mount-1504  [009]   146.454030: xfs_group_get:        dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.454031: xfs_buf_lock:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454031: xfs_buf_lock_done:    dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454031: xfs_buf_find:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454031: xfs_group_put:        dev 252:18 agno 0x0 passive refs 7 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.454031: xfs_buf_get:          dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454031: xfs_buf_read:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.454031: xfs_trans_add_item:   dev 252:18 trans 8de07c60 flags 0x4 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.454031: xfs_trans_read_buf:   dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
           mount-1504  [009]   146.454032: xfs_trans_log_buf:    dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454032: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_inobt_init_cursor+0x67
           mount-1504  [009]   146.454032: xfs_group_get:        dev 252:18 agno 0x0 passive refs 7 active refs 2 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.454032: xfs_buf_lock:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454032: xfs_buf_lock_done:    dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454032: xfs_buf_find:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454033: xfs_group_put:        dev 252:18 agno 0x0 passive refs 8 active refs 2 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.454033: xfs_buf_get:          dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454033: xfs_buf_read:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.454033: xfs_trans_add_item:   dev 252:18 trans 8de07c60 flags 0x5 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.454033: xfs_trans_read_buf:   dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
           mount-1504  [009]   146.454033: xfs_trans_log_buf:    dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454034: xfs_trans_log_buf:    dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454034: xfs_trans_brelse:     dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454034: xfs_group_put:        dev 252:18 agno 0x0 passive refs 7 active refs 2 caller xfs_btree_del_cursor+0x5f
           mount-1504  [009]   146.454034: xfs_trans_brelse:     dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454034: xfs_group_put:        dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_btree_del_cursor+0x5f
           mount-1504  [009]   146.454034: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_dialloc+0x648
           mount-1504  [009]   146.454035: xfs_group_get:        dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_iget+0xd6
           mount-1504  [009]   146.454036: xfs_iget_miss:        dev 252:18 ino 0x85 iflags 0x0
           mount-1504  [009]   146.454036: xfs_ilock_nowait:     dev 252:18 ino 0x85 flags ILOCK_EXCL caller xfs_iget+0xa85
           mount-1504  [009]   146.454036: xfs_group_put:        dev 252:18 agno 0x0 passive refs 6 active refs 1 caller xfs_iget+0x725
           mount-1504  [009]   146.454037: xfs_trans_add_item:   dev 252:18 trans 8de07c60 flags 0x5 caller xfs_icreate+0x68
           mount-1504  [009]   146.454037: xfs_buf_lock:         dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 1 lock 1 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_trans_getsb+0x1e
           mount-1504  [009]   146.454037: xfs_buf_lock_done:    dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_trans_getsb+0x1e
           mount-1504  [009]   146.454037: xfs_buf_hold:         dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_trans_getsb+0x26
           mount-1504  [009]   146.454037: xfs_trans_add_item:   dev 252:18 trans 8de07c60 flags 0x5 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.454037: xfs_trans_getsb:      dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
           mount-1504  [009]   146.454038: xfs_trans_log_buf:    dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454038: xfs_defer_finish:     dev 252:18 tp 0xffffa084d8a68c30 caller xfs_trans_commit+0x4f
           mount-1504  [009]   146.454038: xfs_defer_finish_done: dev 252:18 tp 0xffffa084d8a68c30 caller xfs_trans_commit+0x4f
           mount-1504  [009]   146.454039: xfs_trans_commit:     dev 252:18 trans 8de07c60 flags 0x5 caller xfs_trans_commit+0x38
           mount-1504  [009]   146.454039: xfs_group_get:        dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_buf_get_map+0x11a
           mount-1504  [009]   146.454039: xfs_buf_lock:         dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454039: xfs_buf_lock_done:    dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
           mount-1504  [009]   146.454039: xfs_buf_find:         dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454039: xfs_group_put:        dev 252:18 agno 0x0 passive refs 6 active refs 1 caller xfs_buf_get_map+0x6cc
           mount-1504  [009]   146.454040: xfs_buf_get:          dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_buf_read_map+0x61
           mount-1504  [009]   146.454040: xfs_buf_read:         dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags READ|UNMAPPED caller xfs_trans_read_buf_map+0x1be
           mount-1504  [009]   146.454040: xfs_buf_hold:         dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
           mount-1504  [009]   146.454040: xfs_trans_add_item:   dev 252:18 trans 8de07c60 flags 0x5 caller _xfs_trans_bjoin+0x76
           mount-1504  [009]   146.454040: xfs_trans_read_buf:   dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags DONE|INODES|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.454040: xfs_buf_hold:         dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_precommit+0x1c9
           mount-1504  [009]   146.454040: xfs_trans_brelse:     dev 252:18 daddr 0x80 bbcount 0x20 hold 6 pincount 0 lock 0 flags DONE|INODES|PAGES recur 0 refcount 1 bliflags  liflags 
           mount-1504  [009]   146.454040: xfs_buf_item_relse:   dev 252:18 daddr 0x80 bbcount 0x20 hold 6 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_put+0x39
           mount-1504  [009]   146.454040: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 6 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_relse+0x88
           mount-1504  [009]   146.454041: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 6 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_item_relse+0x88
           mount-1504  [009]   146.454041: xfs_buf_unlock:       dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_trans_brelse+0xa5
           mount-1504  [009]   146.454041: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_precommit+0x238
           mount-1504  [009]   146.454041: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_precommit+0x238
           mount-1504  [009]   146.454041: xfs_buf_item_size:    dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454041: xfs_buf_item_size:    dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454042: xfs_buf_item_size:    dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454042: xfs_buf_item_size:    dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454042: xfs_inode_pin:        dev 252:18 ino 0x85 count 1 pincount 0 caller xfs_cil_prepare_item+0x8b
           mount-1504  [009]   146.454042: xfs_buf_item_format:  dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454042: xfs_buf_item_format:  dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454043: xfs_buf_item_format:  dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454043: xfs_buf_item_format:  dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
           mount-1504  [009]   146.454043: xfs_log_ticket_ungrant: dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 2 t_curr_res 312472 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 649464 grant_write_bytes 649464 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454043: xfs_log_ticket_ungrant_sub: dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 1 t_curr_res 312472 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 649464 grant_write_bytes 649464 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454043: xfs_log_ticket_ungrant_exit: dev 252:18 tic 0xffffa084d7e93d50 t_ocnt 2 t_cnt 1 t_curr_res 312472 t_unit_res 317968 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 19024 grant_write_bytes 19024 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.454043: xfs_trans_commit_items: dev 252:18 trans 0 flags 0x5 caller __xfs_trans_commit+0x11f
           mount-1504  [009]   146.454043: xfs_buf_item_release: dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
           mount-1504  [009]   146.454044: xfs_buf_unlock:       dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_release+0xec
           mount-1504  [009]   146.454044: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454044: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454044: xfs_buf_item_release: dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
           mount-1504  [009]   146.454044: xfs_buf_unlock:       dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_item_release+0xec
           mount-1504  [009]   146.454044: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454044: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454044: xfs_buf_item_release: dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
           mount-1504  [009]   146.454044: xfs_buf_unlock:       dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_release+0xec
           mount-1504  [009]   146.454045: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454045: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454045: xfs_buf_item_release: dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
           mount-1504  [009]   146.454045: xfs_buf_unlock:       dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 1 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_buf_item_release+0xec
           mount-1504  [009]   146.454045: xfs_buf_rele:         dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 1 lock 1 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xlog_cil_commit+0x666
           mount-1504  [009]   146.454045: xfs_trans_free:       dev 252:18 trans 0 flags 0x5 caller __xfs_trans_commit+0x127
           mount-1504  [009]   146.454045: xfs_iunlock:          dev 252:18 ino 0x85 flags ILOCK_EXCL caller xfs_qm_qino_alloc+0x35c
           mount-1504  [009]   146.454046: xfs_quota_expiry_range: dev 252:18 min 4 max 16299260424
           mount-1504  [009]   146.454051: xfs_dqread:           dev 252:18 id 0x0 type USER flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.454051: xfs_ilock:            dev 252:18 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_data_map_shared+0x1f
           mount-1504  [009]   146.454052: xfs_iunlock:          dev 252:18 ino 0x83 flags ILOCK_SHARED caller xfs_dquot_disk_read+0xd1
           mount-1504  [009]   146.454052: xfs_dqread_fail:      dev 252:18 id 0x0 type USER flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.454053: xfs_dqread:           dev 252:18 id 0x0 type GROUP flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.454053: xfs_ilock:            dev 252:18 ino 0x84 flags ILOCK_SHARED caller xfs_ilock_data_map_shared+0x1f
           mount-1504  [009]   146.454053: xfs_iunlock:          dev 252:18 ino 0x84 flags ILOCK_SHARED caller xfs_dquot_disk_read+0xd1
           mount-1504  [009]   146.454053: xfs_dqread_fail:      dev 252:18 id 0x0 type GROUP flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.454054: xfs_dqread:           dev 252:18 id 0x0 type PROJ flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.454054: xfs_ilock:            dev 252:18 ino 0x85 flags ILOCK_SHARED caller xfs_ilock_data_map_shared+0x1f
           mount-1504  [009]   146.454054: xfs_iunlock:          dev 252:18 ino 0x85 flags ILOCK_SHARED caller xfs_dquot_disk_read+0xd1
           mount-1504  [009]   146.454054: xfs_dqread_fail:      dev 252:18 id 0x0 type PROJ flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.454054: xfs_dqread:           dev 252:18 id 0x0 type USER flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.454055: xfs_ilock:            dev 252:18 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_data_map_shared+0x1f
           mount-1504  [009]   146.454055: xfs_iunlock:          dev 252:18 ino 0x83 flags ILOCK_SHARED caller xfs_dquot_disk_read+0xd1
           mount-1504  [009]   146.454055: xfs_dqread_fail:      dev 252:18 id 0x0 type USER flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.454055: xfs_dqread:           dev 252:18 id 0x0 type GROUP flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.454055: xfs_ilock:            dev 252:18 ino 0x84 flags ILOCK_SHARED caller xfs_ilock_data_map_shared+0x1f
           mount-1504  [009]   146.454055: xfs_iunlock:          dev 252:18 ino 0x84 flags ILOCK_SHARED caller xfs_dquot_disk_read+0xd1
           mount-1504  [009]   146.454055: xfs_dqread_fail:      dev 252:18 id 0x0 type GROUP flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.454056: xfs_dqread:           dev 252:18 id 0x0 type PROJ flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.454056: xfs_ilock:            dev 252:18 ino 0x85 flags ILOCK_SHARED caller xfs_ilock_data_map_shared+0x1f
           mount-1504  [009]   146.454056: xfs_iunlock:          dev 252:18 ino 0x85 flags ILOCK_SHARED caller xfs_dquot_disk_read+0xd1
           mount-1504  [009]   146.454056: xfs_dqread_fail:      dev 252:18 id 0x0 type PROJ flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.454494: xfs_pwork_init:       dev 252:18 nr_threads 0 pid 1504
           mount-1504  [009]   146.454533: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 5 active refs 1 caller xfs_iwalk_threaded+0xbc
           mount-1504  [009]   146.454533: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 5 active refs 2 caller xfs_iwalk_threaded+0x168
           mount-1504  [009]   146.454537: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_group_next_range+0x2d
           mount-1504  [009]   146.454537: xfs_group_grab:       dev 252:18 agno 0x1 passive refs 2 active refs 1 caller xfs_iwalk_threaded+0xbc
           mount-1504  [009]   146.454537: xfs_group_hold:       dev 252:18 agno 0x1 passive refs 2 active refs 2 caller xfs_iwalk_threaded+0x168
           mount-1504  [009]   146.454537: xfs_group_rele:       dev 252:18 agno 0x1 passive refs 3 active refs 2 caller xfs_group_next_range+0x2d
           mount-1504  [009]   146.454537: xfs_group_grab:       dev 252:18 agno 0x2 passive refs 2 active refs 1 caller xfs_iwalk_threaded+0xbc
           mount-1504  [009]   146.454537: xfs_group_hold:       dev 252:18 agno 0x2 passive refs 2 active refs 2 caller xfs_iwalk_threaded+0x168
           mount-1504  [009]   146.454538: xfs_group_rele:       dev 252:18 agno 0x2 passive refs 3 active refs 2 caller xfs_group_next_range+0x2d
           mount-1504  [009]   146.454538: xfs_group_grab:       dev 252:18 agno 0x3 passive refs 2 active refs 1 caller xfs_iwalk_threaded+0xbc
           mount-1504  [009]   146.454538: xfs_group_hold:       dev 252:18 agno 0x3 passive refs 2 active refs 2 caller xfs_iwalk_threaded+0x168
           mount-1504  [009]   146.454538: xfs_group_rele:       dev 252:18 agno 0x3 passive refs 3 active refs 2 caller xfs_group_next_range+0x2d
   kworker/u74:2-637   [009]   146.454610: xfs_trans_alloc:      dev 252:18 trans 0 flags 0x20 caller xfs_trans_alloc_empty+0x43
   kworker/u74:2-637   [009]   146.454611: xfs_ialloc_read_agi:  dev 252:18 agno 0x1
   kworker/u74:2-637   [009]   146.454611: xfs_read_agi:         dev 252:18 agno 0x1
   kworker/u74:2-637   [009]   146.454611: xfs_group_get:        dev 252:18 agno 0x1 passive refs 3 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:2-637   [009]   146.454612: xfs_buf_lock:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:2-637   [009]   146.454612: xfs_buf_lock_done:    dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:2-637   [009]   146.454612: xfs_buf_find:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:2-637   [009]   146.454612: xfs_group_put:        dev 252:18 agno 0x1 passive refs 4 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:2-637   [009]   146.454612: xfs_buf_get:          dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:2-637   [009]   146.454612: xfs_buf_read:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:2-637   [009]   146.454613: xfs_buf_hold:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:2-637   [009]   146.454613: xfs_trans_add_item:   dev 252:18 trans 0 flags 0x20 caller _xfs_trans_bjoin+0x76
   kworker/u74:2-637   [009]   146.454613: xfs_trans_read_buf:   dev 252:18 daddr 0xa00002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:2-637   [009]   146.454613: xfs_group_hold:       dev 252:18 agno 0x1 passive refs 3 active refs 1 caller xfs_inobt_init_cursor+0x67
   kworker/u74:2-637   [009]   146.454614: xfs_group_get:        dev 252:18 agno 0x1 passive refs 4 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:2-637   [009]   146.454618: xfs_buf_init:         dev 252:18 daddr 0xa00018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
   kworker/u74:2-637   [009]   146.454619: xfs_buf_get:          dev 252:18 daddr 0xa00018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:2-637   [009]   146.454619: xfs_buf_read:         dev 252:18 daddr 0xa00018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:2-637   [009]   146.454619: xfs_buf_submit:       dev 252:18 daddr 0xa00018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_read_map+0x11f
   kworker/u74:2-637   [009]   146.454619: xfs_buf_hold:         dev 252:18 daddr 0xa00018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
   kworker/u74:3-686   [003]   146.454621: xfs_trans_alloc:      dev 252:18 trans 0 flags 0x20 caller xfs_trans_alloc_empty+0x43
   kworker/u74:3-686   [003]   146.454624: xfs_ialloc_read_agi:  dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.454625: xfs_read_agi:         dev 252:18 agno 0x0
   kworker/u74:2-637   [009]   146.454626: xfs_buf_iowait:       dev 252:18 daddr 0xa00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
   kworker/u74:3-686   [003]   146.454627: xfs_group_get:        dev 252:18 agno 0x0 passive refs 6 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.454628: xfs_buf_lock:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.454629: xfs_buf_lock_done:    dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.454630: xfs_buf_find:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:0-123   [009]   146.454631: xfs_trans_alloc:      dev 252:18 trans 0 flags 0x20 caller xfs_trans_alloc_empty+0x43
   kworker/u74:3-686   [003]   146.454631: xfs_group_put:        dev 252:18 agno 0x0 passive refs 7 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:0-123   [009]   146.454631: xfs_ialloc_read_agi:  dev 252:18 agno 0x2
   kworker/u74:0-123   [009]   146.454631: xfs_read_agi:         dev 252:18 agno 0x2
   kworker/u74:3-686   [003]   146.454631: xfs_buf_get:          dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:0-123   [009]   146.454631: xfs_group_get:        dev 252:18 agno 0x2 passive refs 3 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:0-123   [009]   146.454632: xfs_buf_lock:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.454632: xfs_buf_read:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:0-123   [009]   146.454632: xfs_buf_lock_done:    dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:0-123   [009]   146.454632: xfs_buf_find:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:0-123   [009]   146.454632: xfs_group_put:        dev 252:18 agno 0x2 passive refs 4 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:0-123   [009]   146.454632: xfs_buf_get:          dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:0-123   [009]   146.454632: xfs_buf_read:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:0-123   [009]   146.454633: xfs_buf_hold:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:0-123   [009]   146.454633: xfs_trans_add_item:   dev 252:18 trans 0 flags 0x20 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.454633: xfs_trans_add_item:   dev 252:18 trans 0 flags 0x20 caller _xfs_trans_bjoin+0x76
   kworker/u74:0-123   [009]   146.454633: xfs_trans_read_buf:   dev 252:18 daddr 0x1400002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:0-123   [009]   146.454633: xfs_group_hold:       dev 252:18 agno 0x2 passive refs 3 active refs 1 caller xfs_inobt_init_cursor+0x67
   kworker/u74:0-123   [009]   146.454634: xfs_group_get:        dev 252:18 agno 0x2 passive refs 4 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.454634: xfs_trans_read_buf:   dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:0-123   [009]   146.454634: xfs_buf_init:         dev 252:18 daddr 0x1400018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
   kworker/u74:0-123   [009]   146.454635: xfs_buf_get:          dev 252:18 daddr 0x1400018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:0-123   [009]   146.454635: xfs_buf_read:         dev 252:18 daddr 0x1400018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:0-123   [009]   146.454635: xfs_buf_submit:       dev 252:18 daddr 0x1400018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_read_map+0x11f
   kworker/u74:0-123   [009]   146.454636: xfs_buf_hold:         dev 252:18 daddr 0x1400018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
   kworker/u74:3-686   [003]   146.454636: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 6 active refs 1 caller xfs_inobt_init_cursor+0x67
   kworker/u74:0-123   [009]   146.454637: xfs_buf_iowait:       dev 252:18 daddr 0x1400018 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
   kworker/u74:3-686   [003]   146.454639: xfs_group_get:        dev 252:18 agno 0x0 passive refs 7 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.454639: xfs_buf_lock:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.454640: xfs_buf_lock_done:    dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.454640: xfs_buf_find:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.454640: xfs_group_put:        dev 252:18 agno 0x0 passive refs 8 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.454641: xfs_buf_get:          dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.454641: xfs_buf_read:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.454642: xfs_trans_add_item:   dev 252:18 trans 0 flags 0x20 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.454642: xfs_trans_read_buf:   dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.454646: xfs_group_get:        dev 252:18 agno 0x0 passive refs 7 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.454647: xfs_buf_trylock:      dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_find_lock+0x1e
   kworker/u74:3-686   [003]   146.454647: xfs_buf_find:         dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.454648: xfs_group_put:        dev 252:18 agno 0x0 passive refs 8 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.454659: xfs_buf_get:          dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.454660: xfs_buf_read:         dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK caller xfs_buf_readahead_map+0x49
   kworker/u74:3-686   [003]   146.454660: xfs_buf_unlock:       dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_read_map+0x221
   kworker/u74:3-686   [003]   146.454661: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_read_map+0x229
   kworker/u74:3-686   [003]   146.454661: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 1 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_read_map+0x229
   kworker/u74:3-686   [003]   146.454664: xfs_trans_brelse:     dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.454664: xfs_buf_unlock:       dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.454665: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_btree_del_cursor+0x26
   kworker/u74:3-686   [003]   146.454665: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_btree_del_cursor+0x26
   kworker/u74:3-686   [003]   146.454666: xfs_group_put:        dev 252:18 agno 0x0 passive refs 7 active refs 1 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.454667: xfs_trans_brelse:     dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.454667: xfs_buf_unlock:       dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.454667: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_iwalk_run_callbacks+0x84
   kworker/u74:3-686   [003]   146.454668: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_iwalk_run_callbacks+0x84
   kworker/u74:3-686   [003]   146.454668: xfs_trans_cancel:     dev 252:18 trans 0 flags 0x20 caller xfs_iwalk_run_callbacks+0x14a
   kworker/u74:3-686   [003]   146.454670: xfs_trans_free_items: dev 252:18 trans 0 flags 0x20 caller xfs_trans_cancel+0x9d
   kworker/u74:3-686   [003]   146.454671: xfs_trans_free:       dev 252:18 trans 0 flags 0x20 caller xfs_iwalk_run_callbacks+0x14a
   kworker/u74:3-686   [003]   146.454672: xfs_iwalk_ag_rec:     dev 252:18 agno 0x0 startino 0x80 freemask 0xffffffffffffffc0
   kworker/u74:3-686   [003]   146.454674: xfs_group_get:        dev 252:18 agno 0x0 passive refs 6 active refs 1 caller xfs_iget+0xd6
   kworker/u74:3-686   [003]   146.454675: xfs_iget_hit:         dev 252:18 ino 0x80 iflags 0x0
   kworker/u74:3-686   [003]   146.454676: xfs_group_put:        dev 252:18 agno 0x0 passive refs 7 active refs 1 caller xfs_iget+0x725
   kworker/u74:3-686   [003]   146.454677: xfs_ilock:            dev 252:18 ino 0x80 flags ILOCK_SHARED caller xfs_ilock_data_map_shared+0x1f
   kworker/u74:3-686   [003]   146.454678: xfs_iunlock:          dev 252:18 ino 0x80 flags ILOCK_SHARED caller xfs_qm_dqusage_adjust+0x1a4
   kworker/u74:3-686   [003]   146.454690: xfs_dqread:           dev 252:18 id 0x0 type USER flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.454691: xfs_ilock:            dev 252:18 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_data_map_shared+0x1f
   kworker/u74:3-686   [003]   146.454692: xfs_iunlock:          dev 252:18 ino 0x83 flags ILOCK_SHARED caller xfs_dquot_disk_read+0xd1
   kworker/u74:3-686   [003]   146.454693: xfs_dqalloc:          dev 252:18 id 0x0 type USER flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.454697: xfs_log_reserve:      dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 5 t_curr_res 202995 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 19024 grant_write_bytes 19024 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.454698: xfs_log_reserve_exit: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 5 t_curr_res 202995 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 1033999 grant_write_bytes 1033999 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.454698: xfs_trans_alloc:      dev 252:18 trans f4fd559a flags 0x4 caller xfs_dquot_disk_alloc+0xbe
   kworker/u74:3-686   [003]   146.454699: xfs_ilock:            dev 252:18 ino 0x83 flags ILOCK_EXCL caller xfs_dquot_disk_alloc+0xd5
   kworker/u74:3-686   [003]   146.454700: xfs_trans_add_item:   dev 252:18 trans f4fd559a flags 0x4 caller xfs_dquot_disk_alloc+0xe4
   kworker/u74:3-686   [003]   146.454703: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 6 active refs 1 caller xfs_bmap_btalloc+0x266
   kworker/u74:3-686   [003]   146.454704: xfs_ag_resv_needed:   dev 252:18 agno 0x0 resv 0 freeblks 1310699 flcount 6 resv 0 ask 0 len 0
   kworker/u74:3-686   [003]   146.454705: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_bmap_btalloc+0x5ee
   kworker/u74:3-686   [003]   146.454706: xfs_alloc_vextent_start_ag: dev 252:18 agno 0xffffffff agbno 0xffffffff minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 0 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0xffffffff
   kworker/u74:3-686   [003]   146.454707: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 6 active refs 1 caller xfs_alloc_vextent_iterate_ags.constprop.0+0x88
   kworker/u74:3-686   [003]   146.454708: xfs_ag_resv_needed:   dev 252:18 agno 0x0 resv 0 freeblks 1310699 flcount 6 resv 0 ask 0 len 0
   kworker/u74:3-686   [003]   146.454709: xfs_alloc_read_agf:   dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.454709: xfs_read_agf:         dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.454710: xfs_group_get:        dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.454711: xfs_buf_trylock:      dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x1e
   kworker/u74:3-686   [003]   146.454711: xfs_buf_find:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|TRYLOCK caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.454712: xfs_group_put:        dev 252:18 agno 0x0 passive refs 7 active refs 2 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.454712: xfs_buf_get:          dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|TRYLOCK caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.454713: xfs_buf_read:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|TRYLOCK caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.454715: xfs_buf_hold:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.454715: xfs_trans_add_item:   dev 252:18 trans f4fd559a flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.454717: xfs_trans_read_buf:   dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.454732: xfs_ag_resv_needed:   dev 252:18 agno 0x0 resv 0 freeblks 1310699 flcount 6 resv 0 ask 0 len 0
   kworker/u74:3-686   [003]   146.454733: xfs_group_get:        dev 252:18 agno 0x0 passive refs 6 active refs 2 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.454735: xfs_buf_init:         dev 252:18 daddr 0x3 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
   kworker/u74:3-686   [003]   146.454737: xfs_buf_get:          dev 252:18 daddr 0x3 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.454738: xfs_buf_read:         dev 252:18 daddr 0x3 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.454739: xfs_buf_submit:       dev 252:18 daddr 0x3 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_read_map+0x11f
   kworker/u74:3-686   [003]   146.454739: xfs_buf_hold:         dev 252:18 daddr 0x3 bbcount 0x1 hold 1 pincount 0 lock 0 flags READ|KMEM bufops xfs_agfl_buf_ops+0x0 caller __xfs_buf_submit+0x4c
     kworker/9:4-691   [009]   146.454744: xfs_buf_iodone:       dev 252:18 daddr 0x1400018 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller process_one_work+0x176
   kworker/u74:0-123   [009]   146.454757: xfs_buf_iowait_done:  dev 252:18 daddr 0x1400018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
   kworker/u74:0-123   [009]   146.454757: xfs_buf_rele:         dev 252:18 daddr 0x1400018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:0-123   [009]   146.454757: xfs_buf_rele:         dev 252:18 daddr 0x1400018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:0-123   [009]   146.454758: xfs_buf_hold:         dev 252:18 daddr 0x1400018 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:0-123   [009]   146.454758: xfs_trans_add_item:   dev 252:18 trans 0 flags 0x20 caller _xfs_trans_bjoin+0x76
   kworker/u74:0-123   [009]   146.454759: xfs_trans_read_buf:   dev 252:18 daddr 0x1400018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
   kworker/u74:0-123   [009]   146.454759: xfs_trans_brelse:     dev 252:18 daddr 0x1400018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
   kworker/u74:0-123   [009]   146.454759: xfs_buf_item_relse:   dev 252:18 daddr 0x1400018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_put+0x39
   kworker/u74:0-123   [009]   146.454759: xfs_buf_rele:         dev 252:18 daddr 0x1400018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:0-123   [009]   146.454760: xfs_buf_rele:         dev 252:18 daddr 0x1400018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:0-123   [009]   146.454760: xfs_buf_unlock:       dev 252:18 daddr 0x1400018 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:0-123   [009]   146.454760: xfs_buf_rele:         dev 252:18 daddr 0x1400018 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_btree_del_cursor+0x26
   kworker/u74:0-123   [009]   146.454760: xfs_buf_rele:         dev 252:18 daddr 0x1400018 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_btree_del_cursor+0x26
   kworker/u74:0-123   [009]   146.454760: xfs_group_put:        dev 252:18 agno 0x2 passive refs 5 active refs 1 caller xfs_btree_del_cursor+0x5f
   kworker/u74:0-123   [009]   146.454760: xfs_trans_brelse:     dev 252:18 daddr 0x1400002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:0-123   [009]   146.454761: xfs_buf_item_relse:   dev 252:18 daddr 0x1400002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_put+0x39
   kworker/u74:0-123   [009]   146.454761: xfs_buf_rele:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:0-123   [009]   146.454761: xfs_buf_rele:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:0-123   [009]   146.454761: xfs_buf_unlock:       dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:0-123   [009]   146.454761: xfs_buf_rele:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_iwalk_ag+0xe4
   kworker/u74:0-123   [009]   146.454761: xfs_buf_rele:         dev 252:18 daddr 0x1400002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_iwalk_ag+0xe4
   kworker/u74:0-123   [009]   146.454762: xfs_trans_cancel:     dev 252:18 trans 0 flags 0x20 caller xfs_iwalk_ag_work+0x7b
   kworker/u74:0-123   [009]   146.454762: xfs_trans_free_items: dev 252:18 trans 0 flags 0x20 caller xfs_trans_cancel+0x9d
   kworker/u74:0-123   [009]   146.454762: xfs_trans_free:       dev 252:18 trans 0 flags 0x20 caller xfs_iwalk_ag_work+0x7b
   kworker/u74:0-123   [009]   146.454763: xfs_group_put:        dev 252:18 agno 0x2 passive refs 4 active refs 1 caller xfs_iwalk_ag_work+0x4c
   kworker/u74:0-123   [009]   146.454764: xfs_trans_alloc:      dev 252:18 trans 0 flags 0x20 caller xfs_trans_alloc_empty+0x43
   kworker/u74:0-123   [009]   146.454764: xfs_ialloc_read_agi:  dev 252:18 agno 0x3
   kworker/u74:0-123   [009]   146.454764: xfs_read_agi:         dev 252:18 agno 0x3
   kworker/u74:0-123   [009]   146.454764: xfs_group_get:        dev 252:18 agno 0x3 passive refs 3 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:0-123   [009]   146.454764: xfs_buf_lock:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:0-123   [009]   146.454765: xfs_buf_lock_done:    dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:0-123   [009]   146.454765: xfs_buf_find:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:0-123   [009]   146.454765: xfs_group_put:        dev 252:18 agno 0x3 passive refs 4 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:0-123   [009]   146.454765: xfs_buf_get:          dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:0-123   [009]   146.454765: xfs_buf_read:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:0-123   [009]   146.454765: xfs_buf_hold:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:0-123   [009]   146.454766: xfs_trans_add_item:   dev 252:18 trans 0 flags 0x20 caller _xfs_trans_bjoin+0x76
   kworker/u74:0-123   [009]   146.454766: xfs_trans_read_buf:   dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:0-123   [009]   146.454766: xfs_group_hold:       dev 252:18 agno 0x3 passive refs 3 active refs 1 caller xfs_inobt_init_cursor+0x67
   kworker/u74:0-123   [009]   146.454766: xfs_group_get:        dev 252:18 agno 0x3 passive refs 4 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:0-123   [009]   146.454766: xfs_buf_init:         dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
   kworker/u74:0-123   [009]   146.454767: xfs_buf_get:          dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:0-123   [009]   146.454767: xfs_buf_read:         dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:0-123   [009]   146.454768: xfs_buf_submit:       dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_read_map+0x11f
   kworker/u74:0-123   [009]   146.454768: xfs_buf_hold:         dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
   kworker/u74:0-123   [009]   146.454771: xfs_buf_iowait:       dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.454772: xfs_buf_iodone:       dev 252:18 daddr 0xa00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller process_one_work+0x176
   kworker/u74:2-637   [009]   146.454776: xfs_buf_iowait_done:  dev 252:18 daddr 0xa00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
   kworker/u74:2-637   [009]   146.454776: xfs_buf_rele:         dev 252:18 daddr 0xa00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:2-637   [009]   146.454776: xfs_buf_rele:         dev 252:18 daddr 0xa00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:2-637   [009]   146.454777: xfs_buf_hold:         dev 252:18 daddr 0xa00018 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:2-637   [009]   146.454777: xfs_trans_add_item:   dev 252:18 trans 0 flags 0x20 caller _xfs_trans_bjoin+0x76
   kworker/u74:2-637   [009]   146.454777: xfs_trans_read_buf:   dev 252:18 daddr 0xa00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
   kworker/u74:2-637   [009]   146.454777: xfs_trans_brelse:     dev 252:18 daddr 0xa00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
   kworker/u74:2-637   [009]   146.454777: xfs_buf_item_relse:   dev 252:18 daddr 0xa00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_put+0x39
   kworker/u74:2-637   [009]   146.454777: xfs_buf_rele:         dev 252:18 daddr 0xa00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:2-637   [009]   146.454778: xfs_buf_rele:         dev 252:18 daddr 0xa00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:2-637   [009]   146.454778: xfs_buf_unlock:       dev 252:18 daddr 0xa00018 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:2-637   [009]   146.454778: xfs_buf_rele:         dev 252:18 daddr 0xa00018 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_btree_del_cursor+0x26
   kworker/u74:2-637   [009]   146.454778: xfs_buf_rele:         dev 252:18 daddr 0xa00018 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_btree_del_cursor+0x26
   kworker/u74:2-637   [009]   146.454778: xfs_group_put:        dev 252:18 agno 0x1 passive refs 5 active refs 1 caller xfs_btree_del_cursor+0x5f
   kworker/u74:2-637   [009]   146.454778: xfs_trans_brelse:     dev 252:18 daddr 0xa00002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:2-637   [009]   146.454778: xfs_buf_item_relse:   dev 252:18 daddr 0xa00002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_put+0x39
   kworker/u74:2-637   [009]   146.454779: xfs_buf_rele:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:2-637   [009]   146.454779: xfs_buf_rele:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:2-637   [009]   146.454779: xfs_buf_unlock:       dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:2-637   [009]   146.454779: xfs_buf_rele:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_iwalk_ag+0xe4
   kworker/u74:2-637   [009]   146.454779: xfs_buf_rele:         dev 252:18 daddr 0xa00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_iwalk_ag+0xe4
   kworker/u74:2-637   [009]   146.454780: xfs_trans_cancel:     dev 252:18 trans 0 flags 0x20 caller xfs_iwalk_ag_work+0x7b
   kworker/u74:2-637   [009]   146.454780: xfs_trans_free_items: dev 252:18 trans 0 flags 0x20 caller xfs_trans_cancel+0x9d
   kworker/u74:2-637   [009]   146.454780: xfs_trans_free:       dev 252:18 trans 0 flags 0x20 caller xfs_iwalk_ag_work+0x7b
   kworker/u74:2-637   [009]   146.454780: xfs_group_put:        dev 252:18 agno 0x1 passive refs 4 active refs 1 caller xfs_iwalk_ag_work+0x4c
   kworker/u74:3-686   [003]   146.454783: xfs_buf_iowait:       dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agfl_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/9:4-691   [009]   146.454863: xfs_buf_iodone:       dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_inobt_buf_ops+0x0 caller process_one_work+0x176
   kworker/u74:0-123   [009]   146.454868: xfs_buf_iowait_done:  dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
   kworker/u74:0-123   [009]   146.454868: xfs_buf_rele:         dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:0-123   [009]   146.454868: xfs_buf_rele:         dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:0-123   [009]   146.454868: xfs_buf_hold:         dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:0-123   [009]   146.454868: xfs_trans_add_item:   dev 252:18 trans 0 flags 0x20 caller _xfs_trans_bjoin+0x76
   kworker/u74:0-123   [009]   146.454869: xfs_trans_read_buf:   dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
   kworker/u74:0-123   [009]   146.454869: xfs_trans_brelse:     dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
   kworker/u74:0-123   [009]   146.454869: xfs_buf_item_relse:   dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_put+0x39
   kworker/u74:0-123   [009]   146.454869: xfs_buf_rele:         dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:0-123   [009]   146.454869: xfs_buf_rele:         dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:0-123   [009]   146.454870: xfs_buf_unlock:       dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:0-123   [009]   146.454870: xfs_buf_rele:         dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_btree_del_cursor+0x26
   kworker/u74:0-123   [009]   146.454870: xfs_buf_rele:         dev 252:18 daddr 0x1e00018 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_btree_del_cursor+0x26
   kworker/u74:0-123   [009]   146.454870: xfs_group_put:        dev 252:18 agno 0x3 passive refs 5 active refs 1 caller xfs_btree_del_cursor+0x5f
   kworker/u74:0-123   [009]   146.454870: xfs_trans_brelse:     dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:0-123   [009]   146.454871: xfs_buf_item_relse:   dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_put+0x39
   kworker/u74:0-123   [009]   146.454871: xfs_buf_rele:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:0-123   [009]   146.454871: xfs_buf_rele:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:0-123   [009]   146.454871: xfs_buf_unlock:       dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:0-123   [009]   146.454871: xfs_buf_rele:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_iwalk_ag+0xe4
   kworker/u74:0-123   [009]   146.454871: xfs_buf_rele:         dev 252:18 daddr 0x1e00002 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_iwalk_ag+0xe4
   kworker/u74:0-123   [009]   146.454871: xfs_trans_cancel:     dev 252:18 trans 0 flags 0x20 caller xfs_iwalk_ag_work+0x7b
   kworker/u74:0-123   [009]   146.454871: xfs_trans_free_items: dev 252:18 trans 0 flags 0x20 caller xfs_trans_cancel+0x9d
   kworker/u74:0-123   [009]   146.454871: xfs_trans_free:       dev 252:18 trans 0 flags 0x20 caller xfs_iwalk_ag_work+0x7b
   kworker/u74:0-123   [009]   146.454872: xfs_group_put:        dev 252:18 agno 0x3 passive refs 4 active refs 1 caller xfs_iwalk_ag_work+0x4c
     kworker/3:2-1061  [003]   146.454914: xfs_buf_iodone:       dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ|KMEM bufops xfs_agfl_buf_ops+0x0 caller process_one_work+0x176
   kworker/u74:3-686   [003]   146.454933: xfs_buf_iowait_done:  dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller __xfs_buf_submit+0x10c
   kworker/u74:3-686   [003]   146.454934: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:3-686   [003]   146.454934: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:3-686   [003]   146.454948: xfs_buf_hold:         dev 252:18 daddr 0x3 bbcount 0x1 hold 1 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.454949: xfs_trans_add_item:   dev 252:18 trans f4fd559a flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.454950: xfs_trans_read_buf:   dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.454951: xfs_trans_brelse:     dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.454952: xfs_buf_item_relse:   dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_put+0x39
   kworker/u74:3-686   [003]   146.454953: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:3-686   [003]   146.454953: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:3-686   [003]   146.454955: xfs_buf_unlock:       dev 252:18 daddr 0x3 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.454956: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_alloc_fix_freelist+0x5d5
   kworker/u74:3-686   [003]   146.454956: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 1 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_alloc_fix_freelist+0x5d5
   kworker/u74:3-686   [003]   146.454966: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 7 active refs 2 caller xfs_cntbt_init_cursor+0x62
   kworker/u74:3-686   [003]   146.454969: xfs_group_get:        dev 252:18 agno 0x0 passive refs 8 active refs 2 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.454970: xfs_buf_init:         dev 252:18 daddr 0x10 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
   kworker/u74:3-686   [003]   146.454974: xfs_buf_get:          dev 252:18 daddr 0x10 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.454975: xfs_buf_read:         dev 252:18 daddr 0x10 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.454976: xfs_buf_submit:       dev 252:18 daddr 0x10 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_read_map+0x11f
   kworker/u74:3-686   [003]   146.454976: xfs_buf_hold:         dev 252:18 daddr 0x10 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_cntbt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
   kworker/u74:3-686   [003]   146.454993: xfs_buf_iowait:       dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_cntbt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/3:2-1061  [003]   146.455171: xfs_buf_iodone:       dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_cntbt_buf_ops+0x0 caller process_one_work+0x176
   kworker/u74:3-686   [003]   146.455196: xfs_buf_iowait_done:  dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
   kworker/u74:3-686   [003]   146.455197: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:3-686   [003]   146.455197: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:3-686   [003]   146.455200: xfs_buf_hold:         dev 252:18 daddr 0x10 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.455201: xfs_trans_add_item:   dev 252:18 trans f4fd559a flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455202: xfs_trans_read_buf:   dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455206: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 9 active refs 2 caller xfs_bnobt_init_cursor+0x62
   kworker/u74:3-686   [003]   146.455206: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 10 active refs 2 caller xfs_bnobt_init_cursor+0x62
   kworker/u74:3-686   [003]   146.455211: xfs_alloc_cur_check:  dev 252:18 cntbt agbno 0xd fsbcount 0x3 diff 0x1 new 1
   kworker/u74:3-686   [003]   146.455212: xfs_alloc_cur_check:  dev 252:18 cntbt agbno 0x18 fsbcount 0x13ffe8 diff 0x8 new 0
   kworker/u74:3-686   [003]   146.455213: xfs_alloc_near_first: dev 252:18 agno 0x0 agbno 0x10 minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 1 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0xffffffff
   kworker/u74:3-686   [003]   146.455216: xfs_group_get:        dev 252:18 agno 0x0 passive refs 11 active refs 2 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455218: xfs_buf_init:         dev 252:18 daddr 0x8 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
   kworker/u74:3-686   [003]   146.455222: xfs_buf_get:          dev 252:18 daddr 0x8 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455223: xfs_buf_read:         dev 252:18 daddr 0x8 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455223: xfs_buf_submit:       dev 252:18 daddr 0x8 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_read_map+0x11f
   kworker/u74:3-686   [003]   146.455224: xfs_buf_hold:         dev 252:18 daddr 0x8 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_bnobt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
   kworker/u74:3-686   [003]   146.455244: xfs_buf_iowait:       dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_bnobt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/3:2-1061  [003]   146.455367: xfs_buf_iodone:       dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_bnobt_buf_ops+0x0 caller process_one_work+0x176
   kworker/u74:3-686   [003]   146.455387: xfs_buf_iowait_done:  dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
   kworker/u74:3-686   [003]   146.455388: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:3-686   [003]   146.455388: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:3-686   [003]   146.455389: xfs_buf_hold:         dev 252:18 daddr 0x8 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.455390: xfs_trans_add_item:   dev 252:18 trans f4fd559a flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455390: xfs_trans_read_buf:   dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455394: xfs_trans_log_buf:    dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455395: xfs_trans_log_buf:    dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455397: xfs_trans_log_buf:    dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455397: xfs_trans_log_buf:    dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455399: xfs_trans_log_buf:    dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455411: xfs_agf:              dev 252:18 agno 0x0 flags LONGEST length 1310720 roots b 1 c 2 levels b 1 c 1 flfirst 1 fllast 6 flcount 6 freeblks 1310699 longest 1310696 caller xfs_alloc_fixup_longest+0xa3
   kworker/u74:3-686   [003]   146.455412: xfs_trans_log_buf:    dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455413: xfs_alloc_cur:        dev 252:18 agno 0x0 agbno 0xf minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 1 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0xffffffff
   kworker/u74:3-686   [003]   146.455414: xfs_trans_brelse:     dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455415: xfs_group_put:        dev 252:18 agno 0x0 passive refs 12 active refs 2 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.455416: xfs_trans_brelse:     dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455416: xfs_group_put:        dev 252:18 agno 0x0 passive refs 11 active refs 2 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.455417: xfs_group_put:        dev 252:18 agno 0x0 passive refs 10 active refs 2 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.455418: xfs_agf:              dev 252:18 agno 0x0 flags FREEBLKS length 1310720 roots b 1 c 2 levels b 1 c 1 flfirst 1 fllast 6 flcount 6 freeblks 1310698 longest 1310696 caller xfs_alloc_update_counters+0x3e
   kworker/u74:3-686   [003]   146.455419: xfs_trans_log_buf:    dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455420: xfs_ag_resv_alloc_extent: dev 252:18 agno 0x0 resv 0 freeblks 1310698 flcount 6 resv 0 ask 0 len 1
   kworker/u74:3-686   [003]   146.455421: xfs_alloc_vextent_finish: dev 252:18 agno 0x0 agbno 0xf minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 1 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0x0
   kworker/u74:3-686   [003]   146.455422: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 9 active refs 2 caller xfs_alloc_vextent_finish+0x2d7
   kworker/u74:3-686   [003]   146.455431: xfs_iext_insert:      dev 252:18 ino 0x83 state  cur 0xffffa084c183e5b0/0 fileoff 0x0 startblock 0xf fsbcount 0x1 flag 0 caller xfs_bmap_add_extent_hole_real+0x446
   kworker/u74:3-686   [003]   146.455442: xfs_rmap_defer:       dev 252:18 op map agno 0x0 agbno 0xf owner 0x83 data fileoff 0x0 fsbcount 0x1 state 0
   kworker/u74:3-686   [003]   146.455443: xfs_group_get:        dev 252:18 agno 0x0 passive refs 9 active refs 1 caller xfs_group_intent_get+0x12
   kworker/u74:3-686   [003]   146.455444: xfs_group_intent_hold: dev 252:18 agno 0x0 intents 0 caller xfs_rmap_defer_add+0x27
   kworker/u74:3-686   [003]   146.455446: xfs_defer_add_item:   dev 252:18 optype rmap intent (nil) item 0xffffa084d8f0b168 flags  committed 0 nr 1
   kworker/u74:3-686   [003]   146.455449: xfs_group_get:        dev 252:18 agno 0x0 passive refs 10 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455450: xfs_buf_init:         dev 252:18 daddr 0x78 bbcount 0x8 hold 1 pincount 0 lock 0 flags  bufops 0x0 caller xfs_buf_get_map+0x270
   kworker/u74:3-686   [003]   146.455453: xfs_buf_ioerror:      dev 252:18 daddr 0x78 bbcount 0x8 hold 1 pincount 0 lock 0 error 0 flags PAGES caller xfs_buf_get_map+0x7e5
   kworker/u74:3-686   [003]   146.455453: xfs_buf_get:          dev 252:18 daddr 0x78 bbcount 0x8 hold 1 pincount 0 lock 0 flags  caller xfs_trans_get_buf_map+0x13b
   kworker/u74:3-686   [003]   146.455454: xfs_buf_hold:         dev 252:18 daddr 0x78 bbcount 0x8 hold 1 pincount 0 lock 0 flags PAGES bufops 0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.455454: xfs_trans_add_item:   dev 252:18 trans f4fd559a flags 0x5 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455455: xfs_trans_get_buf:    dev 252:18 daddr 0x78 bbcount 0x8 hold 2 pincount 0 lock 0 flags PAGES recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455466: xfs_buf_item_ordered: dev 252:18 daddr 0x78 bbcount 0x8 hold 2 pincount 0 lock 0 flags DQUOTS|PAGES recur 0 refcount 1 bliflags ORDERED liflags 
   kworker/u74:3-686   [003]   146.455467: xfs_trans_bhold:      dev 252:18 daddr 0x78 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 1 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455468: xfs_defer_finish:     dev 252:18 tp 0xffffa084c4f804b0 caller xfs_trans_commit+0x4f
   kworker/u74:3-686   [003]   146.455469: xfs_defer_create_intent: dev 252:18 optype rmap intent (nil) flags  committed 0 nr 1
   kworker/u74:3-686   [003]   146.455482: xfs_trans_add_item:   dev 252:18 trans f4fd559a flags 0x5 caller xfs_defer_create_intent+0x58
   kworker/u74:3-686   [003]   146.455484: xfs_defer_trans_roll: dev 252:18 tp 0xffffa084c4f804b0 caller xfs_defer_finish_noroll+0x2c5
   kworker/u74:3-686   [003]   146.455484: xfs_trans_roll:       dev 252:18 trans f4fd559a flags 0x5 caller xfs_defer_trans_roll+0x58
   kworker/u74:3-686   [003]   146.455485: xfs_trans_dup:        dev 252:18 trans f4fd559a flags 0x5 caller xfs_trans_roll+0x51
   kworker/u74:3-686   [003]   146.455486: xfs_trans_commit:     dev 252:18 trans f4fd559a flags 0x25 caller xfs_trans_roll+0x61
   kworker/u74:3-686   [003]   146.455492: xfs_buf_item_size:    dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455493: xfs_buf_item_size:    dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455493: xfs_buf_item_size:    dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455495: xfs_buf_item_size_ordered: dev 252:18 daddr 0x78 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 1 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455500: xfs_write_extent:     dev 252:18 ino 0x83 state  cur 0xffffa084c183e5b0/0 fileoff 0x0 startblock 0xf fsbcount 0x1 flag 0 caller xfs_inode_item_format_data_fork+0x31f
   kworker/u74:3-686   [003]   146.455501: xfs_buf_item_format:  dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455502: xfs_buf_item_pin:     dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455502: xfs_buf_hold:         dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_pin+0x32
   kworker/u74:3-686   [003]   146.455503: xfs_buf_item_format:  dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455503: xfs_buf_item_pin:     dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455504: xfs_buf_hold:         dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_item_pin+0x32
   kworker/u74:3-686   [003]   146.455504: xfs_buf_item_format:  dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455505: xfs_buf_item_pin:     dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455505: xfs_buf_hold:         dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_item_pin+0x32
   kworker/u74:3-686   [003]   146.455505: xfs_buf_item_pin:     dev 252:18 daddr 0x78 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 1 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455506: xfs_buf_hold:         dev 252:18 daddr 0x78 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_item_pin+0x32
   kworker/u74:3-686   [003]   146.455507: xfs_log_ticket_regrant: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 5 t_curr_res 198711 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 1033999 grant_write_bytes 1033999 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455508: xfs_log_ticket_regrant_sub: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 4 t_curr_res 202995 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 835288 grant_write_bytes 835288 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455509: xfs_trans_commit_items: dev 252:18 trans 0 flags 0x25 caller __xfs_trans_commit+0x11f
   kworker/u74:3-686   [003]   146.455510: xfs_buf_item_release: dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
   kworker/u74:3-686   [003]   146.455511: xfs_buf_unlock:       dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.455511: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455511: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455512: xfs_buf_item_release: dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
   kworker/u74:3-686   [003]   146.455513: xfs_buf_unlock:       dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.455513: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455513: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455514: xfs_buf_item_release: dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
   kworker/u74:3-686   [003]   146.455514: xfs_buf_unlock:       dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.455514: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455515: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455515: xfs_buf_item_release: dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags 
   kworker/u74:3-686   [003]   146.455516: xfs_trans_free:       dev 252:18 trans 0 flags 0x25 caller __xfs_trans_commit+0x127
   kworker/u74:3-686   [003]   146.455517: xfs_trans_add_item:   dev 252:18 trans f4fd559b flags 0x4 caller xfs_defer_restore_resources+0x3b
   kworker/u74:3-686   [003]   146.455518: xfs_trans_add_item:   dev 252:18 trans f4fd559b flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455519: xfs_trans_bjoin:      dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455520: xfs_buf_item_ordered: dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags DIRTY|ORDERED liflags 
   kworker/u74:3-686   [003]   146.455520: xfs_trans_bhold:      dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455521: xfs_defer_trans_roll: dev 252:18 tp 0xffffa084c4f81a40 caller xfs_defer_finish_noroll+0x304
   kworker/u74:3-686   [003]   146.455522: xfs_trans_roll:       dev 252:18 trans f4fd559b flags 0x5 caller xfs_defer_trans_roll+0x58
   kworker/u74:3-686   [003]   146.455522: xfs_trans_dup:        dev 252:18 trans f4fd559b flags 0x5 caller xfs_trans_roll+0x51
   kworker/u74:3-686   [003]   146.455523: xfs_trans_commit:     dev 252:18 trans f4fd559b flags 0x25 caller xfs_trans_roll+0x61
   kworker/u74:3-686   [003]   146.455525: xfs_buf_item_size_ordered: dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455526: xfs_write_extent:     dev 252:18 ino 0x83 state  cur 0xffffa084c183e5b0/0 fileoff 0x0 startblock 0xf fsbcount 0x1 flag 0 caller xfs_inode_item_format_data_fork+0x31f
   kworker/u74:3-686   [003]   146.455527: xfs_log_ticket_regrant: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 4 t_curr_res 199327 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 835288 grant_write_bytes 835288 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455528: xfs_log_ticket_regrant_sub: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 3 t_curr_res 202995 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 635961 grant_write_bytes 635961 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455528: xfs_trans_commit_items: dev 252:18 trans 0 flags 0x25 caller __xfs_trans_commit+0x11f
   kworker/u74:3-686   [003]   146.455529: xfs_buf_item_release: dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags 
   kworker/u74:3-686   [003]   146.455529: xfs_trans_free:       dev 252:18 trans 0 flags 0x25 caller __xfs_trans_commit+0x127
   kworker/u74:3-686   [003]   146.455530: xfs_trans_add_item:   dev 252:18 trans f4fd559c flags 0x4 caller xfs_defer_restore_resources+0x3b
   kworker/u74:3-686   [003]   146.455530: xfs_trans_add_item:   dev 252:18 trans f4fd559c flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455531: xfs_trans_bjoin:      dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455531: xfs_buf_item_ordered: dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags DIRTY|ORDERED liflags 
   kworker/u74:3-686   [003]   146.455531: xfs_trans_bhold:      dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455532: xfs_defer_pending_finish: dev 252:18 optype rmap intent 0xffffa084d81b4080 flags  committed 0 nr 1
   kworker/u74:3-686   [003]   146.455538: xfs_trans_add_item:   dev 252:18 trans f4fd559c flags 0x85 caller xfs_defer_finish_one+0x7a
   kworker/u74:3-686   [003]   146.455539: xfs_defer_finish_item: dev 252:18 optype rmap intent 0xffffa084d81b4080 item 0xffffa084d8f0b168 flags  committed 1 nr 0
   kworker/u74:3-686   [003]   146.455540: xfs_rmap_deferred:    dev 252:18 op map agno 0x0 agbno 0xf owner 0x83 data fileoff 0x0 fsbcount 0x1 state 0
   kworker/u74:3-686   [003]   146.455541: xfs_alloc_read_agf:   dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.455541: xfs_read_agf:         dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.455542: xfs_group_get:        dev 252:18 agno 0x0 passive refs 11 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455543: xfs_buf_lock:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455543: xfs_buf_lock_done:    dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455544: xfs_buf_find:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455544: xfs_group_put:        dev 252:18 agno 0x0 passive refs 12 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455544: xfs_buf_get:          dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455545: xfs_buf_read:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455545: xfs_trans_add_item:   dev 252:18 trans f4fd559c flags 0x85 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455546: xfs_trans_read_buf:   dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455547: xfs_group_get:        dev 252:18 agno 0x0 passive refs 11 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455547: xfs_buf_lock:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455548: xfs_buf_lock_done:    dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455548: xfs_buf_find:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455548: xfs_group_put:        dev 252:18 agno 0x0 passive refs 12 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455549: xfs_buf_get:          dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455549: xfs_buf_read:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455550: xfs_buf_hold:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.455550: xfs_trans_add_item:   dev 252:18 trans f4fd559c flags 0x85 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455550: xfs_trans_read_buf:   dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455551: xfs_trans_brelse:     dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455551: xfs_buf_item_relse:   dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_put+0x39
   kworker/u74:3-686   [003]   146.455552: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:3-686   [003]   146.455552: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:3-686   [003]   146.455553: xfs_buf_unlock:       dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.455553: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_alloc_fix_freelist+0x5d5
   kworker/u74:3-686   [003]   146.455554: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_alloc_fix_freelist+0x5d5
   kworker/u74:3-686   [003]   146.455558: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 11 active refs 1 caller xfs_rmapbt_init_cursor+0x62
   kworker/u74:3-686   [003]   146.455559: xfs_rmap_map:         dev 252:18 agno 0x0 agbno 0xf fsbcount 0x1 owner 0x83 fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.455561: xfs_group_get:        dev 252:18 agno 0x0 passive refs 12 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455561: xfs_buf_init:         dev 252:18 daddr 0x28 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ bufops 0x0 caller xfs_buf_get_map+0x270
   kworker/u74:3-686   [003]   146.455564: xfs_buf_get:          dev 252:18 daddr 0x28 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455565: xfs_buf_read:         dev 252:18 daddr 0x28 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455565: xfs_buf_submit:       dev 252:18 daddr 0x28 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_read_map+0x11f
   kworker/u74:3-686   [003]   146.455565: xfs_buf_hold:         dev 252:18 daddr 0x28 bbcount 0x8 hold 1 pincount 0 lock 0 flags READ|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
   kworker/u74:3-686   [003]   146.455581: xfs_buf_iowait:       dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
     kworker/3:2-1061  [003]   146.455766: xfs_buf_iodone:       dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags READ|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller process_one_work+0x176
   kworker/u74:3-686   [003]   146.455782: xfs_buf_iowait_done:  dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller __xfs_buf_submit+0x10c
   kworker/u74:3-686   [003]   146.455782: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:3-686   [003]   146.455782: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller __xfs_buf_submit+0xad
   kworker/u74:3-686   [003]   146.455784: xfs_buf_hold:         dev 252:18 daddr 0x28 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.455784: xfs_trans_add_item:   dev 252:18 trans f4fd559c flags 0x85 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455784: xfs_trans_read_buf:   dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455788: xfs_rmap_lookup_le_range_result: dev 252:18 agno 0x0 agbno 0x7 fsbcount 0x6 owner 0xfffffffffffffffb fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.455789: xfs_rmap_find_right_neighbor_result: dev 252:18 agno 0x0 agbno 0x10 fsbcount 0x8 owner 0xfffffffffffffff9 fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.455790: xfs_rmap_insert:      dev 252:18 agno 0x0 agbno 0xf fsbcount 0x1 owner 0x83 fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.455792: xfs_trans_log_buf:    dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455793: xfs_trans_log_buf:    dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455794: xfs_rmap_map_done:    dev 252:18 agno 0x0 agbno 0xf fsbcount 0x1 owner 0x83 fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.455795: xfs_group_intent_rele: dev 252:18 agno 0x0 intents 1 caller xfs_rmap_update_cancel_item+0x16
   kworker/u74:3-686   [003]   146.455795: xfs_group_put:        dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_rmap_update_cancel_item+0x16
   kworker/u74:3-686   [003]   146.455796: xfs_trans_brelse:     dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455797: xfs_group_put:        dev 252:18 agno 0x0 passive refs 12 active refs 1 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.455798: xfs_defer_finish_done: dev 252:18 tp 0xffffa084c4f804b0 caller xfs_trans_commit+0x4f
   kworker/u74:3-686   [003]   146.455798: xfs_trans_commit:     dev 252:18 trans f4fd559c flags 0x85 caller xfs_trans_commit+0x38
   kworker/u74:3-686   [003]   146.455800: xfs_buf_item_size_ordered: dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455801: xfs_buf_item_size:    dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455803: xfs_cil_whiteout_mark: dev 252:18 lip 0xffffa084d81b4080 lsn 0/0 type XFS_LI_RUI flags WHITEOUT
   kworker/u74:3-686   [003]   146.455805: xfs_buf_item_format:  dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455806: xfs_buf_item_pin:     dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455806: xfs_buf_hold:         dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_item_pin+0x32
   kworker/u74:3-686   [003]   146.455807: xfs_log_ticket_ungrant: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 3 t_curr_res 199083 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 635961 grant_write_bytes 635961 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455807: xfs_log_ticket_ungrant_sub: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 2 t_curr_res 199083 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 635961 grant_write_bytes 635961 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455808: xfs_log_ticket_ungrant_exit: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 2 t_curr_res 199083 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 30888 grant_write_bytes 30888 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455809: xfs_trans_commit_items: dev 252:18 trans 0 flags 0x85 caller __xfs_trans_commit+0x11f
   kworker/u74:3-686   [003]   146.455809: xfs_buf_item_release: dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags 
   kworker/u74:3-686   [003]   146.455810: xfs_buf_item_release: dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455810: xfs_buf_unlock:       dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.455811: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455811: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455811: xfs_buf_item_release: dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
   kworker/u74:3-686   [003]   146.455812: xfs_buf_unlock:       dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.455812: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455812: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455813: xfs_trans_free:       dev 252:18 trans 0 flags 0x85 caller __xfs_trans_commit+0x127
   kworker/u74:3-686   [003]   146.455814: xfs_iunlock:          dev 252:18 ino 0x83 flags ILOCK_EXCL caller xfs_dquot_disk_alloc+0x286
   kworker/u74:3-686   [003]   146.455815: xfs_buf_unlock:       dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_dqread+0x87
   kworker/u74:3-686   [003]   146.455816: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_dqread+0x8f
   kworker/u74:3-686   [003]   146.455816: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_dqread+0x8f
   kworker/u74:3-686   [003]   146.455817: xfs_dqget_miss:       dev 252:18 id 0x0 type USER flags  nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.455819: xfs_group_get:        dev 252:18 agno 0x0 passive refs 11 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455819: xfs_buf_lock:         dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455820: xfs_buf_lock_done:    dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455820: xfs_buf_find:         dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455821: xfs_group_put:        dev 252:18 agno 0x0 passive refs 12 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455821: xfs_buf_get:          dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455821: xfs_buf_read:         dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455822: xfs_buf_hold:         dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_attach_buf+0xf4
   kworker/u74:3-686   [003]   146.455822: xfs_buf_unlock:       dev 252:18 daddr 0x78 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.455822: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_attach_buf+0x10e
   kworker/u74:3-686   [003]   146.455823: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_attach_buf+0x10e
   kworker/u74:3-686   [003]   146.455824: xfs_dqadjust:         dev 252:18 id 0x0 type USER flags  nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.455825: xfs_dqput:            dev 252:18 id 0x0 type USER flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x1 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x1 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.455825: xfs_dqput_free:       dev 252:18 id 0x0 type USER flags DIRTY nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x1 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x1 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.455828: xfs_dqread:           dev 252:18 id 0x0 type GROUP flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.455829: xfs_ilock:            dev 252:18 ino 0x84 flags ILOCK_SHARED caller xfs_ilock_data_map_shared+0x1f
   kworker/u74:3-686   [003]   146.455830: xfs_iunlock:          dev 252:18 ino 0x84 flags ILOCK_SHARED caller xfs_dquot_disk_read+0xd1
   kworker/u74:3-686   [003]   146.455831: xfs_dqalloc:          dev 252:18 id 0x0 type GROUP flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.455833: xfs_log_reserve:      dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 5 t_curr_res 202995 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 30888 grant_write_bytes 30888 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455833: xfs_log_reserve_exit: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 5 t_curr_res 202995 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 1045863 grant_write_bytes 1045863 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455834: xfs_trans_alloc:      dev 252:18 trans ebe32657 flags 0x4 caller xfs_dquot_disk_alloc+0xbe
   kworker/u74:3-686   [003]   146.455834: xfs_ilock:            dev 252:18 ino 0x84 flags ILOCK_EXCL caller xfs_dquot_disk_alloc+0xd5
   kworker/u74:3-686   [003]   146.455835: xfs_trans_add_item:   dev 252:18 trans ebe32657 flags 0x4 caller xfs_dquot_disk_alloc+0xe4
   kworker/u74:3-686   [003]   146.455837: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 11 active refs 1 caller xfs_bmap_btalloc+0x266
   kworker/u74:3-686   [003]   146.455838: xfs_ag_resv_needed:   dev 252:18 agno 0x0 resv 0 freeblks 1310698 flcount 6 resv 0 ask 0 len 0
   kworker/u74:3-686   [003]   146.455838: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 11 active refs 2 caller xfs_bmap_btalloc+0x5ee
   kworker/u74:3-686   [003]   146.455840: xfs_alloc_vextent_start_ag: dev 252:18 agno 0xffffffff agbno 0xffffffff minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 0 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0xffffffff
   kworker/u74:3-686   [003]   146.455840: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 11 active refs 1 caller xfs_alloc_vextent_iterate_ags.constprop.0+0x88
   kworker/u74:3-686   [003]   146.455841: xfs_ag_resv_needed:   dev 252:18 agno 0x0 resv 0 freeblks 1310698 flcount 6 resv 0 ask 0 len 0
   kworker/u74:3-686   [003]   146.455841: xfs_alloc_read_agf:   dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.455842: xfs_read_agf:         dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.455842: xfs_group_get:        dev 252:18 agno 0x0 passive refs 11 active refs 2 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455843: xfs_buf_trylock:      dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x1e
   kworker/u74:3-686   [003]   146.455843: xfs_buf_find:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ|TRYLOCK caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455844: xfs_group_put:        dev 252:18 agno 0x0 passive refs 12 active refs 2 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455844: xfs_buf_get:          dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ|TRYLOCK caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455845: xfs_buf_read:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ|TRYLOCK caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455845: xfs_trans_add_item:   dev 252:18 trans ebe32657 flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455845: xfs_trans_read_buf:   dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455846: xfs_ag_resv_needed:   dev 252:18 agno 0x0 resv 0 freeblks 1310698 flcount 6 resv 0 ask 0 len 0
   kworker/u74:3-686   [003]   146.455847: xfs_group_get:        dev 252:18 agno 0x0 passive refs 11 active refs 2 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455847: xfs_buf_lock:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455847: xfs_buf_lock_done:    dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455848: xfs_buf_find:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455848: xfs_group_put:        dev 252:18 agno 0x0 passive refs 12 active refs 2 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455848: xfs_buf_get:          dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455849: xfs_buf_read:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455849: xfs_buf_hold:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.455850: xfs_trans_add_item:   dev 252:18 trans ebe32657 flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455850: xfs_trans_read_buf:   dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455850: xfs_trans_brelse:     dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455851: xfs_buf_item_relse:   dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_put+0x39
   kworker/u74:3-686   [003]   146.455851: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:3-686   [003]   146.455852: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:3-686   [003]   146.455852: xfs_buf_unlock:       dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.455853: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_alloc_fix_freelist+0x5d5
   kworker/u74:3-686   [003]   146.455853: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_alloc_fix_freelist+0x5d5
   kworker/u74:3-686   [003]   146.455854: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 11 active refs 2 caller xfs_cntbt_init_cursor+0x62
   kworker/u74:3-686   [003]   146.455855: xfs_group_get:        dev 252:18 agno 0x0 passive refs 12 active refs 2 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455855: xfs_buf_lock:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455855: xfs_buf_lock_done:    dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455856: xfs_buf_find:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455856: xfs_group_put:        dev 252:18 agno 0x0 passive refs 13 active refs 2 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455856: xfs_buf_get:          dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455857: xfs_buf_read:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455857: xfs_trans_add_item:   dev 252:18 trans ebe32657 flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455857: xfs_trans_read_buf:   dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455858: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 12 active refs 2 caller xfs_bnobt_init_cursor+0x62
   kworker/u74:3-686   [003]   146.455859: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 13 active refs 2 caller xfs_bnobt_init_cursor+0x62
   kworker/u74:3-686   [003]   146.455860: xfs_group_get:        dev 252:18 agno 0x0 passive refs 14 active refs 2 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455861: xfs_buf_lock:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455861: xfs_buf_lock_done:    dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455861: xfs_buf_find:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455862: xfs_group_put:        dev 252:18 agno 0x0 passive refs 15 active refs 2 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455862: xfs_buf_get:          dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455862: xfs_buf_read:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455863: xfs_trans_add_item:   dev 252:18 trans ebe32657 flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455863: xfs_trans_read_buf:   dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455864: xfs_trans_read_buf_recur: dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 1 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455865: xfs_alloc_cur_lookup: dev 252:18 agno 0x0 agbno 0x10 minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 0 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0xffffffff
   kworker/u74:3-686   [003]   146.455867: xfs_alloc_cur_check:  dev 252:18 bnobt agbno 0xd fsbcount 0x2 diff 0x2 new 1
   kworker/u74:3-686   [003]   146.455867: xfs_alloc_cur_left:   dev 252:18 agno 0x0 agbno 0x10 minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 1 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0xffffffff
   kworker/u74:3-686   [003]   146.455868: xfs_alloc_cur_check:  dev 252:18 bnobt agbno 0x18 fsbcount 0x13ffe8 diff 0x8 new 0
   kworker/u74:3-686   [003]   146.455870: xfs_trans_log_buf:    dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455871: xfs_trans_log_buf:    dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455872: xfs_trans_log_buf:    dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455873: xfs_trans_log_buf:    dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455874: xfs_trans_log_buf:    dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 1 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455875: xfs_agf:              dev 252:18 agno 0x0 flags LONGEST length 1310720 roots b 1 c 2 levels b 1 c 1 flfirst 1 fllast 6 flcount 6 freeblks 1310698 longest 1310696 caller xfs_alloc_fixup_longest+0xa3
   kworker/u74:3-686   [003]   146.455875: xfs_trans_log_buf:    dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455876: xfs_alloc_cur:        dev 252:18 agno 0x0 agbno 0xe minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 1 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0xffffffff
   kworker/u74:3-686   [003]   146.455876: xfs_trans_brelse:     dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455877: xfs_group_put:        dev 252:18 agno 0x0 passive refs 14 active refs 2 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.455877: xfs_trans_brelse:     dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 1 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455877: xfs_group_put:        dev 252:18 agno 0x0 passive refs 13 active refs 2 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.455878: xfs_trans_brelse:     dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455878: xfs_group_put:        dev 252:18 agno 0x0 passive refs 12 active refs 2 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.455879: xfs_agf:              dev 252:18 agno 0x0 flags FREEBLKS length 1310720 roots b 1 c 2 levels b 1 c 1 flfirst 1 fllast 6 flcount 6 freeblks 1310697 longest 1310696 caller xfs_alloc_update_counters+0x3e
   kworker/u74:3-686   [003]   146.455880: xfs_trans_log_buf:    dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455880: xfs_ag_resv_alloc_extent: dev 252:18 agno 0x0 resv 0 freeblks 1310697 flcount 6 resv 0 ask 0 len 1
   kworker/u74:3-686   [003]   146.455881: xfs_alloc_vextent_finish: dev 252:18 agno 0x0 agbno 0xe minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 1 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0x0
   kworker/u74:3-686   [003]   146.455881: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 11 active refs 2 caller xfs_alloc_vextent_finish+0x2d7
   kworker/u74:3-686   [003]   146.455883: xfs_iext_insert:      dev 252:18 ino 0x84 state  cur 0xffffa084c183ea30/0 fileoff 0x0 startblock 0xe fsbcount 0x1 flag 0 caller xfs_bmap_add_extent_hole_real+0x446
   kworker/u74:3-686   [003]   146.455884: xfs_rmap_defer:       dev 252:18 op map agno 0x0 agbno 0xe owner 0x84 data fileoff 0x0 fsbcount 0x1 state 0
   kworker/u74:3-686   [003]   146.455885: xfs_group_get:        dev 252:18 agno 0x0 passive refs 11 active refs 1 caller xfs_group_intent_get+0x12
   kworker/u74:3-686   [003]   146.455885: xfs_group_intent_hold: dev 252:18 agno 0x0 intents 0 caller xfs_rmap_defer_add+0x27
   kworker/u74:3-686   [003]   146.455886: xfs_defer_add_item:   dev 252:18 optype rmap intent (nil) item 0xffffa084d8f0b168 flags  committed 0 nr 1
   kworker/u74:3-686   [003]   146.455888: xfs_group_get:        dev 252:18 agno 0x0 passive refs 12 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455889: xfs_buf_init:         dev 252:18 daddr 0x70 bbcount 0x8 hold 1 pincount 0 lock 0 flags  bufops 0x0 caller xfs_buf_get_map+0x270
   kworker/u74:3-686   [003]   146.455891: xfs_buf_ioerror:      dev 252:18 daddr 0x70 bbcount 0x8 hold 1 pincount 0 lock 0 error 0 flags PAGES caller xfs_buf_get_map+0x7e5
   kworker/u74:3-686   [003]   146.455892: xfs_buf_get:          dev 252:18 daddr 0x70 bbcount 0x8 hold 1 pincount 0 lock 0 flags  caller xfs_trans_get_buf_map+0x13b
   kworker/u74:3-686   [003]   146.455892: xfs_buf_hold:         dev 252:18 daddr 0x70 bbcount 0x8 hold 1 pincount 0 lock 0 flags PAGES bufops 0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.455893: xfs_trans_add_item:   dev 252:18 trans ebe32657 flags 0x5 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455893: xfs_trans_get_buf:    dev 252:18 daddr 0x70 bbcount 0x8 hold 2 pincount 0 lock 0 flags PAGES recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455904: xfs_buf_item_ordered: dev 252:18 daddr 0x70 bbcount 0x8 hold 2 pincount 0 lock 0 flags DQUOTS|PAGES recur 0 refcount 1 bliflags ORDERED liflags 
   kworker/u74:3-686   [003]   146.455904: xfs_trans_bhold:      dev 252:18 daddr 0x70 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 1 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455905: xfs_defer_finish:     dev 252:18 tp 0xffffa084c4f804b0 caller xfs_trans_commit+0x4f
   kworker/u74:3-686   [003]   146.455905: xfs_defer_create_intent: dev 252:18 optype rmap intent (nil) flags  committed 0 nr 1
   kworker/u74:3-686   [003]   146.455906: xfs_trans_add_item:   dev 252:18 trans ebe32657 flags 0x5 caller xfs_defer_create_intent+0x58
   kworker/u74:3-686   [003]   146.455907: xfs_defer_trans_roll: dev 252:18 tp 0xffffa084c4f804b0 caller xfs_defer_finish_noroll+0x2c5
   kworker/u74:3-686   [003]   146.455907: xfs_trans_roll:       dev 252:18 trans ebe32657 flags 0x5 caller xfs_defer_trans_roll+0x58
   kworker/u74:3-686   [003]   146.455908: xfs_trans_dup:        dev 252:18 trans ebe32657 flags 0x5 caller xfs_trans_roll+0x51
   kworker/u74:3-686   [003]   146.455908: xfs_trans_commit:     dev 252:18 trans ebe32657 flags 0x25 caller xfs_trans_roll+0x61
   kworker/u74:3-686   [003]   146.455911: xfs_buf_item_size:    dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455911: xfs_buf_item_size:    dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455912: xfs_buf_item_size:    dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455913: xfs_buf_item_size_ordered: dev 252:18 daddr 0x70 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 1 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455915: xfs_write_extent:     dev 252:18 ino 0x84 state  cur 0xffffa084c183ea30/0 fileoff 0x0 startblock 0xe fsbcount 0x1 flag 0 caller xfs_inode_item_format_data_fork+0x31f
   kworker/u74:3-686   [003]   146.455916: xfs_buf_item_format:  dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455917: xfs_buf_item_format:  dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455918: xfs_buf_item_format:  dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455918: xfs_buf_item_pin:     dev 252:18 daddr 0x70 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 1 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455918: xfs_buf_hold:         dev 252:18 daddr 0x70 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_item_pin+0x32
   kworker/u74:3-686   [003]   146.455919: xfs_log_ticket_regrant: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 5 t_curr_res 199239 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 1045863 grant_write_bytes 1045863 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455920: xfs_log_ticket_regrant_sub: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 4 t_curr_res 202995 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 846624 grant_write_bytes 846624 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455920: xfs_trans_commit_items: dev 252:18 trans 0 flags 0x25 caller __xfs_trans_commit+0x11f
   kworker/u74:3-686   [003]   146.455921: xfs_buf_item_release: dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
   kworker/u74:3-686   [003]   146.455921: xfs_buf_unlock:       dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.455922: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455922: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455922: xfs_buf_item_release: dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
   kworker/u74:3-686   [003]   146.455923: xfs_buf_unlock:       dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.455923: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455923: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455924: xfs_buf_item_release: dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
   kworker/u74:3-686   [003]   146.455924: xfs_buf_unlock:       dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.455924: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455925: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455925: xfs_buf_item_release: dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags 
   kworker/u74:3-686   [003]   146.455926: xfs_trans_free:       dev 252:18 trans 0 flags 0x25 caller __xfs_trans_commit+0x127
   kworker/u74:3-686   [003]   146.455927: xfs_trans_add_item:   dev 252:18 trans ebe32658 flags 0x4 caller xfs_defer_restore_resources+0x3b
   kworker/u74:3-686   [003]   146.455927: xfs_trans_add_item:   dev 252:18 trans ebe32658 flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455927: xfs_trans_bjoin:      dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455928: xfs_buf_item_ordered: dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags DIRTY|ORDERED liflags 
   kworker/u74:3-686   [003]   146.455928: xfs_trans_bhold:      dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455929: xfs_defer_trans_roll: dev 252:18 tp 0xffffa084c4f81a40 caller xfs_defer_finish_noroll+0x304
   kworker/u74:3-686   [003]   146.455929: xfs_trans_roll:       dev 252:18 trans ebe32658 flags 0x5 caller xfs_defer_trans_roll+0x58
   kworker/u74:3-686   [003]   146.455929: xfs_trans_dup:        dev 252:18 trans ebe32658 flags 0x5 caller xfs_trans_roll+0x51
   kworker/u74:3-686   [003]   146.455930: xfs_trans_commit:     dev 252:18 trans ebe32658 flags 0x25 caller xfs_trans_roll+0x61
   kworker/u74:3-686   [003]   146.455931: xfs_buf_item_size_ordered: dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455932: xfs_write_extent:     dev 252:18 ino 0x84 state  cur 0xffffa084c183ea30/0 fileoff 0x0 startblock 0xe fsbcount 0x1 flag 0 caller xfs_inode_item_format_data_fork+0x31f
   kworker/u74:3-686   [003]   146.455933: xfs_log_ticket_regrant: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 4 t_curr_res 199327 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 846624 grant_write_bytes 846624 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455933: xfs_log_ticket_regrant_sub: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 3 t_curr_res 202995 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 647297 grant_write_bytes 647297 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455934: xfs_trans_commit_items: dev 252:18 trans 0 flags 0x25 caller __xfs_trans_commit+0x11f
   kworker/u74:3-686   [003]   146.455935: xfs_buf_item_release: dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags 
   kworker/u74:3-686   [003]   146.455935: xfs_trans_free:       dev 252:18 trans 0 flags 0x25 caller __xfs_trans_commit+0x127
   kworker/u74:3-686   [003]   146.455936: xfs_trans_add_item:   dev 252:18 trans ebe32659 flags 0x4 caller xfs_defer_restore_resources+0x3b
   kworker/u74:3-686   [003]   146.455936: xfs_trans_add_item:   dev 252:18 trans ebe32659 flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455936: xfs_trans_bjoin:      dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455937: xfs_buf_item_ordered: dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags DIRTY|ORDERED liflags 
   kworker/u74:3-686   [003]   146.455937: xfs_trans_bhold:      dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455938: xfs_defer_pending_finish: dev 252:18 optype rmap intent 0xffffa084d81b1d90 flags  committed 0 nr 1
   kworker/u74:3-686   [003]   146.455938: xfs_trans_add_item:   dev 252:18 trans ebe32659 flags 0x85 caller xfs_defer_finish_one+0x7a
   kworker/u74:3-686   [003]   146.455939: xfs_defer_finish_item: dev 252:18 optype rmap intent 0xffffa084d81b1d90 item 0xffffa084d8f0b168 flags  committed 1 nr 0
   kworker/u74:3-686   [003]   146.455939: xfs_rmap_deferred:    dev 252:18 op map agno 0x0 agbno 0xe owner 0x84 data fileoff 0x0 fsbcount 0x1 state 0
   kworker/u74:3-686   [003]   146.455940: xfs_alloc_read_agf:   dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.455940: xfs_read_agf:         dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.455941: xfs_group_get:        dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455941: xfs_buf_lock:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455942: xfs_buf_lock_done:    dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455942: xfs_buf_find:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455942: xfs_group_put:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455943: xfs_buf_get:          dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455943: xfs_buf_read:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455943: xfs_trans_add_item:   dev 252:18 trans ebe32659 flags 0x85 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455944: xfs_trans_read_buf:   dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455944: xfs_group_get:        dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455945: xfs_buf_lock:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455945: xfs_buf_lock_done:    dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455946: xfs_buf_find:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455946: xfs_group_put:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455946: xfs_buf_get:          dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455947: xfs_buf_read:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455948: xfs_buf_hold:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.455948: xfs_trans_add_item:   dev 252:18 trans ebe32659 flags 0x85 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455948: xfs_trans_read_buf:   dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455949: xfs_trans_brelse:     dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455949: xfs_buf_item_relse:   dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_put+0x39
   kworker/u74:3-686   [003]   146.455950: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:3-686   [003]   146.455950: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:3-686   [003]   146.455950: xfs_buf_unlock:       dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.455951: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_alloc_fix_freelist+0x5d5
   kworker/u74:3-686   [003]   146.455951: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_alloc_fix_freelist+0x5d5
   kworker/u74:3-686   [003]   146.455952: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_rmapbt_init_cursor+0x62
   kworker/u74:3-686   [003]   146.455952: xfs_rmap_map:         dev 252:18 agno 0x0 agbno 0xe fsbcount 0x1 owner 0x84 fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.455953: xfs_group_get:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455954: xfs_buf_lock:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455954: xfs_buf_lock_done:    dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455954: xfs_buf_find:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455955: xfs_group_put:        dev 252:18 agno 0x0 passive refs 15 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455955: xfs_buf_get:          dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455955: xfs_buf_read:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455956: xfs_trans_add_item:   dev 252:18 trans ebe32659 flags 0x85 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455956: xfs_trans_read_buf:   dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455957: xfs_rmap_lookup_le_range_result: dev 252:18 agno 0x0 agbno 0x7 fsbcount 0x6 owner 0xfffffffffffffffb fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.455958: xfs_rmap_find_right_neighbor_result: dev 252:18 agno 0x0 agbno 0xf fsbcount 0x1 owner 0x83 fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.455958: xfs_rmap_insert:      dev 252:18 agno 0x0 agbno 0xe fsbcount 0x1 owner 0x84 fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.455959: xfs_trans_log_buf:    dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455960: xfs_trans_log_buf:    dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455960: xfs_rmap_map_done:    dev 252:18 agno 0x0 agbno 0xe fsbcount 0x1 owner 0x84 fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.455961: xfs_group_intent_rele: dev 252:18 agno 0x0 intents 1 caller xfs_rmap_update_cancel_item+0x16
   kworker/u74:3-686   [003]   146.455961: xfs_group_put:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_rmap_update_cancel_item+0x16
   kworker/u74:3-686   [003]   146.455962: xfs_trans_brelse:     dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455962: xfs_group_put:        dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.455962: xfs_defer_finish_done: dev 252:18 tp 0xffffa084c4f804b0 caller xfs_trans_commit+0x4f
   kworker/u74:3-686   [003]   146.455963: xfs_trans_commit:     dev 252:18 trans ebe32659 flags 0x85 caller xfs_trans_commit+0x38
   kworker/u74:3-686   [003]   146.455964: xfs_buf_item_size_ordered: dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.455965: xfs_buf_item_size:    dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455965: xfs_cil_whiteout_mark: dev 252:18 lip 0xffffa084d81b1d90 lsn 0/0 type XFS_LI_RUI flags WHITEOUT
   kworker/u74:3-686   [003]   146.455966: xfs_buf_item_format:  dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.455967: xfs_log_ticket_ungrant: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 3 t_curr_res 199259 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 647297 grant_write_bytes 647297 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455967: xfs_log_ticket_ungrant_sub: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 2 t_curr_res 199259 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 647297 grant_write_bytes 647297 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455968: xfs_log_ticket_ungrant_exit: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 2 t_curr_res 199259 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 42048 grant_write_bytes 42048 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455968: xfs_trans_commit_items: dev 252:18 trans 0 flags 0x85 caller __xfs_trans_commit+0x11f
   kworker/u74:3-686   [003]   146.455969: xfs_buf_item_release: dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags 
   kworker/u74:3-686   [003]   146.455970: xfs_buf_item_release: dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455970: xfs_buf_unlock:       dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.455970: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455971: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455971: xfs_buf_item_release: dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
   kworker/u74:3-686   [003]   146.455972: xfs_buf_unlock:       dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.455972: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455972: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.455973: xfs_trans_free:       dev 252:18 trans 0 flags 0x85 caller __xfs_trans_commit+0x127
   kworker/u74:3-686   [003]   146.455973: xfs_iunlock:          dev 252:18 ino 0x84 flags ILOCK_EXCL caller xfs_dquot_disk_alloc+0x286
   kworker/u74:3-686   [003]   146.455974: xfs_buf_unlock:       dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_dqread+0x87
   kworker/u74:3-686   [003]   146.455974: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_dqread+0x8f
   kworker/u74:3-686   [003]   146.455974: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_dqread+0x8f
   kworker/u74:3-686   [003]   146.455975: xfs_dqget_miss:       dev 252:18 id 0x0 type GROUP flags  nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.455976: xfs_group_get:        dev 252:18 agno 0x0 passive refs 12 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455976: xfs_buf_lock:         dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455976: xfs_buf_lock_done:    dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455977: xfs_buf_find:         dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455977: xfs_group_put:        dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455977: xfs_buf_get:          dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455978: xfs_buf_read:         dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455978: xfs_buf_hold:         dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_attach_buf+0xf4
   kworker/u74:3-686   [003]   146.455979: xfs_buf_unlock:       dev 252:18 daddr 0x70 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.455979: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_attach_buf+0x10e
   kworker/u74:3-686   [003]   146.455979: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_attach_buf+0x10e
   kworker/u74:3-686   [003]   146.455980: xfs_dqadjust:         dev 252:18 id 0x0 type GROUP flags  nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.455980: xfs_dqput:            dev 252:18 id 0x0 type GROUP flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x1 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x1 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.455980: xfs_dqput_free:       dev 252:18 id 0x0 type GROUP flags DIRTY nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x1 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x1 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.455982: xfs_dqread:           dev 252:18 id 0x0 type PROJ flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.455982: xfs_ilock:            dev 252:18 ino 0x85 flags ILOCK_SHARED caller xfs_ilock_data_map_shared+0x1f
   kworker/u74:3-686   [003]   146.455983: xfs_iunlock:          dev 252:18 ino 0x85 flags ILOCK_SHARED caller xfs_dquot_disk_read+0xd1
   kworker/u74:3-686   [003]   146.455984: xfs_dqalloc:          dev 252:18 id 0x0 type PROJ flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.455985: xfs_log_reserve:      dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 5 t_curr_res 202995 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 42048 grant_write_bytes 42048 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455985: xfs_log_reserve_exit: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 5 t_curr_res 202995 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 1057023 grant_write_bytes 1057023 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.455985: xfs_trans_alloc:      dev 252:18 trans 6beca085 flags 0x4 caller xfs_dquot_disk_alloc+0xbe
   kworker/u74:3-686   [003]   146.455986: xfs_ilock:            dev 252:18 ino 0x85 flags ILOCK_EXCL caller xfs_dquot_disk_alloc+0xd5
   kworker/u74:3-686   [003]   146.455986: xfs_trans_add_item:   dev 252:18 trans 6beca085 flags 0x4 caller xfs_dquot_disk_alloc+0xe4
   kworker/u74:3-686   [003]   146.455987: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 12 active refs 1 caller xfs_bmap_btalloc+0x266
   kworker/u74:3-686   [003]   146.455988: xfs_ag_resv_needed:   dev 252:18 agno 0x0 resv 0 freeblks 1310697 flcount 6 resv 0 ask 0 len 0
   kworker/u74:3-686   [003]   146.455988: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 12 active refs 2 caller xfs_bmap_btalloc+0x5ee
   kworker/u74:3-686   [003]   146.455989: xfs_alloc_vextent_start_ag: dev 252:18 agno 0xffffffff agbno 0xffffffff minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 0 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0xffffffff
   kworker/u74:3-686   [003]   146.455989: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 12 active refs 1 caller xfs_alloc_vextent_iterate_ags.constprop.0+0x88
   kworker/u74:3-686   [003]   146.455990: xfs_ag_resv_needed:   dev 252:18 agno 0x0 resv 0 freeblks 1310697 flcount 6 resv 0 ask 0 len 0
   kworker/u74:3-686   [003]   146.455990: xfs_alloc_read_agf:   dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.455990: xfs_read_agf:         dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.455991: xfs_group_get:        dev 252:18 agno 0x0 passive refs 12 active refs 2 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455991: xfs_buf_trylock:      dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x1e
   kworker/u74:3-686   [003]   146.455992: xfs_buf_find:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ|TRYLOCK caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455992: xfs_group_put:        dev 252:18 agno 0x0 passive refs 13 active refs 2 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455992: xfs_buf_get:          dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ|TRYLOCK caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455992: xfs_buf_read:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ|TRYLOCK caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455993: xfs_trans_add_item:   dev 252:18 trans 6beca085 flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455993: xfs_trans_read_buf:   dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.455994: xfs_ag_resv_needed:   dev 252:18 agno 0x0 resv 0 freeblks 1310697 flcount 6 resv 0 ask 0 len 0
   kworker/u74:3-686   [003]   146.455994: xfs_group_get:        dev 252:18 agno 0x0 passive refs 12 active refs 2 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.455995: xfs_buf_lock:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455995: xfs_buf_lock_done:    dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.455995: xfs_buf_find:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455996: xfs_group_put:        dev 252:18 agno 0x0 passive refs 13 active refs 2 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.455996: xfs_buf_get:          dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.455996: xfs_buf_read:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.455997: xfs_buf_hold:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.455998: xfs_trans_add_item:   dev 252:18 trans 6beca085 flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.455998: xfs_trans_read_buf:   dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455999: xfs_trans_brelse:     dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.455999: xfs_buf_item_relse:   dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_put+0x39
   kworker/u74:3-686   [003]   146.455999: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:3-686   [003]   146.456000: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:3-686   [003]   146.456000: xfs_buf_unlock:       dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.456001: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_alloc_fix_freelist+0x5d5
   kworker/u74:3-686   [003]   146.456001: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_alloc_fix_freelist+0x5d5
   kworker/u74:3-686   [003]   146.456002: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 12 active refs 2 caller xfs_cntbt_init_cursor+0x62
   kworker/u74:3-686   [003]   146.456003: xfs_group_get:        dev 252:18 agno 0x0 passive refs 13 active refs 2 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.456003: xfs_buf_lock:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456003: xfs_buf_lock_done:    dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456004: xfs_buf_find:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456004: xfs_group_put:        dev 252:18 agno 0x0 passive refs 14 active refs 2 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.456004: xfs_buf_get:          dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456005: xfs_buf_read:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.456005: xfs_trans_add_item:   dev 252:18 trans 6beca085 flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.456005: xfs_trans_read_buf:   dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.456006: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 13 active refs 2 caller xfs_bnobt_init_cursor+0x62
   kworker/u74:3-686   [003]   146.456007: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 14 active refs 2 caller xfs_bnobt_init_cursor+0x62
   kworker/u74:3-686   [003]   146.456007: xfs_alloc_cur_check:  dev 252:18 cntbt agbno 0xd fsbcount 0x1 diff 0x3 new 1
   kworker/u74:3-686   [003]   146.456008: xfs_alloc_cur_check:  dev 252:18 cntbt agbno 0x18 fsbcount 0x13ffe8 diff 0x8 new 0
   kworker/u74:3-686   [003]   146.456009: xfs_alloc_near_first: dev 252:18 agno 0x0 agbno 0x10 minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 1 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0xffffffff
   kworker/u74:3-686   [003]   146.456010: xfs_group_get:        dev 252:18 agno 0x0 passive refs 15 active refs 2 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.456011: xfs_buf_lock:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456011: xfs_buf_lock_done:    dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456011: xfs_buf_find:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456012: xfs_group_put:        dev 252:18 agno 0x0 passive refs 16 active refs 2 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.456012: xfs_buf_get:          dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456012: xfs_buf_read:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.456013: xfs_trans_add_item:   dev 252:18 trans 6beca085 flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.456013: xfs_trans_read_buf:   dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.456014: xfs_trans_log_buf:    dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456014: xfs_trans_log_buf:    dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456015: xfs_trans_log_buf:    dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456016: xfs_trans_log_buf:    dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456016: xfs_agf:              dev 252:18 agno 0x0 flags LONGEST length 1310720 roots b 1 c 2 levels b 1 c 1 flfirst 1 fllast 6 flcount 6 freeblks 1310697 longest 1310696 caller xfs_alloc_fixup_longest+0xa3
   kworker/u74:3-686   [003]   146.456017: xfs_trans_log_buf:    dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456017: xfs_alloc_cur:        dev 252:18 agno 0x0 agbno 0xd minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 1 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0xffffffff
   kworker/u74:3-686   [003]   146.456018: xfs_trans_brelse:     dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456018: xfs_group_put:        dev 252:18 agno 0x0 passive refs 15 active refs 2 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.456018: xfs_trans_brelse:     dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456019: xfs_group_put:        dev 252:18 agno 0x0 passive refs 14 active refs 2 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.456019: xfs_group_put:        dev 252:18 agno 0x0 passive refs 13 active refs 2 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.456020: xfs_agf:              dev 252:18 agno 0x0 flags FREEBLKS length 1310720 roots b 1 c 2 levels b 1 c 1 flfirst 1 fllast 6 flcount 6 freeblks 1310696 longest 1310696 caller xfs_alloc_update_counters+0x3e
   kworker/u74:3-686   [003]   146.456020: xfs_trans_log_buf:    dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456021: xfs_ag_resv_alloc_extent: dev 252:18 agno 0x0 resv 0 freeblks 1310696 flcount 6 resv 0 ask 0 len 1
   kworker/u74:3-686   [003]   146.456021: xfs_alloc_vextent_finish: dev 252:18 agno 0x0 agbno 0xd minlen 1 maxlen 1 mod 0 prod 1 minleft 1 total 0 alignment 1 minalignslop 0 len 1 wasdel 0 wasfromfl 0 resv 0 datatype 0x0 highest_agno 0x0
   kworker/u74:3-686   [003]   146.456021: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 12 active refs 2 caller xfs_alloc_vextent_finish+0x2d7
   kworker/u74:3-686   [003]   146.456022: xfs_iext_insert:      dev 252:18 ino 0x85 state  cur 0xffffa084c183e9d0/0 fileoff 0x0 startblock 0xd fsbcount 0x1 flag 0 caller xfs_bmap_add_extent_hole_real+0x446
   kworker/u74:3-686   [003]   146.456023: xfs_rmap_defer:       dev 252:18 op map agno 0x0 agbno 0xd owner 0x85 data fileoff 0x0 fsbcount 0x1 state 0
   kworker/u74:3-686   [003]   146.456023: xfs_group_get:        dev 252:18 agno 0x0 passive refs 12 active refs 1 caller xfs_group_intent_get+0x12
   kworker/u74:3-686   [003]   146.456024: xfs_group_intent_hold: dev 252:18 agno 0x0 intents 0 caller xfs_rmap_defer_add+0x27
   kworker/u74:3-686   [003]   146.456024: xfs_defer_add_item:   dev 252:18 optype rmap intent (nil) item 0xffffa084d8f0b168 flags  committed 0 nr 1
   kworker/u74:3-686   [003]   146.456025: xfs_group_get:        dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.456026: xfs_buf_init:         dev 252:18 daddr 0x68 bbcount 0x8 hold 1 pincount 0 lock 0 flags  bufops 0x0 caller xfs_buf_get_map+0x270
   kworker/u74:3-686   [003]   146.456028: xfs_buf_ioerror:      dev 252:18 daddr 0x68 bbcount 0x8 hold 1 pincount 0 lock 0 error 0 flags PAGES caller xfs_buf_get_map+0x7e5
   kworker/u74:3-686   [003]   146.456028: xfs_buf_get:          dev 252:18 daddr 0x68 bbcount 0x8 hold 1 pincount 0 lock 0 flags  caller xfs_trans_get_buf_map+0x13b
   kworker/u74:3-686   [003]   146.456029: xfs_buf_hold:         dev 252:18 daddr 0x68 bbcount 0x8 hold 1 pincount 0 lock 0 flags PAGES bufops 0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.456029: xfs_trans_add_item:   dev 252:18 trans 6beca085 flags 0x5 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.456029: xfs_trans_get_buf:    dev 252:18 daddr 0x68 bbcount 0x8 hold 2 pincount 0 lock 0 flags PAGES recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.456040: xfs_buf_item_ordered: dev 252:18 daddr 0x68 bbcount 0x8 hold 2 pincount 0 lock 0 flags DQUOTS|PAGES recur 0 refcount 1 bliflags ORDERED liflags 
   kworker/u74:3-686   [003]   146.456041: xfs_trans_bhold:      dev 252:18 daddr 0x68 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 1 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.456041: xfs_defer_finish:     dev 252:18 tp 0xffffa084c4f804b0 caller xfs_trans_commit+0x4f
   kworker/u74:3-686   [003]   146.456042: xfs_defer_create_intent: dev 252:18 optype rmap intent (nil) flags  committed 0 nr 1
   kworker/u74:3-686   [003]   146.456042: xfs_trans_add_item:   dev 252:18 trans 6beca085 flags 0x5 caller xfs_defer_create_intent+0x58
   kworker/u74:3-686   [003]   146.456043: xfs_defer_trans_roll: dev 252:18 tp 0xffffa084c4f804b0 caller xfs_defer_finish_noroll+0x2c5
   kworker/u74:3-686   [003]   146.456043: xfs_trans_roll:       dev 252:18 trans 6beca085 flags 0x5 caller xfs_defer_trans_roll+0x58
   kworker/u74:3-686   [003]   146.456044: xfs_trans_dup:        dev 252:18 trans 6beca085 flags 0x5 caller xfs_trans_roll+0x51
   kworker/u74:3-686   [003]   146.456044: xfs_trans_commit:     dev 252:18 trans 6beca085 flags 0x25 caller xfs_trans_roll+0x61
   kworker/u74:3-686   [003]   146.456046: xfs_buf_item_size:    dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456047: xfs_buf_item_size:    dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456047: xfs_buf_item_size:    dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456048: xfs_buf_item_size_ordered: dev 252:18 daddr 0x68 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 1 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.456049: xfs_write_extent:     dev 252:18 ino 0x85 state  cur 0xffffa084c183e9d0/0 fileoff 0x0 startblock 0xd fsbcount 0x1 flag 0 caller xfs_inode_item_format_data_fork+0x31f
   kworker/u74:3-686   [003]   146.456050: xfs_buf_item_format:  dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456050: xfs_buf_item_format:  dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456051: xfs_buf_item_format:  dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456051: xfs_buf_item_pin:     dev 252:18 daddr 0x68 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 1 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.456052: xfs_buf_hold:         dev 252:18 daddr 0x68 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_item_pin+0x32
   kworker/u74:3-686   [003]   146.456052: xfs_log_ticket_regrant: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 5 t_curr_res 199239 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 1057023 grant_write_bytes 1057023 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.456053: xfs_log_ticket_regrant_sub: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 4 t_curr_res 202995 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 857784 grant_write_bytes 857784 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.456053: xfs_trans_commit_items: dev 252:18 trans 0 flags 0x25 caller __xfs_trans_commit+0x11f
   kworker/u74:3-686   [003]   146.456054: xfs_buf_item_release: dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
   kworker/u74:3-686   [003]   146.456054: xfs_buf_unlock:       dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.456054: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.456055: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.456055: xfs_buf_item_release: dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
   kworker/u74:3-686   [003]   146.456055: xfs_buf_unlock:       dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.456056: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.456056: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.456063: xfs_buf_item_release: dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
   kworker/u74:3-686   [003]   146.456064: xfs_buf_unlock:       dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.456064: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.456065: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.456065: xfs_buf_item_release: dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags 
   kworker/u74:3-686   [003]   146.456066: xfs_trans_free:       dev 252:18 trans 0 flags 0x25 caller __xfs_trans_commit+0x127
   kworker/u74:3-686   [003]   146.456066: xfs_trans_add_item:   dev 252:18 trans 6beca086 flags 0x4 caller xfs_defer_restore_resources+0x3b
   kworker/u74:3-686   [003]   146.456067: xfs_trans_add_item:   dev 252:18 trans 6beca086 flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.456067: xfs_trans_bjoin:      dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.456068: xfs_buf_item_ordered: dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags DIRTY|ORDERED liflags 
   kworker/u74:3-686   [003]   146.456068: xfs_trans_bhold:      dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.456068: xfs_defer_trans_roll: dev 252:18 tp 0xffffa084c4f81a40 caller xfs_defer_finish_noroll+0x304
   kworker/u74:3-686   [003]   146.456069: xfs_trans_roll:       dev 252:18 trans 6beca086 flags 0x5 caller xfs_defer_trans_roll+0x58
   kworker/u74:3-686   [003]   146.456069: xfs_trans_dup:        dev 252:18 trans 6beca086 flags 0x5 caller xfs_trans_roll+0x51
   kworker/u74:3-686   [003]   146.456070: xfs_trans_commit:     dev 252:18 trans 6beca086 flags 0x25 caller xfs_trans_roll+0x61
   kworker/u74:3-686   [003]   146.456071: xfs_buf_item_size_ordered: dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.456072: xfs_write_extent:     dev 252:18 ino 0x85 state  cur 0xffffa084c183e9d0/0 fileoff 0x0 startblock 0xd fsbcount 0x1 flag 0 caller xfs_inode_item_format_data_fork+0x31f
   kworker/u74:3-686   [003]   146.456073: xfs_log_ticket_regrant: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 4 t_curr_res 199327 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 857784 grant_write_bytes 857784 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.456073: xfs_log_ticket_regrant_sub: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 3 t_curr_res 202995 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 658457 grant_write_bytes 658457 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.456073: xfs_trans_commit_items: dev 252:18 trans 0 flags 0x25 caller __xfs_trans_commit+0x11f
   kworker/u74:3-686   [003]   146.456074: xfs_buf_item_release: dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags 
   kworker/u74:3-686   [003]   146.456074: xfs_trans_free:       dev 252:18 trans 0 flags 0x25 caller __xfs_trans_commit+0x127
   kworker/u74:3-686   [003]   146.456075: xfs_trans_add_item:   dev 252:18 trans 6beca087 flags 0x4 caller xfs_defer_restore_resources+0x3b
   kworker/u74:3-686   [003]   146.456075: xfs_trans_add_item:   dev 252:18 trans 6beca087 flags 0x4 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.456076: xfs_trans_bjoin:      dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.456076: xfs_buf_item_ordered: dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags DIRTY|ORDERED liflags 
   kworker/u74:3-686   [003]   146.456076: xfs_trans_bhold:      dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.456077: xfs_defer_pending_finish: dev 252:18 optype rmap intent 0xffffa084d81b22f0 flags  committed 0 nr 1
   kworker/u74:3-686   [003]   146.456077: xfs_trans_add_item:   dev 252:18 trans 6beca087 flags 0x85 caller xfs_defer_finish_one+0x7a
   kworker/u74:3-686   [003]   146.456078: xfs_defer_finish_item: dev 252:18 optype rmap intent 0xffffa084d81b22f0 item 0xffffa084d8f0b168 flags  committed 1 nr 0
   kworker/u74:3-686   [003]   146.456078: xfs_rmap_deferred:    dev 252:18 op map agno 0x0 agbno 0xd owner 0x85 data fileoff 0x0 fsbcount 0x1 state 0
   kworker/u74:3-686   [003]   146.456078: xfs_alloc_read_agf:   dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.456079: xfs_read_agf:         dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.456079: xfs_group_get:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.456080: xfs_buf_lock:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456080: xfs_buf_lock_done:    dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456080: xfs_buf_find:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456081: xfs_group_put:        dev 252:18 agno 0x0 passive refs 15 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.456081: xfs_buf_get:          dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456081: xfs_buf_read:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.456082: xfs_trans_add_item:   dev 252:18 trans 6beca087 flags 0x85 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.456082: xfs_trans_read_buf:   dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.456083: xfs_group_get:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.456083: xfs_buf_lock:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456084: xfs_buf_lock_done:    dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456084: xfs_buf_find:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456084: xfs_group_put:        dev 252:18 agno 0x0 passive refs 15 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.456085: xfs_buf_get:          dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456085: xfs_buf_read:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.456086: xfs_buf_hold:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_init+0x1d8
   kworker/u74:3-686   [003]   146.456086: xfs_trans_add_item:   dev 252:18 trans 6beca087 flags 0x85 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.456087: xfs_trans_read_buf:   dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.456087: xfs_trans_brelse:     dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags  liflags 
   kworker/u74:3-686   [003]   146.456087: xfs_buf_item_relse:   dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_put+0x39
   kworker/u74:3-686   [003]   146.456088: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:3-686   [003]   146.456088: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_buf_item_relse+0x88
   kworker/u74:3-686   [003]   146.456089: xfs_buf_unlock:       dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.456089: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_alloc_fix_freelist+0x5d5
   kworker/u74:3-686   [003]   146.456089: xfs_buf_rele:         dev 252:18 daddr 0x3 bbcount 0x1 hold 2 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agfl_buf_ops+0x0 caller xfs_alloc_fix_freelist+0x5d5
   kworker/u74:3-686   [003]   146.456090: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_rmapbt_init_cursor+0x62
   kworker/u74:3-686   [003]   146.456090: xfs_rmap_map:         dev 252:18 agno 0x0 agbno 0xd fsbcount 0x1 owner 0x85 fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.456091: xfs_group_get:        dev 252:18 agno 0x0 passive refs 15 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.456091: xfs_buf_lock:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456092: xfs_buf_lock_done:    dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456092: xfs_buf_find:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456092: xfs_group_put:        dev 252:18 agno 0x0 passive refs 16 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.456093: xfs_buf_get:          dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456093: xfs_buf_read:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.456093: xfs_trans_add_item:   dev 252:18 trans 6beca087 flags 0x85 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.456094: xfs_trans_read_buf:   dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.456095: xfs_rmap_lookup_le_range_result: dev 252:18 agno 0x0 agbno 0x7 fsbcount 0x6 owner 0xfffffffffffffffb fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.456095: xfs_rmap_find_right_neighbor_result: dev 252:18 agno 0x0 agbno 0xe fsbcount 0x1 owner 0x84 fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.456096: xfs_rmap_insert:      dev 252:18 agno 0x0 agbno 0xd fsbcount 0x1 owner 0x85 fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.456097: xfs_trans_log_buf:    dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456097: xfs_trans_log_buf:    dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456098: xfs_rmap_map_done:    dev 252:18 agno 0x0 agbno 0xd fsbcount 0x1 owner 0x85 fileoff 0x0 flags 0x0
   kworker/u74:3-686   [003]   146.456098: xfs_group_intent_rele: dev 252:18 agno 0x0 intents 1 caller xfs_rmap_update_cancel_item+0x16
   kworker/u74:3-686   [003]   146.456098: xfs_group_put:        dev 252:18 agno 0x0 passive refs 15 active refs 1 caller xfs_rmap_update_cancel_item+0x16
   kworker/u74:3-686   [003]   146.456099: xfs_trans_brelse:     dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456099: xfs_group_put:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.456100: xfs_defer_finish_done: dev 252:18 tp 0xffffa084c4f804b0 caller xfs_trans_commit+0x4f
   kworker/u74:3-686   [003]   146.456100: xfs_trans_commit:     dev 252:18 trans 6beca087 flags 0x85 caller xfs_trans_commit+0x38
   kworker/u74:3-686   [003]   146.456101: xfs_buf_item_size_ordered: dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags DIRTY
   kworker/u74:3-686   [003]   146.456102: xfs_buf_item_size:    dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456102: xfs_cil_whiteout_mark: dev 252:18 lip 0xffffa084d81b22f0 lsn 0/0 type XFS_LI_RUI flags WHITEOUT
   kworker/u74:3-686   [003]   146.456103: xfs_buf_item_format:  dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags DIRTY
   kworker/u74:3-686   [003]   146.456103: xfs_log_ticket_ungrant: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 3 t_curr_res 199387 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 658457 grant_write_bytes 658457 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.456104: xfs_log_ticket_ungrant_sub: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 2 t_curr_res 199387 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 658457 grant_write_bytes 658457 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.456104: xfs_log_ticket_ungrant_exit: dev 252:18 tic 0xffffa084d7ed3480 t_ocnt 5 t_cnt 2 t_curr_res 199387 t_unit_res 202995 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty tail space 0 grant_reserve_bytes 53080 grant_write_bytes 53080 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [003]   146.456105: xfs_trans_commit_items: dev 252:18 trans 0 flags 0x85 caller __xfs_trans_commit+0x11f
   kworker/u74:3-686   [003]   146.456105: xfs_buf_item_release: dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES recur 0 refcount 2 bliflags HOLD|DIRTY|LOGGED|ORDERED liflags 
   kworker/u74:3-686   [003]   146.456106: xfs_buf_item_release: dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.456106: xfs_buf_unlock:       dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.456106: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.456107: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.456107: xfs_buf_item_release: dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY|LOGGED liflags 
   kworker/u74:3-686   [003]   146.456108: xfs_buf_unlock:       dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_item_release+0xec
   kworker/u74:3-686   [003]   146.456108: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.456108: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xlog_cil_commit+0x666
   kworker/u74:3-686   [003]   146.456109: xfs_trans_free:       dev 252:18 trans 0 flags 0x85 caller __xfs_trans_commit+0x127
   kworker/u74:3-686   [003]   146.456109: xfs_iunlock:          dev 252:18 ino 0x85 flags ILOCK_EXCL caller xfs_dquot_disk_alloc+0x286
   kworker/u74:3-686   [003]   146.456110: xfs_buf_unlock:       dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_dqread+0x87
   kworker/u74:3-686   [003]   146.456110: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_dqread+0x8f
   kworker/u74:3-686   [003]   146.456110: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_dqread+0x8f
   kworker/u74:3-686   [003]   146.456111: xfs_dqget_miss:       dev 252:18 id 0x0 type PROJ flags  nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456111: xfs_group_get:        dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.456112: xfs_buf_lock:         dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456112: xfs_buf_lock_done:    dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456113: xfs_buf_find:         dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456113: xfs_group_put:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.456113: xfs_buf_get:          dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456113: xfs_buf_read:         dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.456114: xfs_buf_hold:         dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_attach_buf+0xf4
   kworker/u74:3-686   [003]   146.456115: xfs_buf_unlock:       dev 252:18 daddr 0x68 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.456115: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_attach_buf+0x10e
   kworker/u74:3-686   [003]   146.456115: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_attach_buf+0x10e
   kworker/u74:3-686   [003]   146.456116: xfs_dqadjust:         dev 252:18 id 0x0 type PROJ flags  nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x0 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x0 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456116: xfs_dqput:            dev 252:18 id 0x0 type PROJ flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x1 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x1 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456117: xfs_dqput_free:       dev 252:18 id 0x0 type PROJ flags DIRTY nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x1 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x1 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456118: xfs_irele:            dev 252:18 ino 0x80 count 2 pincount 0 caller xfs_qm_dqusage_adjust+0x130
   kworker/u74:3-686   [003]   146.456120: xfs_group_get:        dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_iget+0xd6
   kworker/u74:3-686   [003]   146.456121: xfs_iget_hit:         dev 252:18 ino 0x81 iflags 0x0
   kworker/u74:3-686   [003]   146.456122: xfs_group_put:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_iget+0x725
   kworker/u74:3-686   [003]   146.456122: xfs_ilock:            dev 252:18 ino 0x81 flags ILOCK_SHARED caller xfs_ilock_data_map_shared+0x1f
   kworker/u74:3-686   [003]   146.456123: xfs_iunlock:          dev 252:18 ino 0x81 flags ILOCK_SHARED caller xfs_qm_dqusage_adjust+0x1a4
   kworker/u74:3-686   [003]   146.456124: xfs_dqget_hit:        dev 252:18 id 0x0 type USER flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x1 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x1 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456125: xfs_dqadjust:         dev 252:18 id 0x0 type USER flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x1 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x1 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456125: xfs_dqput:            dev 252:18 id 0x0 type USER flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x2 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x2 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456125: xfs_dqput_free:       dev 252:18 id 0x0 type USER flags DIRTY nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x2 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x2 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456126: xfs_dqget_hit:        dev 252:18 id 0x0 type GROUP flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x1 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x1 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456126: xfs_dqadjust:         dev 252:18 id 0x0 type GROUP flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x1 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x1 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456127: xfs_dqput:            dev 252:18 id 0x0 type GROUP flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x2 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x2 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456127: xfs_dqput_free:       dev 252:18 id 0x0 type GROUP flags DIRTY nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x2 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x2 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456128: xfs_dqget_hit:        dev 252:18 id 0x0 type PROJ flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x1 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x1 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456128: xfs_dqadjust:         dev 252:18 id 0x0 type PROJ flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x1 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x1 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456128: xfs_dqput:            dev 252:18 id 0x0 type PROJ flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x2 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x2 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456129: xfs_dqput_free:       dev 252:18 id 0x0 type PROJ flags DIRTY nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x2 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x2 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456129: xfs_irele:            dev 252:18 ino 0x81 count 2 pincount 0 caller xfs_qm_dqusage_adjust+0x130
   kworker/u74:3-686   [003]   146.456130: xfs_group_get:        dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_iget+0xd6
   kworker/u74:3-686   [003]   146.456130: xfs_iget_hit:         dev 252:18 ino 0x82 iflags 0x0
   kworker/u74:3-686   [003]   146.456131: xfs_group_put:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_iget+0x725
   kworker/u74:3-686   [003]   146.456131: xfs_ilock:            dev 252:18 ino 0x82 flags ILOCK_SHARED caller xfs_ilock_data_map_shared+0x1f
   kworker/u74:3-686   [003]   146.456132: xfs_iunlock:          dev 252:18 ino 0x82 flags ILOCK_SHARED caller xfs_qm_dqusage_adjust+0x1a4
   kworker/u74:3-686   [003]   146.456132: xfs_dqget_hit:        dev 252:18 id 0x0 type USER flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x2 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x2 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456133: xfs_dqadjust:         dev 252:18 id 0x0 type USER flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x2 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x2 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456133: xfs_dqput:            dev 252:18 id 0x0 type USER flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456133: xfs_dqput_free:       dev 252:18 id 0x0 type USER flags DIRTY nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456134: xfs_dqget_hit:        dev 252:18 id 0x0 type GROUP flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x2 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x2 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456134: xfs_dqadjust:         dev 252:18 id 0x0 type GROUP flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x2 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x2 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456135: xfs_dqput:            dev 252:18 id 0x0 type GROUP flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456135: xfs_dqput_free:       dev 252:18 id 0x0 type GROUP flags DIRTY nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456135: xfs_dqget_hit:        dev 252:18 id 0x0 type PROJ flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x2 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x2 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456136: xfs_dqadjust:         dev 252:18 id 0x0 type PROJ flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x2 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x2 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456137: xfs_dqput:            dev 252:18 id 0x0 type PROJ flags DIRTY nrefs 1 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456137: xfs_dqput_free:       dev 252:18 id 0x0 type PROJ flags DIRTY nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
   kworker/u74:3-686   [003]   146.456138: xfs_irele:            dev 252:18 ino 0x82 count 2 pincount 0 caller xfs_qm_dqusage_adjust+0x130
   kworker/u74:3-686   [003]   146.456139: xfs_trans_alloc:      dev 252:18 trans 0 flags 0x20 caller xfs_trans_alloc_empty+0x43
   kworker/u74:3-686   [003]   146.456140: xfs_ialloc_read_agi:  dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.456140: xfs_read_agi:         dev 252:18 agno 0x0
   kworker/u74:3-686   [003]   146.456141: xfs_group_get:        dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.456141: xfs_buf_lock:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456142: xfs_buf_lock_done:    dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456142: xfs_buf_find:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456142: xfs_group_put:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.456143: xfs_buf_get:          dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456143: xfs_buf_read:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.456144: xfs_trans_add_item:   dev 252:18 trans 0 flags 0x20 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.456144: xfs_trans_read_buf:   dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.456145: xfs_group_hold:       dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_inobt_init_cursor+0x67
   kworker/u74:3-686   [003]   146.456146: xfs_group_get:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_buf_get_map+0x11a
   kworker/u74:3-686   [003]   146.456146: xfs_buf_lock:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456147: xfs_buf_lock_done:    dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_find_lock+0x6a
   kworker/u74:3-686   [003]   146.456147: xfs_buf_find:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456148: xfs_group_put:        dev 252:18 agno 0x0 passive refs 15 active refs 1 caller xfs_buf_get_map+0x6cc
   kworker/u74:3-686   [003]   146.456148: xfs_buf_get:          dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags READ caller xfs_buf_read_map+0x61
   kworker/u74:3-686   [003]   146.456148: xfs_buf_read:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags READ caller xfs_trans_read_buf_map+0x1be
   kworker/u74:3-686   [003]   146.456149: xfs_trans_add_item:   dev 252:18 trans 0 flags 0x20 caller _xfs_trans_bjoin+0x76
   kworker/u74:3-686   [003]   146.456149: xfs_trans_read_buf:   dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.456150: xfs_trans_brelse:     dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|PAGES recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.456150: xfs_buf_unlock:       dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.456151: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_btree_del_cursor+0x26
   kworker/u74:3-686   [003]   146.456151: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_btree_del_cursor+0x26
   kworker/u74:3-686   [003]   146.456151: xfs_group_put:        dev 252:18 agno 0x0 passive refs 14 active refs 1 caller xfs_btree_del_cursor+0x5f
   kworker/u74:3-686   [003]   146.456152: xfs_trans_brelse:     dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 2 bliflags DIRTY liflags 
   kworker/u74:3-686   [003]   146.456152: xfs_buf_unlock:       dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_trans_brelse+0xa5
   kworker/u74:3-686   [003]   146.456153: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_iwalk_ag+0xe4
   kworker/u74:3-686   [003]   146.456153: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 1 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_iwalk_ag+0xe4
   kworker/u74:3-686   [003]   146.456153: xfs_trans_cancel:     dev 252:18 trans 0 flags 0x20 caller xfs_iwalk_ag_work+0x7b
   kworker/u74:3-686   [003]   146.456154: xfs_trans_free_items: dev 252:18 trans 0 flags 0x20 caller xfs_trans_cancel+0x9d
   kworker/u74:3-686   [003]   146.456155: xfs_trans_free:       dev 252:18 trans 0 flags 0x20 caller xfs_iwalk_ag_work+0x7b
   kworker/u74:3-686   [003]   146.456155: xfs_group_put:        dev 252:18 agno 0x0 passive refs 13 active refs 1 caller xfs_iwalk_ag_work+0x4c
           mount-1504  [009]   146.456228: xfs_buf_trylock:      dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_use_attached_buf+0x22
           mount-1504  [009]   146.456229: xfs_buf_hold:         dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_use_attached_buf+0x2e
           mount-1504  [009]   146.456229: xfs_dqflush:          dev 252:18 id 0x0 type USER flags DIRTY nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.456231: xfs_dqflush_force:    dev 252:18 id 0x0 type USER flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.456232: xfs_log_force:        dev 252:18 lsn 0x0 caller xfs_qm_dqflush+0x272
           mount-1504  [009]   146.456232: xfs_log_force:        dev 252:18 lsn 0x1 caller xfs_log_force+0x99
   kworker/u74:3-686   [009]   146.456245: xfs_cil_whiteout_skip: dev 252:18 lip 0xffffa084d81b4080 lsn 0/0 type XFS_LI_RUI flags WHITEOUT
   kworker/u74:3-686   [009]   146.456245: xfs_cil_whiteout_skip: dev 252:18 lip 0xffffa084d81b1d90 lsn 0/0 type XFS_LI_RUI flags WHITEOUT
   kworker/u74:3-686   [009]   146.456246: xfs_cil_whiteout_skip: dev 252:18 lip 0xffffa084d81b22f0 lsn 0/0 type XFS_LI_RUI flags WHITEOUT
   kworker/u74:3-686   [009]   146.456248: xlog_iclog_get_space: dev 252:18 state XLOG_STATE_ACTIVE refcnt 1 offset 0 lsn 0x0 flags  caller xlog_write+0x7a
   kworker/u74:3-686   [009]   146.456251: xlog_iclog_release:   dev 252:18 state XLOG_STATE_ACTIVE refcnt 1 offset 2812 lsn 0x100000000 flags XLOG_ICL_NEED_FLUSH caller xlog_write+0x20a
   kworker/u74:3-686   [009]   146.456251: xlog_iclog_get_space: dev 252:18 state XLOG_STATE_ACTIVE refcnt 1 offset 2812 lsn 0x100000000 flags XLOG_ICL_NEED_FLUSH caller xlog_write+0x7a
   kworker/u74:3-686   [009]   146.456251: xlog_iclog_release:   dev 252:18 state XLOG_STATE_ACTIVE refcnt 2 offset 2824 lsn 0x100000000 flags XLOG_ICL_NEED_FLUSH caller xlog_write+0x20a
   kworker/u74:3-686   [009]   146.456252: xlog_iclog_release:   dev 252:18 state XLOG_STATE_ACTIVE refcnt 1 offset 2824 lsn 0x100000000 flags XLOG_ICL_NEED_FLUSH|XLOG_ICL_NEED_FUA caller xlog_cil_push_work+0x78d
   kworker/u74:3-686   [009]   146.456252: xfs_cil_whiteout_unpin: dev 252:18 lip 0xffffa084d81b22f0 lsn 0/0 type XFS_LI_RUI flags WHITEOUT
   kworker/u74:3-686   [009]   146.456254: xfs_cil_whiteout_unpin: dev 252:18 lip 0xffffa084d81b1d90 lsn 0/0 type XFS_LI_RUI flags WHITEOUT
   kworker/u74:3-686   [009]   146.456254: xfs_cil_whiteout_unpin: dev 252:18 lip 0xffffa084d81b4080 lsn 0/0 type XFS_LI_RUI flags WHITEOUT
   kworker/u74:3-686   [009]   146.456255: xfs_log_ticket_ungrant: dev 252:18 tic 0xffffa084d7e93900 t_ocnt 1 t_cnt 1 t_curr_res 49744 t_unit_res 2100 t_flags  reserveq empty writeq empty tail space 0 grant_reserve_bytes 53080 grant_write_bytes 53080 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [009]   146.456255: xfs_log_ticket_ungrant_sub: dev 252:18 tic 0xffffa084d7e93900 t_ocnt 1 t_cnt 0 t_curr_res 49744 t_unit_res 2100 t_flags  reserveq empty writeq empty tail space 0 grant_reserve_bytes 53080 grant_write_bytes 53080 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
   kworker/u74:3-686   [009]   146.456255: xfs_log_ticket_ungrant_exit: dev 252:18 tic 0xffffa084d7e93900 t_ocnt 1 t_cnt 0 t_curr_res 49744 t_unit_res 2100 t_flags  reserveq empty writeq empty tail space 0 grant_reserve_bytes 3336 grant_write_bytes 3336 curr_cycle 1 curr_block 0 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.456260: xlog_iclog_force:     dev 252:18 state XLOG_STATE_ACTIVE refcnt 0 offset 2824 lsn 0x100000000 flags XLOG_ICL_NEED_FLUSH|XLOG_ICL_NEED_FUA caller xfs_qm_dqflush+0x272
           mount-1504  [009]   146.456260: xlog_iclog_switch:    dev 252:18 state XLOG_STATE_ACTIVE refcnt 1 offset 2824 lsn 0x100000000 flags XLOG_ICL_NEED_FLUSH|XLOG_ICL_NEED_FUA caller xfs_log_force+0x246
           mount-1504  [009]   146.456261: xlog_iclog_release:   dev 252:18 state XLOG_STATE_WANT_SYNC refcnt 1 offset 2824 lsn 0x100000000 flags XLOG_ICL_NEED_FLUSH|XLOG_ICL_NEED_FUA caller xfs_log_force+0x1ea
           mount-1504  [009]   146.456261: xlog_iclog_syncing:   dev 252:18 state XLOG_STATE_SYNCING refcnt 0 offset 2824 lsn 0x100000000 flags XLOG_ICL_NEED_FLUSH|XLOG_ICL_NEED_FUA caller xfs_log_force+0x1ea
           mount-1504  [009]   146.456262: xlog_iclog_sync:      dev 252:18 state XLOG_STATE_SYNCING refcnt 0 offset 2824 lsn 0x100000000 flags XLOG_ICL_NEED_FLUSH|XLOG_ICL_NEED_FUA caller xlog_state_release_iclog+0xfd
           mount-1504  [009]   146.456265: xlog_iclog_write:     dev 252:18 state XLOG_STATE_SYNCING refcnt 0 offset 2824 lsn 0x100000000 flags XLOG_ICL_NEED_FLUSH|XLOG_ICL_NEED_FUA caller xlog_state_release_iclog+0xfd
           mount-1504  [009]   146.456272: xfs_dqflush_done:     dev 252:18 id 0x0 type USER flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.456272: xfs_buf_delwri_queue: dev 252:18 daddr 0x78 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_flush_one+0x155
           mount-1504  [009]   146.456272: xfs_buf_unlock:       dev 252:18 daddr 0x78 bbcount 0x8 hold 5 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_flush_one+0xcd
           mount-1504  [009]   146.456273: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 5 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_flush_one+0xd5
           mount-1504  [009]   146.456273: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 5 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_flush_one+0xd5
           mount-1504  [009]   146.456274: xfs_buf_trylock:      dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_use_attached_buf+0x22
           mount-1504  [009]   146.456274: xfs_buf_hold:         dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_use_attached_buf+0x2e
           mount-1504  [009]   146.456275: xfs_dqflush:          dev 252:18 id 0x0 type GROUP flags DIRTY nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.456275: xfs_dqflush_force:    dev 252:18 id 0x0 type GROUP flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.456276: xfs_log_force:        dev 252:18 lsn 0x0 caller xfs_qm_dqflush+0x272
           mount-1504  [009]   146.456276: xfs_log_force:        dev 252:18 lsn 0x2 caller xfs_log_force+0x99
           mount-1504  [009]   146.456277: xlog_iclog_force:     dev 252:18 state XLOG_STATE_ACTIVE refcnt 0 offset 0 lsn 0x0 flags  caller xfs_qm_dqflush+0x272
           mount-1504  [009]   146.456277: xfs_dqflush_done:     dev 252:18 id 0x0 type GROUP flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.456277: xfs_buf_delwri_queue: dev 252:18 daddr 0x70 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_flush_one+0x155
           mount-1504  [009]   146.456277: xfs_buf_unlock:       dev 252:18 daddr 0x70 bbcount 0x8 hold 5 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_flush_one+0xcd
           mount-1504  [009]   146.456277: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 5 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_flush_one+0xd5
           mount-1504  [009]   146.456277: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 5 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_flush_one+0xd5
           mount-1504  [009]   146.456278: xfs_buf_trylock:      dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_use_attached_buf+0x22
           mount-1504  [009]   146.456278: xfs_buf_hold:         dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_dquot_use_attached_buf+0x2e
           mount-1504  [009]   146.456278: xfs_dqflush:          dev 252:18 id 0x0 type PROJ flags DIRTY nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.456279: xfs_dqflush_force:    dev 252:18 id 0x0 type PROJ flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.456279: xfs_log_force:        dev 252:18 lsn 0x0 caller xfs_qm_dqflush+0x272
           mount-1504  [009]   146.456279: xfs_log_force:        dev 252:18 lsn 0x2 caller xfs_log_force+0x99
           mount-1504  [009]   146.456279: xlog_iclog_force:     dev 252:18 state XLOG_STATE_ACTIVE refcnt 0 offset 0 lsn 0x0 flags  caller xfs_qm_dqflush+0x272
           mount-1504  [009]   146.456280: xfs_dqflush_done:     dev 252:18 id 0x0 type PROJ flags  nrefs 0 res_bc 0x0 res_rtbc 0x0 res_ic 0x3 bcnt 0x0 bhardlimit 0x0 bsoftlimit 0x0 rtbcnt 0x0 rtbhardlimit 0x0 rtbsoftlimit 0x0 icnt 0x3 ihardlimit 0x0 isoftlimit 0x0]
           mount-1504  [009]   146.456280: xfs_buf_delwri_queue: dev 252:18 daddr 0x68 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_flush_one+0x155
           mount-1504  [009]   146.456280: xfs_buf_unlock:       dev 252:18 daddr 0x68 bbcount 0x8 hold 5 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_flush_one+0xcd
           mount-1504  [009]   146.456280: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 5 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_flush_one+0xd5
           mount-1504  [009]   146.456280: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 5 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_qm_flush_one+0xd5
           mount-1504  [009]   146.456280: xfs_buf_lock:         dev 252:18 daddr 0x68 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x96
           mount-1504  [009]   146.456281: xfs_buf_lock_done:    dev 252:18 daddr 0x68 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x96
           mount-1504  [009]   146.456281: xfs_buf_delwri_split: dev 252:18 daddr 0x68 bbcount 0x8 hold 4 pincount 1 lock 0 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x34
           mount-1504  [009]   146.456281: xfs_buf_submit:       dev 252:18 daddr 0x68 bbcount 0x8 hold 4 pincount 1 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x113
           mount-1504  [009]   146.456281: xfs_buf_hold:         dev 252:18 daddr 0x68 bbcount 0x8 hold 4 pincount 1 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller __xfs_buf_submit+0x4c
    kworker/9:1H-456   [009]   146.457001: xlog_iclog_sync_done: dev 252:18 state XLOG_STATE_SYNCING refcnt 0 offset 2824 lsn 0x100000000 flags  caller xlog_ioend_work+0x60
    kworker/9:1H-456   [009]   146.457002: xlog_iclog_callback:  dev 252:18 state XLOG_STATE_DONE_SYNC refcnt 0 offset 2824 lsn 0x100000000 flags  caller xlog_ioend_work+0x60
    kworker/9:1H-456   [009]   146.457002: xlog_iclog_callbacks_start: dev 252:18 state XLOG_STATE_CALLBACK refcnt 0 offset 2824 lsn 0x100000000 flags  caller xlog_ioend_work+0x60
    kworker/9:1H-456   [009]   146.457003: xfs_log_assign_tail_lsn: dev 252:18 new tail lsn 1/0, old lsn 1/0, head lsn 1/0
    kworker/9:1H-456   [009]   146.457004: xfs_buf_item_committed: dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 1 lock 1 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY liflags 
    kworker/9:1H-456   [009]   146.457004: xfs_buf_item_committed: dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 1 lock 1 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY liflags 
    kworker/9:1H-456   [009]   146.457005: xfs_buf_item_committed: dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY liflags 
    kworker/9:1H-456   [009]   146.457005: xfs_buf_item_committed: dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 1 lock 1 flags NO_IOACCT|DONE|PAGES recur 0 refcount 1 bliflags DIRTY liflags 
    kworker/9:1H-456   [009]   146.457005: xfs_buf_item_committed: dev 252:18 daddr 0x78 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q recur 0 refcount 1 bliflags DIRTY liflags 
    kworker/9:1H-456   [009]   146.457006: xfs_buf_item_committed: dev 252:18 daddr 0x70 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q recur 0 refcount 1 bliflags DIRTY liflags 
    kworker/9:1H-456   [009]   146.457006: xfs_buf_item_committed: dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 1 lock 1 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY liflags 
    kworker/9:1H-456   [009]   146.457006: xfs_buf_item_committed: dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 1 lock 1 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY liflags 
    kworker/9:1H-456   [009]   146.457006: xfs_buf_item_committed: dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 1 lock 1 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY liflags 
    kworker/9:1H-456   [009]   146.457007: xfs_buf_item_committed: dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 1 lock 1 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY liflags 
    kworker/9:1H-456   [009]   146.457007: xfs_buf_item_committed: dev 252:18 daddr 0x68 bbcount 0x8 hold 5 pincount 1 lock 0 flags WRITE|DONE|DQUOTS|PAGES recur 0 refcount 1 bliflags DIRTY liflags 
    kworker/9:1H-456   [009]   146.457008: xfs_ail_insert:       dev 252:18 lip 0xffffa084ea2b5870 old lsn 0/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/9:1H-456   [009]   146.457008: xfs_ail_insert:       dev 252:18 lip 0xffffa084ea2b4aa0 old lsn 0/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/9:1H-456   [009]   146.457008: xfs_ail_insert:       dev 252:18 lip 0xffffa084ea2b4000 old lsn 0/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/9:1H-456   [009]   146.457008: xfs_ail_insert:       dev 252:18 lip 0xffffa084ea2b5dc0 old lsn 0/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/9:1H-456   [009]   146.457008: xfs_ail_insert:       dev 252:18 lip 0xffffa084deb41b58 old lsn 0/0 new lsn 1/0 type XFS_LI_INODE flags IN_AIL
    kworker/9:1H-456   [009]   146.457009: xfs_ail_insert:       dev 252:18 lip 0xffffa084d7cee880 old lsn 0/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/9:1H-456   [009]   146.457009: xfs_ail_insert:       dev 252:18 lip 0xffffa084deb400c8 old lsn 0/0 new lsn 1/0 type XFS_LI_INODE flags IN_AIL
    kworker/9:1H-456   [009]   146.457009: xfs_ail_insert:       dev 252:18 lip 0xffffa084d7cef540 old lsn 0/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/9:1H-456   [009]   146.457009: xfs_ail_insert:       dev 252:18 lip 0xffffa084d7cee550 old lsn 0/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/9:1H-456   [009]   146.457009: xfs_ail_insert:       dev 252:18 lip 0xffffa084d7cefed0 old lsn 0/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/9:1H-456   [009]   146.457010: xfs_ail_insert:       dev 252:18 lip 0xffffa084d7cefa90 old lsn 0/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/9:1H-456   [009]   146.457010: xfs_ail_insert:       dev 252:18 lip 0xffffa084deb40898 old lsn 0/0 new lsn 1/0 type XFS_LI_INODE flags IN_AIL
    kworker/9:1H-456   [009]   146.457010: xfs_ail_insert:       dev 252:18 lip 0xffffa084d7cef760 old lsn 0/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/9:1H-456   [009]   146.457010: xfs_ail_insert:       dev 252:18 lip 0xffffa084d7cef320 old lsn 0/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/9:1H-456   [009]   146.457013: xfs_log_assign_tail_lsn: dev 252:18 new tail lsn 1/0, old lsn 1/0, head lsn 1/0
    kworker/9:1H-456   [009]   146.457014: xfs_buf_item_unpin:   dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 1 lock 1 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY liflags IN_AIL
    kworker/9:1H-456   [009]   146.457014: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457014: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457015: xfs_buf_item_unpin:   dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 1 lock 1 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY liflags IN_AIL
    kworker/9:1H-456   [009]   146.457015: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457015: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457015: xfs_buf_item_unpin:   dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 1 lock 1 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY liflags IN_AIL
    kworker/9:1H-456   [009]   146.457016: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457016: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 1 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457016: xfs_buf_item_unpin:   dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 1 lock 1 flags NO_IOACCT|DONE|PAGES recur 0 refcount 1 bliflags DIRTY liflags IN_AIL
    kworker/9:1H-456   [009]   146.457016: xfs_buf_rele:         dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 1 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457017: xfs_inode_unpin:      dev 252:18 ino 0x83 count 1 pincount 1 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457017: xfs_buf_item_unpin:   dev 252:18 daddr 0x78 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q recur 0 refcount 1 bliflags DIRTY liflags IN_AIL
    kworker/9:1H-456   [009]   146.457018: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 4 pincount 0 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457018: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 4 pincount 0 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457018: xfs_inode_unpin:      dev 252:18 ino 0x84 count 1 pincount 1 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457018: xfs_buf_item_unpin:   dev 252:18 daddr 0x70 bbcount 0x8 hold 4 pincount 1 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q recur 0 refcount 1 bliflags DIRTY liflags IN_AIL
    kworker/9:1H-456   [009]   146.457018: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 4 pincount 0 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457018: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 4 pincount 0 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457019: xfs_buf_item_unpin:   dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 1 lock 1 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY liflags IN_AIL
    kworker/9:1H-456   [009]   146.457019: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457019: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 1 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457019: xfs_buf_item_unpin:   dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 1 lock 1 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY liflags IN_AIL
    kworker/9:1H-456   [009]   146.457019: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457020: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457020: xfs_buf_item_unpin:   dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 1 lock 1 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY liflags IN_AIL
    kworker/9:1H-456   [009]   146.457020: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457020: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457020: xfs_inode_unpin:      dev 252:18 ino 0x85 count 1 pincount 1 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457020: xfs_buf_item_unpin:   dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 1 lock 1 flags DONE|PAGES recur 0 refcount 1 bliflags DIRTY liflags IN_AIL
    kworker/9:1H-456   [009]   146.457021: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457021: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457021: xfs_buf_item_unpin:   dev 252:18 daddr 0x68 bbcount 0x8 hold 5 pincount 1 lock 0 flags WRITE|DONE|DQUOTS|PAGES recur 0 refcount 1 bliflags DIRTY liflags IN_AIL
    kworker/9:1H-456   [009]   146.457023: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 5 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457023: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 5 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xlog_cil_ail_insert+0x3dc
    kworker/9:1H-456   [009]   146.457026: xlog_iclog_callbacks_done: dev 252:18 state XLOG_STATE_CALLBACK refcnt 0 offset 2824 lsn 0x100000000 flags  caller xlog_ioend_work+0x60
    kworker/9:1H-456   [009]   146.457026: xlog_iclog_clean:     dev 252:18 state XLOG_STATE_CALLBACK refcnt 0 offset 2824 lsn 0x100000000 flags  caller xlog_state_do_callback+0x163
    kworker/9:1H-456   [009]   146.457027: xlog_iclog_activate:  dev 252:18 state XLOG_STATE_DIRTY refcnt 0 offset 2824 lsn 0x100000000 flags  caller xlog_state_do_callback+0x163
           mount-1504  [009]   146.457033: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 4 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.457033: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 4 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.457033: xfs_buf_lock:         dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 0 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x96
           mount-1504  [009]   146.457033: xfs_buf_lock_done:    dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x96
           mount-1504  [009]   146.457033: xfs_buf_delwri_split: dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x34
           mount-1504  [009]   146.457033: xfs_buf_submit:       dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x113
           mount-1504  [009]   146.457033: xfs_buf_hold:         dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.457035: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 4 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.457035: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 4 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.457035: xfs_buf_lock:         dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 0 lock 1 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x96
           mount-1504  [009]   146.457035: xfs_buf_lock_done:    dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x96
           mount-1504  [009]   146.457036: xfs_buf_delwri_split: dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|DQUOTS|PAGES|DELWRI_Q bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x34
           mount-1504  [009]   146.457036: xfs_buf_submit:       dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x113
           mount-1504  [009]   146.457036: xfs_buf_hold:         dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller __xfs_buf_submit+0x4c
           mount-1504  [009]   146.457037: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 4 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.457037: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 4 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller __xfs_buf_submit+0xad
           mount-1504  [009]   146.457040: xfs_buf_iowait:       dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x80
     kworker/9:4-691   [009]   146.457186: xfs_buf_iodone:       dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller process_one_work+0x176
     kworker/9:4-691   [009]   146.457187: xfs_ail_delete:       dev 252:18 lip 0xffffa084d7cef320 old lsn 1/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
     kworker/9:4-691   [009]   146.457188: xfs_buf_item_relse:   dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_ioend+0x79
     kworker/9:4-691   [009]   146.457188: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_item_relse+0x88
     kworker/9:4-691   [009]   146.457188: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_item_relse+0x88
     kworker/9:4-691   [009]   146.457189: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_dquot_iodone+0x136
     kworker/9:4-691   [009]   146.457189: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_dquot_iodone+0x136
     kworker/9:4-691   [009]   146.457192: xfs_buf_iodone:       dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller process_one_work+0x176
     kworker/9:4-691   [009]   146.457192: xfs_ail_delete:       dev 252:18 lip 0xffffa084d7cef540 old lsn 1/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
     kworker/9:4-691   [009]   146.457192: xfs_buf_item_relse:   dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_ioend+0x79
     kworker/9:4-691   [009]   146.457192: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_item_relse+0x88
     kworker/9:4-691   [009]   146.457192: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_item_relse+0x88
     kworker/9:4-691   [009]   146.457193: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_dquot_iodone+0x136
     kworker/9:4-691   [009]   146.457193: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_dquot_iodone+0x136
     kworker/9:4-691   [009]   146.457194: xfs_buf_iodone:       dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller process_one_work+0x176
     kworker/9:4-691   [009]   146.457194: xfs_ail_delete:       dev 252:18 lip 0xffffa084d7cee880 old lsn 1/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
     kworker/9:4-691   [009]   146.457194: xfs_buf_item_relse:   dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_ioend+0x79
     kworker/9:4-691   [009]   146.457194: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_item_relse+0x88
     kworker/9:4-691   [009]   146.457194: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_item_relse+0x88
     kworker/9:4-691   [009]   146.457194: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_dquot_iodone+0x136
     kworker/9:4-691   [009]   146.457194: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_dquot_iodone+0x136
           mount-1504  [009]   146.457196: xfs_buf_iowait_done:  dev 252:18 daddr 0x68 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x80
           mount-1504  [009]   146.457196: xfs_buf_unlock:       dev 252:18 daddr 0x68 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x8a
           mount-1504  [009]   146.457197: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x92
           mount-1504  [009]   146.457197: xfs_buf_rele:         dev 252:18 daddr 0x68 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x92
           mount-1504  [009]   146.457197: xfs_buf_iowait:       dev 252:18 daddr 0x70 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x80
           mount-1504  [009]   146.457197: xfs_buf_iowait_done:  dev 252:18 daddr 0x70 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x80
           mount-1504  [009]   146.457198: xfs_buf_unlock:       dev 252:18 daddr 0x70 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x8a
           mount-1504  [009]   146.457198: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x92
           mount-1504  [009]   146.457198: xfs_buf_rele:         dev 252:18 daddr 0x70 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x92
           mount-1504  [009]   146.457198: xfs_buf_iowait:       dev 252:18 daddr 0x78 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x80
           mount-1504  [009]   146.457198: xfs_buf_iowait_done:  dev 252:18 daddr 0x78 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x80
           mount-1504  [009]   146.457198: xfs_buf_unlock:       dev 252:18 daddr 0x78 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x8a
           mount-1504  [009]   146.457198: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x92
           mount-1504  [009]   146.457198: xfs_buf_rele:         dev 252:18 daddr 0x78 bbcount 0x8 hold 1 pincount 0 lock 1 flags DONE|DQUOTS|PAGES bufops xfs_dquot_buf_ops+0x0 caller xfs_buf_delwri_submit+0x92
           mount-1504  [009]   146.457544: xfs_fs_mark_healthy:  dev 252:18 flags 0x10
           mount-1504  [009]   146.457545: xfs_log_reserve:      dev 252:18 tic 0xffffa084d7e93900 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags  reserveq empty writeq empty tail space 0 grant_reserve_bytes 18446744072634764800 grant_write_bytes 18446744072634764800 curr_cycle 1 curr_block 7 tail_cycle 1 tail_block 0
           mount-1504  [009]   146.457548: xfs_log_grant_sleep:  dev 252:18 tic 0xffffa084d7e93900 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags  reserveq active writeq empty tail space 0 grant_reserve_bytes 18446744072634764800 grant_write_bytes 18446744072634764800 curr_cycle 1 curr_block 7 tail_cycle 1 tail_block 0
    xfsaild/vdb2-1512  [011]   146.457579: xfs_buf_trylock:      dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_push+0x42
    xfsaild/vdb2-1512  [011]   146.457581: xfs_buf_item_push:    dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 0 bliflags DIRTY liflags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457582: xfs_buf_delwri_queue: dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_push+0x77
    xfsaild/vdb2-1512  [011]   146.457583: xfs_buf_unlock:       dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 1 flags DONE|KMEM|DELWRI_Q bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_push+0x8a
    xfsaild/vdb2-1512  [011]   146.457584: xfs_ail_push:         dev 252:18 lip 0xffffa084ea2b5870 lsn 1/0 type XFS_LI_BUF flags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457585: xfs_buf_trylock:      dev 252:18 daddr 0x20 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_item_push+0x42
    xfsaild/vdb2-1512  [011]   146.457585: xfs_buf_item_push:    dev 252:18 daddr 0x20 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 0 bliflags DIRTY liflags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457585: xfs_buf_delwri_queue: dev 252:18 daddr 0x20 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_item_push+0x77
    xfsaild/vdb2-1512  [011]   146.457586: xfs_buf_unlock:       dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES|DELWRI_Q bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_item_push+0x8a
    xfsaild/vdb2-1512  [011]   146.457586: xfs_ail_push:         dev 252:18 lip 0xffffa084ea2b4aa0 lsn 1/0 type XFS_LI_BUF flags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457587: xfs_buf_trylock:      dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_push+0x42
    xfsaild/vdb2-1512  [011]   146.457587: xfs_buf_item_push:    dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 0 bliflags DIRTY liflags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457588: xfs_buf_delwri_queue: dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_push+0x77
    xfsaild/vdb2-1512  [011]   146.457588: xfs_buf_unlock:       dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 1 flags DONE|PAGES|DELWRI_Q bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_push+0x8a
    xfsaild/vdb2-1512  [011]   146.457588: xfs_ail_push:         dev 252:18 lip 0xffffa084ea2b4000 lsn 1/0 type XFS_LI_BUF flags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457589: xfs_buf_trylock:      dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_buf_item_push+0x42
    xfsaild/vdb2-1512  [011]   146.457589: xfs_buf_item_push:    dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES recur 0 refcount 0 bliflags DIRTY liflags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457589: xfs_buf_delwri_queue: dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_buf_item_push+0x77
    xfsaild/vdb2-1512  [011]   146.457590: xfs_buf_unlock:       dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 1 flags NO_IOACCT|DONE|PAGES|DELWRI_Q bufops xfs_sb_buf_ops+0x0 caller xfs_buf_item_push+0x8a
    xfsaild/vdb2-1512  [011]   146.457590: xfs_ail_push:         dev 252:18 lip 0xffffa084ea2b5dc0 lsn 1/0 type XFS_LI_BUF flags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457591: xfs_buf_trylock:      dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_push+0x97
    xfsaild/vdb2-1512  [011]   146.457592: xfs_buf_hold:         dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_push+0xb4
    xfsaild/vdb2-1512  [011]   146.457593: xfs_ilock_nowait:     dev 252:18 ino 0x83 flags ILOCK_SHARED caller xfs_iflush_cluster+0xb2
    xfsaild/vdb2-1512  [011]   146.457598: xfs_write_extent:     dev 252:18 ino 0x83 state  cur 0xffffa084c183e5b0/0 fileoff 0x0 startblock 0xf fsbcount 0x1 flag 0 caller xfs_iflush_cluster+0x2c9
    xfsaild/vdb2-1512  [011]   146.457601: xfs_iunlock:          dev 252:18 ino 0x83 flags ILOCK_SHARED caller xfs_iflush_cluster+0x347
    xfsaild/vdb2-1512  [011]   146.457602: xfs_ilock_nowait:     dev 252:18 ino 0x84 flags ILOCK_SHARED caller xfs_iflush_cluster+0xb2
    xfsaild/vdb2-1512  [011]   146.457603: xfs_write_extent:     dev 252:18 ino 0x84 state  cur 0xffffa084c183ea30/0 fileoff 0x0 startblock 0xe fsbcount 0x1 flag 0 caller xfs_iflush_cluster+0x2c9
    xfsaild/vdb2-1512  [011]   146.457604: xfs_iunlock:          dev 252:18 ino 0x84 flags ILOCK_SHARED caller xfs_iflush_cluster+0x347
    xfsaild/vdb2-1512  [011]   146.457605: xfs_ilock_nowait:     dev 252:18 ino 0x85 flags ILOCK_SHARED caller xfs_iflush_cluster+0xb2
    xfsaild/vdb2-1512  [011]   146.457606: xfs_write_extent:     dev 252:18 ino 0x85 state  cur 0xffffa084c183e9d0/0 fileoff 0x0 startblock 0xd fsbcount 0x1 flag 0 caller xfs_iflush_cluster+0x2c9
    xfsaild/vdb2-1512  [011]   146.457607: xfs_iunlock:          dev 252:18 ino 0x85 flags ILOCK_SHARED caller xfs_iflush_cluster+0x347
    xfsaild/vdb2-1512  [011]   146.457608: xfs_buf_delwri_queue: dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_push+0x10b
    xfsaild/vdb2-1512  [011]   146.457608: xfs_buf_unlock:       dev 252:18 daddr 0x80 bbcount 0x20 hold 6 pincount 0 lock 1 flags DONE|INODES|PAGES|DELWRI_Q bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_push+0x11e
    xfsaild/vdb2-1512  [011]   146.457608: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 6 pincount 0 lock 1 flags DONE|INODES|PAGES|DELWRI_Q bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_push+0x126
    xfsaild/vdb2-1512  [011]   146.457609: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 6 pincount 0 lock 1 flags DONE|INODES|PAGES|DELWRI_Q bufops xfs_inode_buf_ops+0x0 caller xfs_inode_item_push+0x126
    xfsaild/vdb2-1512  [011]   146.457609: xfs_ail_push:         dev 252:18 lip 0xffffa084deb41b58 lsn 1/0 type XFS_LI_INODE flags IN_AIL|FLUSHING
    xfsaild/vdb2-1512  [011]   146.457610: xfs_buf_trylock:      dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_push+0x42
    xfsaild/vdb2-1512  [011]   146.457610: xfs_buf_item_push:    dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 0 bliflags DIRTY liflags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457611: xfs_buf_delwri_queue: dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 0 flags DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_push+0x77
    xfsaild/vdb2-1512  [011]   146.457611: xfs_buf_unlock:       dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 1 flags DONE|KMEM|DELWRI_Q bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_push+0x8a
    xfsaild/vdb2-1512  [011]   146.457611: xfs_ail_push:         dev 252:18 lip 0xffffa084d7cee550 lsn 1/0 type XFS_LI_BUF flags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457612: xfs_buf_trylock:      dev 252:18 daddr 0x10 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_item_push+0x42
    xfsaild/vdb2-1512  [011]   146.457612: xfs_buf_item_push:    dev 252:18 daddr 0x10 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 0 bliflags DIRTY liflags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457613: xfs_buf_delwri_queue: dev 252:18 daddr 0x10 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_item_push+0x77
    xfsaild/vdb2-1512  [011]   146.457613: xfs_buf_unlock:       dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES|DELWRI_Q bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_item_push+0x8a
    xfsaild/vdb2-1512  [011]   146.457614: xfs_ail_push:         dev 252:18 lip 0xffffa084d7cefed0 lsn 1/0 type XFS_LI_BUF flags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457614: xfs_buf_trylock:      dev 252:18 daddr 0x8 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_item_push+0x42
    xfsaild/vdb2-1512  [011]   146.457614: xfs_buf_item_push:    dev 252:18 daddr 0x8 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 0 bliflags DIRTY liflags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457615: xfs_buf_delwri_queue: dev 252:18 daddr 0x8 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_item_push+0x77
    xfsaild/vdb2-1512  [011]   146.457615: xfs_buf_unlock:       dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES|DELWRI_Q bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_item_push+0x8a
    xfsaild/vdb2-1512  [011]   146.457616: xfs_ail_push:         dev 252:18 lip 0xffffa084d7cefa90 lsn 1/0 type XFS_LI_BUF flags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457616: xfs_buf_trylock:      dev 252:18 daddr 0x28 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_item_push+0x42
    xfsaild/vdb2-1512  [011]   146.457616: xfs_buf_item_push:    dev 252:18 daddr 0x28 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES recur 0 refcount 0 bliflags DIRTY liflags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457617: xfs_buf_delwri_queue: dev 252:18 daddr 0x28 bbcount 0x8 hold 1 pincount 0 lock 0 flags DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_item_push+0x77
    xfsaild/vdb2-1512  [011]   146.457617: xfs_buf_unlock:       dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES|DELWRI_Q bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_item_push+0x8a
    xfsaild/vdb2-1512  [011]   146.457618: xfs_ail_push:         dev 252:18 lip 0xffffa084d7cef760 lsn 1/0 type XFS_LI_BUF flags IN_AIL
    xfsaild/vdb2-1512  [011]   146.457620: xfs_buf_trylock:      dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES|DELWRI_Q bufops xfs_sb_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1c1
    xfsaild/vdb2-1512  [011]   146.457621: xfs_buf_delwri_split: dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags NO_IOACCT|DONE|PAGES|DELWRI_Q bufops xfs_sb_buf_ops+0x0 caller xfsaild+0x300
    xfsaild/vdb2-1512  [011]   146.457622: xfs_buf_submit:       dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|NO_IOACCT|ASYNC|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1a0
    xfsaild/vdb2-1512  [011]   146.457622: xfs_buf_hold:         dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|NO_IOACCT|ASYNC|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_buf_submit+0x4c
    xfsaild/vdb2-1512  [011]   146.457626: xfs_group_grab:       dev 252:18 agno 0x0 passive refs 12 active refs 1 caller xfs_verify_icount+0x40
    xfsaild/vdb2-1512  [011]   146.457627: xfs_group_rele:       dev 252:18 agno 0x0 passive refs 12 active refs 2 caller xfs_group_next_range+0x2d
    xfsaild/vdb2-1512  [011]   146.457627: xfs_group_grab:       dev 252:18 agno 0x1 passive refs 3 active refs 1 caller xfs_verify_icount+0x40
    xfsaild/vdb2-1512  [011]   146.457628: xfs_group_rele:       dev 252:18 agno 0x1 passive refs 3 active refs 2 caller xfs_group_next_range+0x2d
    xfsaild/vdb2-1512  [011]   146.457628: xfs_group_grab:       dev 252:18 agno 0x2 passive refs 3 active refs 1 caller xfs_verify_icount+0x40
    xfsaild/vdb2-1512  [011]   146.457629: xfs_group_rele:       dev 252:18 agno 0x2 passive refs 3 active refs 2 caller xfs_group_next_range+0x2d
    xfsaild/vdb2-1512  [011]   146.457642: xfs_group_grab:       dev 252:18 agno 0x3 passive refs 3 active refs 1 caller xfs_verify_icount+0x40
    xfsaild/vdb2-1512  [011]   146.457643: xfs_group_rele:       dev 252:18 agno 0x3 passive refs 3 active refs 2 caller xfs_group_next_range+0x2d
    xfsaild/vdb2-1512  [011]   146.457656: xfs_buf_rele:         dev 252:18 daddr 0x0 bbcount 0x1 hold 4 pincount 0 lock 0 flags WRITE|NO_IOACCT|ASYNC|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457657: xfs_buf_trylock:      dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM|DELWRI_Q bufops xfs_agf_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1c1
    xfsaild/vdb2-1512  [011]   146.457658: xfs_buf_delwri_split: dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM|DELWRI_Q bufops xfs_agf_buf_ops+0x0 caller xfsaild+0x300
    xfsaild/vdb2-1512  [011]   146.457658: xfs_buf_submit:       dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1a0
    xfsaild/vdb2-1512  [011]   146.457659: xfs_buf_hold:         dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0x4c
    xfsaild/vdb2-1512  [011]   146.457666: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457667: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 4 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457667: xfs_buf_trylock:      dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM|DELWRI_Q bufops xfs_agi_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1c1
    xfsaild/vdb2-1512  [011]   146.457668: xfs_buf_delwri_split: dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags DONE|KMEM|DELWRI_Q bufops xfs_agi_buf_ops+0x0 caller xfsaild+0x300
    xfsaild/vdb2-1512  [011]   146.457668: xfs_buf_submit:       dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1a0
    xfsaild/vdb2-1512  [011]   146.457669: xfs_buf_hold:         dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0x4c
    xfsaild/vdb2-1512  [011]   146.457673: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457674: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 4 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457675: xfs_buf_trylock:      dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES|DELWRI_Q bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1c1
    xfsaild/vdb2-1512  [011]   146.457675: xfs_buf_delwri_split: dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES|DELWRI_Q bufops xfs_bnobt_buf_ops+0x0 caller xfsaild+0x300
    xfsaild/vdb2-1512  [011]   146.457676: xfs_buf_submit:       dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1a0
    xfsaild/vdb2-1512  [011]   146.457676: xfs_buf_hold:         dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
    xfsaild/vdb2-1512  [011]   146.457689: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457690: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457691: xfs_buf_trylock:      dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES|DELWRI_Q bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1c1
    xfsaild/vdb2-1512  [011]   146.457691: xfs_buf_delwri_split: dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES|DELWRI_Q bufops xfs_cntbt_buf_ops+0x0 caller xfsaild+0x300
    xfsaild/vdb2-1512  [011]   146.457692: xfs_buf_submit:       dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1a0
    xfsaild/vdb2-1512  [011]   146.457693: xfs_buf_hold:         dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
    xfsaild/vdb2-1512  [011]   146.457705: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457705: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457706: xfs_buf_trylock:      dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|PAGES|DELWRI_Q bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1c1
    xfsaild/vdb2-1512  [011]   146.457707: xfs_buf_delwri_split: dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags DONE|PAGES|DELWRI_Q bufops xfs_inobt_buf_ops+0x0 caller xfsaild+0x300
    xfsaild/vdb2-1512  [011]   146.457707: xfs_buf_submit:       dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1a0
    xfsaild/vdb2-1512  [011]   146.457708: xfs_buf_hold:         dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
    xfsaild/vdb2-1512  [011]   146.457720: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457720: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 4 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457721: xfs_buf_trylock:      dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES|DELWRI_Q bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1c1
    xfsaild/vdb2-1512  [011]   146.457722: xfs_buf_delwri_split: dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES|DELWRI_Q bufops xfs_finobt_buf_ops+0x0 caller xfsaild+0x300
    xfsaild/vdb2-1512  [011]   146.457722: xfs_buf_submit:       dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1a0
    xfsaild/vdb2-1512  [011]   146.457723: xfs_buf_hold:         dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
    xfsaild/vdb2-1512  [011]   146.457735: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457735: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457736: xfs_buf_trylock:      dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES|DELWRI_Q bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1c1
    xfsaild/vdb2-1512  [011]   146.457737: xfs_buf_delwri_split: dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags DONE|PAGES|DELWRI_Q bufops xfs_rmapbt_buf_ops+0x0 caller xfsaild+0x300
    xfsaild/vdb2-1512  [011]   146.457737: xfs_buf_submit:       dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1a0
    xfsaild/vdb2-1512  [011]   146.457738: xfs_buf_hold:         dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller __xfs_buf_submit+0x4c
    xfsaild/vdb2-1512  [011]   146.457768: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457768: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457769: xfs_buf_trylock:      dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags DONE|INODES|PAGES|DELWRI_Q bufops xfs_inode_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1c1
    xfsaild/vdb2-1512  [011]   146.457770: xfs_buf_delwri_split: dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags DONE|INODES|PAGES|DELWRI_Q bufops xfs_inode_buf_ops+0x0 caller xfsaild+0x300
    xfsaild/vdb2-1512  [011]   146.457770: xfs_buf_submit:       dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags WRITE|ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_delwri_submit_buffers+0x1a0
    xfsaild/vdb2-1512  [011]   146.457771: xfs_buf_hold:         dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags WRITE|ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller __xfs_buf_submit+0x4c
    xfsaild/vdb2-1512  [011]   146.457777: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 6 pincount 0 lock 0 flags WRITE|ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller __xfs_buf_submit+0xad
    xfsaild/vdb2-1512  [011]   146.457778: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 6 pincount 0 lock 0 flags WRITE|ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller __xfs_buf_submit+0xad
    kworker/11:3-1065  [011]   146.457970: xfs_buf_iodone:       dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457971: xfs_ail_delete:       dev 252:18 lip 0xffffa084d7cefa90 old lsn 1/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/11:3-1065  [011]   146.457972: xfs_buf_item_relse:   dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_ioend+0x79
    kworker/11:3-1065  [011]   146.457973: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.457973: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.457975: xfs_buf_unlock:       dev 252:18 daddr 0x8 bbcount 0x8 hold 1 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller xfs_buf_ioend+0xad
    kworker/11:3-1065  [011]   146.457976: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 1 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457976: xfs_buf_rele:         dev 252:18 daddr 0x8 bbcount 0x8 hold 1 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_bnobt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457978: xfs_buf_iodone:       dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457979: xfs_ail_delete:       dev 252:18 lip 0xffffa084d7cefed0 old lsn 1/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/11:3-1065  [011]   146.457980: xfs_buf_item_relse:   dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_ioend+0x79
    kworker/11:3-1065  [011]   146.457980: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.457981: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.457982: xfs_buf_unlock:       dev 252:18 daddr 0x10 bbcount 0x8 hold 1 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller xfs_buf_ioend+0xad
    kworker/11:3-1065  [011]   146.457982: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 1 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457982: xfs_buf_rele:         dev 252:18 daddr 0x10 bbcount 0x8 hold 1 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_cntbt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457983: xfs_buf_iodone:       dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457984: xfs_ail_delete:       dev 252:18 lip 0xffffa084ea2b4000 old lsn 1/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/11:3-1065  [011]   146.457984: xfs_buf_item_relse:   dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_ioend+0x79
    kworker/11:3-1065  [011]   146.457985: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.457985: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.457986: xfs_buf_unlock:       dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller xfs_buf_ioend+0xad
    kworker/11:3-1065  [011]   146.457986: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457987: xfs_buf_rele:         dev 252:18 daddr 0x18 bbcount 0x8 hold 2 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_inobt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457987: xfs_buf_iodone:       dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457988: xfs_ail_delete:       dev 252:18 lip 0xffffa084ea2b4aa0 old lsn 1/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/11:3-1065  [011]   146.457988: xfs_buf_item_relse:   dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_ioend+0x79
    kworker/11:3-1065  [011]   146.457989: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.457989: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.457990: xfs_buf_unlock:       dev 252:18 daddr 0x20 bbcount 0x8 hold 1 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller xfs_buf_ioend+0xad
    kworker/11:3-1065  [011]   146.457990: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 1 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457991: xfs_buf_rele:         dev 252:18 daddr 0x20 bbcount 0x8 hold 1 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_finobt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457992: xfs_buf_iodone:       dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457992: xfs_ail_delete:       dev 252:18 lip 0xffffa084d7cef760 old lsn 1/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/11:3-1065  [011]   146.457992: xfs_buf_item_relse:   dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_ioend+0x79
    kworker/11:3-1065  [011]   146.457993: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.457993: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.457994: xfs_buf_unlock:       dev 252:18 daddr 0x28 bbcount 0x8 hold 1 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller xfs_buf_ioend+0xad
    kworker/11:3-1065  [011]   146.457994: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 1 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457994: xfs_buf_rele:         dev 252:18 daddr 0x28 bbcount 0x8 hold 1 pincount 0 lock 1 flags ASYNC|DONE|PAGES bufops xfs_rmapbt_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457996: xfs_buf_iodone:       dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|NO_IOACCT|ASYNC|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457996: xfs_ail_delete:       dev 252:18 lip 0xffffa084ea2b5dc0 old lsn 1/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/11:3-1065  [011]   146.457997: xfs_buf_item_relse:   dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|NO_IOACCT|ASYNC|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_buf_ioend+0x79
    kworker/11:3-1065  [011]   146.457997: xfs_buf_rele:         dev 252:18 daddr 0x0 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|NO_IOACCT|ASYNC|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.457998: xfs_buf_unlock:       dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 1 flags NO_IOACCT|ASYNC|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller xfs_buf_ioend+0xad
    kworker/11:3-1065  [011]   146.457999: xfs_buf_rele:         dev 252:18 daddr 0x0 bbcount 0x1 hold 2 pincount 0 lock 1 flags NO_IOACCT|ASYNC|DONE|PAGES bufops xfs_sb_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.457999: xfs_buf_iodone:       dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.458000: xfs_ail_delete:       dev 252:18 lip 0xffffa084d7cee550 old lsn 1/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/11:3-1065  [011]   146.458000: xfs_buf_item_relse:   dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_ioend+0x79
    kworker/11:3-1065  [011]   146.458001: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.458001: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.458002: xfs_buf_unlock:       dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags ASYNC|DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller xfs_buf_ioend+0xad
    kworker/11:3-1065  [011]   146.458002: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags ASYNC|DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.458002: xfs_buf_rele:         dev 252:18 daddr 0x1 bbcount 0x1 hold 2 pincount 0 lock 1 flags ASYNC|DONE|KMEM bufops xfs_agf_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.458003: xfs_buf_iodone:       dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.458003: xfs_ail_delete:       dev 252:18 lip 0xffffa084ea2b5870 old lsn 1/0 new lsn 1/0 type XFS_LI_BUF flags IN_AIL
    kworker/11:3-1065  [011]   146.458004: xfs_buf_item_relse:   dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_ioend+0x79
    kworker/11:3-1065  [011]   146.458004: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.458004: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_item_relse+0x88
    kworker/11:3-1065  [011]   146.458005: xfs_buf_unlock:       dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 1 flags ASYNC|DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller xfs_buf_ioend+0xad
    kworker/11:3-1065  [011]   146.458006: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 1 flags ASYNC|DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.458006: xfs_buf_rele:         dev 252:18 daddr 0x2 bbcount 0x1 hold 2 pincount 0 lock 1 flags ASYNC|DONE|KMEM bufops xfs_agi_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.458007: xfs_buf_iodone:       dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags WRITE|ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.458008: xfs_ail_delete:       dev 252:18 lip 0xffffa084deb41b58 old lsn 1/0 new lsn 1/0 type XFS_LI_INODE flags IN_AIL|FLUSHING
    kworker/11:3-1065  [011]   146.458008: xfs_ail_delete:       dev 252:18 lip 0xffffa084deb400c8 old lsn 1/0 new lsn 1/0 type XFS_LI_INODE flags IN_AIL|FLUSHING
    kworker/11:3-1065  [011]   146.458009: xfs_ail_delete:       dev 252:18 lip 0xffffa084deb40898 old lsn 1/0 new lsn 1/0 type XFS_LI_INODE flags IN_AIL|FLUSHING
    kworker/11:3-1065  [011]   146.458010: xfs_log_assign_tail_lsn: dev 252:18 new tail lsn 1/0, old lsn 1/0, head lsn 1/0
    kworker/11:3-1065  [011]   146.458011: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags WRITE|ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_inode_iodone+0x356
    kworker/11:3-1065  [011]   146.458012: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 5 pincount 0 lock 0 flags WRITE|ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_inode_iodone+0x356
    kworker/11:3-1065  [011]   146.458012: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags WRITE|ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_inode_iodone+0x356
    kworker/11:3-1065  [011]   146.458013: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 4 pincount 0 lock 0 flags WRITE|ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_inode_iodone+0x356
    kworker/11:3-1065  [011]   146.458014: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_inode_iodone+0x356
    kworker/11:3-1065  [011]   146.458014: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_inode_iodone+0x356
    kworker/11:3-1065  [011]   146.458015: xfs_buf_unlock:       dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 1 flags ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller xfs_buf_ioend+0xad
    kworker/11:3-1065  [011]   146.458015: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 1 flags ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller process_one_work+0x176
    kworker/11:3-1065  [011]   146.458015: xfs_buf_rele:         dev 252:18 daddr 0x80 bbcount 0x20 hold 2 pincount 0 lock 1 flags ASYNC|DONE|INODES|PAGES bufops xfs_inode_buf_ops+0x0 caller process_one_work+0x176

--mey5jkbmjx4f3grm--
