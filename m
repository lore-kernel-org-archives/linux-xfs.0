Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:64893 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750996AbeACAfg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 19:35:36 -0500
Date: Wed, 3 Jan 2018 11:35:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/20] xfs: create a new buf_ops pointer to verify
 structure metadata
Message-ID: <20180103003532.GE5858@dastard>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399131789.23543.12974482465966519677.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151399131789.23543.12974482465966519677.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 05:08:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Expose all metadata structure buffer verifier functions via buf_ops.
> These will be used by the online scrub mechanism to look for problems
> with buffers that are already sitting around in memory.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks OK to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
