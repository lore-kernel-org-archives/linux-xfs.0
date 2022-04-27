Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22680C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 20:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbiD0UdU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 16:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbiD0Uc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 16:32:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5B8B3C63
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 13:29:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E00BB8298A
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 20:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AA5C385A9;
        Wed, 27 Apr 2022 20:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651091384;
        bh=Hk4iMBBOZwuAKrxafCWIRsquBbSoDHqLv9H2jMfkGBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sK/S5wadmEvECzPom4M6E2jRmMLhpW3y5ekfjsalD85cA0HsZ+rHqG1qLxfF2PNN2
         GyeNxJ12F8QAFXtyAU0wNwhMm/B33ioovNXZS4mtYiD6AeicCi7g8eEr3E7Yp7CUho
         MAISlMkux6/T+tKJ0CBh2LpmP8Gh1vad9abuavfQyeohpAhXLe2eXXlHTRHTVWeqjl
         roNyu8BE1qydcab0aeC01tnGHZyBt2NeX6oR47VXb+y2UYgHu0QjxgsS4KpZOcGtXY
         lfXQOmK5mgYw8is4dROy4T3zearf4pgYhMTFISxhKJFYYstXKPm1JzHb2rv2ARrvX3
         icnLAWgwN9RXg==
Date:   Wed, 27 Apr 2022 13:29:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/2] xfs: don't set warns on the id==0 dquot
Message-ID: <20220427202943.GL17025@magnolia>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <20220421165815.87837-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421165815.87837-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 21, 2022 at 09:58:15AM -0700, Catherine Hoang wrote:
> Quotas are not enforced on the id==0 dquot, so the quota code uses it
> to store warning limits and timeouts.  Having just dropped support for
> warning limits, this field no longer has any meaning.  Return -EINVAL
> for this dquot id if the fieldmask has any of the QC_*_WARNS set.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index e7f3ac60ebd9..bdbd5c83b08e 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -290,6 +290,8 @@ xfs_qm_scall_setqlim(
>  		return -EINVAL;
>  	if ((newlim->d_fieldmask & XFS_QC_MASK) == 0)
>  		return 0;
> +	if ((newlim->d_fieldmask & QC_WARNS_MASK) && id == 0)
> +		return -EINVAL;

Assuming there'll be more patches coming to turn off the rest of the
warnings counters, this is a reasonable start:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  
>  	/*
>  	 * Get the dquot (locked) before we start, as we need to do a
> -- 
> 2.27.0
> 
