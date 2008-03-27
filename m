Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Mar 2008 16:57:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2RNvCeR001688
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2008 16:57:14 -0700
Date: Fri, 28 Mar 2008 10:57:39 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: REVIEW: improve/fix/update zeroing garbage in superblock sectors in xfs_repair
Message-ID: <20080327235739.GC108924158@sgi.com>
References: <op.t8ntcvc23jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t8ntcvc23jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Mar 27, 2008 at 04:25:33PM +1100, Barry Naujok wrote:
> Running XFS QA with a standard HDD with the bad_features2 problem
> happening and doing "mkfs.xfs -l version=1", a problem was encounter
> where it went to zero the "bad" features2 bit.
> 
> Why didn't this happen all the time?
> 
> Upon investigation, I updated the behaviour of the "secondary_sb_wack"
> function. Now it always zeroes any garbage found beyond the expected
> end of the xfs_sb_t structure in the first sector.
.....

> -		if (XFS_SB_VERSION_HASMOREBITS(sb))
> -			size = (__psint_t)&sb->sb_features2
> -				+ sizeof(sb->sb_features2) - (__psint_t)sb;
> -		else if (XFS_SB_VERSION_HASLOGV2(sb))
> -			size = (__psint_t)&sb->sb_logsunit
> +	if (xfs_sb_version_hasmorebits(sb))
> +		size = (__psint_t)&sb->sb_bad_features2
> +				+ sizeof(sb->sb_bad_features2) - (__psint_t)sb;
> +	else if (xfs_sb_version_haslogv2(sb))
.....

This is still fragile and requires us to update this function every time
we add a new field to the superblock. Is there some way we can do this
that doesn't require an update for every modification to the superblock
we make?

Also - 
		size = offsetof(sb->sb_bad_features2) +
				sizeof(sb->sb_bad_features2);

or in the case of the last entry in the superblock:

	size = sizeof(xfs_dsb_t);

		
Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
