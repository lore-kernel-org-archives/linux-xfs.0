Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 057E57CA1
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 11:03:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF90C304043
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 09:03:55 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id oAOc5Qki4WQI9ERb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 09:03:53 -0700 (PDT)
Date: Thu, 11 Aug 2016 18:03:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: fix bogus space reservation in
	xfs_iomap_write_allocate
Message-ID: <20160811160352.GA23283@lst.de>
References: <1470245586-14068-1-git-send-email-hch@lst.de>
	<20160805000354.GD16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160805000354.GD16044@dastard>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Aug 05, 2016 at 10:03:54AM +1000, Dave Chinner wrote:
> I don't think this part of the fix is correct. nres feeds into
> args->total which is then used during the AGFL fixup checks. If this
> is not set correctly, then we'll select AGs we have enough space in
> the AG to fix up the AGFL, but not enough space to allocate all the
> BMBT blocks we require. That then leads to ABBA deadlocks on AGF
> locks near ENOSPC - see commit dbd5c8c ("xfs: pass total block
> res. as total xfs_bmapi_write() parameter") for the full details.

I've been going forth and back between both versions and both have
tested fine - I couldn't really convince me which one is more correct.

> I've been testing a local version of this fix since you pointed out
> the problem that still passed nres into xfs_bmapi_write() and I
> haven't seen any problems, so I think it is correct to keep nres
> here. I'm going to drop this hunk from this patch for the moment in
> my tree.

Ok, sounds fine.  If you want a real resend let me know.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
