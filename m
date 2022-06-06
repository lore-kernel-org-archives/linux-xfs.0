Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7F6C43334
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 15:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240527AbiFFPau (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 11:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240522AbiFFPas (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 11:30:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5B335DD2;
        Mon,  6 Jun 2022 08:30:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8CB4B8198A;
        Mon,  6 Jun 2022 15:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C57DC34115;
        Mon,  6 Jun 2022 15:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654529428;
        bh=vJpqwZWBKWUMbx7EFjShdHYFHP9+0mdWttWEtYaxtkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L5DcHD8oJth121Zoqv5UpJbH8Q+8GA/u5PPt4FJMbbtY4G9WS5dVRlauVBTW0hMWt
         qQCExg4we2U7ct24vWQphZAw4U0knBSfLsHGI4Adw91wNcP7kkG1OI5s/ur+PmEh+V
         R9cA0Sdp8B/SwxeXnHZavqbXB4I3qdqyfKb0HJnlIF6uN5n5hL1OLjAAipyCqjueT/
         mzyTF05DDL271+gn5WPTZWIuYGUsxhhxEAcLa601jhlCaU4bnhpc9Zjocgag/6ovwP
         v3GxDr2bHGr1wDjlnUSscJ1z8bUhE9N1jd5vi6k+aZAHpXG8PsfSu4h6eC6ZxOOdse
         RodGuKhntD4cQ==
Date:   Mon, 6 Jun 2022 08:30:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] common/xfs: Add helper to check if nrext64 option is
 supported
Message-ID: <Yp4dkxSr1FZXkUy4@magnolia>
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-3-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606124101.263872-3-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 06:10:59PM +0530, Chandan Babu R wrote:
> This commit adds a new helper to allow tests to check if xfsprogs and xfs
> kernel module support nrext64 option.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks fine to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  common/xfs | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 2123a4ab..dca7af57 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1328,3 +1328,16 @@ _xfs_filter_mkfs()
>  		print STDOUT "realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX\n";
>  	}'
>  }
> +
> +_require_scratch_xfs_nrext64()
> +{
> +	_require_scratch
> +
> +	_scratch_mkfs -i nrext64=1 &>/dev/null || \
> +		_notrun "mkfs.xfs doesn't support nrext64 feature"
> +	_try_scratch_mount || \
> +		_notrun "kernel doesn't support xfs nrext64 feature"
> +	$XFS_INFO_PROG "$SCRATCH_MNT" | grep -q -w "nrext64=1" || \
> +		_notrun "nrext64 feature not advertised on mount?"
> +	_scratch_unmount
> +}
> -- 
> 2.35.1
> 
