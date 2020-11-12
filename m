Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD2F8C388F7
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 05:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 918CF21534
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 05:41:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kRdk9QsQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgKLFiB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 00:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbgKLCog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Nov 2020 21:44:36 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B229CC0613D1
        for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2020 18:44:34 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id f18so2886117pgi.8
        for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2020 18:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dQWQJOJWd3EjBz2dGxey3/e3PK/H1KoiwJ69/sR6oqI=;
        b=kRdk9QsQHI/Hxtdr0lVP3VHE2rwflW1zhNpsFwMHe+GcEnEDQo2L7mJma2tUIAoacy
         P4c5f4rjB/JrgweG3yqCcmTejIiyYlzhXEX2CqdJy+PkuLqY/cn5/p0LMePavuzlD+KB
         IYWqNGT2bYBqe34OHYUM37Y7kRMliUcU4EpMdxBo93G54XgHHnr3hq3YCBkoWG+x7VZo
         RzjBnz0Bvg967JFSEBKvGM86tQbm8lCFcOLNZMa12/hN7jWQ5MdqreCmUWy1BPudG8QZ
         LbHt7+nmjjmXGfVsGxef3qRz6SSa1NY/dQlpy2iR6meZd6xXtlaPe7JBSdXfSumVr9G/
         w5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dQWQJOJWd3EjBz2dGxey3/e3PK/H1KoiwJ69/sR6oqI=;
        b=QfZk/PMJ1bN3m3OMQzT/g7NrgHHlhiCPS47TRcEYaKP2BMWJKCPanq3CM5364sCr6x
         +C5GqlTZvsAJmqBIvu+jd5/pFJ/lV4P4SMwYPy5STIZEwoENwppWl8xRXa32QOlSgP2X
         Xr89pp4fXg4fzNNhRPCXXlc7uqAqb53ShoLhWPfeueA78ArOTajZGuPwv6luvwzLLqEK
         vCSGxVb0VYzfVSkaLaEyPXU0bAvft8I2jgP2dlQonsJOHXyF/Agj6pVdJXq4wkWg0Vec
         XTNFWE7rQgAIuVDTDdlsIhtuJWPVLmiv2jb1ldUJr1P5kIQJ0njv3YXfOjCWHbp2LqQ4
         a8aw==
X-Gm-Message-State: AOAM533LzsckP7bVCR9psiUDz+OMbympJ5XMXMCNmzBq/xsWkbuuEZqf
        UMrDr9Col6BQ3+du3T8WOQ==
X-Google-Smtp-Source: ABdhPJwK+A5JAVNZLI/mfxp8J/wEEMP8nmeaHl9IjXik/1P37fmnFguWLgP2M7ZHW9VFxQTyEc0vGg==
X-Received: by 2002:a17:90a:7522:: with SMTP id q31mr7018616pjk.158.1605149074176;
        Wed, 11 Nov 2020 18:44:34 -0800 (PST)
Received: from [10.76.131.47] ([103.7.29.6])
        by smtp.gmail.com with ESMTPSA id k21sm3985841pfu.7.2020.11.11.18.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 18:44:33 -0800 (PST)
Subject: Re: [PATCH] xfs: remove the unused XFS_B_FSB_OFFSET macro
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
References: <1603169666-16106-1-git-send-email-kaixuxia@tencent.com>
 <20201027184708.GC12824@infradead.org>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <cf86dd98-a6c8-20d1-b0fa-133731d9ea06@gmail.com>
Date:   Thu, 12 Nov 2020 10:44:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201027184708.GC12824@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/10/28 2:47, Christoph Hellwig wrote:
> On Tue, Oct 20, 2020 at 12:54:26PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> There are no callers of the XFS_B_FSB_OFFSET macro, so remove it.
> 
> No callers in xfsprogs either.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Hi Darrick,

There are some patches that have been reviewed but not been merged
into xfs for-next branch, I will reply to them.
Sorry for the noise:)

Thanks,
Kaixu
> 

-- 
kaixuxia
