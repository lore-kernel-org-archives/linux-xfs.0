Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FCCC38A02
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 23:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbiJYX7f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 19:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiJYX7e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 19:59:34 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEE621AA
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 16:59:32 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id q9-20020a17090a178900b00212fe7c6bbeso562651pja.4
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 16:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oN4TXbu2ARELZle9DrKF6pWsgEQuzebLp0s3qf1LySg=;
        b=iKQ3F2cDP0vkEllwupxlhhwXHgYw23pHnKCb9Xn5EM4dLB+0ZQCwdHduARLTykOM/3
         Vbkq0DH1JE1QInEAJe+4VknxxuEHFsPN8kA1tgOmDQksfvd8lo0ABnRXPVSoVQMM1SLn
         a6KvVCst/XDC/KhfyIdrDpDw8EswwExL74/aZyjXXcsb9X9BS2dZQTT3I6KXHkkdTQg9
         r7JbzhT/B5z2RTw/RMn9db59F8PsXMd0RHjaJAG58dmZfWQ694Ypzp4uQmpjvzeoxloh
         xE6Nvr860hDh58ubeCoLihBPKSaISWHx4pwtQdNIbNVsWfXoVpQ9Hi9sGNr1J6c2XVvj
         29BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oN4TXbu2ARELZle9DrKF6pWsgEQuzebLp0s3qf1LySg=;
        b=qK4F7t5j+GUILzVbpA483GK2DWn0CEnauv71SiuWSgf/83Ll4hhh6gxGg4dwissq4c
         /jslc0HiONoklTFflxajukLhfGZFRH0RGCHdlXuDRRteX/1ytJCISgtMl/1gPbe1aEGX
         Rvu1QKLAZUCY5Ss6hZilgGO35QfbK1GEiKiO18DBcouI9cYoZQjkkn9RHP5uuR3yr9S0
         7vdIfOXYAferjmnf/SehdDSwxTj6Q8PIYN5u7PiGjwb5S4vCc31hq39wesoGHo9x8pB/
         By4IY+NUwqPKYH372kWs13D1tauwj+8VkZwDzu6HgkNhuYOHng4zqM8AoM7Myc4+c2jE
         M2Sw==
X-Gm-Message-State: ACrzQf2hefWs1eo9rECFZQS2hwO1yUkpaFbCzgR7/kYYJ4wJLiw3bGIv
        X8RMVX115bqwARxavnDvkz5QSJnUNDbJtg==
X-Google-Smtp-Source: AMsMyM7ISGJubMnLLpr18ACbYK9lLm3ehs663tgVSddEgWuIrT2IYC/ok/kETrROkqo9nYBYozxgZA==
X-Received: by 2002:a17:902:f28b:b0:186:b069:63fc with SMTP id k11-20020a170902f28b00b00186b06963fcmr10894246plc.38.1666742371781;
        Tue, 25 Oct 2022 16:59:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id 190-20020a6205c7000000b0056bcfe015c9sm1898368pff.204.2022.10.25.16.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 16:59:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onTpQ-006Pd2-L8; Wed, 26 Oct 2022 10:59:28 +1100
Date:   Wed, 26 Oct 2022 10:59:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: refactor refcount record usage in
 xchk_refcountbt_rec
Message-ID: <20221025235928.GJ3600936@dread.disaster.area>
References: <166664718897.2690245.5721183007309479393.stgit@magnolia>
 <166664720033.2690245.15933537129611057373.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664720033.2690245.15933537129611057373.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:33:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Consolidate the open-coded xfs_refcount_irec fields into an actual
> struct and use the existing _btrec_to_irec to decode the ondisk record.
> This will reduce code churn in the next patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/refcount.c |   58 +++++++++++++++++++++--------------------------
>  1 file changed, 26 insertions(+), 32 deletions(-)

Seems like a straight forward conversion.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
