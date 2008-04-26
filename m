Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Apr 2008 13:06:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3QK6LGt025330
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 13:06:28 -0700
Date: Sat, 26 Apr 2008 16:07:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Message-ID: <20080426200701.GA10883@infradead.org>
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com> <87iqy4wfjq.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqy4wfjq.fsf@basil.nowhere.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:02:17PM +0200, Andi Kleen wrote:
> Denys Vlasenko <vda.linux@googlemail.com> writes:
> >
> > Compile tested only.
> 
> You should mark the helper noinline just to prevent gcc from possibly
> inlining it. Even if it doesn't with your current compiler inline heuristics
> vary widely between compiler versions.

STATIC as defined by xfs already does this..
