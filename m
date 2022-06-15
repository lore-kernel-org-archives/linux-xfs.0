Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58841C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 01:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbiFOBJj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jun 2022 21:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiFOBJi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jun 2022 21:09:38 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 063E0344EE
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jun 2022 18:09:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 168F010E7A94;
        Wed, 15 Jun 2022 11:09:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1HXI-006kfc-VO; Wed, 15 Jun 2022 11:09:32 +1000
Date:   Wed, 15 Jun 2022 11:09:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 01/17] xfs: Add larp state XFS_DAS_CREATE_FORK
Message-ID: <20220615010932.GZ227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-2-allison.henderson@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a9314f
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=oyGgiOBm48xRfK-4ua4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:44AM -0700, Allison Henderson wrote:
> Recent parent pointer testing has exposed a bug in the underlying
> larp state machine.  A replace operation may remove an old attr
> before adding the new one, but if it is the only attr in the fork,
> then the fork is removed.  This later causes a null pointer in
> xfs_attr_try_sf_addname which expects the fork present.  This
> patch adds an extra state to create the fork.

Hmmmm.

I thought I fixed those problems - in xfs_attr_sf_removename() there
is this code:

        if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
            (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
            !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
                xfs_attr_fork_remove(dp, args->trans);

A replace operation will have XFS_DA_OP_REPLACE set, and so the
final remove from a sf directory will not remove the attr fork in
this case. There is equivalent checks in the leaf/node remove name
paths to avoid removing the attr fork if the last attr is removed
while the attr fork is in those formats.

How do you reproduce this issue?

> Additionally the new state will be used by parent pointers which
> need to add attributes to newly created inodes that do not yet
> have a fork.

We already have the capability of doing that in xfs_init_new_inode()
by passing in init_xattrs == true. So when we are creating a new
inode with parent pointers enabled, we know that we are going to be
creating an xattr on the inode and so we should always set
init_xattrs in that case.

This should avoid the need for parent pointers to ever need to run
an extra transaction to create the attr fork. Hence, AFAICT, this
new state to handle attr fork creation shouldn't ever be needed for
parent pointers....

What am I missing?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
