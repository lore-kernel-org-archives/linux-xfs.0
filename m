Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B27CCA47D
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jun 2022 19:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244172AbiFMTKj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348653AbiFMTI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 15:08:29 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3FA4BFF2
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jun 2022 10:04:57 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t2so5604965pld.4
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jun 2022 10:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=in7tslnl1pN8vUFguET+89DVtHxfd8oga9pQJTnUjCA=;
        b=jlfG4XX0JZah9ScTkDAu897hir02bkHLVC2OYUVBinaVFpgcy1iM5ms5NVWoXZ4wIP
         upQwf52fotHK+u4MTDiQ5gLqeinihIHDyD8Z0Pi+9a1LeBglZoSmERkxWfOrXxaaOQf4
         /nrqOnyuIDqGI40xhulBwgyn2MDsJ9hzrB71M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=in7tslnl1pN8vUFguET+89DVtHxfd8oga9pQJTnUjCA=;
        b=EyWdCp021b4qWsrgoxLUmqXnrh0SgYwbDD20HMUF6ShXOQ15ai2rA7N1oAuEnDzV15
         9/U7H/40WgWQpqo5e5OiFXqVeYWKqEx0KL+u/peM67YtWkWwFUHcx724VBTko667Z+F2
         wNFM+SyvEqRRxWnkGa+EpmDh84WuNUtJdI9p4gVIsVE56GftnxhbfzPA/KlmUPWwtdcj
         sSqdRutklbQFzwDu8C/Hkv83mahOjOzLL5Minby2O14OoEN0YjIlCNVe617AQbTnyIZw
         SBJ/KKmDhCV93q6hqeL529C9DjqyoADkcTtwFlh//GYo2XRoTjVQn2mDoD8P1E12qyje
         SC0w==
X-Gm-Message-State: AJIora+NTf5/gigG1X7CMPMPmTUD5Iv0jNoUkvAxLaCoak/DP7CNri6A
        51sIPBuytk12ZtIlXqNI+7o+Kg==
X-Google-Smtp-Source: AGRyM1ukNi6ZKghruMyMgq9ihVMgVUUHQPC5Ae0JokRXjO5moqGBTsopK5QZ+vZZb16JEEdiAMBHng==
X-Received: by 2002:a17:903:1211:b0:168:e42f:86ff with SMTP id l17-20020a170903121100b00168e42f86ffmr107663plh.112.1655139896906;
        Mon, 13 Jun 2022 10:04:56 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j64-20020a62c543000000b0050dc762819bsm5670671pfg.117.2022.06.13.10.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:04:56 -0700 (PDT)
Date:   Mon, 13 Jun 2022 10:04:55 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/3] usercopy: Handle vm_map_ram() areas
Message-ID: <202206131004.CF19D5659@keescook>
References: <20220612213227.3881769-1-willy@infradead.org>
 <20220612213227.3881769-2-willy@infradead.org>
 <202206130922.A218C4E3E8@keescook>
 <Yqdpc336QsmVr1Tp@casper.infradead.org>
 <Yqdtkhi+AAejtekZ@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqdtkhi+AAejtekZ@pc638.lan>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 13, 2022 at 07:02:10PM +0200, Uladzislau Rezki wrote:
> On Mon, Jun 13, 2022 at 05:44:35PM +0100, Matthew Wilcox wrote:
> > On Mon, Jun 13, 2022 at 09:23:15AM -0700, Kees Cook wrote:
> > > On Sun, Jun 12, 2022 at 10:32:25PM +0100, Matthew Wilcox (Oracle) wrote:
> > > > vmalloc does not allocate a vm_struct for vm_map_ram() areas.  That causes
> > > > us to deny usercopies from those areas.  This affects XFS which uses
> > > > vm_map_ram() for its directories.
> > > > 
> > > > Fix this by calling find_vmap_area() instead of find_vm_area().
> > > 
> > > Thanks for the fixes!
> > > 
> > > > [...]
> > > > +		/* XXX: We should also abort for free vmap_areas */
> > > 
> > > What's needed to detect this?
> > 
> > I'm not entirely sure.  I only just learned of the existence of this
> > struct ;-)
> > 
> >         /*
> >          * The following two variables can be packed, because
> >          * a vmap_area object can be either:
> >          *    1) in "free" tree (root is free_vmap_area_root)
> >          *    2) or "busy" tree (root is vmap_area_root)
> >          */
> >         union {
> >                 unsigned long subtree_max_size; /* in "free" tree */
> >                 struct vm_struct *vm;           /* in "busy" tree */
> >         };
> > 
> > Hmm.  Actually, we only search vmap_area_root, so I suppose it can't
> > be a free area.  So this XXX can be removed, as we'll get NULL back
> > if we've got a pointer to a free area.  Ulad, do I have this right?
> >
> Yep, we find here only allocated areas which bind to the "vmap_area_root"
> tree, so it can not be a freed area. So we will not get a pointer to the
> free area :)

Thanks!

I've tweaked the patch to drop the XXX comment.

-- 
Kees Cook
