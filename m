Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F661C4742C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 07:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 112BD22201
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 07:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MW96qsbC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgKMHCS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 02:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgKMHCR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 02:02:17 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636BFC0613D1
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2020 23:02:17 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id s2so4114517plr.9
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2020 23:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lohb5ImpgR77/sVI6yFOJODcDDLIZNhmm4QZIxU2atY=;
        b=MW96qsbCz9RpZsYsBkfUQNfBW5X2snIoUWazLhrxjsgsmayfA7PsTNdyRHj4/gYbKn
         2CDLGfOK6fFdPGZWxPZ3Dw8wNU9fcGAW9B6ThSnHRUDqXPX12PS++7MxBvQ242gP2eF3
         gf8A51DNb+lQzNhZwjjG0pBq3iW59yeKDoH0nvdbbta9QQpnRB+gMtuBmjl5vKjK78Ct
         sMamR73RBqgFxR5lLTGdG+QQaGbqZqTd1778rjkyHQZjHHE9iSR1631DG4b9L21qTxko
         0YmXHMRiC43OpD/G+s82oSH7WOoiQokWNP1LlYejhNkkWEmb2i7FqWcYUydC0aXw/YgN
         q7JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lohb5ImpgR77/sVI6yFOJODcDDLIZNhmm4QZIxU2atY=;
        b=GbGk7uTSc8HhjXhCkSNG2paM4hbO/4VBQEJ9v90abgoKDBsitAHWuh2Pxg0KNIrqGC
         CxtnFQrST+IcKNWviJaLxdV3Da9iQ+/a/qrjpgVcl7qXHR2/LZZIz9PE2g5CnkixF6Qi
         Oa1TsiV0+mQDiLs+8nxNWSXtAKwShc3gyZokVxRobAL8/0VdJlnhNhIg9nsUgpD5Up+C
         eipyWZ6eGzTCQ4DSzF1R73WNKR84j/GyxzCo+9JAfHoWR7llcIWqlI9LhGtO9Vk28Ggn
         R/TliKgz++K4eUyCR92yDBYhZE54KgSFE2FOW2wTuS6bFTplS1zh0mZksK/yT/x9bUzM
         m8KA==
X-Gm-Message-State: AOAM532jPOjyvpA+ofxmdLNuNqvAAn97OD69CgUHQLCQj7mgC8MoFrcj
        krqqmghj+vxBZBKwYaOHoeE=
X-Google-Smtp-Source: ABdhPJyxNCaCtuuvA8jfIEj2PUu+rg9HHpw/MbpQSqeOJMUmb4yPm1oCXeYZF5k63lMzg2pI7PfqlQ==
X-Received: by 2002:a17:902:6b84:b029:d8:d13d:14e with SMTP id p4-20020a1709026b84b02900d8d13d014emr1093916plk.29.1605250936970;
        Thu, 12 Nov 2020 23:02:16 -0800 (PST)
Received: from garuda.localnet ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id a18sm1820650pfa.151.2020.11.12.23.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 23:02:16 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/4] xfs: strengthen rmap record flags checking
Date:   Fri, 13 Nov 2020 12:32:13 +0530
Message-ID: <48646423.COuINXMs2T@garuda>
In-Reply-To: <160494587178.772802.7759758846362664950.stgit@magnolia>
References: <160494585293.772802.13326482733013279072.stgit@magnolia> <160494587178.772802.7759758846362664950.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 9 November 2020 11:47:51 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We always know the correct state of the rmap record flags (attr, bmbt,
> unwritten) so check them by direct comparison.
>

The statement "operand1 == operand2" returns a 1 or 0 as its value. So the
"!!"  operation on the resulting value is probably not required. But still,
the changes are logically correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Fixes: d852657ccfc0 ("xfs: cross-reference reverse-mapping btree")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/bmap.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 412e2ec55e38..fed56d213a3f 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -218,13 +218,13 @@ xchk_bmap_xref_rmap(
>  	 * which doesn't track unwritten state.
>  	 */
>  	if (owner != XFS_RMAP_OWN_COW &&
> -	    irec->br_state == XFS_EXT_UNWRITTEN &&
> -	    !(rmap.rm_flags & XFS_RMAP_UNWRITTEN))
> +	    !!(irec->br_state == XFS_EXT_UNWRITTEN) !=
> +	    !!(rmap.rm_flags & XFS_RMAP_UNWRITTEN))
>  		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
>  				irec->br_startoff);
>  
> -	if (info->whichfork == XFS_ATTR_FORK &&
> -	    !(rmap.rm_flags & XFS_RMAP_ATTR_FORK))
> +	if (!!(info->whichfork == XFS_ATTR_FORK) !=
> +	    !!(rmap.rm_flags & XFS_RMAP_ATTR_FORK))
>  		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
>  				irec->br_startoff);
>  	if (rmap.rm_flags & XFS_RMAP_BMBT_BLOCK)
> 
> 


-- 
chandan



