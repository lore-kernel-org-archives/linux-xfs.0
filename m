Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9GZ4OI128014 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 10:35:04 -0600
Date: Fri, 9 Nov 2012 11:36:58 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: NFS stalls when writing - linux 3.6.x
Message-ID: <20121109163658.GE6171@fieldses.org>
References: <50957087.6050008@xinu.at> <20121107190724.GD7421@fieldses.org>
	<509D2993.4050604@xinu.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <509D2993.4050604@xinu.at>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Florian Pritz <bluewind@xinu.at>
Cc: linux-nfs@vger.kernel.org, Alex Elder <elder@kernel.org>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Fri, Nov 09, 2012 at 05:04:35PM +0100, Florian Pritz wrote:
> On 07.11.2012 20:07, J. Bruce Fields wrote:
> >> Sadly I don't know when this started happening.
> > 
> > It would be helpful to know that--especially if you find an easy way to
> > reproduce this, it would be worth booting to older kernels and seeing if
> > you can figure when the problem started.
> 
> I'll try that unless the sysrq output helps.
> 
> >> top on the server now shows lots of nfsd threads in D state.
> > 
> > Next time you find in that state, could you try
> > 
> > 	echo t >/proc/sysrq-trigger
> > 
> > on the server?  That will dump a bunch of data to the logs which we
> > might be able to use.
> 
> Data should be attached if the ML allows it. Hope it helps. sysrq output
> is after line 883.

The nfsd threads are all stuck in _vfs_lock_force_lsn in xfs_file_fsync;
for example:

> [99390.866452] nfsd            D ffff880075723060     0  1342      2 0x00000000
> [99390.866455]  ffff88007988d8b0 0000000000000046 ffff880075723060 ffff88007988dfd8
> [99390.866460]  ffff88007988dfd8 ffff88007988dfd8 ffff88007bbcd0a0 ffff880075723060
> [99390.866464]  ffff88007553b998 ffff88007553b980 ffff88005cd2d0c0 0000000000000001
> [99390.866468] Call Trace:
> [99390.866484]  [<ffffffffa0af521e>] ? xlog_cil_force_lsn+0xce/0x160 [xfs]
> [99390.866488]  [<ffffffff81491b79>] schedule+0x29/0x70
> [99390.866504]  [<ffffffffa0af3a17>] _xfs_log_force_lsn+0x287/0x2d0 [xfs]
> [99390.866508]  [<ffffffff8108bbd0>] ? try_to_wake_up+0x2f0/0x2f0
> [99390.866519]  [<ffffffffa0a9ecff>] xfs_file_fsync+0x1bf/0x230 [xfs]
> [99390.866524]  [<ffffffff811ae21d>] generic_write_sync+0x4d/0x60
> [99390.866536]  [<ffffffffa0a9fbcf>] xfs_file_aio_write+0x12f/0x160 [xfs]
> [99390.866547]  [<ffffffffa0a9faa0>] ? xfs_file_buffered_aio_write+0x1f0/0x1f0 [xfs]
> [99390.866552]  [<ffffffff8117fb73>] do_sync_readv_writev+0xa3/0xe0
> [99390.866557]  [<ffffffff8117fe54>] do_readv_writev+0xd4/0x1e0
> [99390.866565]  [<ffffffffa0ba3170>] ? _fh_update.isra.9.part.10+0x60/0x60 [nfsd]
> [99390.866572]  [<ffffffffa0ba3170>] ? _fh_update.isra.9.part.10+0x60/0x60 [nfsd]
> [99390.866576]  [<ffffffff811f64cf>] ? exportfs_decode_fh+0xaf/0x310
> [99390.866581]  [<ffffffff8117ff95>] vfs_writev+0x35/0x60
> [99390.866588]  [<ffffffffa0ba44fb>] nfsd_vfs_write.isra.11+0xeb/0x300 [nfsd]
> [99390.866598]  [<ffffffffa0bbb262>] ? find_confirmed_client+0xb2/0x100 [nfsd]
> [99390.866607]  [<ffffffffa0bbc1ba>] ? nfsd4_lookup_stateid+0xea/0x120 [nfsd]
> [99390.866615]  [<ffffffffa0ba6b22>] nfsd_write+0xa2/0x110 [nfsd]
> [99390.866623]  [<ffffffffa0bb1463>] nfsd4_write+0xe3/0x110 [nfsd]
> [99390.866632]  [<ffffffffa0bb20bc>] nfsd4_proc_compound+0x2fc/0x650 [nfsd]
> [99390.866639]  [<ffffffffa0ba0b3e>] nfsd_dispatch+0xbe/0x1c0 [nfsd]
> [99390.866651]  [<ffffffffa027020e>] svc_process+0x48e/0x790 [sunrpc]
> [99390.866658]  [<ffffffffa0ba0115>] nfsd+0xb5/0x1a0 [nfsd]
> [99390.866664]  [<ffffffffa0ba0060>] ? nfsd_get_default_max_blksize+0x60/0x60 [nfsd]
> [99390.866668]  [<ffffffff81079a03>] kthread+0x93/0xa0
> [99390.866673]  [<ffffffff8149b144>] kernel_thread_helper+0x4/0x10
> [99390.866678]  [<ffffffff81079970>] ? kthread_freezable_should_stop+0x70/0x70
> [99390.866682]  [<ffffffff8149b140>] ? gs_change+0x13/0x13

Maybe xfs folks would have an idea?  (More context:

	http://thread.gmane.org/gmane.linux.nfs/53123/focus=53180
)

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
