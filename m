Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5346FC4360C
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A67A20842
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfI3Hiw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 03:38:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfI3Hiw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Sep 2019 03:38:52 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 37DFD83F42
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2019 07:38:52 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id r21so3568171wme.5
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2019 00:38:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=mP2v3mJlYcmfFASYlbmxI1PhaXvZxAGZkXr7LTAmWRM=;
        b=ZyZu8h76buepvBGAGTH/rZ5DiPvocVViwx5npa4akezZyuuiDzfCFkuCXwILcJaAlm
         ULlwmzp8avEBk+vfcy1WkkgVWqkAu8tmflMspe7pMybw5UKsrbWP0q/sFqviAnOIZ3Ro
         27Y7wtkwqYDfGruVWXXYwHafXSuuFHxr8lhF4bs8vLsUfLf371CZ8nLnIktmChHOiDp0
         Oa4c/+0bPYzaKtvcXtqA4lT/r2PdfOVDJVcix3iFjM8BD6/jE6AmpYjdb73SBx50Jx01
         Nhjk7pfiNfu0QHL8w6k23srKfRCyuT5hc0jKuk3nysuDBVu/j+zxybr3tjxlWBY8zVZD
         8tgA==
X-Gm-Message-State: APjAAAXymr5zgL4IbVahMK11CCFNOjgAiThdh4b8RM/00TZck5SKDRnW
        7KML69iDCU4GGWU6S5o/ETdlG0coDQFuyU2BKnNuVekDSjqgZiVx6Kxi1npfYEdS4YDo3/BHF3Z
        t+AvGL7JoU0GXs7ijVIhH
X-Received: by 2002:a05:600c:291c:: with SMTP id i28mr15154851wmd.98.1569829130936;
        Mon, 30 Sep 2019 00:38:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzmQZtL05KRBE0Qzz3NjpzcEhZGD/I2ve2k/FeaXu5jJ+8tmdcmIbn1zV+NhAeJcuOEqFYH5g==
X-Received: by 2002:a05:600c:291c:: with SMTP id i28mr15154839wmd.98.1569829130727;
        Mon, 30 Sep 2019 00:38:50 -0700 (PDT)
Received: from orion.maiolino.org (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id q19sm30684507wra.89.2019.09.30.00.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 00:38:50 -0700 (PDT)
Date:   Mon, 30 Sep 2019 09:38:48 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove unused flags arg from xfs_get_aghdr_buf()
Message-ID: <20190930073847.clcevqwdjomqugtz@orion.maiolino.org>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <2f4d86a1-0cb9-f859-b120-34d1b511942f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f4d86a1-0cb9-f859-b120-34d1b511942f@redhat.com>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 27, 2019 at 10:46:42AM -0500, Eric Sandeen wrote:
> The flags op is always passed as zero, so remove it.

Fixing the  op -> arg:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> (xfs_buf_get_uncached takes flags to support XBF_NO_IOACCT for
> the sb, but that should never be relevant for xfs_get_aghdr_buf)

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 5de296b34ab1..14fbdf22b7e7 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -28,12 +28,11 @@ xfs_get_aghdr_buf(
>  	struct xfs_mount	*mp,
>  	xfs_daddr_t		blkno,
>  	size_t			numblks,
> -	int			flags,
>  	const struct xfs_buf_ops *ops)
>  {
>  	struct xfs_buf		*bp;
>  
> -	bp = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, flags);
> +	bp = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, 0);
>  	if (!bp)
>  		return NULL;
>  
> @@ -345,7 +344,7 @@ xfs_ag_init_hdr(
>  {
>  	struct xfs_buf		*bp;
>  
> -	bp = xfs_get_aghdr_buf(mp, id->daddr, id->numblks, 0, ops);
> +	bp = xfs_get_aghdr_buf(mp, id->daddr, id->numblks, ops);
>  	if (!bp)
>  		return -ENOMEM;
>  
> 

-- 
Carlos
