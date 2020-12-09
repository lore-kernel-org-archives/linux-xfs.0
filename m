Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230F2C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 17:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E819F23C90
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 17:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732597AbgLIRQr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:16:47 -0500
Received: from sandeen.net ([63.231.237.45]:52474 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731689AbgLIRQi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Dec 2020 12:16:38 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 455AE48C683;
        Wed,  9 Dec 2020 11:15:15 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, bfoster@redhat.com,
        david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
 <160729617344.1606994.3329458995178500981.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/3] xfs: define a new "needrepair" feature
Message-ID: <ce93ba09-c674-afc8-22e1-e60398ddd305@sandeen.net>
Date:   Wed, 9 Dec 2020 11:15:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <160729617344.1606994.3329458995178500981.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/6/20 5:09 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Define an incompat feature flag to indicate that the filesystem needs to
> be repaired.  While libxfs will recognize this feature, the kernel will
> refuse to mount if the feature flag is set, and only xfs_repair will be
> able to clear the flag.  The goal here is to force the admin to run
> xfs_repair to completion after upgrading the filesystem, or if we
> otherwise detect anomalies.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |    7 +++++++
>  fs/xfs/xfs_super.c         |    7 +++++++
>  2 files changed, 14 insertions(+)

I'm curious, will this ever be used to make a filesystem unmountable if
a verifier or scrub detects a problem? That might be some serious scope-creep;
if not, I wonder if intent here should be in the commit log or in
a comment.

"if we otherwise detect anomalies" seems to leave that open.

It doesn't change what we're doing here, I just wonder if we should indicate
the current intent a bit more clearly to the code-and-commit reader.

That said, for the change itself,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index dd764da08f6f..5d8ba609ac0b 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -468,6 +468,7 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
>  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
>  #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
> +#define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
>  #define XFS_SB_FEAT_INCOMPAT_ALL \
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> @@ -584,6 +585,12 @@ static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
>  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
>  }
>  
> +static inline bool xfs_sb_version_needsrepair(struct xfs_sb *sbp)
> +{
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
> +}
> +
>  /*
>   * end of superblock version macros
>   */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 599566c1a3b4..36002f460d7c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1467,6 +1467,13 @@ xfs_fc_fill_super(
>  #endif
>  	}
>  
> +	/* Filesystem claims it needs repair, so refuse the mount. */
> +	if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> +		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
> +		error = -EFSCORRUPTED;
> +		goto out_free_sb;
> +	}
> +
>  	/*
>  	 * Don't touch the filesystem if a user tool thinks it owns the primary
>  	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
> 
