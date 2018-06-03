Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11967 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751132AbeFCXzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:55:22 -0400
Date: Mon, 4 Jun 2018 09:55:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/10] xfs: don't assert when on-disk btree pointers are
 garbage
Message-ID: <20180603235520.GB10363@dastard>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
 <152806816098.18187.494409176600320204.stgit@magnolia>
 <20180603234930.GZ10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180603234930.GZ10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 09:49:30AM +1000, Dave Chinner wrote:
> On Sun, Jun 03, 2018 at 04:22:41PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Don't ASSERT when we encounter bad on-disk btree pointers in the debug
> > check functions.  Log the error to leave breadcrumbs and let the upper
> > layers deal with it.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_btree.c |   23 ++++++++++++++++-------
> >  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> Isn't this the same checks that were in the last patch? Can
> you lift xfs_btree_check_ptr() out of the debug only code, and
> make the previous patch call it?

Another thought on this - we can get rid of all the ifdef DEBUG
wrappers around xfs_btree_check_ptr() for debug kernels by adding:

#ifdef DEBUG
#define xfs_btree_debug_check_ptr	xfs_btree_check_ptr
else
#define xfs_btree_debug_check_ptr(...)	0
#endif

or do something like xfs_dir3_data_check/__xfs_dir3_data_check().
That will clean the core btree code up a fair bit...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
