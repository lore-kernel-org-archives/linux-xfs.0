Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13AC0C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 07:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D435064E66
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 07:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhBKHCp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 02:02:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229478AbhBKHCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Feb 2021 02:02:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613026877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DtPTAUtlE21tFkP6Zd1aV7+l7NlCjYwR1s7OnWR9No8=;
        b=AW9cHSzI8t8ul70NFp/LFPxEO+QnZtgdiGlIjR6R3zu+AUHoeU3BzWz3IQZgNObtBAvcyc
        et8IbXVoAdSX/aT7r72uNdtejhNgqSb7D6Ir2v72JpG4MSf//OG/TJsh3Rd2P91Gn+cUXQ
        EcmuCRRzpww2mN7mtNW4Aoq9puNQhjs=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-qdLVJpJDN1yaAIldDgtYrA-1; Thu, 11 Feb 2021 02:01:15 -0500
X-MC-Unique: qdLVJpJDN1yaAIldDgtYrA-1
Received: by mail-pg1-f199.google.com with SMTP id p6so3840387pgj.11
        for <linux-xfs@vger.kernel.org>; Wed, 10 Feb 2021 23:01:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DtPTAUtlE21tFkP6Zd1aV7+l7NlCjYwR1s7OnWR9No8=;
        b=MzDLAu1pom0JnhJgdcp910p7zwVflrjqA2xwJn2akNJJVGJsDfhwvf6V1DX0GiPPVM
         ct5E7e73ASeNtVbjkUKUH5mw5kAr+Iyv/EIbvH6cD0rxIU9iTD7y0Kn0NXnKWOsz/ETe
         40Jber3BvoDBImzEogduh64lf5KrLzrq6yKBIp5dTyuBVkZ5H8I05P3aSFzcApTSlHDe
         TMfR0LfXI0L+WB4gDgyl/B9KrP8Z9sXO8MhhbttwPH6I5GXtDcuM7qoiTBYrX/Y/RTmW
         dkKBlwSQxMviABr5DwBK+JT+OhwfeUZO0wcivtWibEH46BZq8FhmFIStxXJVx3zkr7tZ
         Gn/Q==
X-Gm-Message-State: AOAM531IsR2jhMyWHEvlefHsuvXg3BDIQvOu1tkhHLnvgOm/u5BQaxgG
        OAuqzg2k9zfJNA4O4zkqerSU0AeAHlvlXVPYcz5qkXcgZW/R5xTLS+4eosWNJUUFDTZedFEUpkh
        koLyi5RCcHXiMO5wMrm4Y
X-Received: by 2002:a65:6246:: with SMTP id q6mr6916191pgv.6.1613026874617;
        Wed, 10 Feb 2021 23:01:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzi2Mph15LV/suzZerw3RxAVxOZxX/Tim1iZoLKj4qWDAEjAnR3eaaRrUbxYYZqCzE2KFA3Q==
X-Received: by 2002:a65:6246:: with SMTP id q6mr6916171pgv.6.1613026874413;
        Wed, 10 Feb 2021 23:01:14 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e26sm4500728pfm.87.2021.02.10.23.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 23:01:14 -0800 (PST)
Date:   Thu, 11 Feb 2021 15:01:03 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: restore shutdown check in mapped write fault path
Message-ID: <20210211070103.GA1297249@xiangao.remote.csb>
References: <20210210170112.172734-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210210170112.172734-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 10, 2021 at 12:01:12PM -0500, Brian Foster wrote:
> XFS triggers an iomap warning in the write fault path due to a
> !PageUptodate() page if a write fault happens to occur on a page
> that recently failed writeback. The iomap writeback error handling
> code can clear the Uptodate flag if no portion of the page is
> submitted for I/O. This is reproduced by fstest generic/019, which
> combines various forms of I/O with simulated disk failures that
> inevitably lead to filesystem shutdown (which then unconditionally
> fails page writeback).
> 
> This is a regression introduced by commit f150b4234397 ("xfs: split
> the iomap ops for buffered vs direct writes") due to the removal of
> a shutdown check and explicit error return in the ->iomap_begin()
> path used by the write fault path. The explicit error return
> historically translated to a SIGBUS, but now carries on with iomap
> processing where it complains about the unexpected state. Restore
> the shutdown check to xfs_buffered_write_iomap_begin() to restore
> historical behavior.
> 
> Fixes: f150b4234397 ("xfs: split the iomap ops for buffered vs direct writes")
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Taking some time on the internal discussion thread, I also think
SIGBUS is also appropriate after fs shutdown rather than dirty
this page anyway.

Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

