Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A9A997FEE
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 21:37:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3A4C3AC007
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 19:37:27 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NhJxo0Y6bWukngHo for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 19:37:25 -0800 (PST)
Date: Wed, 19 Feb 2014 14:37:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: limit superblock corruption errors to actual
	corruption
Message-ID: <20140219033721.GL13647@dastard>
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
	<1392767549-25574-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392767549-25574-3-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 18, 2014 at 05:52:22PM -0600, Eric Sandeen wrote:
> Today, if
> 
> xfs_sb_read_verify
>   xfs_sb_verify
>     xfs_mount_validate_sb
> 
> detects superblock corruption, it'll be extremely noisy, dumping
> 2 stacks, 2 hexdumps, etc.
> 
> This is because we call XFS_CORRUPTION_ERROR in xfs_mount_validate_sb
> as well as in xfs_sb_read_verify.
> 
> Also, *any* errors in xfs_mount_validate_sb which are not corruption
> per se; things like too-big-blocksize, bad version, bad magic, v1 dirs,
> rw-incompat etc - things which do not return EFSCORRUPTED - will
> still do the whole XFS_CORRUPTION_ERROR spew when xfs_sb_read_verify
> sees any error at all.  And it suggests to the user that they
> should run xfs_repair, even if the root cause of the mount failure
> is a simple incompatibility.
> 
> I'll submit that the probably-not-corrupted errors don't warrant
> this much noise, so this patch removes the warning for anything
> other than EFSCORRUPTED returns, and replaces the lower-level
> XFS_CORRUPTION_ERROR with an xfs_notice().
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Agreed. Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
