Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8P9efkN038733 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 04:40:41 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	x7Cq4M1QDaIrDWWy (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Sep 2012 02:41:59 -0700 (PDT)
Date: Tue, 25 Sep 2012 05:41:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] install shared libs with +x bits
Message-ID: <20120925094158.GL9189@infradead.org>
References: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
	<1348529978-30048-3-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348529978-30048-3-git-send-email-vapier@gentoo.org>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: xfs@oss.sgi.com

On Mon, Sep 24, 2012 at 07:39:38PM -0400, Mike Frysinger wrote:
> These are shared libs w/executable code, so make sure they have +x bits
> set on them.  Some kernels will proactively disallow executable mmaps if
> the files lack +x bits.  It's also the right thing to do.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
