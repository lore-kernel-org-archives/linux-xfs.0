Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AE2C34047
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 14:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2AA924656
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 14:32:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aeZNVX/R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgBSOcl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 09:32:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32620 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727434AbgBSOcl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 09:32:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582122760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OOHAzewQBoZ255TOBS7mz304mNECZKNndTDw0olMJvo=;
        b=aeZNVX/R9pGctBl5NPpXQGQ/a82RaQK4oNLOOSXcmrpzAS9hdfWQwg7nNVKrgTTXQPE7D2
        XAB5H4tovDNNZAcMb4wYS4FRTWdGM5/QVZS34JFhTMi5zbGVuXUrRkmdRy8cG4FQzkAoMf
        c+40GC6OKkxWWhmRrkBMhsDLPGAJVt0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-IeIdaWxNMn6InxGGz-Fd6g-1; Wed, 19 Feb 2020 09:32:33 -0500
X-MC-Unique: IeIdaWxNMn6InxGGz-Fd6g-1
Received: by mail-wm1-f69.google.com with SMTP id 7so258491wmf.9
        for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2020 06:32:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=OOHAzewQBoZ255TOBS7mz304mNECZKNndTDw0olMJvo=;
        b=hESHhhu5vclXZG5DhfxnkyJxYrsRnm8M5dz2fmUg4blxR9ecWDGWWu3Y4MgT5i7Fag
         FwSc2SRTFGEmOccrZe5B+hV/ssB5J/Zbpj3aHkZi6dnZ6l0EWCV/uPq36Se5DfuBDlK0
         GB4Jy8nnj/uOoS316EhivfgzWLQObQfOeIVacm8gzW8MVJ6IktcHTOfDOBAi/9Su7IhP
         ofsI7Qqq+IO5IZU6A2hNYnKmH9SOPo7E9LpkwLwNxWpt98l0S/EYgs1m0E43NIEYrk4n
         9tevtz0QYnL0gRugxktPq2Laft5Ai5wJ7hCP5YCsc8nhVL4KGJLYOEFXuYr/Eu6ndRqO
         yRnQ==
X-Gm-Message-State: APjAAAVCjiPTNNbXZGZuDxY57zpXiiSfu/FZGmoiEDK3IpWFlxpjq2hc
        eBRGrsOlwiFOVTr8iSCTN+TztgNL5z/4oZE83i6qU3JtjC0Li+dJJKOvw1oUdgLzUnk4GNCzM99
        8JpE1nBCXxwTcsSfKB+5R
X-Received: by 2002:a1c:7718:: with SMTP id t24mr10386868wmi.119.1582122751737;
        Wed, 19 Feb 2020 06:32:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqyALsIjOv3yw9BVRPFURyTmouWjkzVNePV8E8vszkUdHRmede+Pmmk8V48zzIkYU30n5YMXsA==
X-Received: by 2002:a1c:7718:: with SMTP id t24mr10386855wmi.119.1582122751562;
        Wed, 19 Feb 2020 06:32:31 -0800 (PST)
Received: from andromeda (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id v12sm3321873wru.23.2020.02.19.06.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 06:32:30 -0800 (PST)
Date:   Wed, 19 Feb 2020 15:32:27 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>
Subject: Re: Modern uses of CONFIG_XFS_RT
Message-ID: <20200219143227.aavgzkbuazttpwky@andromeda>
Mail-Followup-To: Luis Chamberlain <mcgrof@kernel.org>,
        Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>
References: <20200219135715.GZ30113@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219135715.GZ30113@42.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 01:57:15PM +0000, Luis Chamberlain wrote:
> I hear some folks still use CONFIG_XFS_RT, I was curious what was the
> actual modern typical use case for it. I thought this was somewhat
> realted to DAX use but upon a quick code inspection I see direct
> realtionship.

Hm, not sure if there is any other use other than it's original purpose of
reducing latency jitters. Also XFS_RT dates way back from the day DAX was even a
thing. But anyway, I don't have much experience using XFS_RT by myself, and I
probably raised more questions than answers to yours :P

Cheers

> 
>   Luis
> 

-- 
Carlos

