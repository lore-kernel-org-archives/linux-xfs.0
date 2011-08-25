Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P6pxTD170639 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 01:51:59 -0500
Received: from idcmail-mo2no.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B6C11C02CF0
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 23:51:57 -0700 (PDT)
Received: from idcmail-mo2no.shaw.ca (idcmail-mo2no.shaw.ca [64.59.134.9]) by
	cuda.sgi.com with ESMTP id 53TXfUpaZMVSEtHq for
	<xfs@oss.sgi.com>; Wed, 24 Aug 2011 23:51:57 -0700 (PDT)
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Mime-Version: 1.0 (Apple Message framework v1084)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20110825064039.GO3162@dastard>
Date: Thu, 25 Aug 2011 00:51:56 -0600
Message-Id: <0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110825060632.GA9933@infradead.org>
	<20110825064039.GO3162@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, viro@ZenIV.linux.org.uk

On 2011-08-25, at 12:40 AM, Dave Chinner wrote:
> On Thu, Aug 25, 2011 at 02:06:32AM -0400, Christoph Hellwig wrote:
>> On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
>>> This is a test to make sure seek_data/seek_hole is acting like it does on
>>> Solaris.  It will check to see if the fs supports finding a hole or not and will adjust as necessary.
>> 
>> Can you resend this with any updates that happened in the meantime?
>> 
>> Dave also still had some comments about semantics, so it might be worth
>> to incorporate that as well.
> 
> The main questions I had when looking at this was how we should
> handle unwritten extents - the only answer I got was along the lines
> of "we'll deal with that once filesystems have implemented
> something". That's a bit of a chicken-and-egg situation, and doesn't
> help me decide what is the best thing to do. I don't want to have to
> re-implement this code when it's decided i did the wrong thing
> initially.

Let's first clarify what you mean by an unwritten extent?  Do you mean a
preallocated extent that returns 0 when read, or do you mean a delayed
allocation extent that was written by the application that is still in
memory but not yet written to disk?

Unfortunately, ZFS has no concept of preallocated extents, so we can't
look to it for precedent, but it definitely has delayed allocation.
Possibly if UFS on Solaris has SEEK_HOLE and also preallocated extents
(I have no idea) it could be tested?

> The most basic question I really want answered is this:
> 
> 	- is preallocated space a HOLE, or is it DATA?
> 
> Whatever the answer, I think it should be consistently
> presented by all filesystems that support preallocation, and it
> should be encoded into the generic SEEK_HOLE/SEEK_DATA tests....

My thought would be that a preallocated extent is still a HOLE, because
it doesn't contain data that an application actually cares about.  On
the other hand, a delalloc extent is DATA because it has something that
an application cares about.

The original reason SEEK_HOLE/SEEK_DATA were brought up over FIEMAP was
"cp" being able to consistently access delalloc data that was only in
the page cache, so if we don't get that right it will have been a pointless
exercise.

> Answering that question then helps answer the more complex questions
> I had, like:
> 
> 	- what does SEEK_DATA return when you have a file layout
> 	  like "hole-prealloc-data"?

I would think only the "data" part, since that is what the definition
of "SEEK_DATA" is IMHO.

> Answers to that sort of question need to be known so we can write
> corner-case tests to correctly verify the filesystem implementation.
> 
> I like to do better than present userspace with an interface that
> behaves vastly different depending on the underlying filesystem, but
> if the answer is "definition and implementation is entirely
> filesystem specific" then I'll just go make something up....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
