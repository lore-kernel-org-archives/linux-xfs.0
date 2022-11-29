Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379AFC4321E
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 22:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbiK2Wfi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 17:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236464AbiK2Wfg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 17:35:36 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0416F81B
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 14:35:35 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id o5-20020a17090a678500b00218cd5a21c9so132736pjj.4
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 14:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P9uthek4YM80vO0YfM6ARWDQu0bWEW2AdDA9mvSATtc=;
        b=0rk5oJD8V4XCYJcVhlzqruL9t+VYHvBuB5PxlCEz+MvKe6ofo4fWAQiBN/i4/P5c3L
         EerVvFO7xuQcy9Wem8OnqvyCrDn3nBzkUplVqcF6Eyp/oQG27QVfMfZcBe41sWFxAVdM
         K6h0p3eZGfr8rrkBLU/iwqVAb7yDuOmgo2TICe0yHVFbLZAhAMoKJDg9eGfg0glvR7ih
         +ryMmRWPU06+1UAvfganBJ7WbSbvOWXbRwMofcxH5Ri4V2kjUddsTn8267UEJhVEafNV
         EvLKty0p9CrmrRekoeeL1zlnlNyMkVznq+fr1L0Qy9ayMnk+1tE9mjVD4SH2OoWhQ8PW
         riSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P9uthek4YM80vO0YfM6ARWDQu0bWEW2AdDA9mvSATtc=;
        b=ZXIkG5x9ZXI4PLCjiJB0fngToR99SwffjRFjb94Aa8jN+NXZ/+3h+JN9Z1s2YdBQWd
         wu63rD1y64HWmTMIDothRzGb7FKgAA2CoihDllTSsh+QWBjOn1RcxtOKkLG9tc237toC
         WxH9Py9x7kM/U7amOdc52kY6tzFiTku8vsqIo8Gy1E886R0Z6fFM0dVs6KA+aTz3Uvoo
         cj0+jEo6VGb2tA+/HQhlPiDWImzXiciBSjuKqqD1qsGQyVTRAd92UgME2XGq5UIpuq+s
         bjl/CqP5yCP4VyVFpQEGluRaaflOfolu9+ktcFrwUgad0QNCzADW5f2r9H/eKGjv420G
         O+vQ==
X-Gm-Message-State: ANoB5pkl0ifmA0BrJ6x1LrD6kd/p/tKASvVIBWOLVVuN/SVog0Nn6Jck
        ELCBq3jTDHYlkT1aUs4NN/sPZ6MppDgK8w==
X-Google-Smtp-Source: AA0mqf52GI6ZBSgXgudiHwlLx9RjiT8k587LFmzW/MQsqjgg5TdFV1X2xDP6hK+dPwXcaPy9RSJcCQ==
X-Received: by 2002:a17:902:6804:b0:189:907c:8380 with SMTP id h4-20020a170902680400b00189907c8380mr9921070plk.104.1669761335265;
        Tue, 29 Nov 2022 14:35:35 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b002135a57029dsm1857052pjb.29.2022.11.29.14.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 14:35:34 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p09CN-002b1m-Ig; Wed, 30 Nov 2022 09:35:31 +1100
Date:   Wed, 30 Nov 2022 09:35:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: hoist refcount record merge predicates
Message-ID: <20221129223531.GJ3600936@dread.disaster.area>
References: <166975928548.3768925.15141817742859398250.stgit@magnolia>
 <166975929118.3768925.9568770405264708473.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166975929118.3768925.9568770405264708473.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 02:01:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Hoist these multiline conditionals into separate static inline helpers
> to improve readability and set the stage for corruption fixes that will
> be introduced in the next patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |  126 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 110 insertions(+), 16 deletions(-)

Looks OK. Minor nit below.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> 
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 3f34bafe18dd..8c68994d09f3 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -815,11 +815,116 @@ xfs_refcount_find_right_extents(
>  /* Is this extent valid? */
>  static inline bool
>  xfs_refc_valid(
> -	struct xfs_refcount_irec	*rc)
> +	const struct xfs_refcount_irec	*rc)
>  {
>  	return rc->rc_startblock != NULLAGBLOCK;
>  }
>  
> +static inline bool
> +xfs_refc_want_merge_center(
> +	const struct xfs_refcount_irec	*left,
> +	const struct xfs_refcount_irec	*cleft,
> +	const struct xfs_refcount_irec	*cright,
> +	const struct xfs_refcount_irec	*right,
> +	bool				cleft_is_cright,
> +	enum xfs_refc_adjust_op		adjust,
> +	unsigned long long		*ulenp)
> +{
> +	unsigned long long		ulen = left->rc_blockcount;
> +
> +	/*
> +	 * To merge with a center record, both shoulder records must be
> +	 * adjacent to the record we want to adjust.  This is only true if
> +	 * find_left and find_right made all four records valid.
> +	 */
> +	if (!xfs_refc_valid(left)  || !xfs_refc_valid(right) ||
> +	    !xfs_refc_valid(cleft) || !xfs_refc_valid(cright))
> +		return false;
> +
> +	/* There must only be one record for the entire range. */
> +	if (!cleft_is_cright)
> +		return false;
> +
> +	/* The shoulder record refcounts must match the new refcount. */
> +	if (left->rc_refcount != cleft->rc_refcount + adjust)
> +		return false;
> +	if (right->rc_refcount != cleft->rc_refcount + adjust)
> +		return false;
> +
> +	/*
> +	 * The new record cannot exceed the max length.  The funny computation
> +	 * of ulen avoids casting.
> +	 */
> +	ulen += cleft->rc_blockcount + right->rc_blockcount;
> +	if (ulen >= MAXREFCEXTLEN)
> +		return false;

The comment took me a bit of spelunking to decipher what the "funny
computation" was. Better to spell it out directly (catch u32
overflows) than just hint that there's somethign special about it.
Say:

	/*
	 * The new record cannot exceed the max length. ulen is a
	 * ULL as the individual record block counts can be up to
	 * (u32 - 1) in length hence we need to catch u32 addition
	 * overflows here.
	 */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
