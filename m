Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:36815 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1031527AbeBNWn2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 17:43:28 -0500
Date: Thu, 15 Feb 2018 09:43:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: rewrite the fdatasync optimization
Message-ID: <20180214224326.GL7000@dastard>
References: <20180205073933.17065-1-hch@lst.de>
 <20180205221726.c2hdvaairki27gxf@destitution>
 <20180206072356.GB1649@lst.de>
 <20180208231725.GH20266@dastard>
 <20180213150402.GA15030@lst.de>
 <20180213232640.GG6778@dastard>
 <20180214155343.GA4472@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180214155343.GA4472@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>

On Wed, Feb 14, 2018 at 04:53:43PM +0100, Christoph Hellwig wrote:
> Ok, for the case where the same file also accessed throught NFS is
> locally written and fdatasync we'll run into an issue.
> 
> But we already have the exact same issue on NFSv3 which always uses
> ctime and never looks at iversion.

The NFSv3 server won't be querying the iversion field, so on
upstream kernels it will never change or need to be logged on local
fs accesses. Hence I don't think we need to care about NFSv3 at all
here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
