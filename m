Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:4120 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750881AbcJJF0F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 01:26:05 -0400
Date: Mon, 10 Oct 2016 16:25:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/7] xfs: reduce stack usage of _reflink_clear_inode_flag
Message-ID: <20161010052527.GQ9806@dastard>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588165809.12127.6624984020251009472.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147588165809.12127.6624984020251009472.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Fri, Oct 07, 2016 at 04:07:38PM -0700, Darrick J. Wong wrote:
> The loop in _reflink_clear_inode_flag isn't necessary since we
> jump out if any part of any extent is shared.  Remove the loop
> and we no longer need two maps, so we can save some stack use.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Brian Foster <bfoster@redhat.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
