Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0622C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88A3E20838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBYA5W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:57:22 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59400 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727696AbgBYA5W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:57:22 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 79EF17E9A8A;
        Tue, 25 Feb 2020 11:57:19 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6OXG-00056x-7n; Tue, 25 Feb 2020 11:57:18 +1100
Date:   Tue, 25 Feb 2020 11:57:18 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 02/19] xfs: Embed struct xfs_name in xfs_da_args
Message-ID: <20200225005718.GC10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223020611.1802-3-allison.henderson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=yFzJWRlWqi1X2jo_sfwA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 22, 2020 at 07:05:54PM -0700, Allison Collins wrote:
> This patch embeds an xfs_name in xfs_da_args, replacing the name, namelen, and flags
> members.  This helps to clean up the xfs_da_args structure and make it more uniform
> with the new xfs_name parameter being passed around.

Commit message should wrap at 68-72 columns.

> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        |  37 +++++++-------
>  fs/xfs/libxfs/xfs_attr_leaf.c   | 104 +++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
>  fs/xfs/libxfs/xfs_da_btree.c    |   6 ++-
>  fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
>  fs/xfs/libxfs/xfs_dir2.c        |  18 +++----
>  fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
>  fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
>  fs/xfs/libxfs/xfs_dir2_node.c   |   8 ++--
>  fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
>  fs/xfs/scrub/attr.c             |  12 ++---
>  fs/xfs/xfs_trace.h              |  20 ++++----
>  12 files changed, 130 insertions(+), 123 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 6717f47..9acdb23 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -72,13 +72,12 @@ xfs_attr_args_init(
>  	args->geo = dp->i_mount->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
>  	args->dp = dp;
> -	args->flags = flags;
> -	args->name = name->name;
> -	args->namelen = name->len;
> -	if (args->namelen >= MAXNAMELEN)
> +	memcpy(&args->name, name, sizeof(struct xfs_name));
> +	args->name.type = flags;

This doesn't play well with Christoph's cleanup series which fixes
up all the confusion with internal versus API flags. I guess the
namespace is part of the attribute name, but I think this would be a
much clearer conversion when placed on top of the way Christoph
cleaned all this up...

Have you looked at rebasing this on top of that cleanup series?

Cheers,

-- 
Dave Chinner
david@fromorbit.com
