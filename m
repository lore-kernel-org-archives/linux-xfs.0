Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:17262 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751303AbeCVWEu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 18:04:50 -0400
Date: Fri, 23 Mar 2018 09:04:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/9] xfs: sanity-check the unused space before trying
 to use it
Message-ID: <20180322220446.GS1150@dastard>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <152107377649.19571.3126019873391787136.stgit@magnolia>
 <20180322055912.GP4818@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180322055912.GP4818@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Wed, Mar 21, 2018 at 10:59:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_dir2_data_use_free, we examine on-disk metadata and ASSERT if
> it doesn't make sense.  Since a carefully crafted fuzzed image can cause
> the kernel to crash after blowing a bunch of assertions, let's move
> those checks into a validator function and rig everything up to return
> EFSCORRUPTED to userspace.  Found by lastbit fuzzing ltail.bestcount via
> xfs/391.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: release buffers defensively, fix some formatting weirdness
....
> +	if ((char *)dup - (char *)hdr !=
> +	    be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)))
> +		return __this_address;

Also this (new logic statement vs multiline continuation).

	if ((char *)dup - (char *)hdr !=
			be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)))
		return __this_address;

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
