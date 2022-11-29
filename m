Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E1DC43217
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 01:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbiK2Be6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 20:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbiK2Be5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 20:34:57 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228C043840
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 17:34:57 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id r18so11588724pgr.12
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 17:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8UxR0vmo60MaG7PcPSAExNLPv9v74btYUzUjbptZdnw=;
        b=FtcJe+Uu937tlBSvl8+oJHblsX7O5ip2QzxvDGMrtje7JTh6zZWGHZd6yTtEKi+ByG
         Kc9v5fAaW60PHuovrWHwDJYPX7voRZ4Z/DhqbrC15uhQ2ZWNrdCUkFklGmdeuohLqSDI
         OULxtKp8/nsCO6/Bc8Dv877fFmAilfXyDXHbp02Dq3YmKfwfdByB89faOjqPRSudESvE
         9eY5tZx7+X8RECSDEexPY5sIg5XTHb/HFJsUdsrrhb7x1DthwoRoHOHcCZtIvzNX2T+a
         D3u4+f6DskTnM4/mK2Q3hgR8Zc1UP1BIVkkLtFzOrIpwt1TXrJnQRXTYDWxJq/5Ge7ZH
         c+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8UxR0vmo60MaG7PcPSAExNLPv9v74btYUzUjbptZdnw=;
        b=Eho5UlZ9T1QNOwOP/948bgcQfnM/2E06G04b1nIOlSMoXH/90RLHxcnyK1nYcolc/u
         0fx8aQZpURzTx5jRLj3F8Iz0kq8i3KE1ZWObytcFdjmWItNDbhgKvmgxP2AiAlE4a8iK
         a2xLoP9G5/Rg8CmPWYFy6XsKmTyVTA993pUpZpwE2Q1+7mhyhgBPvmdawMrABIqoKhNz
         a4gg8wUvTixoRDTh1OiWWeQNl81PGwOA2LehmB8EnE8iQB40Vxl9kKaoQaUS+PWhDNlP
         7oX7JWxwNMpc4QlLIYDc+f1hMjqJxzbXcK5CO2i06JGHXFg6eD48TUnatnDlO0OBCgIV
         q9kw==
X-Gm-Message-State: ANoB5pnh4FdKvf09NUuDloGKg9kjsrIowBqmaI5XSzMGC9Dl6LDtYW6H
        IOaavSnDSWGDAWxeVSzK/sTpTg==
X-Google-Smtp-Source: AA0mqf6RitAbceu9CoV8/Tiea4fE55+y/t+UK4nK3ogoOUTC2ZvtezEgr29dqMX1MepyTXYmymkarQ==
X-Received: by 2002:a63:1b60:0:b0:46f:b2a5:2e2d with SMTP id b32-20020a631b60000000b0046fb2a52e2dmr32937222pgm.400.1669685696608;
        Mon, 28 Nov 2022 17:34:56 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090340c300b001897a8b537asm5011150pld.221.2022.11.28.17.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 17:34:56 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ozpWP-002FWy-CT; Tue, 29 Nov 2022 12:34:53 +1100
Date:   Tue, 29 Nov 2022 12:34:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 10/9] xfs: add debug knob to slow down writeback for
 fun
Message-ID: <20221129013453.GY3600936@dread.disaster.area>
References: <20221123055812.747923-1-david@fromorbit.com>
 <Y4U3XWf5j1zVGvV4@magnolia>
 <Y4VejsHGU/tZuRYs@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4VejsHGU/tZuRYs@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 28, 2022 at 05:21:18PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a new error injection knob so that we can arbitrarily slow down
> writeback to test for race conditions and aberrant reclaim behavior if
> the writeback mechanisms are slow to issue writeback.  This will enable
> functional testing for the ifork sequence counters introduced in commit
> 745b3f76d1c8 ("xfs: maintain a sequence count for inode fork
> manipulations").
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: this time with tracepoints
> ---
.....

> @@ -267,6 +270,14 @@ xfs_errortag_valid(
>  	return true;
>  }
>  
> +bool
> +xfs_errortag_enabled(
> +	struct xfs_mount	*mp,
> +	unsigned int		tag)
> +{
> +	return mp->m_errortag && mp->m_errortag[tag] != 0;
> +}

Perhaps consider using the new xfs_errortag_valid() helper? i.e.

{
	if (!mp->errortag)
		return false;
	if (!xfs_errortag_valid(tag))
		return false;
	return mp->m_errortag[tag] != 0;
}

> +
>  bool
>  xfs_errortag_test(
>  	struct xfs_mount	*mp,
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 5191e9145e55..936d0c52d6af 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -45,6 +45,17 @@ extern bool xfs_errortag_test(struct xfs_mount *mp, const char *expression,
>  		const char *file, int line, unsigned int error_tag);
>  #define XFS_TEST_ERROR(expr, mp, tag)		\
>  	((expr) || xfs_errortag_test((mp), #expr, __FILE__, __LINE__, (tag)))
> +bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
> +#define XFS_ERRORTAG_DELAY(mp, tag)		\
> +	do { \
> +		if (!xfs_errortag_enabled((mp), (tag))) \
> +			break; \
> +		xfs_warn_ratelimited((mp), \
> +"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"", \
> +				(mp)->m_errortag[(tag)], __FILE__, __LINE__, \
> +				(mp)->m_super->s_id); \
> +		mdelay((mp)->m_errortag[(tag)]); \
> +	} while (0)

Putting a might_sleep() in this macro might be a good idea - that
will catch delays being added inside spin lock contexts...

Other than that, it looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
