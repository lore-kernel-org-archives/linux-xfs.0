Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655B1C47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 04:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44B04613B8
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 04:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhFCEop (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 00:44:45 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:42247 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhFCEop (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 00:44:45 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id A22C81AFC23;
        Thu,  3 Jun 2021 14:42:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofBq-008MFC-Vw; Thu, 03 Jun 2021 14:42:42 +1000
Date:   Thu, 3 Jun 2021 14:42:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: don't let background reclaim forget sick inodes
Message-ID: <20210603044242.GQ664593@dread.disaster.area>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
 <162268997239.2724138.6026093150916734925.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162268997239.2724138.6026093150916734925.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=4vf14kBzrKSEk1TxR20A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 08:12:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It's important that the filesystem retain its memory of sick inodes for
> a little while after problems are found so that reports can be collected
> about what was wrong.  Don't let background inode reclamation free sick
> inodes unless we're under memory pressure.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0e2b6c05e604..54285d1ad574 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -911,7 +911,8 @@ xfs_dqrele_all_inodes(
>   */
>  static bool
>  xfs_reclaim_igrab(
> -	struct xfs_inode	*ip)
> +	struct xfs_inode	*ip,
> +	struct xfs_eofblocks	*eofb)
>  {
>  	ASSERT(rcu_read_lock_held());
>  
> @@ -922,6 +923,17 @@ xfs_reclaim_igrab(
>  		spin_unlock(&ip->i_flags_lock);
>  		return false;
>  	}
> +
> +	/*
> +	 * Don't reclaim a sick inode unless we're under memory pressure or the
> +	 * filesystem is unmounting.
> +	 */
> +	if (ip->i_sick && eofb == NULL &&
> +	    !(ip->i_mount->m_flags & XFS_MOUNT_UNMOUNTING)) {
> +		spin_unlock(&ip->i_flags_lock);
> +		return false;
> +	}

Using the "eofb == NULL" as a proxy for being under memory pressure
is ... a bit obtuse. If we've got a handful of sick inodes, then
there is no problem with just leaving the in memory regardless of
memory pressure. If we've got lots of sick inodes, we're likely to
end up in a shutdown state or be unmounted for checking real soon.

I'd just leave sick inodes around until unmount or shutdown occurs;
lots of sick inodes means repair is necessary right now, so
shutdown+unmount is the right solution here, not memory reclaim....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
