Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433ECC432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 21:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BE8C6103D
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 21:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhHaVxd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 17:53:33 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53191 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230085AbhHaVxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Aug 2021 17:53:33 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B77DE82AA72;
        Wed,  1 Sep 2021 07:52:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLBgI-007Dp3-8X; Wed, 01 Sep 2021 07:52:34 +1000
Date:   Wed, 1 Sep 2021 07:52:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v24 03/11] xfs: Set up infrastructure for log atrribute
 replay
Message-ID: <20210831215234.GU3657114@dread.disaster.area>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824224434.968720-4-allison.henderson@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=VuuVpTwVnpFNGkkUZeIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 24, 2021 at 03:44:26PM -0700, Allison Henderson wrote:
> Currently attributes are modified directly across one or more
> transactions. But they are not logged or replayed in the event of an
> error. The goal of log attr replay is to enable logging and replaying
> of attribute operations using the existing delayed operations
> infrastructure.  This will later enable the attributes to become part of
> larger multi part operations that also must first be recorded to the
> log.  This is mostly of interest in the scheme of parent pointers which
> would need to maintain an attribute containing parent inode information
> any time an inode is moved, created, or removed.  Parent pointers would
> then be of interest to any feature that would need to quickly derive an
> inode path from the mount point. Online scrub, nfs lookups and fs grow
> or shrink operations are all features that could take advantage of this.
> 
> This patch adds two new log item types for setting or removing
> attributes as deferred operations.  The xfs_attri_log_item will log an
> intent to set or remove an attribute.  The corresponding
> xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
> freed once the transaction is done.  Both log items use a generic
> xfs_attr_log_format structure that contains the attribute name, value,
> flags, inode, and an op_flag that indicates if the operations is a set
> or remove.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/Makefile                 |   1 +
>  fs/xfs/libxfs/xfs_attr.c        |   5 +-
>  fs/xfs/libxfs/xfs_attr.h        |  31 +++
>  fs/xfs/libxfs/xfs_defer.h       |   2 +
>  fs/xfs/libxfs/xfs_log_format.h  |  44 +++-
>  fs/xfs/libxfs/xfs_log_recover.h |   2 +
>  fs/xfs/scrub/common.c           |   2 +
>  fs/xfs/xfs_attr_item.c          | 453 ++++++++++++++++++++++++++++++++

Comment on the overall structure of this file now I've been trying
to navigate through it for a little while. It is structured like:

<some attri stuff>
<some attrd stuff>
static const struct xfs_item_ops xfs_attrd_item_ops = {...}
<some more attri stuff>
static const struct xfs_item_ops xfs_attri_item_ops = {...}
<some attri log recovery stuff>
<some attrd log recovery stuff>

IOWs, the attri and attrd functions are interleaved non-obvious
ways and that makes it hard to navigate around when trying to find
related information. It would make more sense to me to structure
this as:

<attri stuff>
<attri log recovery stuff>
<some attrd stuff>
<attrd log recovery stuff>
static const struct xfs_item_ops xfs_attri_item_ops = {...}
const struct xlog_recover_item_ops xlog_attri_item_ops = {...}
static const struct xfs_item_ops xfs_attrd_item_ops = {...}
const struct xlog_recover_item_ops xlog_attrd_item_ops = {...}

because then all the related functionality is grouped together. It
also puts all the ops structures together in the one place, so we
don't have to jump around all over the file when just looking at
what ops the items run at different times...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
