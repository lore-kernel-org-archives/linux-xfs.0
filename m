Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:50689 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751769AbeE2Dfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 May 2018 23:35:38 -0400
Date: Tue, 29 May 2018 13:29:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 07/22] xfs: add helpers to attach quotas to inodes
Message-ID: <20180529032929.GN10363@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642366309.1556.5697073197011046065.stgit@magnolia>
 <20180518035802.GE23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518035802.GE23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 17, 2018 at 08:58:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a helper routine to attach quota information to inodes that are
> about to undergo repair.  If that fails, we need to schedule a
> quotacheck for the next mount but allow the corrupted metadata repair to
> continue.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
> v2: improve documentation
> ---

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
