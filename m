Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3288CDB47D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 19:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbjJKTA6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 15:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbjJKTAx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 15:00:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6DCB0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 12:00:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8C1C433C9;
        Wed, 11 Oct 2023 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697050851;
        bh=il6XIFzKh3auCiOTJQOAhU40etXtr6zEXI2tiA6s+eM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k9wryYZO4f60j6ILdmC39Ynh6Vs6xrGnkrYTva11Zta85T4QTAcH839BSqsq0dJWs
         PKBw69cmMy0bD4xj1irqChJdkJ4Rknn0+9uyf3dgiOHgVR1UShYQSkRg3qmFD+zCJ0
         gVRrZDVJtirInU8ijfjlT6ijODopCQ1oFgv/05CmOoL1vvfLAqqWeP0nNNKdU9Jfyo
         W1TfenjvNv23lMhTjJrpYPPNlIs/iO1PnMIhbVChiTGlxDethOL6MF7z6cgTLHN+b2
         BeRNzAUNfBVkXEL8RUmbYy+ukde/88EDE0LNMx3l4pqETILCwib/t/W2UYvAAF+vtx
         kF3mK5RWiZgzg==
Date:   Wed, 11 Oct 2023 12:00:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 23/28] xfs: don't allow to enable DAX on fs-verity
 sealsed inode
Message-ID: <20231011190050.GV21298@frogsfrogsfrogs>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-24-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006184922.252188-24-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 08:49:17PM +0200, Andrey Albershteyn wrote:
> fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
> inodes which already have fs-verity enabled. The opposite is checked
> when fs-verity is enabled, it won't be enabled if DAX is.

Why can't we allow S_DAX and S_VERITY at the same time?  Is there a
design problem that prohibits checking the verity data when we go to
copy the pmem to userspace or take a read fault, or is S_DAX support
simply not implemented?

--D

> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/xfs_iops.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 9f2d5c2505ae..3153767f0d6f 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1209,6 +1209,8 @@ xfs_inode_should_enable_dax(
>  		return false;
>  	if (!xfs_inode_supports_dax(ip))
>  		return false;
> +	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
> +		return false;
>  	if (xfs_has_dax_always(ip->i_mount))
>  		return true;
>  	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
> -- 
> 2.40.1
> 
