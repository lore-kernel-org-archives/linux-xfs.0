Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D255C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 14:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A6961411
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 14:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhELObN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 10:31:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27802 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231143AbhELObK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 10:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620829802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hu0QGAHjqykktjXG3YPD38bv7QJLDIiuhK/NYDHyoZk=;
        b=TwA/RkBYbregoAL/HWz+939yhUMgIPf4W70374KeZpaVS5RPTJLB1Rogbl8GqPQNTiAS7D
        Sz+3Oa9M75NRr3cxisYdfFW4jf3Z/QtobV8YfiG3fdPKB9sAQB1ZaMdod0Tsg9ktHOWWKq
        yDwJ3PoeLjGosY3ylNaScFEF1SxR2bA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-rKRCJSWQOairDw3y4gZsUg-1; Wed, 12 May 2021 10:30:00 -0400
X-MC-Unique: rKRCJSWQOairDw3y4gZsUg-1
Received: by mail-qv1-f71.google.com with SMTP id d11-20020a0cdb0b0000b02901c0da4391d5so19118067qvk.12
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 07:29:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hu0QGAHjqykktjXG3YPD38bv7QJLDIiuhK/NYDHyoZk=;
        b=lhj7iGpWCwsrr1Zd2AHsCdSUExAgal1IxBZyPyZp3Y3ALTgpz6lmnN71qrQ6eF+D15
         532y7qrd7NKKuFrvZMNdEFUorBTZP8ozO4FME5QkrSC02x8V7m4eIt6Ff2TzC3UiDAHv
         2MzjeXE0aqpIesyEeT0cele56do3Uh1EyzZ1GTfpxA+07v5Kn0bMxsx7NnWVbkee6acr
         o6IJu/BNGifv4liiQlk86DCns4NsR2q2qpBniMODcgJw/dDEiaeoSgpE8DMuiAgcQbDz
         yyWrPIG+vYx5fJtYrk/aaxhi/HfqKq8/C6+DHQgUEtOEbbYH3HQ0+prLCITE37t5jDkU
         ljog==
X-Gm-Message-State: AOAM533fmjekv3TBCR398jnHrKdltDuHbFLjF0F5TfK0bantG4M8Ycb0
        ef0vklCURgShhP8I9ljpVYwZx1hmBuWI0VTpooos5OAq4d7BIV/6A9VX6LAOXyTP+E+ugKbZ0rJ
        WjMsAzoZsvuoO8IXVtUC7
X-Received: by 2002:a0c:e749:: with SMTP id g9mr35334568qvn.13.1620829799428;
        Wed, 12 May 2021 07:29:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnE16/YHeVj6FQZfGZEReexWyetgDAjp8FKpqr4bi6sUaV3gxi86mxRuHQCFu0YVk+HU8u4Q==
X-Received: by 2002:a0c:e749:: with SMTP id g9mr35334556qvn.13.1620829799262;
        Wed, 12 May 2021 07:29:59 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id z30sm99418qtm.11.2021.05.12.07.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 07:29:58 -0700 (PDT)
Date:   Wed, 12 May 2021 10:29:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove dead stale buf unpin handling code
Message-ID: <YJvmZRoEQRqMLd2I@bfoster>
References: <20210511135257.878743-1-bfoster@redhat.com>
 <20210511135257.878743-3-bfoster@redhat.com>
 <YJvDWUgZupjoW5Ib@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJvDWUgZupjoW5Ib@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 01:00:25PM +0100, Christoph Hellwig wrote:
> > +		ASSERT(list_empty(&lip->li_trans) && !bp->b_transp);
> 
> Nit:  Two separate ASSERTS are generally better than one with two
> conditions and a "&&", so that when the assert triggers it shows which
> condition caused it.
> 

In this case both checks pretty much mean the same thing so I don't see
much added value, but I don't mind splitting it..

Brian

