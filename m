Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D5ED67F37
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 13:20:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A20F6304059
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 11:20:52 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 2C0LrMtHyzu6eNLb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 14 Oct 2015 11:20:45 -0700 (PDT)
Date: Wed, 14 Oct 2015 11:20:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/51] xfs_db: enable blockget for v5 filesystems
Message-ID: <20151014182013.GK10397@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050558.1504.97525.stgit@birch.djwong.org>
	<20151014170818.GA10559@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151014170818.GA10559@infradead.org>
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

On Wed, Oct 14, 2015 at 10:08:18AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 06, 2015 at 10:05:58PM -0700, Darrick J. Wong wrote:
> > Plumb in the necessary finobt scanning, magic number checks, and other
> > fixups required to handle v5 filesystems.  This makes it so that check
> > can spot-check v5 filesystems even though xfs_repair is now the
> > preferred fixer tool, which makes the xfstests fs check function a
> > little happier.
> 
> As is this makes xfstests rather unhappy by failing tests.  I'm not
> sure if that's issues in the blockget / xfs_check functionality or
> because it actually finds bugs in the kernel code.

Which tests, specifically?  I ran all the tests in the 'quick' group and of
the relatively few errors I saw, I couldn't trace any of them back to blockget.

Earlier patch editions caused such problems, but afaict I've fixed them all. :)

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
