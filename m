Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4VK9vWw075604 for <xfs@oss.sgi.com>; Tue, 31 May 2011 15:09:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A6BAD6459C
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 13:09:55 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	XsZSDTKMGUBUwMVa for <xfs@oss.sgi.com>;
	Tue, 31 May 2011 13:09:55 -0700 (PDT)
Date: Tue, 31 May 2011 16:09:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: clear inode per-lifetime state when recycling it
Message-ID: <20110531200950.GA31713@infradead.org>
References: <1306815659-23346-1-git-send-email-david@fromorbit.com>
	<1306815659-23346-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1306815659-23346-2-git-send-email-david@fromorbit.com>
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

Looks good.


Reviewed-by: Christoph Hellwig <hch@lst.de>

> +		 * XXX(dgc): should the XFS_ISTALE flag only be cleared here?

I think so.  Right now any iget on a stale inode will clear it, which
is very wrong.  Care to send a separate patch for that?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
