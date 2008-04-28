Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 03:31:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3SAVQSt001879
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 03:31:27 -0700
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDD1312150D4
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 03:32:09 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by cuda.sgi.com with ESMTP id eVSD4086dsTqjNIt for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 03:32:09 -0700 (PDT)
Message-ID: <4815A7A5.9040507@firstfloor.org>
Date: Mon, 28 Apr 2008 12:32:05 +0200
From: Andi Kleen <andi@firstfloor.org>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com>	 <87iqy4wfjq.fsf@basil.nowhere.org> <20080426200701.GA10883@infradead.org>	 <20080426202630.GG17905@one.firstfloor.org>	 <20080426202323.GA14245@infradead.org> <1209341212.23166.122.camel@edge.scott.net.au>
In-Reply-To: <1209341212.23166.122.camel@edge.scott.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: Christoph Hellwig <hch@infradead.org>, Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org


> Having to compile chunks of XFS code in both kernel and
> userspace is also wierd (relative to other drivers),

Perhaps it would be a good idea to mark the files where that is expected
to work clearly.

> and
> its a side-effect of needing to do that (all the code
> dealing with specifics of ondisk format is shared).

But does that really need "STATIC"? Seems doubtful to me.

-Andi
