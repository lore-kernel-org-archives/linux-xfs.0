Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B79A7F37
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 14:53:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A5548F8040
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 12:53:00 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id A4rBAJO3t60VixpH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 14 Oct 2015 12:52:55 -0700 (PDT)
Date: Wed, 14 Oct 2015 12:52:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/51] xfs_db: enable blockget for v5 filesystems
Message-ID: <20151014195227.GG11398@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050558.1504.97525.stgit@birch.djwong.org>
	<20151014170818.GA10559@infradead.org>
	<20151014182013.GK10397@birch.djwong.org>
	<20151014182344.GA28670@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151014182344.GA28670@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Oct 14, 2015 at 11:23:44AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 14, 2015 at 11:20:13AM -0700, Darrick J. Wong wrote:
> > > As is this makes xfstests rather unhappy by failing tests.  I'm not
> > > sure if that's issues in the blockget / xfs_check functionality or
> > > because it actually finds bugs in the kernel code.
> > 
> > Which tests, specifically?  I ran all the tests in the 'quick' group and of
> > the relatively few errors I saw, I couldn't trace any of them back to blockget.
> > 
> > Earlier patch editions caused such problems, but afaict I've fixed them all. :)
> 
> shared/006 xfs/076 xfs/206 xfs/250
> 
> although xfs/206 also fails just due to reflink output from mkfs, but
> I'll send a patch for that soon.

Hmm.  I suspect shared/006 and xfs/250 are fixed by Dave's patch to validate
AGI blocks with the AGI buf ops instead of the AGFL buf ops.  They don't
trigger errors now that I've rebased on xfsprogs 4.3-rc1.

I suspect xfs/076 fails because xfs_db doesn't know about sparse inodes.
That's probably because I haven't totally figured them out either.  I'll
have a look at that.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
