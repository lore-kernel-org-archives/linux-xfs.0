Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Apr 2008 13:20:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3QKJl4h027609
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 13:19:49 -0700
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62060F565F
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 13:20:29 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by cuda.sgi.com with ESMTP id PwZ58kh2BEtuag6d for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 13:20:29 -0700 (PDT)
Date: Sat, 26 Apr 2008 22:26:30 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Message-ID: <20080426202630.GG17905@one.firstfloor.org>
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com> <87iqy4wfjq.fsf@basil.nowhere.org> <20080426200701.GA10883@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426200701.GA10883@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 04:07:01PM -0400, Christoph Hellwig wrote:
> On Sat, Apr 26, 2008 at 10:02:17PM +0200, Andi Kleen wrote:
> > Denys Vlasenko <vda.linux@googlemail.com> writes:
> > >
> > > Compile tested only.
> > 
> > You should mark the helper noinline just to prevent gcc from possibly
> > inlining it. Even if it doesn't with your current compiler inline heuristics
> > vary widely between compiler versions.
> 
> STATIC as defined by xfs already does this..

Weird. Unexpected. Different from everyone else. Is this some exercise in 
obfuscation?

But ok.

-Andi
