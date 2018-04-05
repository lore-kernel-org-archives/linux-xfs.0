Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:50289 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750736AbeDEXCa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 19:02:30 -0400
Date: Fri, 6 Apr 2018 09:02:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/21] xfs: add repair helpers for the reverse mapping
 btree
Message-ID: <20180405230218.GI23861@dastard>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
 <152269899099.16346.10130327272084087800.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152269899099.16346.10130327272084087800.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 02, 2018 at 12:56:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of functions to the reverse mapping btree that will be used
> to repair the rmapbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Minor nit:

> +struct xfs_rmap_key_state {
> +	uint64_t			owner;
> +	uint64_t			offset;
> +	unsigned int			flags;
> +	bool				has_rmap;
> +};
> +
> +/* For each rmap given, figure out if it doesn't match the key we want. */
> +STATIC int
> +xfs_rmap_has_other_keys_helper(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_rmap_irec		*rec,
> +	void				*priv)
> +{
> +	struct xfs_rmap_key_state	*rhok = priv;

rks rather than rhok?

Otherwise looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
