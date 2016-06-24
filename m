Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6FDEF7CA0
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 19:40:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B7DDFAC005
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 17:40:27 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jpo717iup26hhwxu for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2016 17:40:24 -0700 (PDT)
Date: Fri, 24 Jun 2016 10:40:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 008/145] libxfs: add more list operations
Message-ID: <20160624004022.GB12670@dastard>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
	<146612709549.16048.6522744362673808871.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612709549.16048.6522744362673808871.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:31:35PM -0700, Darrick J. Wong wrote:
> Add some list operations that the deferred rmap code requires.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This has all come from the linux kernel, right? Can you tell me
which files it has come from so I can add it to the commit message?
Maybe it would be better to keep the list sorting code in it's own
file (e.g. libxfs/list_sort.c) just to keep a bit of separation
between the xfs code and code that is copied in from outside?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
