Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 15:33:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m99MVsei029328
	for <linux-xfs@oss.sgi.com>; Thu, 9 Oct 2008 15:31:54 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEC314DC0F3
	for <linux-xfs@oss.sgi.com>; Thu,  9 Oct 2008 15:33:32 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id hoxZG7mfOlmTFVUr for <linux-xfs@oss.sgi.com>; Thu, 09 Oct 2008 15:33:32 -0700 (PDT)
Date: Fri, 10 Oct 2008 09:33:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/7] XFS: dynamic busy extent tracking
Message-ID: <20081009223328.GI9597@disturbed>
References: <1223417377-8679-1-git-send-email-david@fromorbit.com> <200810092017.33042.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810092017.33042.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

On Thu, Oct 09, 2008 at 08:17:32PM +0200, Martin Steigerwald wrote:
> 
> Hi Dave,
> 
> Am Mittwoch 08 Oktober 2008 schrieb Dave Chinner:
> > The busy extent tracking in XFS is currently very static and has
> > some performance issues. We can only track 128 busy extents per AG,
> > and when we overflow this we fall back to synchronous transactions.
> > Also, every time we re-use a busy extent we cause a synchronous log
> > force, which stops all allocation and freeing in that AG while the
> > log force is in progress.
> 
> Could this accelerate
> 
> tar -xf linux-2.6.26.tar.gz
> rm -r linux-2.6.26

Not really. There is very little reuse of freed extents in this
type of workload. It's when you have 10 users on the filesystem
all doing that sort of thing that it will make a difference.

> ?
> 
> A student in the Linux Performance Tuning course I hold this week compared 
> this with ext3, even with the improved mkfs.xfs options (but without 
> lazy-count=1, cause mkfs.xfs from Debian Etch is too old) and even with 
> noop as IO scheduler. AFAIR XFS took roughly 3-4 times as long as Ext3, I 
> did not note the exact numbers. This was with 2.6.25. I can repeat the 
> test locally with 2.6.26.5 if wanted.

Yes, that's par for the course. XFS journals transactions almost
immediately, whereas ext3 gathers lots of changees in memory and
checkpoints infrequently. Hence XFS writes a lot more to the
journal and is hence slower. The dynamic extent tracking is a
necessary step to moving the XFS journalling to a more
checkpoint-like setup which would perform much less journal
I/O and hence run substantially faster....

See the asynchronous transaction aggregation section here:

http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
