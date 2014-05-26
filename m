Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C32B829DF8
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 17:40:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68DBCAC00A
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 15:40:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IlMBr9Jnoe0Ea3Ar for <xfs@oss.sgi.com>;
	Mon, 26 May 2014 15:40:47 -0700 (PDT)
Date: Tue, 27 May 2014 08:40:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 00/20] xfsprogs: introduce the free inode btree
Message-ID: <20140526224033.GP18954@dastard>
References: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

On Wed, May 07, 2014 at 08:21:39AM -0400, Brian Foster wrote:
> Hi all,
> 
> Here's v4 of the finobt series for xfsprogs. Patches 1-10 are unchanged
> as they are based on the corresponding kernel patches, which have now
> been merged.
> 
> v4 includes some fairly isolated fixes for mkfs and repair based on
> review feedback for v3:
> 
> 	http://oss.sgi.com/archives/xfs/2014-04/msg00239.html
> 
> Some concern was raised over xfs_repair performance based on the
> implementation of patch 17 in v3, so I have run a few repair tests on
> largish filesystems. Tests involved creating a large number of inodes on
> a 1TB 4xraid0, freeing a random percentage to populate the finobt and
> running xfs_repair (e.g., no actual corruptions). xfs_repair was run
> normally (with these patches) and with a change to skip the finobt
> processing via an xfs_sb_version_hasfinobt() hack. The tests were run on
> a 16xcpu, 32GB RAM server.

I still have some concerns about this simply based on the algorithm
and that it will come back an bite us eventually, but for the moment
I think you've done enough to show that it's not going to an
immediate issue.

I haven't seen anything else that needs fixing or causes problems,
so I'm going to merge it for 3.2.1.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
