Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A8A047CAE
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 08:05:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 681BE304043
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 06:05:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cEGjqqWSq1poEC2K (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jul 2016 06:05:51 -0700 (PDT)
Date: Thu, 14 Jul 2016 15:05:46 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Advice needed with file system corruption
Message-ID: <20160714130546.GB16096@redhat.com>
References: <5787852A.7030900@st-andrews.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5787852A.7030900@st-andrews.ac.uk>
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
To: Steve Brooks <sjb14@st-andrews.ac.uk>
Cc: xfs@oss.sgi.com

Hi steve.

On Thu, Jul 14, 2016 at 01:27:22PM +0100, Steve Brooks wrote:
> 
> The "3.1.1"  version of "xfs_repair -n" ran in 1 minute, 32 seconds
> 
> The "4.3"     version of "xfs_repair -n" ran in 50 seconds
> 

Yes, the later versions are compatible with old disk-format filesystems,
and they have improvements in memory usage, speed, etc too

> 
> So my questions are
> 
> [1] Which version of "xfs_repair" should I use to make the repair?
> 
> [2] Is there anything I should have done differently?
>

No, just use the latest stable one, and the defaults, unless you have a good
reason to not use default options, which by your e-mail I believe you don't have
one.

The logs you send below, looks from a corrupted btree, but xfs_repair should be
able to fix that for you.

Cheers.


> 
> Many thanks for any advice given it is much appreciated.
> 
> Thanks,  Steve
> 
> 
> 
> Many blocks (about 20) of code similar to this were repeated in the logs.
> 
> Jul  8 18:40:17 sraid1v kernel: ffff880dca95b000: 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00  ................
> Jul  8 18:40:17 sraid1v kernel: XFS (sde): Internal error xfs_da_do_buf(2)
> at line 2136 of file fs/xfs/xfs_da_btree.c. Caller 0xffffffffa0e6e81a
> Jul  8 18:40:17 sraid1v kernel:
> Jul  8 18:40:17 sraid1v kernel: Pid: 8844, comm: idl Tainted: P           --
> ------------    2.6.32-642.el6.x86_64 #1
> Jul  8 18:40:17 sraid1v kernel: Call Trace:
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e7b68f>] ?
> xfs_error_report+0x3f/0x50 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e6e81a>] ?
> xfs_da_read_buf+0x2a/0x30 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e7b6fe>] ?
> xfs_corruption_error+0x5e/0x90 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e6e6fc>] ?
> xfs_da_do_buf+0x6cc/0x770 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e6e81a>] ?
> xfs_da_read_buf+0x2a/0x30 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffff810154e3>] ?
> native_sched_clock+0x13/0x80
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e6e81a>] ?
> xfs_da_read_buf+0x2a/0x30 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e74a21>] ?
> xfs_dir2_leaf_lookup_int+0x61/0x2c0 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e74a21>] ?
> xfs_dir2_leaf_lookup_int+0x61/0x2c0 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e74e05>] ?
> xfs_dir2_leaf_lookup+0x35/0xf0 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e71306>] ?
> xfs_dir2_isleaf+0x26/0x60 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e71ce4>] ?
> xfs_dir_lookup+0x174/0x190 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e9ea47>] ? xfs_lookup+0x87/0x110
> [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0eabd74>] ?
> xfs_vn_lookup+0x54/0xa0 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffff811a9ca5>] ? do_lookup+0x1a5/0x230
> Jul  8 18:40:17 sraid1v kernel: [<ffffffff811aa823>] ?
> __link_path_walk+0x763/0x1060
> Jul  8 18:40:17 sraid1v kernel: [<ffffffff811ab3da>] ? path_walk+0x6a/0xe0
> Jul  8 18:40:17 sraid1v kernel: [<ffffffff811ab5eb>] ?
> filename_lookup+0x6b/0xc0
> Jul  8 18:40:17 sraid1v kernel: [<ffffffff8123ac46>] ?
> security_file_alloc+0x16/0x20
> Jul  8 18:40:17 sraid1v kernel: [<ffffffff811acac4>] ?
> do_filp_open+0x104/0xd20
> Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e9a4fc>] ?
> _xfs_trans_commit+0x25c/0x310 [xfs]
> Jul  8 18:40:17 sraid1v kernel: [<ffffffff812a749a>] ?
> strncpy_from_user+0x4a/0x90
> Jul  8 18:40:17 sraid1v kernel: [<ffffffff811ba252>] ? alloc_fd+0x92/0x160
> Jul  8 18:40:17 sraid1v kernel: [<ffffffff81196bd7>] ?
> do_sys_open+0x67/0x130
> Jul  8 18:40:17 sraid1v kernel: [<ffffffff81196ce0>] ? sys_open+0x20/0x30
> Jul  8 18:40:17 sraid1v kernel: [<ffffffff8100b0d2>] ?
> system_call_fastpath+0x16/0x1b
> Jul  8 18:40:17 sraid1v kernel: XFS (sde): Corruption detected. Unmount and
> run xfs_repair
> Jul  8 18:40:17 sraid1v kernel: ffff880dca95b000: 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00  ................
> Jul  8 18:40:17 sraid1v kernel: XFS (sde): Internal error xfs_da_do_buf(2)
> at line 2136 of file fs/xfs/xfs_da_btree.c. Caller 0xffffffffa0e6e81a
> Jul  8 18:40:17 sraid1v kernel:
> Jul  8 18:40:17 sraid1v kernel: Pid: 8844, comm: idl Tainted: P           --
> ------------    2.6.32-642.el6.x86_64 #1
> 
> 
> 
> 
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
