Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E9BC432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 05:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E3E120729
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 05:30:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="atnC2AMF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfKOFaU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 00:30:20 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36346 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbfKOF3m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 00:29:42 -0500
Received: by mail-pf1-f196.google.com with SMTP id b19so5875654pfd.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 21:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qwWwUvjngD0vGITVGJw2bNFQc6m1rEqC7TEDYhp2gbo=;
        b=atnC2AMFzcg/i0Mp01bQtIoCfLx+HHbTWM8nHw4lKY3bvK8sTjwuuQEAzd/5lBqjg8
         S2gVzJA/HwmQYtqs72pyRN1J6FXkXvof9go4CmLgmO38QZr4HfrNVAzeJS6EmIVf0Xon
         frtfStys716GXGZIcxrtKpwu1jAmCujAqb+64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qwWwUvjngD0vGITVGJw2bNFQc6m1rEqC7TEDYhp2gbo=;
        b=SrPi9qZNSWZefW7dLmV5Xf7vhwQsYw9HLvUgJYXyeHhO7IHP7XXnCw1hTsDj0Datev
         ux82Xiz8zhUbWvdChlF5apqtjrjfAzVl1VkJnnd9gPGeMN0njKlab7dY4tOw3y2/vwuQ
         dIJ8D0vR4X11ixGbqJ11w89J86Mednk2FSukdJVuJRTnE70XGKbNJZO3e878wEbxX+BN
         VNXz0/TXvAefDJbPmRwVE+v8eYIg+IAJmkC/3V70B9bErm5NuiaS0zVsL5KUsTXT6W/r
         ubqrJGGKAXzJZDCGYqTa2QCXBYUfqkD3Gmui47rm4kMszC+Rmkdd2YhP2E55/nFZ2QvP
         BYSw==
X-Gm-Message-State: APjAAAWzmWdo6G4NyJjGiKKjShgbzU2M125bx2A936ue1UmFNozt+5mC
        l1oUTy6L5o1DkwgQdX8HXiY2rA==
X-Google-Smtp-Source: APXvYqwt4zb0Je/V6IpxbO3fLLPDi96nB5JTyVu+Y5Gk5ifcWF6G9mnVci2ds1rUWNSyZ5xoFyc++Q==
X-Received: by 2002:a62:7c52:: with SMTP id x79mr15159448pfc.18.1573795780005;
        Thu, 14 Nov 2019 21:29:40 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 12sm9010639pjm.11.2019.11.14.21.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 21:29:38 -0800 (PST)
Date:   Thu, 14 Nov 2019 13:27:48 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jiri Slaby <jslaby@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
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
Message-ID: <201911141327.4DE6510@keescook>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
 <1515636190-24061-10-git-send-email-keescook@chromium.org>
 <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz>
 <201911121313.1097D6EE@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201911121313.1097D6EE@keescook>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 01:21:54PM -0800, Kees Cook wrote:
> How is iucv the only network protocol that has run into this? Do others
> use a bounce buffer?

Another solution would be to use a dedicated kmem cache (instead of the
shared kmalloc dma one)?

-- 
Kees Cook
