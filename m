Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 02:02:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3L92dps028859
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 02:02:40 -0700
Date: Mon, 21 Apr 2008 05:03:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] XFS: ASCII case-insensitive support
Message-ID: <20080421090320.GA19639@infradead.org>
References: <20080421083103.433280025@chook.melbourne.sgi.com> <20080421083645.247895324@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421083645.247895324@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

> +extern struct dentry_operations xfs_ci_dentry_operations;

this one is not used nor does the variable exist.  Just kill it :)

> +static inline int xfs_sb_version_hasoldci(xfs_sb_t *sbp)
> +{
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
> +		((sbp)->sb_versionnum & XFS_SB_VERSION_BORGBIT);
> +}

Lots of superflous braces here.  Should be:

static inline int xfs_sb_version_hasoldci(xfs_sb_t *sbp)
{
	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) &&
		(sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
}

(and yes, the other xfs_sb_version_ helpers need fixups like that
aswell)
