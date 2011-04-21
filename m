Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LHx2PG168144 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 12:59:02 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56B20400722
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:02:29 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id HSYLrasuWrD4MiEP for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:02:29 -0700 (PDT)
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: buffered writeback torture program
In-reply-to: <20110421174120.GA7267@infradead.org>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org>
	<1303407205-sup-6141@think> <20110421174120.GA7267@infradead.org>
Date: Thu, 21 Apr 2011 14:00:29 -0400
Message-Id: <1303408265-sup-2454@think>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe <axboe@kernel.dk>, jack <jack@suse.cz>, xfs <xfs@oss.sgi.com>, dchinner <dchinner@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

Excerpts from Christoph Hellwig's message of 2011-04-21 13:41:21 -0400:
> On Thu, Apr 21, 2011 at 01:34:44PM -0400, Chris Mason wrote:
> > Sorry, this doesn't do it.  I think that given what a strange special
> > case this is, we're best off waiting for the IO-less throttling, and
> > maybe changing the code in xfs/ext4 to be a little more seek aware.  Or
> > maybe not, it has to get written eventually either way.
> 
> I'm not sure what you mean with seek aware.  XFS only clusters
> additional pages that are in the same extent, and in fact only does
> so for asynchrononous writeback.  Not sure how this should be more
> seek aware.
> 

How big are extents?  fiemap tells me the file has a single 8GB extent.

There's a little room for seeking inside there.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
