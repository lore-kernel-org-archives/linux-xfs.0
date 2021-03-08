Return-Path: <SRS0=7MVS=IG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09122C433E6
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 09:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB4A265134
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 09:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhCHJbn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 04:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhCHJb3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 04:31:29 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C34EC06174A
        for <linux-xfs@vger.kernel.org>; Mon,  8 Mar 2021 01:31:29 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id o38so6039458pgm.9
        for <linux-xfs@vger.kernel.org>; Mon, 08 Mar 2021 01:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=qtSP0YRE4pjNkU6kd4ttLHqmip2HhWX2bjfazwEguQ4=;
        b=iE0tAL14yr0AG/IxLphHn2nhZM9Vh6/wv1Jw8Y8mr5w8adL+2E1WxFaW2Zn4Ta7UmY
         UV89mADmJQmaun181As3JFsI2bs/PSma07t5hDL5+lG6rWWrP89QxfoQGJKtEK5wwjoV
         Y3R8XLEueusmQTAsPa/+O8XNpeGNIwcnWzIvag3wiv4Beko5iUX6wlJydJC62RNCjN/J
         bC74k+5+cOvNs3eMofklrxzedqV/VCDaSTAmztrfUiwX89N9DjewPcAl/OT1qLka5P78
         nVWgpyRRTTnA7IJOn6IYBFWIywXezxYUHoACHfMGZAI9N+Apmf7BwMr5rb+qemqC1Su/
         SU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=qtSP0YRE4pjNkU6kd4ttLHqmip2HhWX2bjfazwEguQ4=;
        b=T04UVU5seU55nqZyo1EY81qIm37wUKWdph0rh3IvizbrqxjXBgC2/hl/o95yv/K1/E
         ptLz27J53HuXhbnvwUTxnhVMYgid7Jnd8FqbH+Lr5weAiL2FrYjygr31TEvC17AOYk7n
         d0BWD5iEk6ZpVbVKC3f3s6jy/5Tk4sLdGc8GKapcDtoz6SJIE6QAg+Gk7F5cW7uDf388
         yFPvvOfzS+RTgXeUWxFnBleTwjfWw4FcZeFvOUSIbMHwT4fIjQ/zZCPnVVE/02m9EEBM
         w9WR4f0ZmoO7jkDm4Q0VJ79RgMu1jnEBpn+wXF1meDAsgEbQaDTigffzKJqE7a/bE8tn
         P3Ng==
X-Gm-Message-State: AOAM530O5eziMyjqVLrulHpWpy8Il5ybE+yi3pXdBHkljcrnFEp/E7vN
        foWjv1lFVDchiOmMh1g5Y10wkJJVRF4=
X-Google-Smtp-Source: ABdhPJy1XMU4zgnQaPqpVv0NZcuQy8afqfVOCNdp4OYwCNj9tPucmiUUwFhY7LLthAdyCZok151vww==
X-Received: by 2002:a63:5b57:: with SMTP id l23mr19930958pgm.445.1615195888374;
        Mon, 08 Mar 2021 01:31:28 -0800 (PST)
Received: from garuda ([122.167.156.41])
        by smtp.gmail.com with ESMTPSA id b186sm4261611pfb.170.2021.03.08.01.31.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Mar 2021 01:31:27 -0800 (PST)
References: <20210305051143.182133-1-david@fromorbit.com> <20210305051143.182133-5-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/45] xfs: remove xfs_blkdev_issue_flush
In-reply-to: <20210305051143.182133-5-david@fromorbit.com>
Date:   Mon, 08 Mar 2021 15:01:25 +0530
Message-ID: <87ft163sb6.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Mar 2021 at 10:41, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> It's a one line wrapper around blkdev_issue_flush(). Just replace it
> with direct calls to blkdev_issue_flush().
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan
