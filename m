Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2T6ewVg043239 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 01:40:58 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	crt4ggNCKUNN5TqW for <xfs@oss.sgi.com>;
	Wed, 28 Mar 2012 23:40:56 -0700 (PDT)
Date: Thu, 29 Mar 2012 17:40:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Buffalo LS-Q4.0 Raid 5 XFS errors
Message-ID: <20120329064054.GP5091@dastard>
References: <004b01cd0d3f$c6d4fbc0$547ef340$@tx.rr.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <004b01cd0d3f$c6d4fbc0$547ef340$@tx.rr.com>
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
To: Kirk Anderson <kirkande@tx.rr.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 28, 2012 at 07:06:22PM -0500, Kirk Anderson wrote:
> I have a Buffalo LS-QLF55 4TB Raid 5 box.  It is out of warranty.  It was
> using firmware 1.10.    The unit stopped responding and would not power down
> through the web interface, nor the power button on the front of the unit.  I
> unplugged the unit and plugged it back in.  The unit now shows the drives as
> unformatted.  I have provided some information below and would greatly
> appreciate some guidance as to what my next steps are to minimize my data
> loss.  Any and all help is greatly appreciated.  Thanks, Kirk

No unformatted:

> XFS: log mount/recovery failed: error 117
> 
> XFS: log mount failed

Basically your filesystem was corrupted by the crash.

> Filesystem "md2": Disabling barriers, not supported by the underlying device
> 
> XFS mounting filesystem md2
> 
> Starting XFS recovery on filesystem: md2 (logdev: internal)
> 
> Filesystem "md2": xfs_inode_recover: Bad inode magic number, dino ptr =
> 0xc6d2c000, dino bp = 0xc782fa80, ino = 256
> 
> Filesystem "md2": XFS internal error xlog_recover_do_inode_trans(1) at line
> 2310 of file fs/xfs/xfs_log_recover.c.  Caller 0xc017f368
> 
> [<c002b758>] (dump_stack+0x0/0x14) from [<c01666fc>]
> (xfs_error_report+0x54/0x64)
> 
> [<c01666a8>] (xfs_error_report+0x0/0x64) from [<c017eb2c>]
> (xlog_recover_do_inode_trans+0x28c/0x8ac)
> 
> [<c017e8a0>] (xlog_recover_do_inode_trans+0x0/0x8ac) from [<c017f368>]
> (xlog_recover_do_trans+0x80/0x154)
> 
> [<c017f2e8>] (xlog_recover_do_trans+0x0/0x154) from [<c017f478>]
> (xlog_recover_commit_trans+0x3c/0x54)
> 
> [<c017f43c>] (xlog_recover_commit_trans+0x0/0x54) from [<c017f5f4>]
> (xlog_recover_process_data+0x164/0x224)
> 
> r7:c725e204 r6:c0b802d8 r5:08be0000 r4:e5000000
> 
> [<c017f490>] (xlog_recover_process_data+0x0/0x224) from [<c017f9b4>]
> (xlog_do_recovery_pass+0x300/0x828)
> 
> [<c017f6b4>] (xlog_do_recovery_pass+0x0/0x828) from [<c017ff54>]
> (xlog_do_log_recovery+0x78/0x9c)
> 
> [<c017fedc>] (xlog_do_log_recovery+0x0/0x9c) from [<c017ff98>]
> (xlog_do_recover+0x20/0x138)

And this is saying that there are no inodes where there are supposed
to be inodes.

The usual recovery via xfs_repair steps should be taken....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
