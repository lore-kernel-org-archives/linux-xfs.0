Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE98AC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 986B422795
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbhAZFS7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730214AbhAZBcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 20:32:24 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8762C061223
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 16:51:07 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d13so2975786plg.0
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 16:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uPJlUchjV+OaTIftOWbXEjVwG0d/bApny8LKz3OH9do=;
        b=Fn4EVg48BXJQ0XVCGo4P1/CcZQYyaUjR593N0Mrt0Pa+QokgKItCP+8Jqv/2LG0i6e
         ZOE+o7Kp6TSk5kE5z/p+B9iYW/TEKeeUZ38hHU2REBudTZapniqQIgruui5UYR2CX3jM
         XMAbvuY6JHqMBPOAxvGF/pd+dD2JXyjuQuYgOdpBoKEe5OkwN21A1Oz9evbFfBDmAQvY
         7WFdRbpEZ2liR9Ig+qsbIiWSj+GDDvognZEVlwuSJJV6ndniZaVtaxhiGOys5MNoWytQ
         gQ7Z3yycyJCcMckSCcJGV82qUswKaz/f7sRYaD0P22YuS9ZNrnmyYgBqU8O8EcKu5dJk
         dg7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uPJlUchjV+OaTIftOWbXEjVwG0d/bApny8LKz3OH9do=;
        b=VjwZHJlF9BHgg/uwJJWECF+DILnPeRFuNSSG0+K2YjkFlKPF9bP9GuQm4Qyu1BQug1
         4EKx6EjsE/L2muRGmVFzwruqQl11ot304n7vyYD6KhlMoYvRBsfibKhsBg0ak8GBxfEd
         3QnL702DPNKl6xzGZBWYiaHPLsibZJZ6gC3C9Sbr77FUq/WbUKv82av/HNKYJ6qYaQuj
         nTVb4rEw21u9pHIKNr9PSGJVr43r90UPOiZveF2m6neMPKldEPfBspdgEtybRgElRevu
         EnUvnfgi7KM9oeZy54oS5FZBF5Y0niCLIOc4vFsq6eQ3vIsKlCTAU/JAGrwhZMiTD3S4
         Cobg==
X-Gm-Message-State: AOAM530XkEMiVmMipWEYdkzsoUOURooqfJ2i6eDoGmX9cpI+CGVwbTeG
        YBD2aY1FDNKErQCyytiwxeVoAA==
X-Google-Smtp-Source: ABdhPJzzs4C/lNGU5gJfjXLgueQ6h//2HOCs2JEgJn8fHs+SjPK/bp53wfdpI/yc0gqOKDwXYe/jwg==
X-Received: by 2002:a17:902:c284:b029:df:c0d8:6b7 with SMTP id i4-20020a170902c284b02900dfc0d806b7mr3120918pld.34.1611622266246;
        Mon, 25 Jan 2021 16:51:06 -0800 (PST)
Received: from [10.8.1.5] ([185.125.207.232])
        by smtp.gmail.com with ESMTPSA id r7sm3940119pfc.26.2021.01.25.16.50.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 16:51:05 -0800 (PST)
Subject: Re: [PATCH v2 08/10] md: Implement ->corrupted_range()
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-mm@kvack.org
Cc:     linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        darrick.wong@oracle.com, dan.j.williams@intel.com,
        david@fromorbit.com, hch@lst.de, song@kernel.org, rgoldwyn@suse.de,
        qi.fuli@fujitsu.com, y-goto@fujitsu.com
References: <20210125225526.1048877-1-ruansy.fnst@cn.fujitsu.com>
 <20210125225526.1048877-9-ruansy.fnst@cn.fujitsu.com>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <6100b7ca-7968-e1ea-84b8-074dc216a453@cloud.ionos.com>
Date:   Tue, 26 Jan 2021 01:50:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210125225526.1048877-9-ruansy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/25/21 23:55, Shiyang Ruan wrote:
> With the support of ->rmap(), it is possible to obtain the superblock on
> a mapped device.
> 
> If a pmem device is used as one target of mapped device, we cannot
> obtain its superblock directly.  With the help of SYSFS, the mapped
> device can be found on the target devices.  So, we iterate the
> bdev->bd_holder_disks to obtain its mapped device.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> ---
>   drivers/md/dm.c       | 61 +++++++++++++++++++++++++++++++++++++++++++
>   drivers/nvdimm/pmem.c | 11 +++-----
>   fs/block_dev.c        | 42 ++++++++++++++++++++++++++++-
>   include/linux/genhd.h |  2 ++
>   4 files changed, 107 insertions(+), 9 deletions(-)

I can't see md raid is involved here, perhaps dm-devel need to be cced 
instead of raid list. And the subject need to be changed as well.

Thanks,
Guoqing
