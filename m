Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0D9C001B0
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 20:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbjHHUgB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 16:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbjHHUfo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 16:35:44 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5946BD23
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 10:14:04 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id af79cd13be357-76c93abeb83so460051085a.0
        for <linux-xfs@vger.kernel.org>; Tue, 08 Aug 2023 10:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691514844; x=1692119644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BbPZ16x1pgekdDa6U0Vnvkyvr4gII3fhlfHYCeQOlks=;
        b=tHTZdXm5GEslKS3+k88f7UvaGoIH+ch2syn9nTzXxUlbYALNsidkbdmUVh3tKxJhG+
         H12HWbJ+JMW9qnwWV4zoRfD5IIPx/Trz3Lp3OhKe+l5zrGzGeoufjNj7GTYn2WYCII+8
         7VruZi65VVeFhzm2MlFE+zjDH1sxYxZFiVXzyg4ggu631/izJtVXrFM7qO4ZQckL2XBF
         rabkUrz+zIJFMcz1kBopB97zi0UBrretBWATnhaiTvT4pULUsTp06LqBsqtjoYlEMi/c
         /hAAzmBqb6sXdksFIVMEib+dN1O4TYlK8OqXr1WamouRxjMqJHRyA3wQkjC17wj0iHVR
         Y79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691514844; x=1692119644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BbPZ16x1pgekdDa6U0Vnvkyvr4gII3fhlfHYCeQOlks=;
        b=dQGG+jlpxiDDscHS0bz/aTohRKpeMaItBbcZ0MmHp7ELb/qVLHVBhjlqBZiauSuCax
         DfJVmtzKM4zPQQ2qPDQhMklLKeCZrKUGlgLs0Q7yI2moAHC+5KyR6x1Ta69za51YTJug
         53FzaVnuyTposb5IqaY3hw2YeZ4nLRBwKdd5glYO2AbI9dxCgls3nNP7iJA6CA+3SkX/
         I3zzsuCdhMhbewum439Yl4pEzcaprk54xw/RWEpMrLyxHlPptW8WbUrCQXebR3bA/vLd
         n3sR0vxYpp//KBaROGv/LY2uplIkFAsksQ1qcm8Atemg00wab9tSj7I7C2m5fqNIR9F5
         xQwg==
X-Gm-Message-State: AOJu0YwRSsWQORyrDd5Di0z6Y7gQynri5Cb3CcXYoGbDyj31z7RA1s1t
        jNZuSTNLEMvg6VAOdOdJ4/nz1PxuEIXRwH6RbFA=
X-Google-Smtp-Source: AGHT+IHhDKsNIoXhc3lZrFT/yyT51V0/GOw1xvTLPz5YeMPGxrZH9WdevBXc/mgeTmv4ePtPK3CD4w==
X-Received: by 2002:a17:90b:ed4:b0:262:df91:cdce with SMTP id gz20-20020a17090b0ed400b00262df91cdcemr8959621pjb.23.1691478643542;
        Tue, 08 Aug 2023 00:10:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id 14-20020a17090a194e00b00268385b0501sm10599303pjh.27.2023.08.08.00.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 00:10:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qTGrY-002c8i-32;
        Tue, 08 Aug 2023 17:10:40 +1000
Date:   Tue, 8 Aug 2023 17:10:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix agf_fllast when repairing an empty AGFL
Message-ID: <ZNHqcKcjgR/RzsYU@dread.disaster.area>
References: <169049625352.922161.1455328433828521501.stgit@frogsfrogsfrogs>
 <169049625382.922161.17865609533771232818.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169049625382.922161.17865609533771232818.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 03:30:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs/139 with parent pointers enabled occasionally pops up a corruption
> message when online fsck force-rebuild repairs an AGFL:
> 
>  XFS (sde): Metadata corruption detected at xfs_agf_verify+0x11e/0x220 [xfs], xfs_agf block 0x9e0001
>  XFS (sde): Unmount and run xfs_repair
>  XFS (sde): First 128 bytes of corrupted metadata buffer:
>  00000000: 58 41 47 46 00 00 00 01 00 00 00 4f 00 00 40 00  XAGF.......O..@.
>  00000010: 00 00 00 01 00 00 00 02 00 00 00 05 00 00 00 01  ................
>  00000020: 00 00 00 01 00 00 00 01 00 00 00 00 ff ff ff ff  ................
>  00000030: 00 00 00 00 00 00 00 05 00 00 00 05 00 00 00 00  ................
>  00000040: 91 2e 6f b1 ed 61 4b 4d 8c 9b 6e 87 08 bb f6 36  ..o..aKM..n....6
>  00000050: 00 00 00 01 00 00 00 01 00 00 00 06 00 00 00 01  ................
>  00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 
> The root cause of this failure is that prior to the repair, there were
> zero blocks in the AGFL.  This scenario is set up by the test case, since
> it formats with 64MB AGs and tries to ENOSPC the whole filesystem.  In
> this case of flcount==0, we reset fllast to -1U, which then trips the
> write verifier's check that fllast is less than xfs_agfl_size().
> 
> Correct this code to set fllast to the last possible slot in the AGFL
> when flcount is zero, which mirrors the behavior of xfs_repair phase5
> when it has to create a totally empty AGFL.
> 
> Fixes: 0e93d3f43ec7 ("xfs: repair the AGFL")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/agheader_repair.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 4e99e19b2490d..36c511f96b004 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -628,7 +628,10 @@ xrep_agfl_update_agf(
>  	}
>  	agf->agf_flfirst = cpu_to_be32(0);
>  	agf->agf_flcount = cpu_to_be32(flcount);
> -	agf->agf_fllast = cpu_to_be32(flcount - 1);
> +	if (flcount)
> +		agf->agf_fllast = cpu_to_be32(flcount - 1);
> +	else
> +		agf->agf_fllast = cpu_to_be32(xfs_agfl_size(sc->mp) - 1);
>  
>  	xfs_alloc_log_agf(sc->tp, agf_bp,
>  			XFS_AGF_FLFIRST | XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
