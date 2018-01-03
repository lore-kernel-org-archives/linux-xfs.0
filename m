Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:44681 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750922AbeACAdC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 19:33:02 -0500
Date: Wed, 3 Jan 2018 11:32:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/20] xfs: provide a centralized method for verifying
 inline fork data
Message-ID: <20180103003258.GD5858@dastard>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399130564.23543.3415524034974708060.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151399130564.23543.3415524034974708060.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 05:08:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace the current haphazard dir2 shortform verifier callsites with a
> centralized verifier function that can be called either with the default
> verifier functions or with a custom set.  This helps us strengthen
> integrity checking while providing us with flexibility for repair tools.
> 
> xfs_repair wants this to be able to supply its own verifier functions
> when trying to fix possibly corrupt metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
