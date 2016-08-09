Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E4C087CA0
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 17:36:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56442AC001
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 15:36:17 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	oDr3PZuphCjwzoYN for <xfs@oss.sgi.com>;
	Tue, 09 Aug 2016 15:36:13 -0700 (PDT)
Date: Wed, 10 Aug 2016 08:35:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question on migrating data between PVs in xfs
Message-ID: <20160809223503.GJ19025@dastard>
References: <20160809145046.GB5583@ic>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160809145046.GB5583@ic>
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
To: Wei Lin <lin.wei15@imperial.ac.uk>
Cc: xfs@oss.sgi.com

On Tue, Aug 09, 2016 at 03:50:47PM +0100, Wei Lin wrote:
> Hi there,
> 
> I am working on an xfs based project and want to modify the allocation
> algorithm, which is quite involved. I am wondering if anyone could help
> with this.
> 
> The high level goal is to create xfs agains multiple physical volumes,
> allow user to specify the target PV for files, and migrate files
> automatically.

So, essentially tiered storage with automatic migration. Can you
describe the storage layout and setup you are thinking of using and
how that will map to a single XFS filesystem so we have a better
idea of what you are thinking of?

> I plan to implement the user interface with extended attributes, but am
> now stuck with the allocation/migration part. Is there a way to make xfs
> respect the attribute, i.e. only allocate blocks/extents from the target
> PV specified by user?

Define "PV".

XFS separates allocation by allocation group - it has no concept of
underlying physical device layout. If I understand what you , you have
multiple "physical volumes" set up in a single block device (somehow
- please describe!) and now you want to control how data is
allocated to those underlying volumes, right?

So what you're asking about is how to define and implement user
controlled allocation policies, right? Sorta like this old
prototype I was working on years ago?

http://oss.sgi.com/archives/xfs/2009-02/msg00250.html

And some more info from a later discussion:

http://oss.sgi.com/archives/xfs/2013-01/msg00611.html

And maybe in conjunction with this, which added groupings of AGs
together to form independent regions of "physical separation" that
the allocator could then be made aware of:

http://oss.sgi.com/archives/xfs/2009-02/msg00253.html

These were more aimed at defining failure domains for error and
corruption isolation:

http://xfs.org/index.php/Reliable_Detection_and_Repair_of_Metadata_Corruption#Failure_Domains

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
