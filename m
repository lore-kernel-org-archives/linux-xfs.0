Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5FE8D7F37
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 13:23:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2EB92304053
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 11:23:48 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id M7AkzaRL3yPYjtCi (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 14 Oct 2015 11:23:45 -0700 (PDT)
Date: Wed, 14 Oct 2015 11:23:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/51] xfs_db: enable blockget for v5 filesystems
Message-ID: <20151014182344.GA28670@infradead.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050558.1504.97525.stgit@birch.djwong.org>
	<20151014170818.GA10559@infradead.org>
	<20151014182013.GK10397@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151014182013.GK10397@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Oct 14, 2015 at 11:20:13AM -0700, Darrick J. Wong wrote:
> > As is this makes xfstests rather unhappy by failing tests.  I'm not
> > sure if that's issues in the blockget / xfs_check functionality or
> > because it actually finds bugs in the kernel code.
> 
> Which tests, specifically?  I ran all the tests in the 'quick' group and of
> the relatively few errors I saw, I couldn't trace any of them back to blockget.
> 
> Earlier patch editions caused such problems, but afaict I've fixed them all. :)

shared/006 xfs/076 xfs/206 xfs/250

although xfs/206 also fails just due to reflink output from mkfs, but
I'll send a patch for that soon.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
