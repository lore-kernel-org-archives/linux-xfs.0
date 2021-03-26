Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8CFC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 02:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C13B161A38
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 02:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhCZCt7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 22:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230473AbhCZCt1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 22:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD4AD619F2;
        Fri, 26 Mar 2021 02:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616726967;
        bh=fqGpUD3cUul7coOV+hDuYj1fX7wPZHFFVomQsxduFDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ux0Wu0mDzOVVWOuXsjBJdbM/OxD/TATB+O+V3dzuOT6/wCzT31tMdXcsVmZbLEYKR
         C8Uiw7lc2GhKq2jVNjMGoYRwrIGQdqKUNshxVDpbQl1K+LYN8G3yVx1kjQBrsl5Q18
         mPwq7OSXxKXatH23rqjMfK3NVccYvjluydG6eVAizQpnJ9qloNyjY6yDpt/RBMpKoq
         VtJp0rfvjnkRDRGR9Rl/beVugeM0wsfcanQaoMLbEq7CdNJee1gkqD3c6HXeQO0A/t
         FIWiM+2No9HGN2eBb7K1IdduWaWO1Db5tqIEAkurRRV1+oniS93dpr3yHSkOAC3JyS
         1FqrjkVuAO4ew==
Date:   Thu, 25 Mar 2021 19:49:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH v2] xfs_growfs: support shrinking unused space
Message-ID: <20210326024926.GR4090233@magnolia>
References: <20210326024631.12921-1-hsiangkao.ref@aol.com>
 <20210326024631.12921-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326024631.12921-1-hsiangkao@aol.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 26, 2021 at 10:46:31AM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> This allows shrinking operation can pass into kernel. Currently,
> only shrinking unused space in the tail AG functionality works.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks like a reasonable start,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> v1: https://lore.kernel.org/r/20201028114010.545331-1-hsiangkao@redhat.com
> change since v1:
>  - update manpage description (Darrick);
> 
>  growfs/xfs_growfs.c   | 9 ++++-----
>  man/man8/xfs_growfs.8 | 8 +++++---
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index a68b515de40d..d45ba703cc6f 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -246,12 +246,11 @@ main(int argc, char **argv)
>  			error = 1;
>  		}
>  
> -		if (!error && dsize < geo.datablocks) {
> -			fprintf(stderr, _("data size %lld too small,"
> -				" old size is %lld\n"),
> +		if (!error && dsize < geo.datablocks)
> +			fprintf(stderr,
> +_("[EXPERIMENTAL] try to shrink unused space %lld, old size is %lld\n"),
>  				(long long)dsize, (long long)geo.datablocks);
> -			error = 1;
> -		} else if (!error &&
> +		if (!error &&
>  			   dsize == geo.datablocks && maxpct == geo.imaxpct) {
>  			if (dflag)
>  				fprintf(stderr, _(
> diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
> index 60a88189dd88..a01269270580 100644
> --- a/man/man8/xfs_growfs.8
> +++ b/man/man8/xfs_growfs.8
> @@ -60,14 +60,16 @@ becomes available for additional file storage.
>  .SH OPTIONS
>  .TP
>  .BI "\-d | \-D " size
> -Specifies that the data section of the filesystem should be grown. If the
> +Specifies that the data section of the filesystem should be resized. If the
>  .B \-D
>  .I size
> -option is given, the data section is grown to that
> +option is given, the data section is changed to that
>  .IR size ,
>  otherwise the data section is grown to the largest size possible with the
>  .B \-d
> -option. The size is expressed in filesystem blocks.
> +option. The size is expressed in filesystem blocks. A filesystem with only
> +1 AG cannot be shrunk further, and a filesystem cannot be shrunk to the point
> +where it would only have 1 AG.
>  .TP
>  .B \-e
>  Allows the real-time extent size to be specified. In
> -- 
> 2.20.1
> 
