Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p86FX2V6088646 for <xfs@oss.sgi.com>; Tue, 6 Sep 2011 10:33:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 743C11E84639
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2011 08:33:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	YBr3zZu9pCyIAhjX for <xfs@oss.sgi.com>;
	Tue, 06 Sep 2011 08:33:02 -0700 (PDT)
Date: Tue, 6 Sep 2011 11:33:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: fix possible overflow in xfs_ioc_trim()
Message-ID: <20110906153301.GA21675@infradead.org>
References: <1315322977-22736-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315322977-22736-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Tue, Sep 06, 2011 at 05:29:37PM +0200, Lukas Czerner wrote:
> In xfs_ioc_trim it is possible that start+len might overflow. Fix it by
> decrementing the len so that start+len equals to the file system size in
> the worst case.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

> @@ -146,6 +146,7 @@ xfs_ioc_trim(
>  	unsigned int		granularity = q->limits.discard_granularity;
>  	struct fstrim_range	range;
>  	xfs_fsblock_t		start, len, minlen;
> +	xfs_fsblock_t		max_blks = mp->m_sb.sb_dblocks;
>  	xfs_agnumber_t		start_agno, end_agno, agno;
>  	__uint64_t		blocks_trimmed = 0;
>  	int			error, last_error = 0;
> @@ -171,7 +172,8 @@ xfs_ioc_trim(
>  	start_agno = XFS_FSB_TO_AGNO(mp, start);
>  	if (start_agno >= mp->m_sb.sb_agcount)
>  		return -XFS_ERROR(EINVAL);
> -
> +	if (len > max_blks)
> +		len = max_blks - start;

Is this really the correct check?

Shouldn't it be

	if (start + len > max_blks)
		len = max_blks - start;

I'd also just use the mp->m_sb.sb_dblocks value directly instead
of assigning it to a local variable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
