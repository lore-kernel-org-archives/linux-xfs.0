Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 04:55:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LBtKi2024790
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:55:20 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 33A5312E81A3
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:56:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id GJx4zcemjwxiFIHa for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:56:29 -0700 (PDT)
Date: Mon, 21 Jul 2008 07:56:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: Kill xfs_vtoi()
Message-ID: <20080721115629.GC14346@infradead.org>
References: <1216641130-22725-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216641130-22725-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 21, 2008 at 09:52:10PM +1000, Dave Chinner wrote:
> xfs_vtoi() is redundant and only unsed in small sections
> of code. Replace them with widely used XFS_I() inline and
> kill xfs_vtoi().

Looks good.  As it creates conflict for more than half of my pending
patches it would be nice if we could get it merged ASAP so that I can
rediff them.
