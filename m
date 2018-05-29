Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:59376 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932475AbeE2DOY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 May 2018 23:14:24 -0400
Date: Tue, 29 May 2018 13:14:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 04/22] xfs: add helpers to dispose of old btree blocks
 after a repair
Message-ID: <20180529031422.GK10363@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642364418.1556.17533271717583168316.stgit@magnolia>
 <20180518035347.GA23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518035347.GA23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Allison Henderson <allison.henderson@oracle.com>

On Thu, May 17, 2018 at 08:53:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've plumbed in the ability to construct a list of dead btree
> blocks following a repair, add more helpers to dispose of them.  This is
> done by examining the rmapbt -- if the btree was the only owner we can
> free the block, otherwise it's crosslinked and we can only remove the
> rmapbt record.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: document the design of how old btree block disposal is supposed to
>     work and document some of the limitations of the buffer cache that
>     we can't fix here, and reduce perag_get/put traffic

Yup, I can accept those limitations for the initial implementation.
Gotta leave something for you to work on once it's been merged,
right?

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
