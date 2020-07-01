Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E63BC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F362720722
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LgNAZwOx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgGAIew (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbgGAIew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:34:52 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1153AC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:34:52 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e8so11368080pgc.5
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 01:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DO+YrgKOds4/Wzm1X15yq52Qm5648n5bkoBdk5nUqyU=;
        b=LgNAZwOxAWrroQb7u59fS5gVOT9NdA8EykQCH312AhAQT6u1mHPmpOrwT4QFA+9MSs
         5TCoBVEANLPf00xku5YiqKMQVgS+b3GpxRrxgwqG/u62QlaB209auoFQL6vJaqbXS9Kv
         XvGFJSpyVcahXEEEQmuc9S0WVCb60BofIACPLr5tn+AQunF5+HkqHZ47jBmDX77auo0x
         LkqVHtYSyECxOudE3oefPiiM5ETDulxNUMOsEK086mkK2gQmu+TRjS4c0vNoHkZWkATk
         NnYg3QnF0mL+IUclN1z/eoggqBNi/aV1BPKawyFrNIEDigf1AU21CpDlcI/dqVrVbHLL
         cVtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DO+YrgKOds4/Wzm1X15yq52Qm5648n5bkoBdk5nUqyU=;
        b=AHxEthU85tfavV9Gqb5v6OEn8ppZMKY5JJo+0JUqEuKcKpqDmRBqy3KCKe/8ucTP6h
         hwHMmKAqvB6mwI/9VfV6rnkeKMF8NmiMsNeVaSs/3AeiZtRBw9dSK9WeMWUwnQNSYvL4
         sh0eagGzHA4Pudv1SWJTsszetKjqUe3+JBhRc7odSOWsOq9Bwica0fIMiNbsM4lQJEMa
         aFIP3/Ffr1YHJp6AZBvquqn4FuHbtkvzp5xsZYKgf8c/vc2iGI1PD2HB3K2G1sgNuYdA
         QjYxhm/BDtEHJV0wDdwwYLuzYGcqobuojsbQ0T/mIMY5KIsoZWSVYBV2mDI7ta5UaXhS
         bAcA==
X-Gm-Message-State: AOAM532QVCDnY+9hgGpiocwPIg3PcRqhNIqY+R92BNMipLKR9EvsyDzR
        8m12Dona/R/IUtEhAeCa4MOGTE3S
X-Google-Smtp-Source: ABdhPJz+/XBf7y00QVPT4IK1LZkGIhYumUg9j+xyU8VTbxcFQEa2mMtqG64kjgCzTP/E197wlLhmeQ==
X-Received: by 2002:a63:5a17:: with SMTP id o23mr18900289pgb.218.1593592491623;
        Wed, 01 Jul 2020 01:34:51 -0700 (PDT)
Received: from garuda.localnet ([122.171.188.144])
        by smtp.gmail.com with ESMTPSA id 21sm5057430pfu.124.2020.07.01.01.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 01:34:51 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/18] xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush
Date:   Wed, 01 Jul 2020 14:02:15 +0530
Message-ID: <5478435.i7RmhvRWad@garuda>
In-Reply-To: <159353171640.2864738.7967439700762859129.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353171640.2864738.7967439700762859129.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:11:56 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit 8d3d7e2b35ea, we changed xfs_qm_dqpurge to bail out if we
> can't lock the dquot buf to flush the dquot.  This prevents the AIL from
> blocking on the dquot, but it also forgets to clear the FREEING flag on
> its way out.  A subsequent purge attempt will see the FREEING flag is
> set and bail out, which leads to dqpurge_all failing to purge all the
> dquots.  This causes unmounts and quotaoff operations to hang.
>

xfs_qm_dqpurge() checks for the presence of XFS_DQ_FREEING. If it is set, it
indicates that another task is freeing this dquot.

A failed read operation could return -EAGAIN and hence xfs_qm_dqpurge()
returning without clearing XFS_DQ_FREEING would mean that future invocations
of this function would turn out to be a nop and hence the corresponding dquot
would linger around forever. Hence the fix is correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Fixes: 8d3d7e2b35ea ("xfs: trylock underlying buffer on dquot flush")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_qm.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index d6cd83317344..938023dd8ce5 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -148,6 +148,7 @@ xfs_qm_dqpurge(
>  			error = xfs_bwrite(bp);
>  			xfs_buf_relse(bp);
>  		} else if (error == -EAGAIN) {
> +			dqp->dq_flags &= ~XFS_DQ_FREEING;
>  			goto out_unlock;
>  		}
>  		xfs_dqflock(dqp);
> 
> 


-- 
chandan



