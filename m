Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36326 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdDLGo2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 02:44:28 -0400
Date: Tue, 11 Apr 2017 23:44:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] xfs: remove xfs_bmap_remap_alloc
Message-ID: <20170412064420.GB5109@birch.djwong.org>
References: <20170411111011.9437-1-hch@lst.de>
 <20170411111011.9437-6-hch@lst.de>
 <20170411230246.GG8502@birch.djwong.org>
 <20170412053839.GA19900@lst.de>
 <20170412055535.GI8502@birch.djwong.org>
 <20170412060026.GB20204@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412060026.GB20204@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 08:00:26AM +0200, Christoph Hellwig wrote:
> > Looks like _bmapi_remap needs to be able to _iread_extents() if the
> > data fork hasn't been loaded during log recovery.
> 
> Yeah, probably.  I'll respin once more with that included.

Unfortunately, even after adding in the necessary loading code I still
get -ENOSPC back from xfs_bmap_add_extent_hole_real which causes log
recovery to fail.

--D
