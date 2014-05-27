Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED89A7F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 07:06:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A80618F8070
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 05:06:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8iweVDbPemNFoEUK for
	<xfs@oss.sgi.com>; Tue, 27 May 2014 05:06:25 -0700 (PDT)
Date: Tue, 27 May 2014 08:06:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v4 00/20] xfsprogs: introduce the free inode btree
Message-ID: <20140527120621.GA63281@bfoster.bfoster>
References: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
	<20140526224033.GP18954@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140526224033.GP18954@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, May 27, 2014 at 08:40:33AM +1000, Dave Chinner wrote:
> On Wed, May 07, 2014 at 08:21:39AM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > Here's v4 of the finobt series for xfsprogs. Patches 1-10 are unchanged
> > as they are based on the corresponding kernel patches, which have now
> > been merged.
> > 
> > v4 includes some fairly isolated fixes for mkfs and repair based on
> > review feedback for v3:
> > 
> > 	http://oss.sgi.com/archives/xfs/2014-04/msg00239.html
> > 
> > Some concern was raised over xfs_repair performance based on the
> > implementation of patch 17 in v3, so I have run a few repair tests on
> > largish filesystems. Tests involved creating a large number of inodes on
> > a 1TB 4xraid0, freeing a random percentage to populate the finobt and
> > running xfs_repair (e.g., no actual corruptions). xfs_repair was run
> > normally (with these patches) and with a change to skip the finobt
> > processing via an xfs_sb_version_hasfinobt() hack. The tests were run on
> > a 16xcpu, 32GB RAM server.
> 
> I still have some concerns about this simply based on the algorithm
> and that it will come back an bite us eventually, but for the moment
> I think you've done enough to show that it's not going to an
> immediate issue.
> 

Fair enough, it's certainly not the most efficient thing. ;) I'm just
hesitant to go and add more complex infrastructure and likely trade off
the resource consumption here without a clear cost/benefit win for that
approach. Very simple tests suggest we'd just be adding memory overhead.
But of course, repair isn't always going to be running against clean and
fairly new filesystems. Perhaps we'll see some different characteristics
when this hits some more interesting situations and that will help
determine how to optimize this algorithm. If anything comes up worth
testing in this regard, I'm happy to dig into it...

> I haven't seen anything else that needs fixing or causes problems,
> so I'm going to merge it for 3.2.1.
> 

Sounds good, thanks!

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
