Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 16:52:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3SNpwnr023312
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 16:52:01 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CDF4FEA03
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 16:52:42 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id bHjkUEF830AZoi3p for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 16:52:42 -0700 (PDT)
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <4815A7A5.9040507@firstfloor.org>
References: 
	 <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com>
	 <87iqy4wfjq.fsf@basil.nowhere.org> <20080426200701.GA10883@infradead.org>
	 <20080426202630.GG17905@one.firstfloor.org>
	 <20080426202323.GA14245@infradead.org>
	 <1209341212.23166.122.camel@edge.scott.net.au>
	 <4815A7A5.9040507@firstfloor.org>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 09:52:33 +1000
Message-Id: <1209426754.23166.160.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 12:32 +0200, Andi Kleen wrote:
> > and
> > its a side-effect of needing to do that (all the code
> > dealing with specifics of ondisk format is shared).
> 
> But does that really need "STATIC"? Seems doubtful to me.

In userspace STATIC is defined to nothing, and the tools
(and/or libxfs) directly call into numerous functions that
are (really) static in the kernel.

cheers.

-- 
Nathan
