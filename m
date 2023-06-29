Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E172EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 22:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjF2WgW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 18:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbjF2Wf6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 18:35:58 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF47635AE
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 15:35:56 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b8171718a1so9833875ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 15:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1688078156; x=1690670156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RGMGZ3nRirTI5S9qUtLkBlLBGkerf5vY3i2j1y/aDuY=;
        b=2pFbfiij7Wsk0TI5YjdpY6TJVFsQdQkBtCC8/XYrf8y748xvGJVhETLEbSCD+GSzg6
         uk6MH4Bf6YNA9UM5VWPeFE+mGxh89WF/TR/SKJaMkboXz8lkmQqcymMbbzBKjS1odyzD
         V1xCjcwWa6ybCZhcL5tEIgrBM44CG1KrzOu0efQpLQu1W1PGqcgAs9K/GkKqdkNLiBJP
         EiyDTsPfpWFxYk9Kpf3jYsdOEARLuHn/a46/iMXim+7MdEdStYYeHmo1KptLFkdy1xfi
         J1Z0yCq8hCqi3YTmOUTk9RJOYJW9BZPH4lrrTmEQ149DEBiP6oPATi+MwuoZbG6niG43
         c9dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688078156; x=1690670156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGMGZ3nRirTI5S9qUtLkBlLBGkerf5vY3i2j1y/aDuY=;
        b=ABinI2dtB4l7+JkVmMLrtEtkeFn5/FzEbFQ5RjJSOQjd/Z7Sie8Y/qHJmh2F9fW7Yi
         BtEAtTIDPBwGWhsyjfBHnAQK8a0/nontwvvggX+DxyZZBS409tLn3KOnGs7wiMhnmQGA
         Spk7KKmtxDTgvtb13gxwCFQJQPmHzqS01vL9ObQzbEmF1TACp3qAIiWqyqfWSW8wXNP0
         gqEpWvVxUnsNIcJwmIrl9RdJ/VJWSVdCFEo82PskxzT6Jb5hjP1ZJGG4w9dBR69HxltO
         gkppirux44FQkuR19oJPP0q8biRqj8YUh5APn/7WFw1eWfV/dcrPImI/XlM0CbcaSG4w
         ziBQ==
X-Gm-Message-State: ABy/qLY579Z/UADtTvChm4qrhPZUTQ1JUlSsC7jVzXzB74FLcxhfabaL
        dRXmAmAozbiWQuv0bFOu5LStmQ==
X-Google-Smtp-Source: APBJJlHRLadWvWRs21pdExRGcx39HHywwlDeQ/VaTSOfzHp3Qs84XJzsDNKE8o6l5t0UKosCAmCxpA==
X-Received: by 2002:a17:903:41d1:b0:1b7:fe1b:862c with SMTP id u17-20020a17090341d100b001b7fe1b862cmr487474ple.62.1688078156394;
        Thu, 29 Jun 2023 15:35:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id c14-20020a170902d48e00b001b02df0ddbbsm1267484plg.275.2023.06.29.15.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jun 2023 15:35:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qF0Ez-000CLv-2H;
        Fri, 30 Jun 2023 08:35:53 +1000
Date:   Fri, 30 Jun 2023 08:35:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 9/8] xfs: AGI length should be bounds checked
Message-ID: <ZJ4HSYpkp4Bq0oDl@dread.disaster.area>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230629194230.GH11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230629194230.GH11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 29, 2023 at 12:42:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Similar to the recent patch strengthening the AGF agf_length
> verification, the AGI verifier does not check that the AGI length field
> is within known good bounds.  This isn't currently checked by runtime
> kernel code, yet we assume in many places that it is correct and verify
> other metadata against it.
> 
> Add length verification to the AGI verifier.  Just like the AGF length
> checking, the length of the AGI must be equal to the size of the AG
> specified in the superblock, unless it is the last AG in the filesystem.
> In that case, it must be less than or equal to sb->sb_agblocks and
> greater than XFS_MIN_AG_BLOCKS, which is the smallest AG a growfs
> operation will allow to exist.
> 
> There's only one place in the filesystem that actually uses agi_length,
> but let's not leave it vulnerable to the same weird nonsense that
> generates syzbot bugs, eh?
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> NOTE: Untested, but this patch builds...
> ---
>  fs/xfs/libxfs/xfs_ialloc.c |   49 ++++++++++++++++++++++++++++++++------------
>  1 file changed, 36 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 1e5fafbc0cdb..fec6713e1fa9 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2486,11 +2486,12 @@ xfs_ialloc_log_agi(
>  
>  static xfs_failaddr_t
>  xfs_agi_verify(
> -	struct xfs_buf	*bp)
> +	struct xfs_buf		*bp)
>  {
> -	struct xfs_mount *mp = bp->b_mount;
> -	struct xfs_agi	*agi = bp->b_addr;
> -	int		i;
> +	struct xfs_mount	*mp = bp->b_mount;
> +	struct xfs_agi		*agi = bp->b_addr;
> +	uint32_t		agi_length = be32_to_cpu(agi->agi_length);
> +	int			i;
>  
>  	if (xfs_has_crc(mp)) {
>  		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
> @@ -2507,6 +2508,37 @@ xfs_agi_verify(
>  	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
>  		return __this_address;
>  
> +	/*
> +	 * Both agi_seqno and agi_length need to validated before anything else
> +	 * block number related in the AGI can be checked.
> +	 *
> +	 * During growfs operations, the perag is not fully initialised,
> +	 * so we can't use it for any useful checking. growfs ensures we can't
> +	 * use it by using uncached buffers that don't have the perag attached
> +	 * so we can detect and avoid this problem.
> +	 */
> +	if (bp->b_pag && be32_to_cpu(agi->agi_seqno) != bp->b_pag->pag_agno)
> +		return __this_address;
> +
> +	/*
> +	 * Only the last AGI in the filesytsem is allowed to be shorter
> +	 * than the AG size recorded in the superblock.
> +	 */
> +	if (agi_length != mp->m_sb.sb_agblocks) {
> +		/*
> +		 * During growfs, the new last AGI can get here before we
> +		 * have updated the superblock. Give it a pass on the seqno
> +		 * check.
> +		 */
> +		if (bp->b_pag &&
> +		    be32_to_cpu(agi->agi_seqno) != mp->m_sb.sb_agcount - 1)
> +			return __this_address;
> +		if (agi_length < XFS_MIN_AG_BLOCKS)
> +			return __this_address;
> +		if (agi_length > mp->m_sb.sb_agblocks)
> +			return __this_address;
> +	}

I'd pull this into a helper function that both the AGF and AGI
verifiers call. It's the same checks, with the same caveats and
growfs landmines, so I think would be better as a helper...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
