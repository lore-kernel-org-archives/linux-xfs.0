Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Jul 2007 00:58:51 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K7wlbm029826
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2007 00:58:48 -0700
Date: Fri, 20 Jul 2007 08:30:23 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/7] - remove unused variable from locking macros
Message-ID: <20070720073023.GE29295@infradead.org>
References: <46A03631.7060604@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A03631.7060604@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 19, 2007 at 11:12:33PM -0500, Eric Sandeen wrote:
> The "s" in these locking macros used to be used like flags
> in spin_lock_irqsave; but in the xfs codebase today it's 
> never used.
> 
> gcc optimizes it away, but still, why keep it around?

If we change away from the IRIX compatible signatures we could just
kill the lock wrappers aswell..
