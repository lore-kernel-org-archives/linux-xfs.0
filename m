Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 89D347F54
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 19:22:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2457EAC002
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:22:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 5F3MiaEsV5RR2VkB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 17:22:10 -0700 (PDT)
Date: Thu, 28 Aug 2014 17:22:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] xfs: xfs_buf_ioend and xfs_buf_iodone_work duplicate
	functionality
Message-ID: <20140829002209.GB17502@infradead.org>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408084747-4540-3-git-send-email-david@fromorbit.com>
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

>  STATIC void

needs the static removed as pointed out by Brian.
> -	bool			read = !!(bp->b_flags & XBF_READ);
> +	bool		read = !!(bp->b_flags & XBF_READ);

We don't really need the double negation here.

Otherwise this looks reasonable to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
