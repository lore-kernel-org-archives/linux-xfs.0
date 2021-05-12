Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0650AC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 14:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C162F61411
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 14:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhELOay (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 10:30:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230202AbhELOax (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 10:30:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620829785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ahmSvAQCxmjHPBVVnG7mZVN69UNqacFF0qfvN+dEPIU=;
        b=Ax9OPEAEfsm5UPSXj7xE1nR0/QR/SiOUM6h4aG0Pf8BVJ6x6oUiDMU4rYFAz8rnNqA+qPr
        As5DHF07WMJJKyKi43kYsI0Yb9xB0mTzNn1eKt+gjiIT1PBbtx3w3D97IpY1NjoL2qqqMl
        LrxgRdy8EcX56NyvKjs8g8qOTjioT6w=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-kXSLsCxdMAu8EqD64RGjAw-1; Wed, 12 May 2021 10:29:43 -0400
X-MC-Unique: kXSLsCxdMAu8EqD64RGjAw-1
Received: by mail-qk1-f198.google.com with SMTP id d201-20020ae9efd20000b02902e9e9d8d9dcso17415917qkg.10
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 07:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ahmSvAQCxmjHPBVVnG7mZVN69UNqacFF0qfvN+dEPIU=;
        b=d8wo8AI8Y63XxwUnuV4uzzJ0qsheOAoSnEMo2UvOEehyO9aUnFyEfFrvOzeDJLO2mK
         0r3RlQnCndxJz4PLZv7AM8xy6FLF63IfbTUG3aCRHQTbZmgwl9CS+MdxMFDayMzCt1s3
         N6mAu8lJytyPCocSAw3fPVgqMVWUQgqPeP172vxdub9mM9ClvPP/XXRk5VvkcaC4tmzb
         2RvAgP93f24II6UMiVSqiqRfNrinc6wOKp0RwrwCEuEmlAkS2nE/rQPRPdJwKoxLARCM
         NSMSCsrV8gRhkqr+j8M1Tj2rH52mnve81AmOzp8+tAVBetH7UVLkU/r2M3H3sbpD0oGk
         vx/Q==
X-Gm-Message-State: AOAM533qzhQg+XiTESdWSnQMHleggLySPTOKpiJ+xgpPy8K2dLMcynHq
        Yki4ie0SreAV5V7CRQREhyDReTX/MbEkWJvexpUi4pNql989KPmkFJhar7lI3SRekOpWUAoTlCP
        jeThW9WISPD77Z8p1gzhD
X-Received: by 2002:ae9:e845:: with SMTP id a66mr32323876qkg.313.1620829783229;
        Wed, 12 May 2021 07:29:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrklq65QfmgQUmeed3XHuLtBpw5ndKzOOqah1bkDDrnQD8lXfOZ9rPrNngVhCoKs3fKEzpFg==
X-Received: by 2002:ae9:e845:: with SMTP id a66mr32323865qkg.313.1620829783029;
        Wed, 12 May 2021 07:29:43 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id 75sm70799qta.58.2021.05.12.07.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 07:29:42 -0700 (PDT)
Date:   Wed, 12 May 2021 10:29:41 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: hold buffer across unpin and potential shutdown
 processing
Message-ID: <YJvmVUZpSmP9EzTV@bfoster>
References: <20210511135257.878743-1-bfoster@redhat.com>
 <20210511135257.878743-2-bfoster@redhat.com>
 <20210512015244.GW8582@magnolia>
 <YJvImeri0qEQtPJ1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJvImeri0qEQtPJ1@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 01:22:49PM +0100, Christoph Hellwig wrote:
> On Tue, May 11, 2021 at 06:52:44PM -0700, Darrick J. Wong wrote:
> > > is unpinned if the associated item has been aborted and will require
> > > a simulated I/O failure. The hold is already required for the
> > > simulated I/O failure, so the ordering simply guarantees the unpin
> > > handler access to the buffer before it is unpinned and thus
> > > processed by the AIL. This particular ordering is required so long
> > > as the AIL does not acquire a reference on the bli, which is the
> > > long term solution to this problem.
> > 
> > Are you working on that too, or are we just going to let that lie for
> > the time being? :)
> 
> Wouldn't that be as simple as something like the untested patch below?
> 

I actually think this is moderately less simple than the RFC I started
with (see the cover letter for a reference) because there's really no
need for a buffer hold per pin. I moved away from the RFC approach to
this to 1. isolate the hold/rele cycle to the scenario where it's
actually necessary (unpin abort) and 2. document the design flaw that
Dave had pointed out that contributes to this problem.

So point #1 means the explicit hold basically fills the gap that the bli
reference count fails to cover to preserve buffer access by (AIL
resident) log item processing code, and no more, whereas the RFC and the
patch below are a bit more convoluted (even though the code might look
simpler) in that they obscure that context.

Brian

> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index fb69879e4b2b..07e08713ecd4 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -471,6 +471,7 @@ xfs_buf_item_pin(
>  	trace_xfs_buf_item_pin(bip);
>  
>  	atomic_inc(&bip->bli_refcount);
> +	xfs_buf_hold(bip->bli_buf);
>  	atomic_inc(&bip->bli_buf->b_pin_count);
>  }
>  
> @@ -552,14 +553,15 @@ xfs_buf_item_unpin(
>  		xfs_buf_relse(bp);
>  	} else if (freed && remove) {
>  		/*
> -		 * The buffer must be locked and held by the caller to simulate
> -		 * an async I/O failure.
> +		 * The buffer must be locked to simulate an async I/O failure.
> +		 * xfs_buf_ioend_fail will drop our buffer reference.
>  		 */
>  		xfs_buf_lock(bp);
> -		xfs_buf_hold(bp);
>  		bp->b_flags |= XBF_ASYNC;
>  		xfs_buf_ioend_fail(bp);
> +		return;
>  	}
> +	xfs_buf_rele(bp);
>  }
>  
>  STATIC uint
> 

