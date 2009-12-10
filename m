Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBANIM4Q125051 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 17:18:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DA6CDFAE48
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:18:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IaXlkdlSZ3CDRZwg for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:18:57 -0800 (PST)
Date: Thu, 10 Dec 2009 18:18:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] [XFS] Don't directly reference m_perag in
	allocation code
Message-ID: <20091210231856.GB6389@infradead.org>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
	<1259734299-20306-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1259734299-20306-3-git-send-email-david@fromorbit.com>
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

On Wed, Dec 02, 2009 at 05:11:35PM +1100, Dave Chinner wrote:
> +		pag = xfs_perag_get(mp, agno);
> +		pag->pagf_freeblks += len;
> +		xfs_perag_put(pag);
> +
>  		agf = XFS_BUF_TO_AGF(agbp);
> -		pag = &mp->m_perag[agno];
>  		be32_add_cpu(&agf->agf_freeblks, len);
>  		xfs_trans_agblocks_delta(tp, len);
> -		pag->pagf_freeblks += len;

Currently not too deep into this code, but did you make sure moving the
in-core addition before the logging of the transaction doesn't matter/

> +		args->pag = xfs_perag_get(mp, args->agno);
>  		down_read(&mp->m_peraglock);
> -		args->pag = &mp->m_perag[args->agno];

This adds another place where we could hit the growfs race until your
later patches go in.

Otherwise looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
