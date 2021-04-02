Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F2DC433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 05:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C3C261001
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 05:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhDBFFC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 01:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBFFB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 01:05:01 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACCFC0613E6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Apr 2021 22:04:59 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f10so2909789pgl.9
        for <linux-xfs@vger.kernel.org>; Thu, 01 Apr 2021 22:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=rtQT+OwXKd6Z2mRWC2YAgLTgteaXjNic+0HYEgWQIzA=;
        b=AF/caNhnf/esYaibE/MJ4nE/HYUUhe4z4U0mxu9TfBa6VdIowML0PFTiTnFVU1hvd1
         87Yqmz4hxZgfW2SlyN3sgHN37b3e4QSXkn05QYg9uZZ8GXfmwLHJO4KguMqW6PRNzImo
         VHhmDXn0e4bPn1u2eoUxGRjK5/zlTmrAyjBK2j5SbYS+DbTb7xu4JDeQL9114NwPeyIt
         bAMYebctFx2GGBk9O5ZLmxxlqneXKCz0fcjrJp1AlEwo48+jkFEBhHlGPqeO072CsPih
         RRG4IvzOV0PWd9rCgQk1JIGV3tLCnh4pSICDI9jPnSfY0pcyFLTK2Ut9Dg2gKX+VB/Yg
         wc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=rtQT+OwXKd6Z2mRWC2YAgLTgteaXjNic+0HYEgWQIzA=;
        b=tHyC5KvxmbhWLWgN/Ui3UhF6M4MdAaWPyONRrDmLOvBMAWPke1CEW/uMTyKxhEZinF
         ClGg++ihoXYbz8T50M85bvi6riWk3MvGGGJY0YCMTrk74IB/b15wroJUxG5F5+NWwZa6
         GVv66lA9VcgCREpyEXebV7vSA3KTnBM+AwcktyJnpedkT6fYfXQM9od7ZrtHvlkb3TJl
         kl8vaZCclmrfxl6gz/f6ls5zuLakbD4xqUwWNYjGVnY22MkTY0ZkNeXEuTnPqPpLf/5S
         EpCrCzBCkOEq+Eb/57b9KIAdZJXI7FHq8/6RLa1AXjSleR78Syh2xLUY4CDZwOHkr4Il
         qEUQ==
X-Gm-Message-State: AOAM532kSL7G73yeAIsJLAqUGVn2BAHaA2csQRR/NLDrzqg4rR500SOy
        Ftoq+o3TBaWxvkRd/fb6Xp99bAeqSzo=
X-Google-Smtp-Source: ABdhPJwUY/I2iMbFHQGEWVU/K5p0FVqETuB9/4x4uY4BkPDVfkbE2AFygYjO9f9/usM0lAU1h3laww==
X-Received: by 2002:a62:2585:0:b029:1fb:bd86:2008 with SMTP id l127-20020a6225850000b02901fbbd862008mr10297272pfl.77.1617339899248;
        Thu, 01 Apr 2021 22:04:59 -0700 (PDT)
Received: from garuda ([122.171.33.103])
        by smtp.gmail.com with ESMTPSA id v1sm6920308pjt.1.2021.04.01.22.04.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Apr 2021 22:04:58 -0700 (PDT)
References: <20210326003308.32753-1-allison.henderson@oracle.com> <20210326003308.32753-10-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 09/11] xfs: Hoist node transaction handling
In-reply-to: <20210326003308.32753-10-allison.henderson@oracle.com>
Date:   Fri, 02 Apr 2021 10:34:56 +0530
Message-ID: <87pmzd6zuv.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Mar 2021 at 06:03, Allison Henderson wrote:
> This patch basically hoists the node transaction handling around the
> leaf code we just hoisted.  This will helps setup this area for the
> state machine since the goto is easily replaced with a state since it
> ends with a transaction roll.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

-- 
chandan
