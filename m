Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE08F7FE0
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:29:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF6438F8035
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:29:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id hufxLEa99k90wKvy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:29:49 -0700 (PDT)
Date: Tue, 6 May 2014 01:29:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: make superblock version checks reflect reality
Message-ID: <20140506082948.GA18865@infradead.org>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
	<1399348559-19889-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399348559-19889-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> +/*
> + * The first XFS version we support is a v4 superblock with V2 directories.
> + */
> +static inline bool xfs_sb_good_v4_features(struct xfs_sb *sbp)
>  {
> +	if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
> +		return false;
>  
> +	/* check for unknown features in the fs */
> +	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||

Given that sb_versionnum is a __uint16_t and XFS_SB_VERSION_OKBITS is
0xffff this will never evaluate to false and a sane compiler should warn
about it.  How about remove this check and XFS_SB_VERSION_OKBITS?

The various has_ macros are a bit confusing to me, as some explicitly
check for 5 superblocks, and some assume the caller handles them in
some way, but I think this is something we can leave for later cleanups.

>   * For example, for a bit defined as XFS_SB_VERSION2_FUNBIT, has a macro:
>   *
> - * SB_VERSION_HASFUNBIT(xfs_sb_t *sbp)
> + * SB_VERSION_HASFUNBIT(struct xfs_sb *sbp)

>   *	((xfs_sb_version_hasmorebits(sbp) &&
>   *	 ((sbp)->sb_features2 & XFS_SB_VERSION2_FUNBIT)
>   */

This should be updated to the lowe case convention inlines we've used
for a long time.  Or just removed as new features should go into v5
superblocks..

Modulo these minor bits:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
