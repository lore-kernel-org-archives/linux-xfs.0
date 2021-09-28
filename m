Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA12C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 00:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A781611C3
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 00:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238240AbhI1Ass (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:48:48 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:32829 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238236AbhI1Ass (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 20:48:48 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6DAA91053007;
        Tue, 28 Sep 2021 10:47:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mV1H1-00HVXM-R4; Tue, 28 Sep 2021 10:47:07 +1000
Date:   Tue, 28 Sep 2021 10:47:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 08/12] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
Message-ID: <20210928004707.GO1756565@dread.disaster.area>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-9-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916100647.176018-9-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Af7P4EfG c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=h-9boRcjp6GGoqKsSTkA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 03:36:43PM +0530, Chandan Babu R wrote:
> A future commit will introduce a 64-bit on-disk data extent counter and a
> 32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
> xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
> of these quantities.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

So while I was auditing extent lengths w.r.t. the last patch f the
series, I noticed that xfs_extnum_t is used in the struct
xfs_log_dinode and so changing the size of these types changes the
layout of this structure:

/*
 * Define the format of the inode core that is logged. This structure must be
 * kept identical to struct xfs_dinode except for the endianness annotations.
 */
struct xfs_log_dinode {
....
        xfs_rfsblock_t  di_nblocks;     /* # of direct & btree blocks used */
        xfs_extlen_t    di_extsize;     /* basic/minimum extent size for file */
        xfs_extnum_t    di_nextents;    /* number of extents in data fork */
        xfs_aextnum_t   di_anextents;   /* number of extents in attribute fork*/
....

Which means this:

> -typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
> -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> +typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
> +typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */

creates an incompatible log format change that will cause silent
inode corruption during log recovery if inodes logged with this
change are replayed on an older kernel without this change. It's not
just the type size change that matters here - it also changes the
implicit padding in this structure because xfs_extlen_t is a 32 bit
object and so:

Old					New
64 bit object (di_nblocks)		64 bit object (di_nblocks)
32 bit object (di_extsize)		32 bit object (di_extsize)
					32 bit pad (implicit)
32 bit object (di_nextents)		64 bit object (di_nextents)
16 bit object (di_anextents)		32 bit ojecct (di_anextents
8 bit object (di_forkoff)		8 bit object (di_forkoff)
8 bit object (di_aformat)		8 bit object (di_aformat)
					16 bit pad (implicit)
32 bit object (di_dmevmask)		32 bit object (di_dmevmask)


That's quite the layout change, and that's something we must not do
without a feature bit being set. hence I think we need to rev the
struct xfs_log_dinode version for large extent count support, too,
so that the struct xfs_log_dinode does not change size for
filesystems without the large extent count feature.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
