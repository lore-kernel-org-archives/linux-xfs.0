Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 15:55:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33MtKSX007413
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 15:55:23 -0700
Date: Thu, 3 Apr 2008 18:55:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] XFS: ASCII case-insensitive support
Message-ID: <20080403225556.GB448@infradead.org>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062708.071715758@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402062708.071715758@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 02, 2008 at 04:25:10PM +1000, Barry Naujok wrote:
> +	struct qstr	*a,
> +	struct qstr	*b)
> +{
> +	int	result = xfs_dir_compname(XFS_I(dir->d_inode), a->name, a->len,
> +					b->name, b->len) == XFS_CMP_DIFFERENT;
> +	/*
> +	 * result == 0 if a match is found, and if so, copy the name in "b"
> +	 * to "a" to cope with negative dentries getting the correct name.
> +	 */
> +	if (result == 0)
> +		memcpy((unsigned char *)a->name, b->name, a->len);
> +	return result;

qstr->name is marked const for a reason, please don't overwrite
it after it's creation.

> +struct dentry_operations xfs_ci_dentry_operations =
> +{

struct dentry_operations xfs_ci_dentry_operations = {
> +static xfs_dahash_t
> +xfs_ascii_ci_hashname(

is the use of STATIC now officially phased out for XFS?

> +		((sbp)->sb_versionnum & XFS_SB_VERSION_OLDCIBIT);

no need for the braces around sbp

>
