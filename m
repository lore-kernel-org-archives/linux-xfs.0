Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7216BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 22:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245626AbiCJW3l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 17:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbiCJW3l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 17:29:41 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E736517FC
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 14:28:38 -0800 (PST)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3D07910E3DF3;
        Fri, 11 Mar 2022 09:28:38 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nSRGv-003x5P-NM; Fri, 11 Mar 2022 09:28:37 +1100
Date:   Fri, 11 Mar 2022 09:28:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reserve quota for target dir expansion when
 renaming files
Message-ID: <20220310222837.GH3927073@dread.disaster.area>
References: <164694920783.1119636.13401244964062260779.stgit@magnolia>
 <164694921916.1119636.2957657161513150271.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164694921916.1119636.2957657161513150271.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=622a7b96
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=emE5smVbIvwbOYP1doMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 10, 2022 at 01:53:39PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> XFS does not reserve quota for directory expansion when renaming
> children into a directory.  This means that we don't reject the
> expansion with EDQUOT when we're at or near a hard limit, which means
> that unprivileged userspace can use rename() to exceed quota.
> 
> Rename operations don't always expand the target directory, and we allow
> a rename to proceed with no space reservation if we don't need to add a
> block to the target directory to handle the addition.  Moreover, the
> unlink operation on the source directory generally does not expand the
> directory (you'd have to free a block and then cause a btree split) and
> it's probably of little consequence to leave the corner case that
> renaming a file out of a directory can increase its size.
> 
> As with link and unlink, there is a further bug in that we do not
> trigger the blockgc workers to try to clear space when we're out of
> quota.
> 
> Because rename is its own special tricky animal, we'll patch xfs_rename
> directly to reserve quota to the rename transaction.  We'll leave
> cleaning up the rest of xfs_rename for the metadata directory tree
> patchset.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c |   33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
