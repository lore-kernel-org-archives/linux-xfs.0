Return-Path: <SRS0=Vmdp=4G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DAFC34022
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 02:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07DDB214D8
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 02:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgBRCXi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 21:23:38 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55223 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726182AbgBRCXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 21:23:38 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 39FED7EA08A;
        Tue, 18 Feb 2020 13:23:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j3sXu-0004qa-Q2; Tue, 18 Feb 2020 13:23:34 +1100
Date:   Tue, 18 Feb 2020 13:23:34 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 30/31] xfs: remove XFS_DA_OP_INCOMPLETE
Message-ID: <20200218022334.GD10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-31-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217125957.263434-31-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=pGLkceISAAAA:8 a=7-415B0cAAAA:8 a=niSmavUqnFlSKap8o8QA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 01:59:56PM +0100, Christoph Hellwig wrote:
> Now that we use the on-disk flags field also for the interface to the
> lower level attr routines we can use the XFS_ATTR_INCOMPLETE definition
> from the on-disk format directly instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      |  2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c | 15 ++++++---------
>  fs/xfs/libxfs/xfs_types.h     |  6 ++----
>  3 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d5c112b6dcdd..23e0d8ce39f8 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -898,7 +898,7 @@ xfs_attr_node_addname(
>  		 * The INCOMPLETE flag means that we will find the "old"
>  		 * attr, not the "new" one.
>  		 */
> -		args->op_flags |= XFS_DA_OP_INCOMPLETE;
> +		args->attr_namespace |= XFS_ATTR_INCOMPLETE;

So args->attr_namespace is no longer an indication of what attribute
namespace to look up? Unless you are now defining incomplete
attributes to be in a namespace?

If so, I think this needs more explanation than "we can use the
on-disk format directly instead". That's just telling me what the
patch is doing and doesn't explain why we are considering this
specific on disk flag to indicate a new type of "namespace" for
attributes lookups. Hence I think this needs more documentation in
both the commit and the code as the definition of
XFS_ATTR_INCOMPLETE doesn't really make it clear that this is now
considered a namespace signifier...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
