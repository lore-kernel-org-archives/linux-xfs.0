Return-Path: <SRS0=drEG=3Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7291C2D0DB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jan 2020 23:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC6052467B
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jan 2020 23:20:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XawkCOgE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgA0XUC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jan 2020 18:20:02 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35203 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgA0XUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jan 2020 18:20:02 -0500
Received: by mail-pf1-f194.google.com with SMTP id i23so5644420pfo.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2020 15:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QT8O29qq6UX2ERtfMZtIcpjsnZ2zWwc1vGjIRRz0cAI=;
        b=XawkCOgE5DXMC5T4UMCWjNatVuCxPXGElKDJzkypz39qHzpJzBQm4Kjg2Wyc74N8XU
         ae0RNb4v9jld0zCxnKtoZyL8qTh3A+57E2UqJ/UgP52rejOuyEYKSTX+2MbIBdIK8wvO
         WFe7hDDB9CBICJzlBnEvr5cP0Jna4twh3KH9c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QT8O29qq6UX2ERtfMZtIcpjsnZ2zWwc1vGjIRRz0cAI=;
        b=BidJM65FNf2d8wygcHT5gNmGByngApnXTOhSYqh7mzW4l3MGxxQDvI8vA3uhq/awwL
         CiDbBLzyoyT9uQ+PqSlzFgfMqCX26rYKLkZQfoc7KH2TGmvYC9wZfhMtY+J2zX5vczwN
         YTcwYH53j9+8E0Ejacr0RtzrLK4f818Wlew+g2LfTuc27TTNi6R4SxvsQ+Yy9Jgf/reN
         ONuuSyqWlYVj9YvewzdwiuP5Cl9t5uGfPAxgmh4erFCAtDSIWOo2xJwKpnsZmdgGk2Kk
         uNqqoS/mxJwltDyXs9s68KeiqEN7K8LYc6nM9B/CImAiWH6uc0Y4l4+T8FZBvYLvRje1
         cQog==
X-Gm-Message-State: APjAAAXoM12pdAIvO7of6qLmtHB+iGwBWhS7dM3KDJixlzMJF1hBIZYg
        hGEmxOCsHOqTzxWkFtzIff6Ugw==
X-Google-Smtp-Source: APXvYqyXDQEpPXM0xicaJgXWD5GwCMvtHrO2YWSFefSzTu/QuqyGJhGs+kmBUEZGJW1pcHmWRN4ELQ==
X-Received: by 2002:aa7:934a:: with SMTP id 10mr1028171pfn.233.1580167201197;
        Mon, 27 Jan 2020 15:20:01 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m12sm3509886pfh.37.2020.01.27.15.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 15:20:00 -0800 (PST)
Date:   Mon, 27 Jan 2020 15:19:59 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Lameter <cl@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rik van Riel <riel@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <202001271519.AA6ADEACF0@keescook>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
 <1515636190-24061-10-git-send-email-keescook@chromium.org>
 <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz>
 <201911121313.1097D6EE@keescook>
 <201911141327.4DE6510@keescook>
 <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 09:14:20AM +0100, Jiri Slaby wrote:
> On 14. 11. 19, 22:27, Kees Cook wrote:
> > On Tue, Nov 12, 2019 at 01:21:54PM -0800, Kees Cook wrote:
> >> How is iucv the only network protocol that has run into this? Do others
> >> use a bounce buffer?
> > 
> > Another solution would be to use a dedicated kmem cache (instead of the
> > shared kmalloc dma one)?
> 
> Has there been any conclusion to this thread yet? For the time being, we
> disabled HARDENED_USERCOPY on s390...
> 
> https://lore.kernel.org/kernel-hardening/9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz/

I haven't heard anything new. What did people think of a separate kmem
cache?

-- 
Kees Cook
