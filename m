Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE880C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 05:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbiEWFw1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 01:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbiEWFwQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 01:52:16 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46F811583F
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 22:51:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F3E3310E6A56;
        Mon, 23 May 2022 15:51:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nt0yu-00FK0Q-H4; Mon, 23 May 2022 15:51:52 +1000
Date:   Mon, 23 May 2022 15:51:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 2/4] xfs: do not use logged xattr updates on V4
 filesystems
Message-ID: <20220523055152.GR1098723@dread.disaster.area>
References: <165323326679.78754.13346434666230687214.stgit@magnolia>
 <165323327816.78754.11662775390499512627.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165323327816.78754.11662775390499512627.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=628b20fa
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=HMkQDyX5LmrCarfbzSQA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 22, 2022 at 08:27:58AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> V4 superblocks do not contain the log_incompat feature bit, which means
> that we cannot protect xattr log items against kernels that are too old
> to know how to recover them.  Turn off the log items for such
> filesystems and adjust the "delayed" name to reflect what it's really
> controlling.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c |    6 +++---
>  fs/xfs/libxfs/xfs_attr.h |    3 ++-
>  2 files changed, 5 insertions(+), 4 deletions(-)

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
