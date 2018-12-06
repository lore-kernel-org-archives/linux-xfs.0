Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49026 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbeLFQcM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Dec 2018 11:32:12 -0500
Date: Thu, 6 Dec 2018 08:32:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: COW improvements and always_cow support V3
Message-ID: <20181206163201.GA27183@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181206010550.GN24487@magnolia>
 <20181206041606.GA12563@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206041606.GA12563@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 06, 2018 at 05:16:06AM +0100, Christoph Hellwig wrote:
> On Wed, Dec 05, 2018 at 05:05:50PM -0800, Darrick J. Wong wrote:
> > Hmm, so I tried running xfstests with quota enabled and -g all and
> > always_cow=1, and saw a bunch of test failures.  Are these expected?
> > A always_cow=0 run seems to have run fine.
> > 
> > (generic/050 might just be broken so don't spend too much energy on
> > that one)
> 
> What xfstests options are you using for this "quota enabled" run?

Nothing particularly special:

MKFS_OPTIONS='-f -m reflink=1,rmapbt=1 -i sparse=1 /dev/sdb'
MOUNT_OPTIONS='-o usrquota,grpquota,prjquota /dev/sdb /opt'

--D
