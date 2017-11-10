Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:12437 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755255AbdKJBXO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 20:23:14 -0500
Date: Fri, 10 Nov 2017 12:23:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 1/5] xfs: check the uniqueness of the AGFL entries
Message-ID: <20171110012312.GG5858@dastard>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
 <151001660786.26786.14027251894350460924.stgit@magnolia>
 <20171109233944.GO26910@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171109233944.GO26910@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2017 at 03:39:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure we don't list a block twice in the agfl by copying the
> contents of the AGFL to an array, sorting it, and looking for
> duplicates.  We can easily check that the number of agfl entries we see
> actually matches the flcount, so do that too.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: check flcount, don't overflow buffer
> v2: minor reworks per dchinner review suggestions

Looks good. One minor nit:

> +	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount,
> +			KM_SLEEP | KM_NOFS);
> +	if (!sai.entries) {
> +		error = -ENOMEM;
> +		goto out;
> +	}

KM_SLEEP means "never fail", which would make either it or the error
checking redundant. I'd just drop the KM_SLEEP - it's not necessary
if we can handle ENOMEM effectively.

Otherwise it looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
