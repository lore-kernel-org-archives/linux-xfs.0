Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 638F0C38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 18:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJYSkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 14:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiJYSkh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 14:40:37 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5678AC3A0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 11:40:34 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 20so12350687pgc.5
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 11:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ypp924cOxRmHJ8467PlsPJpac5ZwhKzqHwYjG4vMAIY=;
        b=mQqIscoUoR78Aw4+ZOXT7NSKhlzbBIdYBrdStGaIeyFAJ99E+k+uGZ2R3qWQvm05/F
         MW89Bc0HbsLmfE5k/NykN+XajLXcYkfsEsIhVCSH2OwZE5r1mktm5pLMIeVOoLsKu6Jw
         apvpHRozka7y4c+v67UC4Vve+dT6xng4qslT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ypp924cOxRmHJ8467PlsPJpac5ZwhKzqHwYjG4vMAIY=;
        b=AUlnJlywZm/NqLjeTVFjUF4tFajhus7lDDirzun3cy4A8TRuJEcEjQaG6hTAPVQbPq
         2ASTMWcl4osoyBn40JqYE6U6lXKlJ4jkq7Xi6fawUNu5G41huVnStz4fkAEvrZPwfO3H
         Z3YRYx2s7Sn+AJpjzpfBMYyXoM9nHbuLoTweMusmwJsWgeww7p1I/JlEvLPCLcAnQldc
         DgBak3uRwHluOw1UMcU3RDTjw+mTLue37pJyQA1oPd8Ov6pPrI61k8N8Z39eqxEuIbpU
         S8u7a9x2yjmxf/VEPu8oQbAbTEeEDUsWB3mwx2RNbiN2QF6b0eSUg9XLVvhRaUXOK5iv
         FZLw==
X-Gm-Message-State: ACrzQf2lpgaguBoNh9Go7xRRQdlF7fcv8QpV0KWe94MZIHLF6tWc5fKx
        S9ZY4p5c+bJP9csJ2ZI4mkfsonuTVoMQzw==
X-Google-Smtp-Source: AMsMyM5nbOc8BgUpdi2qEvHsCOyN0L6nfnS73pIqvKPHRx34G0fgtXnb7aCW38It/DJwWuEFaqdzAg==
X-Received: by 2002:aa7:92c8:0:b0:56b:d0b8:10f0 with SMTP id k8-20020aa792c8000000b0056bd0b810f0mr11874851pfa.46.1666723234002;
        Tue, 25 Oct 2022 11:40:34 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d185-20020a6236c2000000b0056286c552ecsm1666652pfa.184.2022.10.25.11.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 11:40:33 -0700 (PDT)
Date:   Tue, 25 Oct 2022 11:40:32 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     h@magnolia, xfs <linux-xfs@vger.kernel.org>,
        Zorro Lang <zlang@redhat.com>, linux-hardening@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: fix FORTIFY_SOURCE complaints about log item
 memcpy
Message-ID: <202210251139.3612057E@keescook>
References: <Y1CQe9FWctRg3OZI@magnolia>
 <202210240937.A1404E5@keescook>
 <Y1cFxnea750izJd7@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1cFxnea750izJd7@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:38:14PM -0700, Darrick J. Wong wrote:
> <nod> I realized that these helpers introducing unsafe memcpy weren't
> needed.  Later on after chatting with dchinner a bit I came to the
> conclusion that we might as well convert most of the _copy_format
> functions to memcpy the structure head and flex array separately since
> that function is converting an ondisk log item into its in-memory
> representation, and some day we'll make those struct fields endian safe.
> They aren't now, and that's one of the (many) gaping holes that need
> fixing.

Ah, perfect! Yeah, this is one of the other standard solutions -- header
and flex array handled separately. I'm still working on APIs to handle
the common cases, though. XFS probably will want to keep it separate as
you've done.

> I sent my candidate fixes series to the list just now.

Thanks! I'll go check them out.

-- 
Kees Cook
