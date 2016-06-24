Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E420E7CA0
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 19:46:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77F6DAC003
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 17:46:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id qLBl8N4HCthLuuA5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 23 Jun 2016 17:46:48 -0700 (PDT)
Date: Thu, 23 Jun 2016 17:46:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 008/145] libxfs: add more list operations
Message-ID: <20160624004638.GA18415@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
	<146612709549.16048.6522744362673808871.stgit@birch.djwong.org>
	<20160624004022.GB12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160624004022.GB12670@dastard>
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

On Fri, Jun 24, 2016 at 10:40:22AM +1000, Dave Chinner wrote:
> On Thu, Jun 16, 2016 at 06:31:35PM -0700, Darrick J. Wong wrote:
> > Add some list operations that the deferred rmap code requires.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This has all come from the linux kernel, right?

Yes.

> Can you tell me
> which files it has come from so I can add it to the commit message?

lib/list_sort.c for all the list_sort stuff,
include/linux/list.h for the rest of the list_* stuff,
include/linux/kernel.h for container_of.

> Maybe it would be better to keep the list sorting code in it's own
> file (e.g. libxfs/list_sort.c) just to keep a bit of separation
> between the xfs code and code that is copied in from outside?

I'd wondered if it made more sense to do that, but (sort of arbitrarily
decided not to add more files).

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
