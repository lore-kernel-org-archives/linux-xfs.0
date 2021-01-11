Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9825C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 18:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9603F22288
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 18:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389939AbhAKSEO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 13:04:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389119AbhAKSEO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 13:04:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610388167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uHC1voz+A/MVyoqItzobZTuRz1pUJaFMGeWs2dClSDc=;
        b=QJaDuAX5EUkqTZW79zqeGCb0qWi8ipa9ToED0NiZuLHMvhqTofUGCP95ZFdYR3hRBjrQ/s
        /kbWbHBLUz11eaXEYr3ASt4IscTMMfA4xUTD4Ny9OLCO3qx1UH/Nlw7kN26JthjVKiW2eC
        uFNOLMkldSKZNQAD4Nv9M/f934IIBDM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-GIQ-3tUOPnyt7OV3mafm7A-1; Mon, 11 Jan 2021 13:02:44 -0500
X-MC-Unique: GIQ-3tUOPnyt7OV3mafm7A-1
Received: by mail-pg1-f200.google.com with SMTP id c3so305787pgq.16
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 10:02:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uHC1voz+A/MVyoqItzobZTuRz1pUJaFMGeWs2dClSDc=;
        b=Z7QtKXgd2INKxoAZnD1aO8VXfUB3PivNQzG7rRsgdpFSGPUWdMn13WlwY9jqPFZoBz
         77XaLWyPq2M3M777elSztDEyh93+cVU1bJ7WkYd/yz3P8HAcDVz/LwYIxST7FZTX0kW5
         B3LvyVLptZfftZeasCwXZ6CmKJCH4N0YH54ytQlPPAyMhm6w0z7JCt5YdcQhYIG/GhiT
         PQ125ClysyAWqKk/SJghGaBl6MocLbSFBi56L9UeuvezzQIy2MV/3xx1PpE3MSNOc5Mv
         AauaOK9erFTS5w2EAy1hza9dkJYLRcv+DoH+R/9hyQGNaJR99psWxt8tzGCOIwvQ++HE
         tPMg==
X-Gm-Message-State: AOAM532VYNVi003AQejh51JJi4btn9sT9wY8dBzDpbZw/nbQIjolkHi8
        epTxNFjzNVI6xu7Ikjcy4aDqlV2PNSxllsetyk9cEekh2/sNApN5UF021gKukm8oDUR7yLqLLeE
        zWLcAcvcZcRqMuYl2RDiT
X-Received: by 2002:a17:902:8bc8:b029:dc:36d4:fba8 with SMTP id r8-20020a1709028bc8b02900dc36d4fba8mr463141plo.82.1610388163957;
        Mon, 11 Jan 2021 10:02:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNZ5J7sarVWKrPrbAlX5xnGFDXCg5HBDNfXSkD9Jbbwf2ZzE6ZWu2+o8GTryBepI/iNzb4gw==
X-Received: by 2002:a17:902:8bc8:b029:dc:36d4:fba8 with SMTP id r8-20020a1709028bc8b02900dc36d4fba8mr463122plo.82.1610388163712;
        Mon, 11 Jan 2021 10:02:43 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a29sm265193pfr.73.2021.01.11.10.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 10:02:43 -0800 (PST)
Date:   Tue, 12 Jan 2021 02:02:32 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 2/4] xfs: get rid of xfs_growfs_{data,log}_t
Message-ID: <20210111180232.GB1213845@xiangao.remote.csb>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-3-hsiangkao@redhat.com>
 <20210108212132.GS38809@magnolia>
 <f1b99677-aefa-a026-681a-e7d0ad515a8a@sandeen.net>
 <20210109004934.GB660098@xiangao.remote.csb>
 <20210110210436.GM331610@dread.disaster.area>
 <20210111001749.GC660098@xiangao.remote.csb>
 <20210111173054.GB848188@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210111173054.GB848188@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 05:30:54PM +0000, Christoph Hellwig wrote:
> On Mon, Jan 11, 2021 at 08:17:49AM +0800, Gao Xiang wrote:
> > Okay, will leave the definitions in the next version.
> 
> Note that the important thing is to not break the kernel to userspace
> ABI, the API is a little less important.  That being said breaking
> programs piecemail for no good reason't isn't nice.  I think we
> should probably move all the typedefs to the end of the file with
> a comment and then at some point remove them as a single breaking
> change.

Agree with your point. Yet I'm not sure if it's much related to this
series (I raised this due to touch some code)... I think it'd be better
as an independent xfs-treewide patch to move all userspace visable
typedefs to a unique place at once (not just these two typedefs...)
But I'm also ok if just move these two types in advance if needed.

(I suffer from lack of modification of old typedefs out of copy &
 paste from time to time. IMHO, I hope such exist typedef usage
 could be removed as soon as possible... )

Thanks,
Gao Xiang

> 

