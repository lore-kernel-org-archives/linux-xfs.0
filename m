Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FECC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 01:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiE0B3c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 21:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiE0B3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 21:29:30 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22CB9BA557
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 18:29:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 645E510E6B36;
        Fri, 27 May 2022 11:29:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nuOn9-00GqCB-C1; Fri, 27 May 2022 11:29:27 +1000
Date:   Fri, 27 May 2022 11:29:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 5/5] xfs: move xfs_attr_use_log_assist usage out of libxfs
Message-ID: <20220527012927.GS1098723@dread.disaster.area>
References: <165337058023.994444.12794741176651030531.stgit@magnolia>
 <165337060828.994444.7975135646390262956.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165337060828.994444.7975135646390262956.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62902978
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=V4mvnO2ijRiYbF_QseMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 10:36:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The LARP patchset added an awkward coupling point between libxfs and
> what would be libxlog, if the XFS log were actually its own library.
> Move the code that sets up logged xattr updates out of libxfs and into
> xfs_xattr.c so that libxfs no longer has to know about xlog_* functions.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c |   12 +-----------
>  fs/xfs/xfs_acl.c         |    3 ++-
>  fs/xfs/xfs_ioctl.c       |    3 ++-
>  fs/xfs/xfs_iops.c        |    3 ++-
>  fs/xfs/xfs_xattr.c       |   34 +++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_xattr.h       |    3 +--
>  6 files changed, 39 insertions(+), 19 deletions(-)

That makes the libxfs side of things much neater.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
