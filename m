Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 02:43:52 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6N9hmbm004751
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 02:43:49 -0700
Date: Mon, 23 Jul 2007 10:17:33 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: increase default filestreams timeout
Message-ID: <20070723091733.GA30655@infradead.org>
References: <20070723020630.GU12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723020630.GU12413810@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jul 23, 2007 at 12:06:30PM +1000, David Chinner wrote:
> The default is too low resulting in far too frequent workqueue
> flushing and it's unlikely that it will work properly with buffered
> I/O on such a low timeout. i.e. test 172 expects the timeout of 50
> (default) expects buffered I/O to fail to lay the streams out
> without interleaving.
> 
> Set the default timeout to 30s instead of 500ms.

The patch is obviously correct and I trust you on chosing the right timeout.
