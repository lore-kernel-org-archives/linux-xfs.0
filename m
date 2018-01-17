Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41853 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751004AbeAQBDw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 20:03:52 -0500
Date: Wed, 17 Jan 2018 12:02:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 19/21] xfs: cross-reference refcount btree during scrub
Message-ID: <20180117010242.GH6304@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398988926.18741.14757152372859283463.stgit@magnolia>
 <20180116232715.GD5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116232715.GD5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 16, 2018 at 03:27:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During metadata btree scrub, we should cross-reference with the
> reference counts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: fix indenting and standardize helper naming, refactor helpers per dave's
>     suggestion and add clarifying comments
> v2: streamline scrubber arguments, remove stack allocated objects

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
