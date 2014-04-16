Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 268B529DFD
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 09:27:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F26848F8033
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 07:27:51 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 84g5UUj4RBHXSHiw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 07:27:49 -0700 (PDT)
Date: Wed, 16 Apr 2014 07:27:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: unmount does not wait for shutdown during unmount
Message-ID: <20140416142748.GB32449@infradead.org>
References: <1397104955-7247-1-git-send-email-david@fromorbit.com>
	<20140414192824.GC62307@bfoster.bfoster>
	<20140415021546.GD31578@dastard>
	<20140415145924.GA3470@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140415145924.GA3470@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: bob.mastors@solidfire.com, snitzer@redhat.com, xfs@oss.sgi.com

On Tue, Apr 15, 2014 at 10:59:25AM -0400, Brian Foster wrote:
> Yeah, I noticed that the completion wouldn't fire as is since it appears
> that doesn't occur if a b_iodone call is provided. FWIW, the thought
> process was more to inherit the use of b_iowait in xlog_iodone().

That doesn't mean the b_iodone callback couldn't do the wakeup on
b_iowait.

I have to say it makes me a bit uneasy that we had to find this
race the hard way for the superblock, and now for the logbufs again.

Seems like all other uncached buffers are only read and written
synchronously, so for this should be the last issue, but I fear about
new ones showing up in the future and would prefer a more general
solution.

Reluctantly:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
