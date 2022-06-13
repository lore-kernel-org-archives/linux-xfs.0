Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED80C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jun 2022 19:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347654AbiFMTHI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348114AbiFMTGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 15:06:47 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C6AD19DF;
        Mon, 13 Jun 2022 10:02:17 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id d18so6904067ljc.4;
        Mon, 13 Jun 2022 10:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yfGsHgTqXo2d2GQmMxeXU0MsupjrY03/0LNxbvUvY5k=;
        b=PTqmv1Rff4/u8PNMDJAFwPNTt/5z/Yd1tNaTzaMgWPEdKwvXq/0qQlmsdH8R/+Fmu3
         iVCaK10kW3BJklmWvCfu9lCBf0Dmr0MMQ3ioVCJ9B2zQMQ+yZBiM7uv6fR1B/p/gc1Z8
         wlRpwIxfCDL7TFr787Kl95BPVznpXN5y7fM0DAV2msSRq+OeBHUdODW2wheHrpOoZx8o
         sntr+kU0aqc2U/woOpiUAjjffQJiKYCtQAz7gQ7mbpgTGMPEgZESIl7K5gAWsBntntTc
         YD+CGYdI+Bv8ax+Z0aEW6u04cEw7uLStL/dE1ikWOLZPdVCGjUnKCC3nf4e65f4RruA0
         4Lhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yfGsHgTqXo2d2GQmMxeXU0MsupjrY03/0LNxbvUvY5k=;
        b=j9AWkTdjDgVZYuR7v4ZEjFA5td8kqsair6ROhnyEvae4RAE2CvXRPl7Zrohe8/dzDJ
         +ECG0z+/FcR9eIOihBLv5T5PXtp7q5mumrJEQo9xxe3BuRUR4hnocXbZnp6cG/m2Eu+6
         IpANkpkylJqBO5I4kHJ8iNSMla+4lVCKwCr6nN9CRR/MNlA3Yt/IT17hnrx6oTqPpVIz
         2nhLEWnF9pRnKuhRLDUuoCt4XDyq6ve5hpm9N1MLYJIej5gW1muSm70gN3dch9qIqeEt
         FRd8ibRSOdyyuRhmp9z/dqFSxKUUAMBgdreJlxqFVVBTjksnFHDCqYw8bGiwIS9zWOT8
         A+hA==
X-Gm-Message-State: AJIora/oYDcTCvaZ13Fp0XuAwym38QEp6/YHA5WWWY5HgLMnjxvTWLSE
        tCrwtbardelsmOFMyjSzylQ=
X-Google-Smtp-Source: AGRyM1st0iUnFw0lkjmtyIHGuku7+0N/gd9mCYdoK+ebmldXBzMn84liFV7aXOwHQ34oA/5CQqh8Zg==
X-Received: by 2002:a2e:8851:0:b0:259:1503:56cf with SMTP id z17-20020a2e8851000000b00259150356cfmr6314ljj.272.1655139734445;
        Mon, 13 Jun 2022 10:02:14 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id t20-20020a056512069400b004795311530asm1045996lfe.209.2022.06.13.10.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:02:13 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Mon, 13 Jun 2022 19:02:10 +0200
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-mm@kvack.org,
        Uladzislau Rezki <urezki@gmail.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/3] usercopy: Handle vm_map_ram() areas
Message-ID: <Yqdtkhi+AAejtekZ@pc638.lan>
References: <20220612213227.3881769-1-willy@infradead.org>
 <20220612213227.3881769-2-willy@infradead.org>
 <202206130922.A218C4E3E8@keescook>
 <Yqdpc336QsmVr1Tp@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqdpc336QsmVr1Tp@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 13, 2022 at 05:44:35PM +0100, Matthew Wilcox wrote:
> On Mon, Jun 13, 2022 at 09:23:15AM -0700, Kees Cook wrote:
> > On Sun, Jun 12, 2022 at 10:32:25PM +0100, Matthew Wilcox (Oracle) wrote:
> > > vmalloc does not allocate a vm_struct for vm_map_ram() areas.  That causes
> > > us to deny usercopies from those areas.  This affects XFS which uses
> > > vm_map_ram() for its directories.
> > > 
> > > Fix this by calling find_vmap_area() instead of find_vm_area().
> > 
> > Thanks for the fixes!
> > 
> > > [...]
> > > +		/* XXX: We should also abort for free vmap_areas */
> > 
> > What's needed to detect this?
> 
> I'm not entirely sure.  I only just learned of the existence of this
> struct ;-)
> 
>         /*
>          * The following two variables can be packed, because
>          * a vmap_area object can be either:
>          *    1) in "free" tree (root is free_vmap_area_root)
>          *    2) or "busy" tree (root is vmap_area_root)
>          */
>         union {
>                 unsigned long subtree_max_size; /* in "free" tree */
>                 struct vm_struct *vm;           /* in "busy" tree */
>         };
> 
> Hmm.  Actually, we only search vmap_area_root, so I suppose it can't
> be a free area.  So this XXX can be removed, as we'll get NULL back
> if we've got a pointer to a free area.  Ulad, do I have this right?
>
Yep, we find here only allocated areas which bind to the "vmap_area_root"
tree, so it can not be a freed area. So we will not get a pointer to the
free area :)

--
Uladzislau Rezki
