Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2F3sqU007569 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 09:03:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5ED92D8F6F9
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 07:04:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cLyDRbfqJElfmQDM for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2009 07:04:25 -0800 (PST)
Date: Wed, 2 Dec 2009 10:04:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_db: modify bad_features2 when modifying features2
Message-ID: <20091202150422.GA16338@infradead.org>
References: <4B156BE3.2080107@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B156BE3.2080107@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 01, 2009 at 01:17:55PM -0600, Eric Sandeen wrote:
> +	if (xfs_sb_has_mismatched_features2(&tsb)) {
> +		dbprintf(_("Superblock has mismatched features2 fields, "
> +			   "skipping modification\n"));
> +		return 0;
> +	}

However I'm not sure if this one is an all that good idea.  It'll make
all version updates fail if we have a mismatched features2.  That way
people can't use xfs_db to fix it up which seems odd.

To me just printing the warning but not aborting would be the best way
to inform the user about it.

> +
>  	if ((version & XFS_SB_VERSION_LOGV2BIT) &&
>  					!xfs_sb_version_haslogv2(&tsb)) {
>  		tsb.sb_logsunit = 1;
> @@ -564,7 +570,8 @@ do_version(xfs_agnumber_t agno, __uint16_t version, __uint32_t features)
>  
>  	tsb.sb_versionnum = version;
>  	tsb.sb_features2 = features;
> -	fields |= XFS_SB_VERSIONNUM | XFS_SB_FEATURES2;
> +	tsb.sb_bad_features2 = features;
> +	fields |= XFS_SB_VERSIONNUM | XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;

This one looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
