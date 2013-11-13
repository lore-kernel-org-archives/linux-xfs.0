Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B46EB7F55
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 15:10:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D8E7AC006
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:10:22 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	fBMQZSpHH8dvymRZ for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 13:10:20 -0800 (PST)
Date: Thu, 14 Nov 2013 08:10:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 00/11] xfs: introduce the free inode btree
Message-ID: <20131113211017.GI6188@dastard>
References: <1384353427-36205-1-git-send-email-bfoster@redhat.com>
	<20131113161711.GA14300@infradead.org>
	<5283BD1A.8000704@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5283BD1A.8000704@redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Nov 13, 2013 at 12:55:38PM -0500, Brian Foster wrote:
> On 11/13/2013 11:17 AM, Christoph Hellwig wrote:
> > I have to admit that I haven't followed this series as closely as I
> > should, but could you summarize the performance of it?  What workloads
> > does it help most, what workloads does it hurt and how much?
> > 
> 
> Hi Christoph,
> 
> Sure... this work is based on Dave's write up here:
> 
> http://oss.sgi.com/archives/xfs/2013-08/msg00344.html
> 
> ... where he also explains the general idea, which is basically to
> improve inode allocation performance on a large fs' that happens to be
> sparsely populated with inode chunks with free inodes. We do this by
> creating a second inode btree that only tracks inode chunks with at
> least one free inode.

This is a common problem for people use hard-link based backups
repositories when they start removing backups. It results in random
inode removal, and so allocation never hits the "no free inodes"
fast path. As a result, allocation speed can drop a couple of orders
of magnitude due to the added CPU overhead of searching for free
inodes to allocate. It is completely unpredictable as to when it will
occur, so one backup might run at full speed, and the next might
take 3-4x as long to complete....

> Sorry I don't have more specific numbers at the moment. Most of my
> testing so far has been the focused case and general reliability
> testing. I'll need to find some hardware worthy of performance testing,
> particularly to check for any potential negative effects of managing the
> secondary tree. I suppose I wouldn't expect it to be much worse than the
> overhead of managing two free space trees, but we'll see.
> Thoughts/suggestions appreciated, thanks.

The problem can be demonstrated with a single CPU and a single
spindle. Create a single AG filesystem of a 100GB, and populate it
with 10 million inodes.

Time how long it takes to create another 10000 inodes in a new
directory. Measure CPU usage.

Randomly delete 10,000 inodes from the original population to
sparsely populate the inobt with 10000 free inodes.

Time how long it takes to create another 10000 inodes in a new
directory. Measure CPU usage.

The difference in time and CPU will be diretly related to the
addition time spent searching the inobt for free inodes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
