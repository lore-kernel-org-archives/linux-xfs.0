Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9730C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 01:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbiLNBGg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 20:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236802AbiLNBGf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 20:06:35 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5681D1FCFE
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 17:06:35 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d15so1746233pls.6
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 17:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dr6HKjJL5YZPttTn+gV2aPe+Mf5XhziCJpI/tZW/Q84=;
        b=qPFSTQxlk2cH6kCSHhOdQw3BFZd0Awj/PK0ojqrpU7mLzHUkyVb2i5urjWlFmyNErJ
         V0gBdfjsb5GI4MhB+oO2jhW2qDzl+41KUXnmLnurOo5V8VGs9VHCA2iJyE6BQCS6fdhV
         4JiAXSWKYFYLTp0RrV/qXI870nrPDNcgWtR+pj4dfiXBbSXKu+zgBRGm6uws3c5R0BIb
         1plMooNFe/hflm4gaQ2rABIURCYaMR9SjoJCeC0C+dljPbkyUwTVcEt7v8/mgSQ0hoov
         Uo5qPerRuPOFiSw4k45i0V9bl/35eMAdy0YCDuQpRoLbZ/nRGdVOR8Ava2n3p0BKPGm8
         W4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dr6HKjJL5YZPttTn+gV2aPe+Mf5XhziCJpI/tZW/Q84=;
        b=YH7VkV4Jm4ZlUif3V3K3mJKQ8EjH6OUtxAf5VRdNSH8lbczS3sEbUgOLn/xHLMbXni
         xI+1IrrTg58NFJAMqRtNoolNdKvnrxUP3+AaMp1WnLH8SxpRmWL2vqJbcHBahkisLWJZ
         o4oJQVmzwgBmgPMFsQ8iGmItPBZpEI/RL6H/+EhiGHoO5hygKmGZA/42rKrbhzY2z1U1
         6DvE5IHuAdtRYqqHvo2pfZMEOSRkPAc6fz3WksGfYXxkI55o77X2TNM+0RK8/yiWlFJG
         J7emNyMxGZ3U12xdYYw8Mi23DvyzA7DkuHPJuXH/rCkgDMDbn08dXfxNyl2ql/uKtDY1
         B8ZA==
X-Gm-Message-State: ANoB5pnytmzJhP3Lc/txya6Ykrgcd9ihQis2fKG6g6p3c3i4Zy3wLEdn
        DGFa59qds1swmUq59mWRRUjuiw==
X-Google-Smtp-Source: AA0mqf5yZ/qk94hUHNSjnOOltj3W5wqj71c+FuQkaPNREywvONC19g4YqKYs504kdGGUTHBbs4EAMw==
X-Received: by 2002:a17:902:f243:b0:189:d051:129 with SMTP id j3-20020a170902f24300b00189d0510129mr18388020plc.66.1670979994877;
        Tue, 13 Dec 2022 17:06:34 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id i17-20020a170902c95100b001897de9bae3sm481147pla.204.2022.12.13.17.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 17:06:34 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p5GEC-0089cy-05; Wed, 14 Dec 2022 12:06:32 +1100
Date:   Wed, 14 Dec 2022 12:06:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 04/11] xfs: add fs-verity ro-compat flag
Message-ID: <20221214010631.GD3600936@dread.disaster.area>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-5-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213172935.680971-5-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 06:29:28PM +0100, Andrey Albershteyn wrote:
> To mark inodes sealed with fs-verity the new XFS_DIFLAG2_VERITY flag
> will be added in further patch. This requires ro-compat flag to let
> older kernels know that fs with fs-verity can not be modified.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 10 ++++++----
>  fs/xfs/libxfs/xfs_sb.c     |  2 ++
>  fs/xfs/xfs_mount.h         |  2 ++
>  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index f413819b2a8aa..2b76e646e6f14 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -353,11 +353,13 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
>  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
>  #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
> +#define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */

Yup, define this now, but ....

>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
> -		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
> -		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> -		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
> -		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
> +		(XFS_SB_FEAT_RO_COMPAT_FINOBT  | \
> +		 XFS_SB_FEAT_RO_COMPAT_RMAPBT  | \
> +		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
> +		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT| \
> +		 XFS_SB_FEAT_RO_COMPAT_VERITY)

This hunk should be in a separate patch at the end of the series
so that VERITY enabled filesystems won't mount until all the
infrastructure is in place to handle it correctly. This means git
bisects won't land in the middle of the patchset where
VERITY is accepted as valid but the functionality doesn't work.

Otherwise looks good.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
