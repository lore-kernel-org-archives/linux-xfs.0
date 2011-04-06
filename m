Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p36IEWQE047831 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 13:14:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5919148858F
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 11:17:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iCZiz8jjYlTBPxvg for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2011 11:17:49 -0700 (PDT)
Date: Wed, 6 Apr 2011 14:17:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/9] xfs: clean up code layout in xfs_trans_ail.c
Message-ID: <20110406181749.GC4356@infradead.org>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302070758-17312-7-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> +/*
> + * Return a pointer to the first item in the AIL.
> + * If the AIL is empty, then return NULL.
> + */

> +/*
> + * Return a pointer to the item which follows
> + * the given item in the AIL.  If the given item
> + * is the last item in the list, then return NULL.
> + */

These comment seem to line break strangely early.

> +	ASSERT((&next_lip->li_ail == &ailp->xa_ail) ||
> +	       (XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0));

no need for the inner braces here.

> +	list_splice_init(list, &next_lip->li_ail);
> +	return;

and no need for the return.


I know it's all nitpicking about pre-existing code, but when you touch
it anyway it might make sense to tidy it up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
