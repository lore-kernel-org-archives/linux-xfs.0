Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P6eiJs169823 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 01:40:44 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C3C1139BF41
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 23:43:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	c89VNqdDzQQ2QbxC for <xfs@oss.sgi.com>;
	Wed, 24 Aug 2011 23:43:33 -0700 (PDT)
Date: Thu, 25 Aug 2011 16:40:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Message-ID: <20110825064039.GO3162@dastard>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110825060632.GA9933@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110825060632.GA9933@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Thu, Aug 25, 2011 at 02:06:32AM -0400, Christoph Hellwig wrote:
> On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
> > This is a test to make sure seek_data/seek_hole is acting like it does on
> > Solaris.  It will check to see if the fs supports finding a hole or not and will
> > adjust as necessary.
> 
> Can you resend this with any updates that happened in the meantime?
> 
> Dave also still had some comments about semantics, so it might be worth
> to incorporate that as well.

The main questions I had when looking at this was how we should
handle unwritten extents - the only answer I got was along the lines
of "we'll deal with that once filesystems have implemented
something". That's a bit of a chicken-and-egg situation, and doesn't
help me decide what is the best thing to do. I don't want to have to
re-implement this code when it's decided i did the wrong thing
initially.

The most basic question I really want answered is this:

	- is preallocated space a HOLE, or is it DATA?

Whatever the answer, I think it should be consistently
presented by all filesystems that support preallocation, and it
should be encoded into the generic SEEK_HOLE/SEEK_DATA tests....

Answering that question then helps answer the more complex questions
I had, like:

	- what does SEEK_DATA return when you have a file layout
	  like "hole-prealloc-data"?

Answers to that sort of question need to be known so we can write
corner-case tests to correctly verify the filesystem implementation.

I like to do better than present userspace with an interface that
behaves vastly different depending on the underlying filesystem, but
if the answer is "definition and implementation is entirely
filesystem specific" then I'll just go make something up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
