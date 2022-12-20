Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDCAC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 04:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiLTEti (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 23:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiLTEth (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 23:49:37 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BF1CEE
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 20:49:36 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id t18so7703246pfq.13
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 20:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J9+SQPtmRecq33+/N6HkpYt5nR60lkZwVbwU4eoIoGc=;
        b=x5qsgosQnYmkLfp1l0J9UkC5taUdrl4lm3SFFCUNXf5IZxIV44eDj06fURLdE39q5J
         mW0rDbMgcmc1eTla6KrsIW/EuGCB4W6TfpXQzZQdUG/RI7UcYa5ogdVs+KZ67hWbq31I
         sfTyOXtpQkGR9hE4wDhHhTlLC7Z/FpVn5CVsWYPYKUp6zx6YjEBi8JGnLqV+9GBBmal/
         cIvP8cSTgyWh/UdZupt1O0tZvF7mVe4nT6dWatQ6KrlXx2jFHAV/Qd+rtQ+V1TgJjKWQ
         dYMnY7WiG/uW1G7aq6el1BZqIpv55+CWRsREdiPVTcmUsuy0iPraf/3kXJc3xv3gWB7L
         SilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J9+SQPtmRecq33+/N6HkpYt5nR60lkZwVbwU4eoIoGc=;
        b=Ob3JhX8T8tRdY6ijPJvnj7VUGJ8XyEZOjgbujfXDpyIFvPH4LcyCvlDaEdmwuNLNhb
         /tkpnggfRg2JiMXn3o8coKwAukH9kSSafXAHhwW3rUkC1mkz4C3Tq7OSS36n/SYG/czl
         dckVqigmc+GmOQDV+HcKEIEvCupPcvgV7CPxsuwbHKRYBTtLjzGJJU4IE6hp5mDcc7sL
         df+FiD+KI3kq+G5PH5ypK6TR0bLtB2qnF7kopT+NYw6blP0TiB3IKDEw3gBdFkP2DOYg
         pWnyrYOS2iyUkuhHTwR4QPlAnQNHNia2wsZpOgZR78PnsZN2JY//CwjmIXJ/7O1n/0Pq
         QcwQ==
X-Gm-Message-State: ANoB5plTxlV3Q1alNCK0mBiSK39hwXoBHXcgcuEAxo9Ur81d4fm7+Lwu
        M0iCiUluQNCOxJ83JlNnYzKaznDVyqX5dZa8
X-Google-Smtp-Source: AA0mqf42SPpsDDzfabxlVaf68xO7jDDr7lkcC3LtIfIRA0RgmvVFkF0LgBr3HKuwe+hAvX/aCCkSdw==
X-Received: by 2002:a62:7983:0:b0:577:8d87:d8f4 with SMTP id u125-20020a627983000000b005778d87d8f4mr46847324pfc.34.1671511776260;
        Mon, 19 Dec 2022 20:49:36 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id z9-20020aa79589000000b00576489088c7sm7540554pfj.37.2022.12.19.20.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 20:49:35 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p7UZJ-00AZsW-Cq; Tue, 20 Dec 2022 15:49:33 +1100
Date:   Tue, 20 Dec 2022 15:49:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: make xfs_iomap_page_ops static
Message-ID: <20221220044933.GI1971568@dread.disaster.area>
References: <167149469744.336919.13748690081866673267.stgit@magnolia>
 <167149471429.336919.12382220831144249809.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167149471429.336919.12382220831144249809.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 19, 2022 at 04:05:14PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Shut up the sparse warnings about this variable that isn't referenced
> anywhere else.
> 
> Fixes: cd89a0950c40 ("xfs: use iomap_valid method to detect stale cached iomaps")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_iomap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 669c1bc5c3a7..fc1946f80a4a 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -83,7 +83,7 @@ xfs_iomap_valid(
>  	return true;
>  }
>  
> -const struct iomap_page_ops xfs_iomap_page_ops = {
> +static const struct iomap_page_ops xfs_iomap_page_ops = {
>  	.iomap_valid		= xfs_iomap_valid,
>  };

Oops, yeah.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
