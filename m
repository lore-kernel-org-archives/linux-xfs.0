Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9D3C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 23:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A5C8619D0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 23:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhC3XGc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 19:06:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233270AbhC3XGG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 19:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617145565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9hZtylm8nvz5MatIb07B/+7UKv0RbnOUjyX6DflX8jQ=;
        b=JJPs9t8l5+lBi8ODB4PA8uxbTgBeYP3+BbekQVKYvCUhtdAXAD3iN9gnc9i7+4O9F8atee
        s2nLaVlY5+62SYTrU7Cf86mZ6mHYDNerQ3Y43M6qVdva1gigDPN7FLqZxnpJAfTCdwLwRi
        LYkS3d3hKVvnWFjKy3wG4ctLA8UNHvA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-rbNLRKoGPmqMsnHNEKvemQ-1; Tue, 30 Mar 2021 19:06:02 -0400
X-MC-Unique: rbNLRKoGPmqMsnHNEKvemQ-1
Received: by mail-pl1-f199.google.com with SMTP id b13so112032plh.19
        for <linux-xfs@vger.kernel.org>; Tue, 30 Mar 2021 16:06:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9hZtylm8nvz5MatIb07B/+7UKv0RbnOUjyX6DflX8jQ=;
        b=Hr0rb5xqk/KpUWzkDoW5zSpAs75T5iF20scvriKjibBnzZIUr8QB8i58xA/bj+PmtV
         ueT9fw37tx7f0SyTVMUDh678uwm1afGMT8T8CZTuycWRH8f7zgXmCVWUHqrJeazyse/u
         GAin9jm0RE/O4MlGfZA2Hf4+Q9pa0EFXCF1hwcSM5RQgeMRkdaXkVpCx+I39mCRcoWQl
         sKlwz6uUTOHYQETuDi8izBicD06yOWIBDIr/9Nxo+1rYqbfi/oCnysX1S3JaxL0xqzDh
         p/Fbyq8qCPkatI1BzkQnnw2xVPyQahS597WCm9DbkGKz7/YXx2KQpy9r/oFy4sovTli/
         BE8g==
X-Gm-Message-State: AOAM531+kezuOFHZLHe7asWPnN8PNkCBvhooySi3N2OErRhQzi8SyKow
        HWcgGiHhtzLW70WAGD9ND1Glw6oI3TwwgGmFU1lvQYVYNBiPhdZ4UkuOL2LsMuNy9p0cF+tfjUD
        3IrRempgCuSBji3HcPv0T
X-Received: by 2002:a17:902:7fc8:b029:e4:32af:32da with SMTP id t8-20020a1709027fc8b02900e432af32damr595775plb.24.1617145561833;
        Tue, 30 Mar 2021 16:06:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/c1kUrfISuxGuY51ski11hrLCsIK0kWHmfwmVJvBZ6jmkDSfzQvT4qfTR9nMlKvk3uKDV/g==
X-Received: by 2002:a17:902:7fc8:b029:e4:32af:32da with SMTP id t8-20020a1709027fc8b02900e432af32damr595766plb.24.1617145561652;
        Tue, 30 Mar 2021 16:06:01 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j3sm173122pjf.36.2021.03.30.16.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 16:06:01 -0700 (PDT)
Date:   Wed, 31 Mar 2021 07:05:51 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Gao Xiang <hsiangkao@aol.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/8] repair: turn bad inode list into array
Message-ID: <20210330230551.GC3589611@xiangao.remote.csb>
References: <20210330142531.19809-1-hsiangkao@aol.com>
 <20210330142531.19809-2-hsiangkao@aol.com>
 <20210330184608.GY4090233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210330184608.GY4090233@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Tue, Mar 30, 2021 at 11:46:08AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 30, 2021 at 10:25:24PM +0800, Gao Xiang wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 
> > Just use array and reallocate one-by-one here (not sure if bulk
> > allocation is more effective or not.)
> 
> I'm not sure either.  The list of bad directories is likely to be
> sparse, so perhaps the libfrog bitmap isn't going to beat a realloc
> array for space efficiency... and reusing the slab array might be
> overkill for an array-backed bitmap?
> 
> Eh, you know what?  I don't think the bad directory bitmap is hot enough
> to justify broadening this into an algorithmic review of data
> structures.  Incremental space efficiency is good enough for me.

I'm not sure if it's a good choice tbh, let me try to use some
balanced binary tree instead as Dave suggested.

Thanks,
Gao Xiang

