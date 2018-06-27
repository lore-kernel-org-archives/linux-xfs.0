Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:63058 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932649AbeF0BDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 21:03:49 -0400
Date: Wed, 27 Jun 2018 11:02:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/21] xfs: add helper to decide if an inode has
 allocated cow blocks
Message-ID: <20180627010254.GC19934@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986822251.3155.14348466047540978889.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152986822251.3155.14348466047540978889.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 24, 2018 at 12:23:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a helper to decide if an inode has real or unwritten extents in the
> CoW fork.  The upcoming repair freeze functionality will have to know if
> it's safe to iput an inode -- if the inode has incore any state that
> would require a transaction to unwind during iput, we'll have to defer
> the iput.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Seems ok, but I really can't review this in isolation because at
this point I've got no idea what it's calling context is.

i.e. I'm not going to say this is OK until I see how/why/where
delayed iput()s are used.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
