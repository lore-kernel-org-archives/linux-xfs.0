Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:55434 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1030463AbeF2Cws (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 22:52:48 -0400
Date: Fri, 29 Jun 2018 12:52:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/21] xfs: scrub should set preen if attr leaf has holes
Message-ID: <20180629025245.GF2234@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986832932.3155.15710387334363948384.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152986832932.3155.15710387334363948384.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 24, 2018 at 12:25:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If an attr block indicates that it could use compaction, set the preen
> flag to have the attr fork rebuilt, since the attr fork rebuilder can
> take care of that for us.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Oh, that's an easy one :P

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
