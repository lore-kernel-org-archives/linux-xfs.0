Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2704C2D0A8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B94720C56
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KiQ5/SAK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgIWQxP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 12:53:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726381AbgIWQxP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 12:53:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600879993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=INcCXn1RK0xhAfzdbfajWJAFEX8WqvW2GFvP792doxY=;
        b=KiQ5/SAKMunyC1ZFItxUsDMBZCNekD20I50PKAK0HkPgRVGJ4dsp7rPUshPbV/qwk2OsPT
        VQypUHdQO7PGfH6shcxaTAC4vhB9JNoiQzze4vKu8TRAzDlFa7Yz1UNrU8+AiCtByMQ4zv
        p38+gBWhNaZd7fMW6CRr5tUVEFO+06M=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-So1XyVwxPJCS6Mdp-c5Cng-1; Wed, 23 Sep 2020 12:53:10 -0400
X-MC-Unique: So1XyVwxPJCS6Mdp-c5Cng-1
Received: by mail-pf1-f200.google.com with SMTP id 8so62260pfx.6
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 09:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=INcCXn1RK0xhAfzdbfajWJAFEX8WqvW2GFvP792doxY=;
        b=Y8GN0jRokc6siZwnt/p4WiVgs9T1BylXLPzzmMIvoqN3I5CXPDeRDcUVkgkJ3VPO3h
         qPLM0BbIjBWsehIHThietMpEWWmdqUhbpbLmWQME12EbX746pjVr/jkDwgwA7d3GxIWK
         542fpApx+aJb0mwEcpJ8oxCC1/Xw2fAFMMRqJ8QGwgLgAeJmQstO5veSkpCM3XuhjHrV
         RIqYR1QWhpd/YYyyLYR/+IMnEbmR+BKFFTajOgAfjm5kiD8RNNaTzkdHpO/tIxQF+tBL
         kfaOYZUcOPX6xSCVSWfay85FkCQkLpYDOwS4BvzkFk2zCAEz9YBN0jcbqTtBTU9iCbV4
         QOmw==
X-Gm-Message-State: AOAM5308C8fFYPmbWaeNRvxCPpCHdKXA+5+y4T7uY4s0bar5lfZIg1KR
        AA2bJnnIbZDR90zuK6Gs8oFksAm/Us1N6DVQPzndybCs250MtAYJNXVs5Zon1rBFdmZVCieADWK
        HOvNF27+KKAa2cw37gUcR
X-Received: by 2002:a17:90a:ad8b:: with SMTP id s11mr312947pjq.40.1600879989132;
        Wed, 23 Sep 2020 09:53:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypZKf8+IQ5aexlsd/TWaOfPjzOmv8/b/pN56qlVrSZsgBK1Nvdz9H0+h0Sh/5Fua5uJVclBA==
X-Received: by 2002:a17:90a:ad8b:: with SMTP id s11mr312933pjq.40.1600879988886;
        Wed, 23 Sep 2020 09:53:08 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e2sm391656pgl.38.2020.09.23.09.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 09:53:08 -0700 (PDT)
Date:   Thu, 24 Sep 2020 00:52:58 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 1/2] xfs: avoid LR buffer overrun due to crafted h_len
Message-ID: <20200923165258.GA28205@xiangao.remote.csb>
References: <20200917051341.9811-1-hsiangkao@redhat.com>
 <20200917051341.9811-2-hsiangkao@redhat.com>
 <20200923163540.GU7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923163540.GU7955@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 09:35:40AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 17, 2020 at 01:13:40PM +0800, Gao Xiang wrote:
> > Currently, crafted h_len has been blocked for the log
> > header of the tail block in commit a70f9fe52daa ("xfs:
> > detect and handle invalid iclog size set by mkfs").
> > 
> > However, each log record could still have crafted h_len
> > and cause log record buffer overrun. So let's check
> > h_len vs buffer size for each log record as well.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 
> /me squints real hard and thinks he understands what this patch does.
> 
> Tighten up xlog_valid_rec_header, and add a new callsite in the middle
> of xlog_do_recovery_pass instead of the insufficient length checking.
> Assuming that's right,
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks for the review!

The main point is to check each individual LR h_len against LR buffer
size allocated first in xlog_do_recovery_pass() to avoid buffer
overflow triggered by CRC calc or follow-up steps (details in
https://lore.kernel.org/linux-xfs/20200902224726.GB4671@xiangao.remote.csb/ ).

no new callsite (just move the callsite after original workaround
code). Anyway, that is just a buffer overflow issue can be triggered
by corrupted log. Just a minor stuff but security guyes could also
keep eyes on such thing. I think that is right. :)

Thanks,
Gao Xiang

> 
> --D

