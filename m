Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 99CDF7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 03:28:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B0B6304048
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 01:28:19 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id z0PgrEc7rPAjO9W2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 01:28:17 -0800 (PST)
Date: Mon, 8 Feb 2016 01:28:17 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] xfs: remove timestamps from incore inode
Message-ID: <20160208092817.GB28146@infradead.org>
References: <1454905461-2773-1-git-send-email-david@fromorbit.com>
	<1454905461-2773-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454905461-2773-3-git-send-email-david@fromorbit.com>
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

> +	/*
> +	 * time is signed, so need to convert to signed 32 bit before
> +	 * storing in inode timestamp which may be 64 bit. Otherwise
> +	 * a time before epoch is converted to a time long after epoch
> +	 * on 64 bit systems.
> +	 */

Time should be captizalized at the beginning of the comment.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
