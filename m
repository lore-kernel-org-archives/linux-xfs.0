Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Apr 2008 11:54:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3QIsG8r015579
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 11:54:23 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8451315EDBB0
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 11:54:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id uEi7Mt5eowWenSby for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 11:54:57 -0700 (PDT)
Message-ID: <48137A7E.4000202@sandeen.net>
Date: Sat, 26 Apr 2008 13:54:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
References: <200804261651.02078.vda.linux@googlemail.com>
In-Reply-To: <200804261651.02078.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> Hi David,
> 
> This patch reduces xfs_bmap_btalloc() stack usage by 50 bytes
> by moving part of its body into a helper function.
> 
> This results in some variables not taking stack space in
> xfs_bmap_btalloc() anymore.
> 
> The helper itself does not call anything stack-deep.
> Stack-deep call to xfs_alloc_vextent() happen
> in xfs_bmap_btalloc(), as before.
> 
> Compile tested only.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> --
> vda
> 

Looks like a very good approach, it pushes a lot of large local vars off
into the helper.

There is one build-time problem if DEBUG is turned on:

        if (args.fsbno != NULLFSBLOCK) {
                ap->firstblock = ap->rval = args.fsbno;
                ASSERT(nullfb || fb_agno == args.agno ||
                       (ap->low && fb_agno < args.agno));

in xfs_bmap_btalloc, which no longer has an fb_agno variable which the
ASSERT macro uses.

Thanks,

-Eric
