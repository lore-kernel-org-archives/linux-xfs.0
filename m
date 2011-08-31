Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7V3Tcgj174727 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 22:29:38 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 178FC13B28F7
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 20:32:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	sOqwkKSeHYh1Sdvw for <xfs@oss.sgi.com>;
	Tue, 30 Aug 2011 20:32:59 -0700 (PDT)
Date: Wed, 31 Aug 2011 13:29:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Message-ID: <20110831032932.GI32358@dastard>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110825060632.GA9933@infradead.org>
	<20110825064039.GO3162@dastard>
	<0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca>
	<20110826013528.GW3162@dastard> <4E5D8B8E.8030401@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E5D8B8E.8030401@oracle.com>
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
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, viro@ZenIV.linux.org.uk

On Tue, Aug 30, 2011 at 06:17:02PM -0700, Sunil Mushran wrote:
> On 08/25/2011 06:35 PM, Dave Chinner wrote:
> >Agreed, that's the way I'd interpret it, too. So perhaps we need to
> >ensure that this interpretation is actually tested by this test?
> >
> >How about some definitions to work by:
> >
> >Data: a range of the file that contains valid data, regardless of
> >whether it exists in memory or on disk. The valid data can be
> >preceeded and/or followed by an arbitrary number of zero bytes
> >dependent on the underlying implementation of hole detection.
> >
> >Hole: a range of the file that contains no data or is made up
> >entirely of  NULL (zero) data. Holes include preallocated ranges of
> >files that have not had actual data written to them.
> >
> >Does that make sense? It has sufficient flexibility in it for the
> >existing generic "non-implementation", allows for filesystems to
> >define their own hole detection boundaries (e.g. filesystem block
> >size), and effectively defines how preallocated ranges from
> >fallocate() should be treated (i.e. as holes). If we can agree on
> >those definitions, I think that we should document them in both the
> >kernel and the man page that defines SEEK_HOLE/SEEK_DATA so everyone
> >is on the same page...
> 
> We should not tie in the definition to existing fs technologies.

Such as? If we don't use well known, well defined terminology, we
end up with ambiguous, vague functionality and inconsistent
implementations.

> Instead
> we should let the fs weigh the cost of providing accurate information
> with the possible gain in performance.
> 
> Data:
> A range in a file that could contain something other than nulls.
> If in doubt, it is data.
> 
> Hole:
> A range in a file that only contains nulls.

And that's -exactly- the ambiguous, vague definition that has raised
all these questions in the first place. I was in doubt about whether
unwritten extents can be considered a hole, and by your definition
that means it should be data. But Andreas seems to be in no doubt it
should be considered a hole.

Hence if I implement XFS support and Andreas implements ext4 support
by your defintion, we end with vastly different behaviour even
though the two filesystems use the same underlying technology for
preallocated ranges. That's exactly the inconsistency in
implementation that I'd like us to avoid.

IOWs, the definition needs to be clear enough to prevent these
inconsistencies from occurring. Indeed, the phrase "preallocated
ranges that have not had data written to them" is as independent of
filesystem implementation or technologies as possible. However,
because Linux supports preallocation (unlike our reference
platform), and we encourage developers to use it where appropriate,
it is best that we define how we expect such ranges to behave
clearly. That makes life easier for everyone.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
