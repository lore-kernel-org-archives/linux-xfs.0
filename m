Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 14:49:42 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3NLncfB014659
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 14:49:39 -0700
Date: Mon, 23 Apr 2007 22:27:39 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: don't block non-blocking setattr when frozen
Message-ID: <20070423212739.GG13572@infradead.org>
References: <20070423003142.GZ32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423003142.GZ32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 23, 2007 at 10:31:42AM +1000, David Chinner wrote:
> 
> Prevent nfsds from blocking doing on setattr calls (i.e. truncates)
> when the filesystem is frozen or being frozen.

Ok with same caveat as the last one.
