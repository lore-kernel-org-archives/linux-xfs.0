Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 02:13:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J9DtnG009107
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:13:57 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B450891DF7F
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:15:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id WvE1PMwCaPcX5MoH for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:15:26 -0700 (PDT)
Date: Fri, 19 Sep 2008 05:15:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] XFS: Allocate the struct xfs_ail
Message-ID: <20080919091526.GA11443@infradead.org>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com> <1221317877-8333-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221317877-8333-2-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:57:50AM +1000, Dave Chinner wrote:
> Rather than embedding the struct xfs_ail in the struct xfs_mount,
> allocate it during AIL initialisation. Add a back pointer to
> the struct xfs_ail so that we can pass around the xfs_ail
> and still be able to access the xfs_mount if need be. This
> is th first step involved in isolating the AIL implementation
> from the surrounding filesystem code.

Makes sense.
