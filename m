Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F78C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 07:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1444610A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 07:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237002AbhHSH56 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 03:57:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237038AbhHSH5r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 03:57:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629359831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zOZ7cxU7HcO1r3q2yjQw+qFxRV0RZY0WvCr9UfdkfMY=;
        b=haFpIPFOPLtFXxLWB7MhIReafgtZ1kl5f8/f0g0i4CTzq7JlT15w/kFFzPmSHLMF2oWDjX
        JiEQ9Ewzw/l76PHD/8NxdszKCqkDx2gEp0FkHv6BReQVaXs8nIVBzyMsfVYev+uqNFgJbs
        p0RcDBYL2AAH3egVKbuVFqUGuzR7QHI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-N2FKcfFSOvG3omyuBPUDPw-1; Thu, 19 Aug 2021 03:57:09 -0400
X-MC-Unique: N2FKcfFSOvG3omyuBPUDPw-1
Received: by mail-ej1-f69.google.com with SMTP id e1-20020a170906c001b02905b53c2f6542so1917971ejz.7
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 00:57:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=zOZ7cxU7HcO1r3q2yjQw+qFxRV0RZY0WvCr9UfdkfMY=;
        b=aPZLEhZ95QdXgOLe+hcoAVRo0pPTtxyiivVTrAEIvWp8hhS3uKZI9G7UxCq1io2wy5
         tVhiOI9r1crwTSeVy1ruS5/rtXA7LtkIBWG6+v8VNvKBtCoPPSr6RkP/VBtmQWiaOeQV
         hwy3drsv0MkLzb6GlnAcMhlvhVSA2sl1JvEs0KTqxNkDxB4uDpQC1k/G2RCeaD8nTVCH
         fatjDN1noeqDggm3hFymkcezfoG1Hj1m2u4owXYodrJmk+XqKt415RSa8xUGkkFT8gNX
         t3ADsFwUkYkCqWZT3x30uOhLbEn2Gbs5/xNHO7MGV6YOX8yprWVI9uPUkd4wQA2LvHCX
         w7Ww==
X-Gm-Message-State: AOAM533A2AqIm4c6hVc9ej+td5GyWlPMwTy26gxc2MWI8L4hKfl00hJL
        IDehN64oHv5qZ+pcvLsxBch/2VdRV+dInhRc3ZFhqtBZAi7qbeYMjG+RMQC0sSDhxc+UqSh6Xy7
        grbGTdPEMYkZZR1Ng2qvQ
X-Received: by 2002:a17:906:a0ce:: with SMTP id bh14mr13939821ejb.434.1629359828661;
        Thu, 19 Aug 2021 00:57:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxra/KbQLBUNGIkvm2rwRGaWjGxXEHLvU1okQdsXobIeZk2XdJDIkmOhA8jqihi1ySZTChOyQ==
X-Received: by 2002:a17:906:a0ce:: with SMTP id bh14mr13939810ejb.434.1629359828385;
        Thu, 19 Aug 2021 00:57:08 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id q8sm1260294edv.95.2021.08.19.00.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 00:57:07 -0700 (PDT)
Date:   Thu, 19 Aug 2021 09:57:06 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/15] xfs: fix incorrect unit conversion in scrub
 tracepoint
Message-ID: <20210819075706.zapcyhwpqzdsmoow@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924373760.761813.14269643495581366455.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924373760.761813.14269643495581366455.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:42:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> XFS_DADDR_TO_FSB converts a raw disk address (in units of 512b blocks)
> to a raw disk address (in units of fs blocks).  Unfortunately, the
> xchk_block_error_class tracepoints incorrectly uses this to decode
> xfs_daddr_t into segmented AG number and AG block addresses.  Use the
> correct translation code.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/scrub/trace.h |   16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index e46f5cef90da..29f1d0ac7ec5 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -193,29 +193,21 @@ DECLARE_EVENT_CLASS(xchk_block_error_class,
>  		__field(dev_t, dev)
>  		__field(unsigned int, type)
>  		__field(xfs_agnumber_t, agno)
> -		__field(xfs_agblock_t, bno)
> +		__field(xfs_agblock_t, agbno)
>  		__field(void *, ret_ip)
>  	),
>  	TP_fast_assign(
> -		xfs_fsblock_t	fsbno;
> -		xfs_agnumber_t	agno;
> -		xfs_agblock_t	bno;
> -
> -		fsbno = XFS_DADDR_TO_FSB(sc->mp, daddr);
> -		agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
> -		bno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
> -
>  		__entry->dev = sc->mp->m_super->s_dev;
>  		__entry->type = sc->sm->sm_type;
> -		__entry->agno = agno;
> -		__entry->bno = bno;
> +		__entry->agno = xfs_daddr_to_agno(sc->mp, daddr);
> +		__entry->agbno = xfs_daddr_to_agbno(sc->mp, daddr);
>  		__entry->ret_ip = ret_ip;
>  	),
>  	TP_printk("dev %d:%d type %s agno %u agbno %u ret_ip %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
>  		  __entry->agno,
> -		  __entry->bno,
> +		  __entry->agbno,
>  		  __entry->ret_ip)
>  )
>  
> 

-- 
Carlos

