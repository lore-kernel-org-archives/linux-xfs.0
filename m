Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA73C77B73
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 02:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344643AbjD1CUr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 22:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344621AbjD1CUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 22:20:47 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F05B269D
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:20:46 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b5c48ea09so7481875b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682648445; x=1685240445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1MFNQpQIdQ8nHgw9CzNiFNAgVeo1etEj3o4SIL3t0Ms=;
        b=ZPb0Dkgp+GVfUzVFsF/ESNw2mCEx+vlct4WqYhx3z9XQAoPzSttMIVWiPyXpv6dYho
         4j4R5uCjrK3NmuRsRRw0xFEO3ME1H4FBX4EsaXvPhCvm3Ea1YQK0lNBLPeWtd4Lqy6RC
         GzvHUlVOWs2bGc58Ci3wI7Gwg/UHPsmlM8bRGIgelRENqXaIE1p1B5it7Ypug9uuLP9R
         Xej6UwNCvMHZ/qJaaxUm90NnEI9+D+n16KbSVHiOLSBUmeRGcFGWoFoR4na/htLK13Ls
         IAcG7tKY+b1SIYysoJ9/gqira0Utr9URFH552BgXWorhfnIdSnY4E+0fH+bl2GG9biDL
         pcgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682648445; x=1685240445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1MFNQpQIdQ8nHgw9CzNiFNAgVeo1etEj3o4SIL3t0Ms=;
        b=GgA7jE/M3avP2iyDxtZmARJTP6KMxHrCutIQuCLalyxgirWFqGyMJaAL66qRUXlcMh
         4YyuqA4dsH86I5uBTR1G3+wHxRTPn3dEz1EEVNBOfzELk7vKvszlOpej0UYRE2Jc8Pw1
         EQ/xOmyMvvSN4a/jUfjuJreZhnvpOVlxQ+a1lavyXQ20Ac/8Qe2aN1ZT49caJ5yEr4r8
         J+L4pXD45KPUb4J3Y3Nl2BVjtsvzA8q29A9HSif/LS745AcxFv44vSlpAqNYDPoV12Of
         9M8PMrmLJDAVWPIOeuWNL16V2rMjaQBV7yh1zQWn7O6Vr+iEDSm4G+aYBM/INDyMOMSS
         Ba9w==
X-Gm-Message-State: AC+VfDwDss5RuDQiX4kgdHRBjl1kEfr457XXU4y2LbVJTmG75VjjZeb7
        LMzfS/G4oFWWltKro4jnJfj2BA==
X-Google-Smtp-Source: ACHHUZ6mi3bDatAwBbLOlgnZgiOW5YYHf22puUhshMs0+4HATYDXejFNYUX7NX7RP6mfr0a4N0UQ7w==
X-Received: by 2002:a05:6a20:5495:b0:ec:7cc:2da6 with SMTP id i21-20020a056a20549500b000ec07cc2da6mr4212698pzk.56.1682648445562;
        Thu, 27 Apr 2023 19:20:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id l6-20020a656806000000b0051b71e8f633sm11966417pgt.92.2023.04.27.19.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 19:20:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1psDiz-008i1h-UG; Fri, 28 Apr 2023 12:20:41 +1000
Date:   Fri, 28 Apr 2023 12:20:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: disable reaping in fscounters scrub
Message-ID: <20230428022041.GT3223426@dread.disaster.area>
References: <168263576040.1719564.2454266085026973056.stgit@frogsfrogsfrogs>
 <168263577739.1719564.16150152466509865245.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168263577739.1719564.16150152466509865245.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 03:49:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The fscounters scrub code doesn't work properly because it cannot
> quiesce updates to the percpu counters in the filesystem, hence it
> returns false corruption reports.  This has been fixed properly in
> one of the online repair patchsets that are under review by replacing
> the xchk_disable_reaping calls with an exclusive filesystem freeze.
> Disabling background gc isn't sufficient to fix the problem.
> 
> In other words, scrub doesn't need to call xfs_inodegc_stop, which is
> just as well since it wasn't correct to allow scrub to call
> xfs_inodegc_start when something else could be calling xfs_inodegc_stop
> (e.g. trying to freeze the filesystem).
> 
> Neuter the scrubber for now, and remove the xchk_*_reaping functions.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks ok, minor nit below.

> @@ -453,6 +446,9 @@ xchk_fscounters(
>  	if (frextents > mp->m_sb.sb_rextents)
>  		xchk_set_corrupt(sc);
>  
> +	/* XXX: We can't quiesce percpu counter updates, so exit early. */
> +	return 0;

Can you just add to this that we can re-enable this functionality
when we have the exclusive freeze functionality in the kernel?

With that,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
