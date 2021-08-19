Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F40C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 12:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3074B6112D
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 12:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhHSMtY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 08:49:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhHSMtY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 08:49:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629377327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w5KlRz+E1Ug1+yqih4cATS6Spj7KN7M23UGqpGY2yF8=;
        b=OXaNCH6PXEPAD8JfWEAPqjoygTIRVhvrAvPGNw+b/Mh/TQfhqyQLbz1fY3gndXxe+g7Av4
        qhIN5J8TVUc4nIMzTjyg2au+gBoQATKlCeHuHbaUbiUgRG5+IHNxpIbpVSYFogqQvD2DbR
        CdvrVIjwttIK7wb50QeLCtFyBPMrNOA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-JR1wWyzVNOqBbJBWhnPeVg-1; Thu, 19 Aug 2021 08:48:46 -0400
X-MC-Unique: JR1wWyzVNOqBbJBWhnPeVg-1
Received: by mail-ed1-f70.google.com with SMTP id p2-20020a50c9420000b02903a12bbba1ebso2758577edh.6
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 05:48:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=w5KlRz+E1Ug1+yqih4cATS6Spj7KN7M23UGqpGY2yF8=;
        b=jScYLxQ1/QW+917zI7jP78fQspn+iU3lCxp9hmZJO27FLoOgCgDBmfWmGBBeq4zyIU
         vjQUyf34Bp9FTtwbJymHWAAoZjCH28GwWg5gcrbgDblHMi9XC8kb3Q/KOkxeSWXghiPD
         y+kTzo7SmKCwaej/0D/QNcY9aUhF7+D2sKkDWyCDEi1huzfG6zEyzGX/4nq0WbS9d5jg
         w5WBJneZ/hx5xQonts/QqHTwcuMZ/qV0hTNjWzzgDHHw2r/XWmhEz3ZxYLsYaSixA3bG
         kMG7sX4zg3qNVi24OeSzX8jc68m73JeW3NrJAXolIx1cyOTdnmonW1qSMLR+f1WccLvg
         H54Q==
X-Gm-Message-State: AOAM531GDYaLxq1iE9Y6RvOpG0AgeSLD4rvQSoyPIDsK/Jc479WSkrlG
        Z2WrKnidGfmtGj/LbxtcdaVgs48JjkM2Nkg3RDRD9thNI8r5s96BppCBhhKs3XMveYQ7NCiz6o3
        trTuDXXwCSQTKNivt0IX3
X-Received: by 2002:a17:906:a044:: with SMTP id bg4mr15593447ejb.312.1629377324923;
        Thu, 19 Aug 2021 05:48:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoa1p20H9jpViixq6HB7y8+e2HhI02iuZRKzOZo3cB0U/TMFpMBG1px/q5fxU/PqBY6NNsyQ==
X-Received: by 2002:a17:906:a044:: with SMTP id bg4mr15593440ejb.312.1629377324722;
        Thu, 19 Aug 2021 05:48:44 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id dv8sm1219337ejb.93.2021.08.19.05.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 05:48:44 -0700 (PDT)
Date:   Thu, 19 Aug 2021 14:48:42 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/15] xfs: standardize remaining xfs_buf length
 tracepoints
Message-ID: <20210819124842.zz3bgmn5z4wyo2zj@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924380364.761813.15066686718183338281.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924380364.761813.15066686718183338281.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:43:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For the remaining xfs_buf tracepoints, convert all the tags to
> xfs_daddr_t units and retag them 'daddrcount' to match everything else.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

I agree with Dave on s/daddrcount/bbcount/, other than that:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/xfs_trace.h |   24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 474fdaffdccf..3b53fd681ce7 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -397,7 +397,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
>  		__entry->flags = bp->b_flags;
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d daddr 0x%llx nblks 0x%x hold %d pincount %d "
> +	TP_printk("dev %d:%d daddr 0x%llx daddrcount 0x%x hold %d pincount %d "
>  		  "lock %d flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long long)__entry->bno,
> @@ -448,7 +448,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_daddr_t, bno)
> -		__field(size_t, buffer_length)
> +		__field(unsigned int, length)
>  		__field(int, hold)
>  		__field(int, pincount)
>  		__field(unsigned, lockval)
> @@ -458,18 +458,18 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
>  	TP_fast_assign(
>  		__entry->dev = bp->b_target->bt_dev;
>  		__entry->bno = bp->b_bn;
> -		__entry->buffer_length = BBTOB(bp->b_length);
> +		__entry->length = bp->b_length;
>  		__entry->flags = flags;
>  		__entry->hold = atomic_read(&bp->b_hold);
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
>  		__entry->lockval = bp->b_sema.count;
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d daddr 0x%llx len 0x%zx hold %d pincount %d "
> +	TP_printk("dev %d:%d daddr 0x%llx daddrcount 0x%x hold %d pincount %d "
>  		  "lock %d flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long long)__entry->bno,
> -		  __entry->buffer_length,
> +		  __entry->length,
>  		  __entry->hold,
>  		  __entry->pincount,
>  		  __entry->lockval,
> @@ -491,7 +491,7 @@ TRACE_EVENT(xfs_buf_ioerror,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_daddr_t, bno)
> -		__field(size_t, buffer_length)
> +		__field(unsigned int, length)
>  		__field(unsigned, flags)
>  		__field(int, hold)
>  		__field(int, pincount)
> @@ -502,7 +502,7 @@ TRACE_EVENT(xfs_buf_ioerror,
>  	TP_fast_assign(
>  		__entry->dev = bp->b_target->bt_dev;
>  		__entry->bno = bp->b_bn;
> -		__entry->buffer_length = BBTOB(bp->b_length);
> +		__entry->length = bp->b_length;
>  		__entry->hold = atomic_read(&bp->b_hold);
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
>  		__entry->lockval = bp->b_sema.count;
> @@ -510,11 +510,11 @@ TRACE_EVENT(xfs_buf_ioerror,
>  		__entry->flags = bp->b_flags;
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d daddr 0x%llx len 0x%zx hold %d pincount %d "
> +	TP_printk("dev %d:%d daddr 0x%llx daddrcount 0x%x hold %d pincount %d "
>  		  "lock %d error %d flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long long)__entry->bno,
> -		  __entry->buffer_length,
> +		  __entry->length,
>  		  __entry->hold,
>  		  __entry->pincount,
>  		  __entry->lockval,
> @@ -529,7 +529,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_daddr_t, buf_bno)
> -		__field(size_t, buf_len)
> +		__field(unsigned int, buf_len)
>  		__field(int, buf_hold)
>  		__field(int, buf_pincount)
>  		__field(int, buf_lockval)
> @@ -545,14 +545,14 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  		__entry->bli_recur = bip->bli_recur;
>  		__entry->bli_refcount = atomic_read(&bip->bli_refcount);
>  		__entry->buf_bno = bip->bli_buf->b_bn;
> -		__entry->buf_len = BBTOB(bip->bli_buf->b_length);
> +		__entry->buf_len = bip->bli_buf->b_length;
>  		__entry->buf_flags = bip->bli_buf->b_flags;
>  		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
>  		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
>  		__entry->buf_lockval = bip->bli_buf->b_sema.count;
>  		__entry->li_flags = bip->bli_item.li_flags;
>  	),
> -	TP_printk("dev %d:%d daddr 0x%llx len 0x%zx hold %d pincount %d "
> +	TP_printk("dev %d:%d daddr 0x%llx daddrcount 0x%x hold %d pincount %d "
>  		  "lock %d flags %s recur %d refcount %d bliflags %s "
>  		  "liflags %s",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> 

-- 
Carlos

