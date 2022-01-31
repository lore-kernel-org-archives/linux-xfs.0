Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20A2C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 22:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiAaW7v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 17:59:51 -0500
Received: from sandeen.net ([63.231.237.45]:51930 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbiAaW7v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Jan 2022 17:59:51 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CD1394916;
        Mon, 31 Jan 2022 16:59:32 -0600 (CST)
Message-ID: <44cb7849-a54d-b7b2-0ca0-c963947ae765@sandeen.net>
Date:   Mon, 31 Jan 2022 16:59:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263798606.860211.15937351978841057288.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 26/45] xfs: convert mount flags to features
In-Reply-To: <164263798606.860211.15937351978841057288.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:19 PM, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Source kernel commit: 0560f31a09e523090d1ab2bfe21c69d028c2bdf2
> 
> Replace m_flags feature checks with xfs_has_<feature>() calls and
> rework the setup code to set flags in m_features.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  include/xfs_mount.h    |   11 +++++++++++
>  libxfs/xfs_attr.c      |    4 ++--
>  libxfs/xfs_attr_leaf.c |   41 +++++++++++++++++++++++------------------
>  libxfs/xfs_bmap.c      |    4 ++--
>  libxfs/xfs_ialloc.c    |   10 ++++------
>  5 files changed, 42 insertions(+), 28 deletions(-)
> 
> 
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index a995140d..d4b4ccdc 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -197,6 +197,17 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
>  __XFS_HAS_FEAT(bigtime, BIGTIME)
>  __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
>  
> +/* Kernel mount features that we don't support */
> +#define __XFS_UNSUPP_FEAT(name) \
> +static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
> +{ \
> +	return false; \
> +}
> +__XFS_UNSUPP_FEAT(wsync)
> +__XFS_UNSUPP_FEAT(noattr2)
> +__XFS_UNSUPP_FEAT(ikeep)
> +__XFS_UNSUPP_FEAT(swalloc)

So I'd like to add small_inums to the above list:

+__XFS_UNSUPP_FEAT(small_inums)

and use that in xfs_set_inode_alloc() here as was done in kernelspace, i.e.:

diff --git a/libxfs/init.c b/libxfs/init.c
index 7d94b721..364c3578 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -540,7 +540,7 @@ xfs_set_inode_alloc(
 	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
 	 * the allocator to accommodate the request.
 	 */
-	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
+	if (xfs_has_small_inums(mp) && ino > XFS_MAXINUMBER_32)
 		mp->m_flags |= XFS_MOUNT_32BITINODES;
 	else
 		mp->m_flags &= ~XFS_MOUNT_32BITINODES;


That will let us keep this "backport libxfs" series more or less the
same as kernelspace, without needing to gut xfs_set_inode_alloc() as
got proposed in

[PATCH v1.1 39/45] libxfs: remove pointless *XFS_MOUNT* flags

and followups to preserve userspace inode allocation behavior.

If we want to remove dead code from the userspace-specific version of
xfs_set_inode_alloc() I think we can/should do that separately.

Thanks,
-Eric

