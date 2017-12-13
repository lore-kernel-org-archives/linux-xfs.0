Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40295 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751129AbdLMWM0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 17:12:26 -0500
Date: Thu, 14 Dec 2017 09:12:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8] xfs: fix tests to handle removal of no-alloc create
 nonfeature
Message-ID: <20171213221223.GZ4094@dastard>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314502196.18893.14496524309954254435.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151314502196.18893.14496524309954254435.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Dec 12, 2017 at 10:03:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We're removing from XFS the ability to perform no-allocation file
> creation.  This was added years ago because someone at SGI demanded that
> we still be able to create (empty?) files with zero free blocks

Just to correct the record, it wasn't SGI that demanded this - it
was implemented by SGI a long, long time ago (~1998) in response to
customer demands.

> remaining so long as there were free inodes and space in existing
> directory blocks.  This came at an unacceptable risk of ENOSPC'ing
> midway through a transaction and shutting down the fs, so we're removing
> it for the create case.

Well, 20 years later we consider it an unacceptible risk. :P

> However, some tests fail as a result, so fix them to be more flexible
> about not failing when a dir/file creation fails due to ENOSPC.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
