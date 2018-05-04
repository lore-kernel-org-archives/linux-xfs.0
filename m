Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52260 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751875AbeEDWAX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 18:00:23 -0400
Subject: Re: [PATCH 08/11] xfs_repair: don't crash if da btree is corrupt
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401964171.13319.385054209589991590.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a9cd786e-0aa2-8852-54f3-be88b7e6e7a6@sandeen.net>
Date: Fri, 4 May 2018 17:00:21 -0500
MIME-Version: 1.0
In-Reply-To: <152401964171.13319.385054209589991590.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/17/18 9:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In the recursive verify_da_path call chain, we decide to examine the
> next upper level if the current entry points past the end of the
> entries.  However, we don't check for a node with zero entries (which
> should be impossible) so we run right off the end of the da cursor's
> level array and crash.  Found by fuzzing hdr.count in xfs/402.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/da_util.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 
> diff --git a/repair/da_util.c b/repair/da_util.c
> index a65652f..bca4060 100644
> --- a/repair/da_util.c
> +++ b/repair/da_util.c
> @@ -526,6 +526,10 @@ verify_da_path(
>  	else
>  		geo = mp->m_attr_geo;
>  
> +	/* No buffer at this level, tree is corrupt. */
> +	if (cursor->level[this_level].bp == NULL)
> +		return 1;
> +
>  	/*
>  	 * index is currently set to point to the entry that
>  	 * should be processed now in this level.
> @@ -535,6 +539,10 @@ verify_da_path(
>  	btree = M_DIROPS(mp)->node_tree_p(node);
>  	M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
>  
> +	/* No entries in this node?  Tree is corrupt. */
> +	if (nodehdr.count == 0)
> +		return 1;
> +
>  	/*
>  	 * if this block is out of entries, validate this
>  	 * block and move on to the next block.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
