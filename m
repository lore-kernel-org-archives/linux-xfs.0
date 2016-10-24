Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:38513 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752089AbcJXDyn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Oct 2016 23:54:43 -0400
Date: Mon, 24 Oct 2016 14:54:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: defer should abort intent items if the trans roll
 fails
Message-ID: <20161024035434.GY14023@dastard>
References: <20161022021337.GC5256@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161022021337.GC5256@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2016 at 07:13:37PM -0700, Darrick J. Wong wrote:
> If the deferred ops transaction roll fails, we need to abort the intent
> items if we haven't already logged a done item for it, regardless of
> whether or not the deferred ops has had a transaction committed.  Dave
> found this while running generic/388.
> 
> Move the tracepoint to make it easier to track object lifetimes.
> 
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks good and fixes the hang here.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
