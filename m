Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698FBC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jun 2022 17:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiFMRfU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 13:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241426AbiFMReM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 13:34:12 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7583527D;
        Mon, 13 Jun 2022 05:56:08 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id d18so6097478ljc.4;
        Mon, 13 Jun 2022 05:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=23KDBDDZ3VkUuxNsEX2Vg6z3P++uxWU/q1ahY548XbY=;
        b=WGFEBLPvs34hqZorXMFpphv2yLNWJQYYANp9GUstfjUroHh7OzaIXSayDUxBb6AwQu
         ZWN96SgJakP1KylQptQ2ki5zjTMI8nhEUCXzp+i1OqA8rIZZgd3v2/4cGJvpjnm75a8z
         pD/mZM7pjW5r49KyvGdXP1czPuJ1FRm7z6XmpQB0uUSkTEZGgrTERmLHbhFRVxciYsAO
         27CwrUIC74b7uFY7jRQMoT30nAEc0DBH/qlMh5Zqg/MtLQoLvKnbsCiH+ZBpCrvBENTD
         SmbEVB2ezT/aQLK7UK0DM9Qw1OaXMb5zVao3q+fabZifar49zS2fYpjNd0gfwssT57aZ
         jkNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=23KDBDDZ3VkUuxNsEX2Vg6z3P++uxWU/q1ahY548XbY=;
        b=tK83dO8s4B4+fl1ASwDQiHT2DDgzoqtgGt78kMiUf2zJ+uZrJ+9WqB5i4WEH1ck0eS
         4VpanSbCl8kt8sIBSGX2aNh3s1x+BmPLRtxfPsj1Rqedhx2NPJlBuaQjk+mvhSGlrPbu
         GIP11PXW3AR0VgyYYrYTl9Hhb4c1SCZtNpTyrxtMr8n57wuhXJD1hgsWy8oldKCDZBm0
         h+FsYudwGUa73K73o5+xEpEB0yeAzUYgcs/HFWw/cW6vIV+oGvpZSEp4+NnFuzSrHXj3
         Ut4yTgbZWj72YkjIat8tOq+K9Kbe63mlwT1eIiOaTUOfbE9PqmTSHgina52DKNAv36Cz
         nlNg==
X-Gm-Message-State: AOAM533tH1puL0ozporawIFadrOuEb8exhhjBQDeSFRN68xHyx4/3wKh
        z9W0tV5hMON0cyiTJxyfBgU=
X-Google-Smtp-Source: ABdhPJxA5x8JCBmPoxnRAJLCpQ2Ve1KOnbsHBwhlXNeb0c0xEh3qeODUBU0JaHYb/BM+3eJ9d0OafA==
X-Received: by 2002:a05:651c:210f:b0:255:847d:391d with SMTP id a15-20020a05651c210f00b00255847d391dmr24739381ljq.354.1655124966313;
        Mon, 13 Jun 2022 05:56:06 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id 1-20020a2eb941000000b00258df665017sm1001443ljs.3.2022.06.13.05.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 05:56:05 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Mon, 13 Jun 2022 14:56:03 +0200
To:     Baoquan He <bhe@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Uladzislau Rezki <urezki@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Kees Cook <keescook@chromium.org>, linux-mm@kvack.org,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/3] usercopy: Handle vm_map_ram() areas
Message-ID: <Yqcz4wRt8o4IfwTr@pc638.lan>
References: <20220612213227.3881769-1-willy@infradead.org>
 <20220612213227.3881769-2-willy@infradead.org>
 <YqcKw4AxxvEWtLmS@pc638.lan>
 <Yqck9GUI8B7mUx4N@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqck9GUI8B7mUx4N@MiWiFi-R3L-srv>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On 06/13/22 at 12:00pm, Uladzislau Rezki wrote:
> > > vmalloc does not allocate a vm_struct for vm_map_ram() areas.  That causes
> > > us to deny usercopies from those areas.  This affects XFS which uses
> > > vm_map_ram() for its directories.
> > > 
> > > Fix this by calling find_vmap_area() instead of find_vm_area().
> > > 
> > > Fixes: 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
> > > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > ---
> > >  include/linux/vmalloc.h | 1 +
> > >  mm/usercopy.c           | 8 +++++---
> > >  mm/vmalloc.c            | 2 +-
> > >  3 files changed, 7 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> > > index b159c2789961..096d48aa3437 100644
> > > --- a/include/linux/vmalloc.h
> > > +++ b/include/linux/vmalloc.h
> > > @@ -215,6 +215,7 @@ extern struct vm_struct *__get_vm_area_caller(unsigned long size,
> > >  void free_vm_area(struct vm_struct *area);
> > >  extern struct vm_struct *remove_vm_area(const void *addr);
> > >  extern struct vm_struct *find_vm_area(const void *addr);
> > > +struct vmap_area *find_vmap_area(unsigned long addr);
> > Make it "extern" since it becomes globally visible?
> 
> extern is not suggested any more to add for function declaration in
> header file, and removing it doesn't impact thing.
> 
OK, thanks for the hint: Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki
