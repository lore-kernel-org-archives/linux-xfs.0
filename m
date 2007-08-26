Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Aug 2007 09:56:50 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7QGul4p017420
	for <xfs@oss.sgi.com>; Sun, 26 Aug 2007 09:56:49 -0700
Date: Sun, 26 Aug 2007 17:39:06 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] clean up vnode^winode tracing
Message-ID: <20070826163906.GA13665@infradead.org>
References: <46D11F1B.5020409@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D11F1B.5020409@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Aug 26, 2007 at 01:35:07AM -0500, Eric Sandeen wrote:
> Simplify vnode tracing calls by embedding function name & return addr
> in the calling macro.
> 
> Also do a lot of vnode->inode renaming for consistency, while
> we're at it.

Looks good. One day we should move the implementation and declaration out
of xfs_vnode.[ch], but that's fine as a separate patch.
