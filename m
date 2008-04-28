Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 17:06:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3S06FPv007780
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 17:06:18 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F247AF8067
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 17:06:58 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id 4cFeOeEj5c8hE4oK for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 17:06:58 -0700 (PDT)
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20080426202323.GA14245@infradead.org>
References: 
	 <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com>
	 <87iqy4wfjq.fsf@basil.nowhere.org> <20080426200701.GA10883@infradead.org>
	 <20080426202630.GG17905@one.firstfloor.org>
	 <20080426202323.GA14245@infradead.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 10:06:51 +1000
Message-Id: <1209341212.23166.122.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Sat, 2008-04-26 at 16:23 -0400, Christoph Hellwig wrote:
> 
> 
> 
> 
>                              Date: 
> Sat, 26 Apr 2008 16:23:23 -0400
> (Sun, 06:23 EST)
> 
> 
> On Sat, Apr 26, 2008 at 10:26:30PM +0200, Andi Kleen wrote:
> > > STATIC as defined by xfs already does this..
> > 
> > Weird. Unexpected. Different from everyone else. Is this some
> exercise in 
> > obfuscation?
> 
> The whole STATIC thing is weird to start with..
> 

Having to compile chunks of XFS code in both kernel and
userspace is also wierd (relative to other drivers), and
its a side-effect of needing to do that (all the code
dealing with specifics of ondisk format is shared).

cheers.

-- 
Nathan
