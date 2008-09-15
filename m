Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 14:10:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8FLAcgs031230
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:10:38 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 403A312A889F
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:12:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id aeSK4pahbXlnLPmd for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:12:10 -0700 (PDT)
Date: Mon, 15 Sep 2008 17:12:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] XFS: factor xfs_iget_core() into hit and miss cases
Message-ID: <20080915211209.GC29743@infradead.org>
References: <1221314627-29065-1-git-send-email-david@fromorbit.com> <1221314627-29065-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221314627-29065-2-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:03:45AM +1000, Dave Chinner wrote:
> There are really two cases in xfs_iget_core(). The first is the
> cache hit case, the second is the miss case. They share very little
> code, and hence can easily be factored out into separate functions.
> This makes the code much easier to understand and subsequently
> modify.

Looks good.
