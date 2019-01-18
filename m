Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:55174 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbfARFEO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jan 2019 00:04:14 -0500
Date: Fri, 18 Jan 2019 16:04:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: don't crash when read verifier reports errors
 with null b_ops
Message-ID: <20190118050410.GH6173@dastard>
References: <20190115170820.GB12689@magnolia>
 <20190115224256.GF12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115224256.GF12689@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 15, 2019 at 02:42:56PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xrep_findroot_block, we work out the btree type and correctness of a
> given block by calling different btree verifiers on root block
> candidates.  However, we leave the NULL b_ops while ->verify_read
> validates the block, which means that if the verifier calls
> xfs_buf_verifier_error it'll crash on the null b_ops.  Fix it to avoid
> this crash.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: leave a comment about what we're doing above the function
> ---

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
