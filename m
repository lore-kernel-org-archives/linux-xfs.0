Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4881C433C1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 03:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8103061A1E
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 03:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhCYDGo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 23:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhCYDGb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 23:06:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A0DD61580;
        Thu, 25 Mar 2021 03:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616641589;
        bh=oZv+v7mRbypqbhwmrjapMG3Of5RNyAPzgaFIuevL8ls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CYgsnA7/WlyJeabioPfXm36RnjDl6MRHNDgMPWYkWCH1T5vXzG/IBcY4oPlvcRSbM
         Fqm9dS4fIRpZjCqsc4YY9ZlXY0YI0S7xA5XI7kO5h8NYm3OevNylus99Nza7FZlM8H
         y7sjNNH3KakC6QB29xazH8F6Etp5/MmrveLu7YvhcepXhESO6wsnTxbPPmw1w4sR8N
         e28UcMkhwXnqfkOMZfTCoNYleBIM0HOoO/q9A5GbRiBQgLFHBB/Bx82p3tU21cnNit
         fntzBoEHTE/2cyB9kSOTIkWJxOg5w8ffr6BPeuPyUCXtrAGv6Z0WY20EIixv7vQsyY
         DOjCRm/iU5Wgg==
Date:   Wed, 24 Mar 2021 20:06:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/18] xfs: use a union for i_cowextsize and i_flushiter
Message-ID: <20210325030628.GA4090233@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-14-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:24PM +0100, Christoph Hellwig wrote:
> The i_cowextsize field is only used for v3 inodes, and the i_flushiter
> field is only used for v1/v2 inodes.  Use a union to pack the inode a
> littler better after adding a few missing guards around their usage.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hmm, so this patch caused a regression on V4 filesystems xfs/051.  It
looks like the flush iter gets set to zero and then log recovery forgets
to replay the inode(?)

The following patch fixes it for me, FWIW...

--D

xfs: fix regression in xfs/051 with this patch

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 205ee7da8fa5..795c23e5c655 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1525,11 +1525,12 @@ xfs_ioctl_setattr(
 		ip->i_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
 	else
 		ip->i_extsize = 0;
-	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
-	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
-		ip->i_cowextsize = fa->fsx_cowextsize >> mp->m_sb.sb_blocklog;
-	else
-		ip->i_cowextsize = 0;
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
+		if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+			ip->i_cowextsize = XFS_B_TO_FSBT(mp, fa->fsx_cowextsize);
+		else
+			ip->i_cowextsize = 0;
+	}
 
 	error = xfs_trans_commit(tp);
 
