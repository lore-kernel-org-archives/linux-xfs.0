Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 11:16:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8OIFnUS032543
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 11:15:49 -0700
Date: Wed, 24 Sep 2008 14:17:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 985583 - make btree tracing generic
Message-ID: <20080924181722.GA28151@infradead.org>
References: <20080924074713.2A8EC58C52AE@chook.melbourne.sgi.com> <20080924180540.GA28138@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924180540.GA28138@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Wed, Sep 24, 2008 at 02:05:40PM -0400, Christoph Hellwig wrote:
> This commit forgot to add the new xfs_btree_trace.h file and thus breaks
> the compile of btree tracing is enabled.

And xfs_btree_trace.c, too.
