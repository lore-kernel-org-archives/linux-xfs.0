Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 055E6C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 09:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C579561038
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 09:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhHLJcB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 05:32:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34283 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234975AbhHLJcA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 05:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628760695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vSd2dnL9dFciONN33fhNWI+mmvNxJ7xy2PF9BBcvD/A=;
        b=c1WwYwfVmMlPWCUM2j9As+DOdPEbe+Gur99AGe45iwnJBiMaCRVcuDtEgc5/qnb+UordIj
        vG1G1ML7GZLwekRTMa1EZob9h3ezPDOVuv8r4nH9/pA6u7iJFnzI8s0+83+l4TEcRJrQtT
        2QJhHI3ItiZ+4DKhj+7AZffOst0gMl4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-ujKH7gQNPhub1sSa8WndOg-1; Thu, 12 Aug 2021 05:31:34 -0400
X-MC-Unique: ujKH7gQNPhub1sSa8WndOg-1
Received: by mail-ed1-f72.google.com with SMTP id de5-20020a0564023085b02903bb92fd182eso2789328edb.8
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 02:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vSd2dnL9dFciONN33fhNWI+mmvNxJ7xy2PF9BBcvD/A=;
        b=lVLgbUPFw8IrerDt+jj0UcazkXhY1paybqBl4FInvX0UoivTUnL9XbfMgtfYTDoj1x
         W6vVdyoHUgFS2I+R42LA49BB2kwFWHQK5WSCxVULfbCfX6rKdWNTHB87dsSf06bWl/7L
         d124fNF/Obd1T8Ov5A8nzp19VI24PwGOg/Kf16TUH1/ICI8yDwBK/0e1U0ckFo+BtD04
         E+rRfk/57mDR/8JjextJyON6p3C5U7rGUBD1P4s5xfHuTad+2UAQVpbstDFf/w25NJ+7
         pdJy7dF98fW8L068vhiOJD6LBgJMXdhx0qFtvL4UBYqw9OGpyIsf+8481BVhPOXLmBgG
         /Gyg==
X-Gm-Message-State: AOAM533jukHOrYRr4pacl21vZB1HtAQHdSE/kxYaZMXN4qPa9zCrQatE
        ZsyRo6YutmIKrLCsm7Sr+q2w465Fv3y3jngr61NKZ1CsktLG4oNIhPU5Nf9Mb83Pbpa35HSHNn2
        Haf4ZYqyE//vFj4bSQ9XYp9vH3TUUdm7tMZhol3sZd5OB4KXIJOLciq6QZ6wiQwrVJioCOes=
X-Received: by 2002:a17:906:2bd0:: with SMTP id n16mr2771260ejg.132.1628760692809;
        Thu, 12 Aug 2021 02:31:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsZ6t2ip+kbKBfI/AtQmCzx4ztGztCMi6USCI0lWOlt4DktK0974ZJwwgcTWt68O6Jcau8og==
X-Received: by 2002:a17:906:2bd0:: with SMTP id n16mr2771250ejg.132.1628760692633;
        Thu, 12 Aug 2021 02:31:32 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id a3sm844195edu.46.2021.08.12.02.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 02:31:32 -0700 (PDT)
Subject: Re: [PATCH 1/3] xfs: remove the xfs_dinode_t typedef
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20210812084343.27934-1-hch@lst.de>
 <20210812084343.27934-2-hch@lst.de>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <6d28d82c-4113-3b74-c7bd-f430cf8fbfb3@redhat.com>
Date:   Thu, 12 Aug 2021 11:31:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812084343.27934-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 8/12/21 10:43 AM, Christoph Hellwig wrote:
>   	/*
>   	 * If the size is unreasonable, then something
> @@ -162,8 +162,8 @@ xfs_iformat_extents(
>    */
>   STATIC int
>   xfs_iformat_btree(
> -	xfs_inode_t		*ip,
> -	xfs_dinode_t		*dip,
> +	struct xfs_inode	*ip,
> +	struct xfs_dinode	*dip,
>   	int			whichfork)

Hi,

since you are also removing xfs_inode_t I'd like to ask if it is a good 
idea to send a separate patch removing all other instances of 
xfs_inode_t? (I'm happy to do it).

Patch applies, builds and LGTM.

Reviewed-by: Pavel Reichl <preichl@redhat.com>

