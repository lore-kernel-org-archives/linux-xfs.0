Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C5A577FCD
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 04:04:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5CE18F806F
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 02:04:56 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HWzO8sDDw9Zz07TQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Jul 2014 02:04:51 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1X7hcQ-0002dA-SR
	for xfs@oss.sgi.com; Thu, 17 Jul 2014 09:04:50 +0000
Date: Thu, 17 Jul 2014 02:04:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Error setting extent size on a directory
Message-ID: <20140717090450.GA27425@infradead.org>
References: <20140714070913.GA29541@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140714070913.GA29541@teal.hq.k1024.org>
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
To: xfs@oss.sgi.com

On Mon, Jul 14, 2014 at 09:09:13AM +0200, Iustin Pop wrote:
> The xfsctl man page says that an extent size should be settable any time
> on a directory, so why would this fail? Looking at the kernel sources,
> I see a number of possible cases where EINVAL is returned:

And no special casing for directories at all..

> So to me this reads as if the di_nextents check can also fail for a
> directory which has extents, contradicting the man page. Which one needs
> to be updated?
> 
> The question arises to if the extent size also applies, then, to
> allocating extents for a directory - instead of just being inherited for
> files (the man page says no).

We're not using the extent size hint on the directory itself.  So to
me it seems we just not check for already allocated blocks if we're
setting the extent size on a directory, but instead maybe make sure
the directory.  What's also a little odd is that we allow setting
the extent size on a directory even if the extent size inherit bit is
not set, which doesn't make much sense to me.

Do you want to prepare a patch to remove the check for directories?
At testcase for xfstests that ensures this works also would be highly
useful..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
