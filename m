Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B0CA7F85
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 14:26:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6F94AC003
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 12:26:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ErtCBfcFGW2AyiNA for
	<xfs@oss.sgi.com>; Thu, 30 Jan 2014 12:26:23 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0UKQNL8001212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 15:26:23 -0500
Message-ID: <52EAB56D.2050203@redhat.com>
Date: Thu, 30 Jan 2014 15:26:21 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: limit superblock corruption errors to probable
	corruption
References: <52E88D8B.90208@redhat.com>
In-Reply-To: <52E88D8B.90208@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 01/29/2014 12:11 AM, Eric Sandeen wrote:
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
> this much noise, so this patch removes the high-level
> XFS_CORRUPTION_ERROR which was firing for every error return
> except EWRONGFS.
> 
> It also adds one to the path which detects a failed checksum.
> 
> The idea is, if it's really _corruption_ we can call
> XFS_CORRUPTION_ERROR at the point of detection.  More benign
> incompatibilities can do a little printk & fail the mount without
> so much drama.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I could see an argument where we might still want the hexdump
> for things like bad magic - ok, just what *was* the magic?  But
> I think we do need to reserve the oops-mimicing-backtraces for
> the most severe problems.  Discuss.  ;)
> 

This seems pretty reasonable to me, particularly if pretty much any
error via the xfs_sb_verify() path dumps corruption noise...

> diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
> index 511cce9..b575317 100644
> --- a/fs/xfs/xfs_sb.c
> +++ b/fs/xfs/xfs_sb.c
> @@ -617,6 +617,8 @@ xfs_sb_read_verify(
>  			/* Only fail bad secondaries on a known V5 filesystem */
>  			if (bp->b_bn != XFS_SB_DADDR &&
>  			    xfs_sb_version_hascrc(&mp->m_sb)) {
> +				XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> +						     mp, bp->b_addr);
>  				error = EFSCORRUPTED;
>  				goto out_error;
>  			}
> @@ -625,12 +627,8 @@ xfs_sb_read_verify(
>  	error = xfs_sb_verify(bp, true);
>  
>  out_error:
> -	if (error) {
> -		if (error != EWRONGFS)
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -					     mp, bp->b_addr);
> +	if (error)
>  		xfs_buf_ioerror(bp, error);
> -	}
>  }

... but why not leave the corruption output here in out_error, change
the check to (error == EFSCORRUPTED) and remove the now duplicate
corruption message in xfs_mount_validate_sb() (or replace it with a
warn/notice message)? This would catch the other EFSCORRUPTED returns in
a consistent manner, including another potential duplicate in the write
verifier. I guess we'd lose a little specificity between the crc failure
and sb validation, but we could add a warn/notice for the former too.

Brian

>  
>  /*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
