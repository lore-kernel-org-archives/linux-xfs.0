Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496F7C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 04:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06E5360FE8
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 04:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhDBEk5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 00:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhDBEk5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 00:40:57 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA24C0613E6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Apr 2021 21:40:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h8so2022258plt.7
        for <linux-xfs@vger.kernel.org>; Thu, 01 Apr 2021 21:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=VLWq82Q3CSzaigcN2OKHDaSf7kb4WEI8Nli18XHbBVU=;
        b=gPIAs2ks4h9S3poz0qvUIUWVOgAWzvhXQETIrU5ITGfIXCAqKBTX3TzhsaQ+L/mayc
         2++4QAM1hI1CJrDkwb3Ox/DfGCoRdgb3Gh5eorpAYD8jqQPSgkF6RbNTL7U0t6zE8lFF
         T/xHBJZgSOiqWc61d6y7nPRUXLE/fC/ib2qmzVsKMe8UXw/q/FUIBow9mjb+BdQwiBnq
         zopbmu0na3tI0g/XOxMucL/0TfqHusvF8InNSDJQe4rJipcxGv1yUn9l6Se2/ey3AvWe
         g4+078Uo1ceNQhL2R5cOidYKenaieHwQbuphvu2+sAb35agxMICCeSDRg1AbvHMV9GSw
         081Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=VLWq82Q3CSzaigcN2OKHDaSf7kb4WEI8Nli18XHbBVU=;
        b=WONN7WnZ/ZhUaGp1S9JhhjzCd0mEZUQ+OhHlBmOhQZWrf/8vrMNdLUzrkLs4hcNdpT
         qfiAgBO1EPTTkGvzqC2YYaPPicHKV/fb16xYQEu5T3g3vQU/3lRohf3YkP5UNIKzAgz8
         gQMVBtP6vx0fjrJjWvlPiQSx1vyvDRSTUMr1OeE7VcvmDKkasvk+pvNqcDY0DtBsrJKy
         87Xcxe4V0qqe77npCzPDDsoWuwUSeGo1VwoIvp/aBSbuTFsQiNNix/B/1SC4AE+z83mX
         Hp2W4MZE0ZZqHB2XMdtN6/juwtj+LovrISvU9ijKMu4nBwyoIkjWynepqawyIX80zH0L
         5Lqw==
X-Gm-Message-State: AOAM530JP9zgZdqVz158J8h8aXhPHAjegUyQRezIiY8tAUj6bBhYpabt
        7od0GRT/hA85kXJNE0wMNoAlURXkARk=
X-Google-Smtp-Source: ABdhPJybZtI7awcICbTjuhpNtFZWvG2B4o015tMcUaNEkEFyzPqk8zWk+oEv/ry9nBntQV6432+MUg==
X-Received: by 2002:a17:90b:230d:: with SMTP id mt13mr152542pjb.3.1617338455998;
        Thu, 01 Apr 2021 21:40:55 -0700 (PDT)
Received: from garuda ([122.171.33.103])
        by smtp.gmail.com with ESMTPSA id q10sm6831832pgs.44.2021.04.01.21.40.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Apr 2021 21:40:55 -0700 (PDT)
References: <20210326003308.32753-1-allison.henderson@oracle.com> <20210326003308.32753-9-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 08/11] xfs: Hoist xfs_attr_leaf_addname
In-reply-to: <20210326003308.32753-9-allison.henderson@oracle.com>
Date:   Fri, 02 Apr 2021 10:10:53 +0530
Message-ID: <87r1jt70yy.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Mar 2021 at 06:03, Allison Henderson wrote:
> This patch hoists xfs_attr_leaf_addname into the calling function.  The
> goal being to get all the code that will require state management into
> the same scope. This isn't particuarly aesthetic right away, but it is a
> preliminary step to merging in the state machine code.

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

-- 
chandan
