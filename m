Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BA7C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 22:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbiCJW3E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 17:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiCJW3E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 17:29:04 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8BA33EBA4
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 14:28:02 -0800 (PST)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F05D210E3E19;
        Fri, 11 Mar 2022 09:28:01 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nSRGL-003x28-Dn; Fri, 11 Mar 2022 09:28:01 +1100
Date:   Fri, 11 Mar 2022 09:28:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: reserve quota for dir expansion when
 linking/unlinking files
Message-ID: <20220310222801.GG3927073@dread.disaster.area>
References: <164694920783.1119636.13401244964062260779.stgit@magnolia>
 <164694921349.1119636.8537050445789359437.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164694921349.1119636.8537050445789359437.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=622a7b72
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=C9F_rqPESi_u9f_o5tAA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 10, 2022 at 01:53:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> XFS does not reserve quota for directory expansion when linking or
> unlinking children from a directory.  This means that we don't reject
> the expansion with EDQUOT when we're at or near a hard limit, which
> means that unprivileged userspace can use link()/unlink() to exceed
> quota.
> 
> The fix for this is nuanced -- link operations don't always expand the
> directory, and we allow a link to proceed with no space reservation if
> we don't need to add a block to the directory to handle the addition.
> Unlink operations generally do not expand the directory (you'd have to
> free a block and then cause a btree split) and we can defer the
> directory block freeing if there is no space reservation.
> 
> Moreover, there is a further bug in that we do not trigger the blockgc
> workers to try to clear space when we're out of quota.
> 
> To fix both cases, create a new xfs_trans_alloc_dir function that
> allocates the transaction, locks and joins the inodes, and reserves
> quota for the directory.  If there isn't sufficient space or quota,
> we'll switch the caller to reservationless mode.  This should prevent
> quota usage overruns with the least restriction in functionality.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c |   46 ++++++++++------------------
>  fs/xfs/xfs_trans.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trans.h |    3 ++
>  3 files changed, 106 insertions(+), 29 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
