Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 18:19:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7R1Ispd002355
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 18:18:54 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1867FFCAA23
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 18:20:17 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id PofhK2s2IXKrWP08 for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 18:20:17 -0700 (PDT)
Date: Wed, 27 Aug 2008 11:20:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080827012013.GC5706@disturbed>
References: <20080821051508.GB5706@disturbed> <200808211933.34565.nickpiggin@yahoo.com.au> <20080821170854.GJ5706@disturbed> <200808221229.11069.nickpiggin@yahoo.com.au> <20080825015922.GP5706@disturbed> <20080825120146.GC20960@shareable.org> <20080826030759.GY5706@disturbed> <alpine.DEB.1.10.0808252041300.29665@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808252041300.29665@asgard.lang.hm>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: david@lang.hm
Cc: Jamie Lokier <jamie@shareable.org>, Nick Piggin <nickpiggin@yahoo.com.au>, gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Aug 25, 2008 at 08:50:14PM -0700, david@lang.hm wrote:
> it sounds as if the various flag definitions have been evolving, would it 
> be worthwhile to sep back and try to get the various filesystem folks to  
> brainstorm together on what types of hints they would _like_ to see  
> supported?

Three types:

	1. immediate dispatch - merge first with adjacent requests
	   then dispatch
	2. delayed dispatch - queue for a short while to allow
	   merging of requests from above
	3. bulk data - queue and merge. dispatch is completely
	   controlled by the elevator

Basically most metadata and log writes would fall into category 2,
which every logbufs/2 log writes or every log force using a category
1 to prevent log I/O from being stalled too long by other I/O.

Data writes from the filesystem would appear as category 3 (read and write)
and are subject to the specific elevator scheduling. That is, things
like the CFQ ionice throttling would work on the bulk data queue,
but not the other queues that the filesystem is using for metadata.

Tagging the I/O as a sync I/O can still be done, but that only
affects category 3 scheduling - category 1 or 2 would do the same
thing whether sync or async....

> it sounds like you are using 'sync' for things where you really should be 
> saying 'metadata' (or 'journal contents'), it's happened to work well  
> enough in the past, but it's forcing you to keep tweaking the 
> filesystems.

Right, because there was no 'metadata' tagging, and 'sync' happened
to do exactly what we needed on all elevators at the time.

> it may be better to try and define things from the 
> filesystem point of view and let the elevators do the tweaking.
>
> basicly I'm proposing a complete rethink of the filesyste <-> elevator  
> interface.

Yeah, I've been saying that for a while w.r.t. the filesystem/block
layer interfaces, esp. now with discard requests, data integrity,
device alignment information, barriers, etc being exposed by the
layers below the filesystem, but with no interface for filesystems
to be able to access that information...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
