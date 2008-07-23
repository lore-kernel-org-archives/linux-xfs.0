Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 00:57:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N7vGJf013884
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:57:17 -0700
Date: Wed, 23 Jul 2008 03:58:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce xfs_bmap_add_attrfork_trans.
Message-ID: <20080723075826.GA27533@infradead.org>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1215675545-2707-1-git-send-email-xaiki@sgi.com> <1215675545-2707-2-git-send-email-xaiki@sgi.com> <1215675545-2707-3-git-send-email-xaiki@sgi.com> <1215675545-2707-4-git-send-email-xaiki@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215675545-2707-4-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

> +error0:
> +	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
> +	ASSERT(ip->i_df.if_ext_max ==
> +	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
> +	return error;

I think the transaction cancelling should be done by the caller.  The
callers will surely have cases where they have to cancel the transaction
already, and it's also more symmetric.

> +	VN_HOLD(XFS_ITOV(ip));

Please just use

	IHOLD(ip);

instead of the above construct.

Otherwise this looks fine and like another candidate to commit already.
