Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:42032 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750903AbcJJFZA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 01:25:00 -0400
Date: Mon, 10 Oct 2016 16:24:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] xfs: check inode reflink flag before calling reflink
 functions
Message-ID: <20161010052419.GP9806@dastard>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588165195.12127.15898847119499370449.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147588165195.12127.15898847119499370449.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Fri, Oct 07, 2016 at 04:07:32PM -0700, Darrick J. Wong wrote:
> There are a couple of places where we don't check the inode's
> reflink flag before calling into the reflink code.  Fix those,
> and add some asserts so we don't make this mistake again.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Brian Foster <bfoster@redhat.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
