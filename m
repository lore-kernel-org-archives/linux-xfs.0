Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 00:43:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3A7h7fn027616
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 00:43:08 -0700
Date: Thu, 10 Apr 2008 03:43:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix logic error in xfs_alloc_ag_vextent_near()
Message-ID: <20080410074342.GA13126@infradead.org>
References: <20080410032555.GS108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410032555.GS108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 10, 2008 at 01:25:55PM +1000, David Chinner wrote:
> Fix a logic error in xfs_alloc_ag_vextent_near(). This is
> a regression introduced by the error handling changes.

With this one onto of the truncate fix xfsqa nows doesn't cause an oops
or regressions on xfsqa.
