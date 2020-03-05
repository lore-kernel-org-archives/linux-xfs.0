Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BF4C3F2CE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 01:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9048B20870
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 01:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgCEBVA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 20:21:00 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34715 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725554AbgCEBU7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 20:20:59 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3F3103A28F4;
        Thu,  5 Mar 2020 12:20:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9fC2-0005kl-Eb; Thu, 05 Mar 2020 12:20:54 +1100
Date:   Thu, 5 Mar 2020 12:20:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/4] xfs: introduce fake roots for ag-rooted btrees
Message-ID: <20200305012054.GF10776@dread.disaster.area>
References: <158329250190.2423432.16958662769192587982.stgit@magnolia>
 <158329250827.2423432.18007812133503266256.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158329250827.2423432.18007812133503266256.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=WxseO8hpZViBEln2YdsA:9
        a=3Y2ewoGzYoCthba3:21 a=-IEhY9erJvnRCN6g:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 07:28:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create an in-core fake root for AG-rooted btree types so that callers
> can generate a whole new btree using the upcoming btree bulk load
> function without making the new tree accessible from the rest of the
> filesystem.  It is up to the individual btree type to provide a function
> to create a staged cursor (presumably with the appropriate callouts to
> update the fakeroot) and then commit the staged root back into the
> filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> @@ -188,6 +188,16 @@ union xfs_btree_cur_private {
>  	} abt;
>  };
>  
> +/* Private information for a AG-rooted btree. */
> +struct xfs_btree_priv_ag {			/* needed for BNO, CNT, INO */
> +	union {
> +		struct xfs_buf		*agbp;	/* agf/agi buffer pointer */
> +		struct xbtree_afakeroot	*afake;	/* fake ag header root */
> +	};
> +	xfs_agnumber_t			agno;	/* ag number */
> +	union xfs_btree_cur_private	priv;
> +};
> +
>  /*
>   * Btree cursor structure.
>   * This collects all information needed by the btree code in one place.
> @@ -209,11 +219,7 @@ typedef struct xfs_btree_cur
>  	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
>  	int		bc_statoff;	/* offset of btre stats array */
>  	union {
> -		struct {			/* needed for BNO, CNT, INO */
> -			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
> -			xfs_agnumber_t	agno;	/* ag number */
> -			union xfs_btree_cur_private	priv;
> -		} a;
> +		struct xfs_btree_priv_ag a;
>  		struct {			/* needed for BMAP */
>  			struct xfs_inode *ip;	/* pointer to our inode */
>  			int		allocated;	/* count of alloced */

I don't really like the mess this is turning into. I'll write a
quick cleanup patch set for this union to make it much neater and
the code much less verbose before we make the code even more
unreadable. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
