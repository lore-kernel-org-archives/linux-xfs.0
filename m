Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72A3C47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 04:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8178F613EE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 04:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhFCEsI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 00:48:08 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57018 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229441AbhFCEsI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 00:48:08 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6B92A1043577;
        Thu,  3 Jun 2021 14:46:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofFO-008MI1-Te; Thu, 03 Jun 2021 14:46:22 +1000
Date:   Thu, 3 Jun 2021 14:46:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: change the prefix of XFS_EOF_FLAGS_* to
 XFS_ICWALK_FLAG_
Message-ID: <20210603044622.GR664593@dread.disaster.area>
References: <162268997425.2724263.18220495607834735216.stgit@locust>
 <162268997987.2724263.8793609361184652026.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162268997987.2724263.8793609361184652026.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=v_qGijgDxQVERF_PJ7YA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 08:12:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In preparation for renaming struct xfs_eofblocks to struct xfs_icwalk,
> change the prefix of the existing XFS_EOF_FLAGS_* flags to
> XFS_ICWALK_FLAG_ and convert all the existing users.  This adds a degree
> of interface separation between the ioctl definitions and the incore
> parameters.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_file.c   |    4 ++--
>  fs/xfs/xfs_icache.c |   40 ++++++++++++++++++++--------------------
>  fs/xfs/xfs_icache.h |   19 +++++++++++++++++--
>  3 files changed, 39 insertions(+), 24 deletions(-)

.....

> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 191620a069af..2f4a27a3109c 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -18,6 +18,21 @@ struct xfs_eofblocks {
>  	int		icw_scan_limit;
>  };
>  
> +/* Flags that we borrowed from struct xfs_fs_eofblocks */

"Flags that reflect xfs_fs_eofblocks functionality"

> +#define XFS_ICWALK_FLAG_SYNC		(XFS_EOF_FLAGS_SYNC)
> +#define XFS_ICWALK_FLAG_UID		(XFS_EOF_FLAGS_UID)
> +#define XFS_ICWALK_FLAG_GID		(XFS_EOF_FLAGS_GID)
> +#define XFS_ICWALK_FLAG_PRID		(XFS_EOF_FLAGS_PRID)
> +#define XFS_ICWALK_FLAG_MINFILESIZE	(XFS_EOF_FLAGS_MINFILESIZE)
> +#define XFS_ICWALK_FLAG_UNION		(XFS_EOF_FLAGS_UNION)

Do these internal flags need to have the same values as the user
API?

Otherwise OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
