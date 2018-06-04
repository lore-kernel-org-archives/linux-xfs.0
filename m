Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:2863 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751232AbeFDV51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 17:57:27 -0400
Date: Tue, 5 Jun 2018 07:57:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: don't assert when on-disk btree pointers are
 garbage
Message-ID: <20180604215725.GS10363@dastard>
References: <152812862079.2736.15381483104759513267.stgit@magnolia>
 <152812864040.2736.215537024334765916.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152812864040.2736.215537024334765916.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 09:10:40AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't ASSERT when we encounter bad on-disk btree pointers in the debug
> check functions.  Log the error to leave breadcrumbs and let the upper
> layers deal with it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Make sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
