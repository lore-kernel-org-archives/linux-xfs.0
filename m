Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2495C43461
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 15:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD45921941
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 15:48:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="Lk6/SwLG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgIIPrt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 11:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730200AbgIIPrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 11:47:42 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650F6C061379
        for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2020 07:19:10 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u126so3267857iod.12
        for <linux-xfs@vger.kernel.org>; Wed, 09 Sep 2020 07:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CmblY2ylsYjWHFktEYRzj6RVW7MJd9inxZj+0AXmUk4=;
        b=Lk6/SwLGNkoc/Vmb1jUQAmwDs73O+dRP/R0g5tuhROvzrh/Xnk8DRAR5mGdwWdArJz
         vZCH3IiSyp1vbwdoaXo4+xF/vLonCfcw4VZgLReFRUaGo3f7hb0+XfH/U5M63xTrGc22
         26LIBp/6IjlkQstor6j4UKXSkN6kKDWyMBce3lqAev9u8mrhaOpzClEhtubcQJ1N1AKL
         Bj+8yJal2FyQTOENoLhAPKKLy+gnutm0ri7C3yCxOFxibH/o76jkYvTf7nZgV4gV/Scw
         1qqlDnuzC9qe2G7lwQzLfbhNXl5GB2CT1bhNa3mbs9Et/qsEY41x23JZo7JgkmMdxKUJ
         dd+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CmblY2ylsYjWHFktEYRzj6RVW7MJd9inxZj+0AXmUk4=;
        b=BaFjUdyUmoHsaFLxhQotayIgWR7lRoH0ZokI+9NynnRpPPTPCaJsqBxXRGzYMuxMpa
         7nzPbj1mkjCVBpo1oMp/euZ2tWZVSsIuRtJHpyiTXLanP2Jh/RlmXc0qw1pCMlER5x0Q
         TyL8fJ1KBoGqkSe6XbcGfJ4VPD17rY64zmaSmlovkd8uDqkk6HZxtbVKAC87UJgmDQDG
         xoIF6l1fEPK/JzbLRjhxlHBXHHiLcduezSloKVx9sCbtXIc4TwYMCFUMreYOxj08pkK2
         FbGEMqy+ZcsDsrNoIcitIje/E/fm68/zQgSh8L1x0ISbVvXXYPbZ5uvhZuO3mj4m5Izf
         cpdw==
X-Gm-Message-State: AOAM532Ogj+Lsg4sp/U8Ip03BS8SrZ7Y9IcxY4uYdenH5UJ2U4z51diI
        kw5thB81S8Gur1S9q+kbioCO9g==
X-Google-Smtp-Source: ABdhPJz8z7+J9CHtH1Rzw4Ej3kaYLD5DXx+Zu82Roro2EA5WfFs49suUa42wQSyVizXaM4N2MkzHhw==
X-Received: by 2002:a02:ca0e:: with SMTP id i14mr4357841jak.65.1599661149424;
        Wed, 09 Sep 2020 07:19:09 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r8sm1200756iot.51.2020.09.09.07.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 07:19:08 -0700 (PDT)
Subject: Re: [RESEND PATCH 1/1] block: Set same_page to false in
 __bio_try_merge_page if ret is false
To:     Ritesh Harjani <riteshh@linux.ibm.com>, linux-block@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        Anju T Sudhakar <anju@linux.vnet.ibm.com>
References: <bfee107c7d1075cab6ec297afbd3ace68955b836.1599620898.git.riteshh@linux.ibm.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a90e9ab8-93b5-8ea0-97fb-2d5ea90196b1@kernel.dk>
Date:   Wed, 9 Sep 2020 08:19:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bfee107c7d1075cab6ec297afbd3ace68955b836.1599620898.git.riteshh@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/8/20 9:14 PM, Ritesh Harjani wrote:
> If we hit the UINT_MAX limit of bio->bi_iter.bi_size and so we are anyway
> not merging this page in this bio, then it make sense to make same_page
> also as false before returning.
> 
> Without this patch, we hit below WARNING in iomap.
> This mostly happens with very large memory system and / or after tweaking
> vm dirty threshold params to delay writeback of dirty data.
> 
> WARNING: CPU: 18 PID: 5130 at fs/iomap/buffered-io.c:74 iomap_page_release+0x120/0x150
>  CPU: 18 PID: 5130 Comm: fio Kdump: loaded Tainted: G        W         5.8.0-rc3 #6
>  Call Trace:
>   __remove_mapping+0x154/0x320 (unreliable)
>   iomap_releasepage+0x80/0x180
>   try_to_release_page+0x94/0xe0
>   invalidate_inode_page+0xc8/0x110
>   invalidate_mapping_pages+0x1dc/0x540
>   generic_fadvise+0x3c8/0x450
>   xfs_file_fadvise+0x2c/0xe0 [xfs]
>   vfs_fadvise+0x3c/0x60
>   ksys_fadvise64_64+0x68/0xe0
>   sys_fadvise64+0x28/0x40
>   system_call_exception+0xf8/0x1c0
>   system_call_common+0xf0/0x278

Applied, thanks.

-- 
Jens Axboe

