Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35382 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdLGATR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 19:19:17 -0500
Date: Wed, 6 Dec 2017 16:19:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove "no-allocation" reservations for file
 creations
Message-ID: <20171207001911.GR19219@magnolia>
References: <20170821082404.3387-1-hch@lst.de>
 <20170823202213.GA4796@magnolia>
 <20170824004755.GC21024@dastard>
 <20170829180445.GU4757@magnolia>
 <20170903072513.GA14807@lst.de>
 <20170903153150.GE4073@magnolia>
 <20171205013422.GC19219@magnolia>
 <20171205185936.GE19219@magnolia>
 <20171207000259.GA18701@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171207000259.GA18701@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Thu, Dec 07, 2017 at 01:02:59AM +0100, Christoph Hellwig wrote:
> On Tue, Dec 05, 2017 at 10:59:36AM -0800, Darrick J. Wong wrote:
> > I fixed most of the auto group regressions with small fixes to xfstests,
> > but xfs/013 is a problem because once we run out of space to create new
> > dirX we simply get nothing.  Will have to study the behavior of that
> > test in more depth...
> 
> With what kind of config do you see xfs/013 failures?

MKFS_OPTIONS='-m rmapbt=1,reflink=1 -i sparse=1'

I /think/ the fix is that the cp -Rl can sometimes fail to create
dir$((i+1)) because we happen to hit exactly the point where the cleaner
hasn't caught up with fsstress and so the dir$((i+1)) creation
transaction fails with ENOSPC.  AFAICT if I change that to:

while ! test -d $SCRATCH_MNT/dir$((i+1)); do
	cp -Rl ...
done

then xfs/013 exercises the finobt just fine and doesn't fail.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
