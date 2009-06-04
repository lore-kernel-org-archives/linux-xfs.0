Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n549NG9D232558 for <xfs@oss.sgi.com>; Thu, 4 Jun 2009 04:23:16 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE2F62CFE08
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2009 02:23:33 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	vXyPYxGQa2ywTcoB for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2009 02:23:33 -0700 (PDT)
Date: Thu, 4 Jun 2009 19:23:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.30-rc6: BUG at fs/xfs/support/debug.c:109!
Message-ID: <20090604092330.GT16929@discord.disaster>
References: <a4423d670906010822l6e8e112dl3d6f7de9e2179850@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a4423d670906010822l6e8e112dl3d6f7de9e2179850@mail.gmail.com>
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
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Jun 01, 2009 at 07:22:56PM +0400, Alexander Beregalov wrote:
> Hi
> 
> Assertion failed: *nmap >= 1, file: fs/xfs/xfs_bmap.c, line: 4846
.....
> Call Trace:
>  [<ffffffff803d6bad>] xfs_bmapi+0xad/0x1ad0
>  [<ffffffff803ee5c0>] xfs_dir2_leaf_getdents+0x640/0x7b0
>  [<ffffffff803e975c>] xfs_readdir+0x12c/0x140
>  [<ffffffff80430b57>] xfs_file_readdir+0x47/0x70
>  [<ffffffff802ec500>] vfs_readdir+0xd0/0xf0
>  [<ffffffff802ec6b6>] sys_getdents+0x96/0x110
>  [<ffffffff8020ba6b>] system_call_fastpath+0x16/0x1b

I'd say this indicates a corrupted directory.  Can you run
'xfs_repair -n' over the filesystem and see if it finds a bad
directory?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
