Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C36C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 14:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244308AbiCWO0Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 10:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244668AbiCWO0X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 10:26:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D615DEE7
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 07:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648045489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7UCUSJROty9f6xga7d9nTJDBxQCTHWB638j83Xfdtpw=;
        b=WJL+1x3ilPKtZyvAg/X+ObNgsWpH/6dMdDBIj9lDGn+DPhbxVv1O3B3NAObpqS/XrlaBY1
        2w6G1mFEnWJwR3ETVqVCq4NKLEXLSBi3LIq7uvtXhBNnki7M8jDtAfpoX9fuITGdAGiu1Z
        M+xf5vrjffSejoXAvKycVOdy8PH1K28=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-zC_w-nRJNeCtNn6PR1Cb5A-1; Wed, 23 Mar 2022 10:24:48 -0400
X-MC-Unique: zC_w-nRJNeCtNn6PR1Cb5A-1
Received: by mail-qk1-f200.google.com with SMTP id 207-20020a3706d8000000b0067b322bef9eso1081036qkg.3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 07:24:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7UCUSJROty9f6xga7d9nTJDBxQCTHWB638j83Xfdtpw=;
        b=lqboB7+5Cq1woHhY1twfckHg8JvmVS3c35zE6zKgAXijIx5hUPPTZq9cO/7u0+xU3c
         xRMdQ92L7Gy3vEOBkg/eCtt1VccMq2XnP2RtxcVwgetLTPHXiT7skswqOki0GfKwHEG9
         jz79tq0E1z9JH16tRx58h4bwTdOn+xqJK+aayydtam4DoSY3/MZda3I994LdTesDtQ2v
         +edzOBNFt065UVazwe4eBnBZ6YRHpJ+YR6FRsHaqgwODmm81JPRVRLm4sFBBjuwUVE11
         Ubm1hYqlgo+v+q53ec3WlP+0akJedIp4gooLf0D0ZGk8uGZcswipdyZqWFs25Aeb+wTu
         L66Q==
X-Gm-Message-State: AOAM530SR2IBm6e48KQ/DE9pK28tXEgKEUflUQa1YVDqzUcSzuG1UjV5
        o4r2CLifxQxHM88y9z0tkMxMt4gxuNjO0O5JVo8mDUNUgtN8X8dYPVd7QShk2WskvwWUD8S7pH+
        h/PAZSekgNWWJXeFe/sj9
X-Received: by 2002:a05:6214:19cc:b0:441:53af:3ec7 with SMTP id j12-20020a05621419cc00b0044153af3ec7mr4757023qvc.101.1648045487239;
        Wed, 23 Mar 2022 07:24:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMc6wkC2Clwy3nh2sCUN2mgd4xFO81E1sliqCENRsGwkGKGpEIPbbZmOM9shodsIB037UQbA==
X-Received: by 2002:a05:6214:19cc:b0:441:53af:3ec7 with SMTP id j12-20020a05621419cc00b0044153af3ec7mr4757008qvc.101.1648045487035;
        Wed, 23 Mar 2022 07:24:47 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id bs32-20020a05620a472000b0067d4560a516sm78227qkb.32.2022.03.23.07.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 07:24:46 -0700 (PDT)
Date:   Wed, 23 Mar 2022 10:24:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS tracepoint warning due to NULL string
Message-ID: <YjstrL6J16TEL/mW@bfoster>
References: <YjsWzuw5FbWPrdqq@bfoster>
 <20220323100200.6f22e417@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323100200.6f22e417@gandalf.local.home>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 23, 2022 at 10:02:00AM -0400, Steven Rostedt wrote:
> On Wed, 23 Mar 2022 08:47:10 -0400
> Brian Foster <bfoster@redhat.com> wrote:
> 
> > What's the best way to address this going forward with the memory usage
> > verification in place? ISTM we could perhaps consider dropping the
> > custom %.*s thing in favor of using %s with __string_len() and friends,
> > or perhaps just replace the open-coded NULL parameter with the "(null)"
> > string that the trace subsystem code seems to use on NULL pointer
> > checks. The latter seems pretty simple and straightforward of a change
> > to me, but I want to make sure I'm not missing something more obvious.
> > Thoughts?
> 
> Can you see if the following (totally untested) patch fixes your issue?
> 

Yup, that restores historical behavior. Thanks!

Brian

> -- Steve
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 08ea781540b5..f4de111fa18f 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3673,12 +3673,17 @@ static char *trace_iter_expand_format(struct trace_iterator *iter)
>  }
>  
>  /* Returns true if the string is safe to dereference from an event */
> -static bool trace_safe_str(struct trace_iterator *iter, const char *str)
> +static bool trace_safe_str(struct trace_iterator *iter, const char *str,
> +			   bool star, int len)
>  {
>  	unsigned long addr = (unsigned long)str;
>  	struct trace_event *trace_event;
>  	struct trace_event_call *event;
>  
> +	/* Ignore strings with no length */
> +	if (star && !len)
> +		return true;
> +
>  	/* OK if part of the event data */
>  	if ((addr >= (unsigned long)iter->ent) &&
>  	    (addr < (unsigned long)iter->ent + iter->ent_size))
> @@ -3864,7 +3869,7 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
>  		 * instead. See samples/trace_events/trace-events-sample.h
>  		 * for reference.
>  		 */
> -		if (WARN_ONCE(!trace_safe_str(iter, str),
> +		if (WARN_ONCE(!trace_safe_str(iter, str, star, len),
>  			      "fmt: '%s' current_buffer: '%s'",
>  			      fmt, show_buffer(&iter->seq))) {
>  			int ret;
> 

