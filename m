Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EFBCCA47F
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jun 2022 08:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbiFMIFG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 04:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239467AbiFMIEj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 04:04:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2F561DA74
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jun 2022 01:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655107475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yG4TXPIUpzu5JrpFoncCij2pFS/fRyC7T4T0EvjrJIw=;
        b=FBY8P+y2zacfzLh+A0ffweZltK9c+iavDmIR09s+lMtS2ihcbuKcGfg+avVgJAiXbdarCW
        6DMvDJGjZancOgLvNDZfrtkLjJObthCWCW/u/FYf9DDrbIzh2mgYsuNRrYGk3Li3dr4Lnb
        sq/5VstFOhv4MhD37RaUojlx6z99zm0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-MaddmyjrP7O2xkvcx3CWDw-1; Mon, 13 Jun 2022 04:04:31 -0400
X-MC-Unique: MaddmyjrP7O2xkvcx3CWDw-1
Received: by mail-qk1-f200.google.com with SMTP id h16-20020a05620a401000b006a6b8ac9c64so4459780qko.8
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jun 2022 01:04:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yG4TXPIUpzu5JrpFoncCij2pFS/fRyC7T4T0EvjrJIw=;
        b=F/yli9IIeOZHs2oSmETetwOZ4vno73gamScLvVHpWxWMxS7pmKLEikuRgVpB2QGYTK
         jZKutWLfrADUmZhNnIgfJGtC6dmp4ovO97FQ4LaDD+Alyuujbz5JYn+6iP6kKb+0sopU
         G2QMRzfcapaYpG++zrAHgdL7qWwVqCD+aPHHV1+GPS9dP1A6J2ipv+3mhTe7UDQNzwBS
         uMTXv/Q445RoufhhSoDeHbw950Eo+6G8ERsNtGKnN4gyI8nZhMv30g0Dn+q/q+DW7PhS
         lY39Wavs7f63dXpFLdr0PbB+8GOTKReKkZxGXT7RkVpSDl8r4Zmqj7JoWDpUhoG7XVIM
         QT5Q==
X-Gm-Message-State: AOAM530AoiXactvHIV37b4UoJTc6ZAhDfF/ZR2yRjhhwMVjIzapi9iTV
        grvotReDTHEZmRghoSJWc+sLWcNv8vWk4NFKmWnRZcMhIg4/Pra9tvWZYeRVN7bqwOluu3VWles
        XJu86VduCetHA4exCQoXG
X-Received: by 2002:ac8:75c5:0:b0:304:ffea:c434 with SMTP id z5-20020ac875c5000000b00304ffeac434mr21835014qtq.170.1655107471479;
        Mon, 13 Jun 2022 01:04:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyK9pDfdt2ahRKvrZUBXZLqk04TKP9jpVIYJWgt4s4IShRDLBAZDAcAbWT6DSNOcl4fM1ceg==
X-Received: by 2002:ac8:75c5:0:b0:304:ffea:c434 with SMTP id z5-20020ac875c5000000b00304ffeac434mr21834999qtq.170.1655107471225;
        Mon, 13 Jun 2022 01:04:31 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x14-20020a05620a448e00b006a711bb74b6sm6631173qkp.87.2022.06.13.01.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 01:04:30 -0700 (PDT)
Date:   Mon, 13 Jun 2022 16:04:24 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-mm@kvack.org,
        Uladzislau Rezki <urezki@gmail.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/3] Fixes for usercopy
Message-ID: <20220613080424.gkfn3v3crjjbgxyb@zlang-mailbox>
References: <20220612213227.3881769-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220612213227.3881769-1-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 12, 2022 at 10:32:24PM +0100, Matthew Wilcox (Oracle) wrote:
> Kees, I'm hoping you'll take these through your tree.  I think they're
> all reasonable fixes to go into 5.19.  The first one is essential;
> it fixes two different bugs that people have hit.
> 
> Matthew Wilcox (Oracle) (3):
>   usercopy: Handle vm_map_ram() areas
>   usercopy: Cast pointer to an integer once
>   usercopy: Make usercopy resilient against ridiculously large copies

Hi Matthew,

[Quick response] ...
After merging this patchset onto linux v5.19-rc2, I can't reproduce bug [1]
anymore. I'd like to keep the test running, if it find other issues I'll
feedback.

Thanks,
Zorro

[1]
https://bugzilla.kernel.org/show_bug.cgi?id=216073

> 
>  include/linux/vmalloc.h |  1 +
>  mm/usercopy.c           | 24 +++++++++++++-----------
>  mm/vmalloc.c            |  2 +-
>  3 files changed, 15 insertions(+), 12 deletions(-)
> 
> -- 
> 2.35.1
> 

