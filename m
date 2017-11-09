Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:59729 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751241AbdKICRg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 21:17:36 -0500
Date: Thu, 9 Nov 2017 13:17:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/5] xfs: only check da node header padding on v5
 filesystems
Message-ID: <20171109021709.GP4094@dastard>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
 <20171108205636.GG26910@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171108205636.GG26910@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2017 at 12:56:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It turns out that we only started zeroing a new da btree node's block
> header on v5 filesystems.  Prior to that, we just wouldn't set anything
> at all, which means that the pad field never got set and would retain
> whatever happened to be in memory.
> 
> Therefore, we can only check the pad for zeroness on v5 filesystems.
> shared/006 on a v4 filesystem exposes this scrub bug.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks good.


Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
