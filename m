Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F11C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 01:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiE0B2y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 21:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiE0B2y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 21:28:54 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DB24AFB11
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 18:28:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8B67110E6B30;
        Fri, 27 May 2022 11:28:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nuOmZ-00GqB5-99; Fri, 27 May 2022 11:28:51 +1000
Date:   Fri, 27 May 2022 11:28:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 4/5] xfs: move xfs_attr_use_log_assist out of xfs_log.c
Message-ID: <20220527012851.GR1098723@dread.disaster.area>
References: <165337058023.994444.12794741176651030531.stgit@magnolia>
 <165337060268.994444.12050011484802879913.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165337060268.994444.12050011484802879913.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62902954
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=ivo7esx2zvnvKSQmXFgA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 10:36:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The LARP patchset added an awkward coupling point between libxfs and
> what would be libxlog, if the XFS log were actually its own library.
> Move the code that enables logged xattr updates out of "lib"xlog and into
> xfs_xattr.c so that it no longer has to know about xlog_* functions.
> 
> While we're at it, give xfs_xattr.c its own header file.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c |    6 +++---
>  fs/xfs/xfs_log.c         |   41 --------------------------------------
>  fs/xfs/xfs_super.c       |    1 +
>  fs/xfs/xfs_super.h       |    1 -
>  fs/xfs/xfs_xattr.c       |   49 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_xattr.h       |   14 +++++++++++++
>  6 files changed, 67 insertions(+), 45 deletions(-)
>  create mode 100644 fs/xfs/xfs_xattr.h

fs/xfs/xfs_xattr.c was the only place I could really think
that this kinda fitted, too.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
