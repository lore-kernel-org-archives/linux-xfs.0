Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BAE457F37
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 13:54:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A22A30406A
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 11:54:06 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id XgxkDwfjM4X1oAi8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jan 2016 11:53:59 -0800 (PST)
Date: Wed, 20 Jan 2016 11:53:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Pass mp to kmem_alloc and friends?
Message-ID: <20160120195354.GA5500@birch.djwong.org>
References: <569FCAED.4050306@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <569FCAED.4050306@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Jan 20, 2016 at 11:59:09AM -0600, Eric Sandeen wrote:
> I had a request for the kmem_alloc deadlock warning to print the
> filesystem involved.
> 
> Any objections to passing mp into kmem_alloc() and friends whenever
> it's reasonably available from the caller?
> 
> It'd be a big mechanical change, don't want to embark on that unless
> it seems acceptable & useful.
> 
> I think we generally know the root causes of the most common deadlock
> warnings, but it's a warm fuzzy to give as much info as possible.
> 
> Heck, I almost wonder if passing a descriptive string in, for at
> least the problematic cases we know about, i.e. "extent map realloc"
> so we'd get something like:
> 
> XFS (sdb1): myprocess(123) possible memory allocation deadlock size 12345 during extent map realloc in kmem_alloc (mode:0x250)
> 
> I dunno ... too much? :)

Not enough?  What about putting in just enough macro madness to report
the name & line number of the calling function in the message?

XFS (sdb1): myprocess(123) possible kmem_alloc deadlock in
xfs_eat_my_data.c:5135 (size:12345 mode:0x250)

(or maybe a tracepoint?)

--D

> 
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
