Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5756EC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 15:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240532AbiFFPcO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 11:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240933AbiFFPcM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 11:32:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEBE49F93;
        Mon,  6 Jun 2022 08:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32F6CB81A6B;
        Mon,  6 Jun 2022 15:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEC5C34115;
        Mon,  6 Jun 2022 15:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654529503;
        bh=qNZpQ/qn4Gh+rTK+XHr+8IHNljt0jt24TKKs+06ncp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RU7JWuoG+g0K6FWbtMWFPSQW2P7Fr7bK9q2BwfJ3e2GWWzdLOu5GjhX4FxF32Kh3j
         PSHpmPSf2gJwkZYgxhIplc8IOmuq21KoWeSBQVgWhykACgGZmwNQc0iuS57POje0KQ
         F2xPmsGQCwfq0HCFTXXuu6B9B0f1/QJ9NVwyHH70FB6FC4xacTDthGja8alzIBYyro
         95MqkNhDfWlFwht1eioqraS6xl1JxC/HyVFiOGellZd84RVXtUCpUhdso7/jWAshYQ
         h079CsYJjT5a/Y+It8z9rdScxQDukcoiMZL1rNkxpZ4YqMKlgY9tBGMvNRtdt4RgdR
         c+P05Lmee+VRg==
Date:   Mon, 6 Jun 2022 08:31:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs/270: Fix ro mount failure when nrext64 option is
 enabled
Message-ID: <Yp4d34D2lMqaNfVr@magnolia>
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-2-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606124101.263872-2-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 06:10:58PM +0530, Chandan Babu R wrote:
> With nrext64 option enabled at run time, the read-only mount performed by the
> test fails because,
> 1. mkfs.xfs would have calculated log size based on reflink being enabled.
> 2. Clearing the reflink ro compat bit causes log size calculations to yield a
>    different value.
> 3. In the case where nrext64 is enabled, this causes attr reservation to be
>    the largest among all the transaction reservations.
> 4. This ends up causing XFS to require a larger ondisk log size than that
>    which is available.
> 
> This commit fixes the problem by setting features_ro_compat to the value
> obtained by the bitwise-OR of features_ro_compat field with 2^31.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  tests/xfs/270     | 16 ++++++++++++++--
>  tests/xfs/270.out |  1 -
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/270 b/tests/xfs/270
> index 0ab0c7d8..f3796691 100755
> --- a/tests/xfs/270
> +++ b/tests/xfs/270
> @@ -27,8 +27,20 @@ _scratch_mkfs_xfs >>$seqres.full 2>&1
>  # set the highest bit of features_ro_compat, use it as an unknown
>  # feature bit. If one day this bit become known feature, please
>  # change this case.
> -_scratch_xfs_set_metadata_field "features_ro_compat" "$((2**31))" "sb 0" | \
> -	grep 'features_ro_compat'
> +ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0")
> +ro_compat=${ro_compat##0x}
> +ro_compat="16#"${ro_compat}
> +ro_compat=$(($ro_compat|16#80000000))

I guess I just learned a  ^^^^^ new bashism today.

> +ro_compat=$(_scratch_xfs_set_metadata_field "features_ro_compat" "$ro_compat" \
> +					    "sb 0" | grep 'features_ro_compat')
> +
> +ro_compat=${ro_compat##features_ro_compat = 0x}
> +ro_compat="16#"${ro_compat}
> +ro_compat=$(($ro_compat&16#80000000))
> +if (( $ro_compat != 16#80000000 )); then
> +	echo "Unable to set most significant bit of features_ro_compat"
> +fi

Thanks for the fix,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
>  
>  # rw mount with unknown ro-compat feature should fail
>  echo "rw mount test"
> diff --git a/tests/xfs/270.out b/tests/xfs/270.out
> index 0a8b3851..edf4c254 100644
> --- a/tests/xfs/270.out
> +++ b/tests/xfs/270.out
> @@ -1,5 +1,4 @@
>  QA output created by 270
> -features_ro_compat = 0x80000000
>  rw mount test
>  ro mount test
>  rw remount test
> -- 
> 2.35.1
> 
