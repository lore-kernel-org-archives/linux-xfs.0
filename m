Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40888 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731386AbeLTWJk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 17:09:40 -0500
Date: Thu, 20 Dec 2018 14:09:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: COW improvements and always_cow support V3
Message-ID: <20181220220933.GE27208@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181206010550.GN24487@magnolia>
 <20181206200930.GA31797@lst.de>
 <20181217175922.GI24487@magnolia>
 <20181218180551.GA15138@lst.de>
 <20181219004411.GW27208@magnolia>
 <20181220070927.GB9803@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220070927.GB9803@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 20, 2018 at 08:09:27AM +0100, Christoph Hellwig wrote:
> On Tue, Dec 18, 2018 at 04:44:11PM -0800, Darrick J. Wong wrote:
> > FWIW one of my test vms seems to have hung in generic/323 with the xfs
> > for-next and your patches applied:
> > 
> > MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, /dev/sdf'
> > MOUNT_OPTIONS='/dev/sdf /opt'
> 
> I've run generic/323 with those settings in a loop over night and
> haven't reproduced it so far.

<nod> It's now shown up in one of my dev tree and TOT test run VMs, so
it would seem that it's not specific to the always_cow patches.

--D
