Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0AF975c030748 for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 09:09:07 -0600
Message-ID: <a4423d670901100709v1e7ce0bfs167547c5001787ac@mail.gmail.com>
Date: Sat, 10 Jan 2009 18:09:05 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
In-Reply-To: <20090110143924.GA25900@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <20090109044121.GA31280@orion> <20090109053858.GP9448@disturbed>
	<a4423d670901091353s7ff12207gcb38eb093d77d401@mail.gmail.com>
	<a4423d670901091418j5c7fdfb2oeba2f4640f8e29d0@mail.gmail.com>
	<a4423d670901091511y68a53808rfaab8148526224c6@mail.gmail.com>
	<a4423d670901100419s2ae106bexac1a538caf654153@mail.gmail.com>
	<20090110143924.GA25900@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-masters@oss.sgi.com, kernel-testers@vger.kernel.org, xfs@oss.sgi.com

2009/1/10 Christoph Hellwig <hch@infradead.org>:
> On Sat, Jan 10, 2009 at 03:19:00PM +0300, Alexander Beregalov wrote:
>> It is hard to bisect it,
>> These are last good and bad commits:
>> good: [854929f05831d3a290a802815ee955b96c740c61] [XFS] add new btree statistics
>> bad: [7f7c39ccb6045cf1fd5e7684a484c445291b44d4] [XFS] make btree tracing generic
>
> That would be odd as 7f7c39ccb6045cf1fd5e7684a484c445291b44d4 only
> changes the tracing code which currently isn't enabled.  Or we
> get some sort of miscompilation due slightly different noop
> macros.
I meant the first bad commit is between these two commits. All of them
fail to compile as is,
I added xfs_btree_trace.h manually to compile it, I got different bugs
on these commits,
but I am not sure if they are really different. Like this:

Filesystem "sdb1": XFS internal error xfs_btree_check_lblock at line
84 of file fs/xfs/xfs_btree.c.  Caller 0xc0247322
Pid: 247, comm: pdflush Not tainted 2.6.28-rc2-00219-g3cc7524 #3
Call Trace:
 [<c025d8d2>] ? xfs_cmn_err+0x32/0x60
 [<c025d94e>] xfs_error_report+0x4e/0x50
 [<c0247322>] ? xfs_btree_check_block+0x32/0x40
 [<c02471ad>] xfs_btree_check_lblock+0x4d/0x190
 [<c0247322>] ? xfs_btree_check_block+0x32/0x40
 [<c0283d5d>] ? xfs_trans_read_buf+0x46d/0x530
 [<c0247322>] xfs_btree_check_block+0x32/0x40
 [<c0247504>] xfs_btree_read_buf_block+0xe4/0x100
 [<c024979f>] xfs_btree_rshift+0xcf/0x540
 [<c025d9eb>] ? xfs_error_test+0x1b/0xc0
 [<c025d9eb>] ? xfs_error_test+0x1b/0xc0
 [<c024b652>] xfs_btree_make_block_unfull+0x32/0x140
 [<c0244d62>] ? xfs_bmbt_recs_inorder+0x32/0x70
 [<c024bd9e>] xfs_btree_insrec+0x63e/0x6c0
 [<c024be89>] xfs_btree_insert+0x69/0x190
 [<c023eaad>] xfs_bmap_add_extent_delay_real+0x142d/0x1700
 [<c0180cfc>] ? slab_pad_check+0x3c/0x120
 [<c022dc79>] ? xfs_alloc_vextent+0x2e9/0x760
 [<c01806bd>] ? check_object+0x13d/0x200
 [<c023fa56>] xfs_bmap_add_extent+0x626/0x670
 [<c0244b2c>] ? xfs_bmbt_init_cursor+0x2c/0x100
 [<c024349b>] xfs_bmapi+0xfcb/0x1c90
 [<c014b7a5>] ? __lock_acquire+0x2c5/0x1000
 [<c014b7a5>] ? __lock_acquire+0x2c5/0x1000
 [<c014b7a5>] ? __lock_acquire+0x2c5/0x1000
 [<c026d6e4>] xfs_iomap_write_allocate+0x254/0x450
 [<c0272010>] ? xfs_log_move_tail+0x190/0x1d0
 [<c0272010>] ? xfs_log_move_tail+0x190/0x1d0
 [<c026e8e7>] xfs_iomap+0x3a7/0x3f0
 [<c014b1cc>] ? trace_hardirqs_on_caller+0x7c/0x160
 [<c028d68e>] xfs_map_blocks+0x3e/0x90
 [<c028f1ea>] xfs_page_state_convert+0x2ea/0x740
 [<c012cb32>] ? _local_bh_enable+0x52/0xa0

Anyway, If they are different, I can not catch the bug at xfs_btree_delrec()
beacuse the bug xfs_btree.c:84 happens earlierly.

>
> How big is the filesystem where you see this corruption? Maybe I could
> reproduce it locally with a xfs_metadump image.

They are big enough, I have four such FS's for >200Gb

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
