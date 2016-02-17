Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C33577CA4
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 02:57:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 557F1AC005
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 00:57:12 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id eTxDyiySjZ3Didow (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 00:57:10 -0800 (PST)
Date: Wed, 17 Feb 2016 00:57:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: remove xfs_trans_get_block_res
Message-ID: <20160217085709.GA9492@infradead.org>
References: <1455699159-20906-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455699159-20906-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Sorry - seems like I sent without the cover letter.

Rational:  the xfs_trans_alloc + xfs_trans_reserve combination is
super confusing, and when recently debugging the block reservation
issues in the reflink code I got reminded of my old series to sort
this out, so I dusted it off, tested it and here were are.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
