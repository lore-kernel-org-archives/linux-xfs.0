Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA2FC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9109920722
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JXzvzO3n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgGAIeu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbgGAIet (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:34:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FFAC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:34:49 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id e18so11352749pgn.7
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 01:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yFWJZ1nvPFQxKkNEV6qkZkIkFJY6Z8UVdCBPGFYvbdk=;
        b=JXzvzO3nvd2HnLqHtzV8eQShe0/TR6Rw7/XYDerjClmPDKGXwk7gnNRRriigD5M4Gd
         R83bQyg0LvQzlnSTS4FCMMlCb56+gZUczh/RxutWe1sGNPAHvX8rPNnjTlrfSLZey+0j
         WyIlbHefb9eR79czmoIh+kKqprkVivPE98U9Sp+vRMYtmIrQY+IQiVctO9Q6ZehvOVNT
         XYXOIqqttenaX8OFpr8s5sNF1KmXtW2B9KJ4sDcnABcoZ48NKe/2aLJby3T069Ez6HBC
         iAy+86aq+Mk6K6QqXJsZPXiayTA3EBcN5LP3GqLE1oXDzfosiWf7Gmv4I8ijc7Aktf02
         LeVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yFWJZ1nvPFQxKkNEV6qkZkIkFJY6Z8UVdCBPGFYvbdk=;
        b=TAI2nFH0JVP6RvPS6LsR5LOXK+gjGdDMWulk4YaW0Gr54BUDHMFaWx7JpmxZ+5m13i
         /3Zahj1+TFt3V8Hr2zwWKVhRYf3qrKDyzcTHXswSiou0WtClCWtz++RCt2QAxw7Oy2ZX
         OdFJ2dbQeuEFN69imQhx2VNLD4iEoUof4bLWCXe0FW8YfPhjRGIlkaXfvGxk05sPMXWA
         Lcyulz7AKHozmAnFN0SauvKAp1iR8I/KNoPQX6CM+LjZx53h2HgaLfvPunha+odatA8M
         DQIjxvFlG+85+OzsYr6sV7ed/P7v+UanC6znj1ijJF7FIQoYVdborWIbpwrUR2c1hDK6
         65mw==
X-Gm-Message-State: AOAM532bUm5qPNe4CMiJiCTe29+HKWxw8a1do5UJT+P+miPao1o8Db07
        k3XmWa3rGhehTorr9Ba0IiqUaykZ
X-Google-Smtp-Source: ABdhPJy+3ueqgSnrzr0/LKgChuvMxuWBCR7elohwKrQK07HWDRxIZJM2iuaTFlLVSMN5dcXWC4byAA==
X-Received: by 2002:a62:cf42:: with SMTP id b63mr16641765pfg.322.1593592489344;
        Wed, 01 Jul 2020 01:34:49 -0700 (PDT)
Received: from garuda.localnet ([122.171.188.144])
        by smtp.gmail.com with ESMTPSA id 130sm4929278pfw.176.2020.07.01.01.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 01:34:49 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/18] xfs: fix inode quota reservation checks
Date:   Wed, 01 Jul 2020 14:03:00 +0530
Message-ID: <1800809.xzDrfeQqv9@garuda>
In-Reply-To: <159353172261.2864738.3201442261854530990.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353172261.2864738.3201442261854530990.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:12:02 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_trans_dqresv is the function that we use to make reservations
> against resource quotas.  Each resource contains two counters: the
> q_core counter, which tracks resources allocated on disk; and the dquot
> reservation counter, which tracks how much of that resource has either
> been allocated or reserved by threads that are working on metadata
> updates.
> 
> For disk blocks, we compare the proposed reservation counter against the
> hard and soft limits to decide if we're going to fail the operation.
> However, for inodes we inexplicably compare against the q_core counter,
> not the incore reservation count.
> 
> Since the q_core counter is always lower than the reservation count and
> we unlock the dquot between reservation and transaction commit, this
> means that multiple threads can reserve the last inode count before we
> hit the hard limit, and when they commit, we'll be well over the hard
> limit.
> 
> Fix this by checking against the incore inode reservation counter, since
> we would appear to maintain that correctly (and that's what we report in
> GETQUOTA).
>

As mentioned above, q_core.d_icount's value can be less than what has been
reserved by various running tasks. Hence deriving new reservation count from
q_core.d_icount is incorrect.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_trans_dquot.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index c0f73b82c055..ed0ce8b301b4 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -647,7 +647,7 @@ xfs_trans_dqresv(
>  			}
>  		}
>  		if (ninos > 0) {
> -			total_count = be64_to_cpu(dqp->q_core.d_icount) + ninos;
> +			total_count = dqp->q_res_icount + ninos;
>  			timer = be32_to_cpu(dqp->q_core.d_itimer);
>  			warns = be16_to_cpu(dqp->q_core.d_iwarns);
>  			warnlimit = defq->iwarnlimit;
> 
> 


-- 
chandan



