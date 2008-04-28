Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 22:56:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3S5tsEm004947
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 22:56:03 -0700
Date: Mon, 28 Apr 2008 01:56:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Message-ID: <20080428055629.GB3192@infradead.org>
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com> <87iqy4wfjq.fsf@basil.nowhere.org> <20080426200701.GA10883@infradead.org> <20080426202630.GG17905@one.firstfloor.org> <20080426202323.GA14245@infradead.org> <1209341212.23166.122.camel@edge.scott.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209341212.23166.122.camel@edge.scott.net.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>, Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 10:06:51AM +1000, Nathan Scott wrote:
> Having to compile chunks of XFS code in both kernel and
> userspace is also wierd (relative to other drivers), and
> its a side-effect of needing to do that (all the code
> dealing with specifics of ondisk format is shared).

There would be neater ways to deal with that, but then again there
are more urgent things to tackle.  And for the time beeing using
STATIC to imply non-inline is actually a very useful hack for XFS.
