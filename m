Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Jul 2007 17:01:48 -0700 (PDT)
Received: from rgminet02.oracle.com (rgminet02.oracle.com [148.87.113.119])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6301itL013266
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 17:01:45 -0700
Received: from rgminet01.oracle.com (rgminet01.oracle.com [148.87.113.118])
	by rgminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l62NIZoJ026335
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 17:18:35 -0600
Date: Mon, 2 Jul 2007 16:18:12 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [-mm PATCH] ocfs2: ->fallocate() support
Message-ID: <20070702231812.GA15463@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070621190143.GC17713@ca-server1.us.oracle.com> <20070630093413.GE22354@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630093413.GE22354@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Amit Arora <aarora@in.ibm.com>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Sat, Jun 30, 2007 at 10:34:13AM +0100, Christoph Hellwig wrote:
> Btw, it seems like ocfs implements the xfs preallocation ioctls.  What
> would people thing about moving those up to work over ->fallocate so they
> can be used on all filesystems that support preallocation?

That sounds like a good idea. We've already got a very good match on
RESVP/UNRESVP with the various ->fallocate flags.

I'm not sure whether we want to do this for ALLOCSP/FREESP - as far as I've
heard those are hardly used.


> While the ABI is quite ugly it has a huge userbase because it's the only
> existing preallocation mechanism on Linux.

Yeah, that was the primary reason I chose to implement the ioctl (along with
the ->fallocate patch)
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
