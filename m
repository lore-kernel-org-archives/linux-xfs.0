Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60579 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964873AbdD0HfW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 03:35:22 -0400
Date: Thu, 27 Apr 2017 00:35:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] xfs: try to avoid blowing out the transaction
 reservation when bunmaping a shared extent
Message-ID: <20170427073519.GA18392@infradead.org>
References: <20170425020954.GV23371@birch.djwong.org>
 <20170426135912.GB42456@bfoster.bfoster>
 <20170426213731.GC23371@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170426213731.GC23371@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Wed, Apr 26, 2017 at 02:37:31PM -0700, Darrick J. Wong wrote:
> That's so shockingly obvious I don't know why it didn't occur to me.
> Uh, I'll go give that a try with that horrid generic/931 testcase that
> I sent to the list a couple of weeks ago. :)

I like the idea too.  But once thing to remember is that freeing
blocks from two AG in the same transaction is deadlock prone as the
other thread shows.  I've been doing some work to mitigate that, but
I guess I'll just wait for your new patch and will rebase on top of
that.
