Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163AAC433E9
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD65F64E6B
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhCSBjT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 21:39:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230128AbhCSBi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Mar 2021 21:38:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616117937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AxjgAB8e8WyfjjmqXmeN4PY3A6Sx3m7BuGASyiSJXd4=;
        b=Y5zbPW3KJCLSAX9zRd3W+HdyOTK7bjF+HtnIsMs/1wcA7ZNlK6NJifydVh1LimqlkocFq+
        +nUFYCEuc1LqDcYeAFLp95VukW1sClhvdnf8bW/oFxcAC7q+WkXYCFPxuqd18a1e5rVCvc
        le5SrxQo+bbhadKT/O5XeqGIOjmZJX8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-4y9SXAYpNs-korRwjrKFXA-1; Thu, 18 Mar 2021 21:38:55 -0400
X-MC-Unique: 4y9SXAYpNs-korRwjrKFXA-1
Received: by mail-pj1-f72.google.com with SMTP id dw22so13543070pjb.6
        for <linux-xfs@vger.kernel.org>; Thu, 18 Mar 2021 18:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AxjgAB8e8WyfjjmqXmeN4PY3A6Sx3m7BuGASyiSJXd4=;
        b=B3Tpv6JGZmE5AWkbvLEllwjuW/9E5lAWumdOi72Vvw3UybZk5k2tKbUIfwQPI7jz6b
         hxl9oDfGiT+Rgs0ZX+6N0kErx5gm4I+XqekooBYP0I2Q/flMs5HCvn5csSeQn2Z47ED5
         1DAILNAoj3Nq7SVhu6IIGpuyBU8+rr6+dvTGfIOev4UaQtF8HEkiWi/oM1FCWosIiEXB
         3yEEc8yNG7DPRvqZzDg9fxu5liPfkpn0Vc3uciWaG7QC7QEPYKf0QuavHTX8XdAJEh6W
         WQT0LAew1uEyhyRG/9yFQRK3e2efbeFR7RjDr84Uql9xeJv15cGFPe5FWC9W5Ye+zq8d
         KZmg==
X-Gm-Message-State: AOAM533xVQFgh90Te0Mso1A+nf6a2vYoryYJnd9zQqrL4e1Vfv/YzRJC
        c3L64m3SNWtCSN3fnAgPC9I0cFZlGP2T3WdDsIw3Ej6fG6HQvOL/8hEHropY2rM1J++F6z3KmpP
        28N3tOjWmkSo5DX8+VO2p
X-Received: by 2002:a65:6a43:: with SMTP id o3mr5200963pgu.297.1616117934758;
        Thu, 18 Mar 2021 18:38:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMCTwCMjWNLbew3S0RZrwTqgFHborkPDX3I8EMALWwu6Z/OJcUB8uLq6JIChquoER9Q9RTEQ==
X-Received: by 2002:a65:6a43:: with SMTP id o3mr5200951pgu.297.1616117934545;
        Thu, 18 Mar 2021 18:38:54 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g26sm3616991pge.67.2021.03.18.18.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 18:38:54 -0700 (PDT)
Date:   Fri, 19 Mar 2021 09:38:45 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/7] repair: Phase 6 performance improvements
Message-ID: <20210319013845.GA1431129@xiangao.remote.csb>
References: <20210319013355.776008-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210319013355.776008-1-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 12:33:48PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> This is largely a repost of my current code so that Xiang can take
> over and finish it off. It applies against 5.11.0 and the
> performance numbers are still valid. I can't remember how much of
> the review comments I addressed from the first time I posted it, so
> the changelog is poor....

Yeah, I will catch what's missing (now looking the previous review),
and follow up then...

Thanks,
Gao Xiang

