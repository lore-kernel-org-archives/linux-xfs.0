Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E302CC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 02:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 768DC20897
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 02:57:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sTaR2Zg+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393932AbgJPC5Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393931AbgJPC5Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 22:57:24 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7017DC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 19:57:24 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id y14so523113pgf.12
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 19:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sB++VUzj5VOEG0xQfpsKdS0aTrXqatpWizFea1A10Nc=;
        b=sTaR2Zg+smFNS0tuVsWBF6QXrAUOdC1syht2oTLP4J0xJ6bGtULn069f9nLXO6t4qW
         IJouceO+9Y5XjdbReZRHPq5/k/cjcEs5+A6I7WpFA4xEV2Qk/fZO1OQ39uAXewiKff/a
         qLOoaRJjRTnIG610ojJe4AFUBYEc5cIIDZuH3TCe/6rRx1wSY5vb12uLvJnNOX14MSiY
         wJ+ggGf3Zr43314oCOgEz2OeVLpp4t2LgLK12ES98WHjXct7YzHWZxL6hk+QFXdG3pfR
         9Hu2pCPXb3QKGvON6173UCsqDgEECEB2Xq7TmE3djb6pJh8XoCJGho4QhKLIgaylyaSa
         2Xmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sB++VUzj5VOEG0xQfpsKdS0aTrXqatpWizFea1A10Nc=;
        b=ObI2HyuYXl/3f5e/2uq/jGOf/cnG82+4vSTsmH5TYzMDiZK1eE0c6fdsvTI3Hjafns
         G0XbAyHwcNdqX4W0yz3b0cFEFUEjPnbxIDQEBTq0trQJqfYke0SDs8T4L+ZJ8sVHJtOx
         HdZBY/GL/pZ7rEE8np7YS6erliU54xEYZjcW83NCqGWNUBbPRJdMmfsjJuq2juOhZAQV
         nmnRMcwq1gHlXR30Va8J6d0hQdEXG71LEDeoQkIHwbcWBjBrja8JeTAjT8rDqlhRWBJv
         VwMo+5GGnyDsQe1LWMmUZDZM21coAStsQD5SpT/Uog/fwSqzg4zJ+Sq6yk/C3bJzAbbl
         1YKQ==
X-Gm-Message-State: AOAM533kSB+3SAhU/yfQ8mCQc1KBTrhECFS7q+o4rlk95GPq6otfndbm
        UoZX7AReebwLeVuYVQM1og==
X-Google-Smtp-Source: ABdhPJxLhFL5aLRvbD5tqzq1JN2xykbGEhUElfr1pzlcNHxbkhy+GKl6QukXx7imvuO0uqP1oxeOfA==
X-Received: by 2002:a65:454c:: with SMTP id x12mr1369301pgr.101.1602817043733;
        Thu, 15 Oct 2020 19:57:23 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.6])
        by smtp.gmail.com with ESMTPSA id u8sm687347pfk.79.2020.10.15.19.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 19:57:23 -0700 (PDT)
Subject: Re: [PATCH v5 1/3] xfs: delete duplicated tp->t_dqinfo null check and
 allocation
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
References: <1602298461-32576-1-git-send-email-kaixuxia@tencent.com>
 <1602298461-32576-2-git-send-email-kaixuxia@tencent.com>
 <20201015082245.GA3583@infradead.org>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <4c9cf4f2-c349-fdb2-90c0-e73beda0ff8f@gmail.com>
Date:   Fri, 16 Oct 2020 10:57:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201015082245.GA3583@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/10/15 16:22, Christoph Hellwig wrote:
> On Sat, Oct 10, 2020 at 10:54:19AM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The function xfs_trans_mod_dquot_byino() wrap around xfs_trans_mod_dquot()
> 
> s/wrap/wraps/
> 
> Also this line is too long for commit messages.
> 
>>
>> to account for quotas, and also there is the function call chain
>> xfs_trans_reserve_quota_bydquots -> xfs_trans_dqresv -> xfs_trans_mod_dquot,
> 
> This one as well.

Yeah, I'll fix them in the next version.

Thanks,
Kaixu
> 
> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

-- 
kaixuxia
