Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43228 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751310AbeBHQ6c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Feb 2018 11:58:32 -0500
Date: Thu, 8 Feb 2018 08:58:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] tests/xfs: rmapbt swapext block reservation overrun
 test
Message-ID: <20180208165828.GK5433@magnolia>
References: <20180208160429.17281-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180208160429.17281-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Feb 08, 2018 at 11:04:29AM -0500, Brian Foster wrote:
> The XFS rmapbt extent swap mechanism performs an extent by extent
> swap to ensure the rmapbt is rectified with the appropriate extent
> owner information after the operation. This implementation suffers
> from a corner case that requires extra reservation if the swap
> operation results in bouncing one of the associated inodes between
> extent and btree formats. When this corner case occurs, it results
> in a transaction block reservation overrun and possible corruption
> of the free space accounting.
> 
> This regression test provides coverage for this corner case. It
> creates two files with a large enough extent count to require btree
> format, regardless of inode size, and performs a sequence of extent
> swaps between them with a decreasing extent count until all extents
> are removed from the file(s). This ensures that one of the swaps
> covers the btree <-> extent fork format boundary case.
> 
> This test reproduces fs corruption on rmapbt enabled filesystems
> running on kernels without the associated extent swap fix.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
