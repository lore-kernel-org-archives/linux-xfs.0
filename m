Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1D4C28E83
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 07:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC2C3206A5
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 07:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIDHxk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 03:53:40 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37620 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729582AbgIDHxj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 03:53:39 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-2bF1QzYyPJ6ywjtvREJWzw-1; Fri, 04 Sep 2020 03:53:33 -0400
X-MC-Unique: 2bF1QzYyPJ6ywjtvREJWzw-1
Received: by mail-wr1-f69.google.com with SMTP id l17so2006704wrw.11
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 00:53:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=61yk5YgfB2OZn7atsoI8Xik3lDZokRlmgFxL9inNvK4=;
        b=KZoJ5obMrZdngiYKNkQzEkIUzpnSMRQmzIx1FeRCpzbNFroa4eTY6sy9oAz6FtzGbQ
         TfvZm/lfUYC3YIZUEjUq1QjcQc2lor1jMm/pN0pbIy/Q44XsYPksOVNLYhvZYGD8/9TN
         v/Jo+zmCsh39oxeIqx62CmlOkdwH3A8aPfGyEHM5QAWwaQ2PEucv2Ef0poLcE9HZOIrr
         LrvjjGPqBwhAkVfGZUmJyqyfE9HWNLSm7WTy2qnW1uvs7nNyfqWtp2y/BPCUXgzSYs3F
         SOtXLY0EEgKq379ZDcvucYYQfgUIUigFCedMnPx21Vlo0sj4nIq1RmwjnXwafJHT53yc
         +2cQ==
X-Gm-Message-State: AOAM530etsKhqbjL7THQquEGOKEIJIUWsOXC4Q7Kc4ssXMP0owpTPveX
        B2KYmdEAjzXjUAPj3Zrfv3G+JE59EC/tHyuuc+/JTvS2M+eUehJNA7qwbQKu0cXL3t45gOSefQM
        rgPdZ0p3wKhLbfA2OmS7A
X-Received: by 2002:adf:dc51:: with SMTP id m17mr6154206wrj.162.1599206011548;
        Fri, 04 Sep 2020 00:53:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoYD6K/AICdSur4YroQ6jdY4ceGjyuBgKLrXvOdrfjEG8zdcupkVSRhO6PnLAg47zFD+pyAw==
X-Received: by 2002:adf:dc51:: with SMTP id m17mr6154196wrj.162.1599206011275;
        Fri, 04 Sep 2020 00:53:31 -0700 (PDT)
Received: from eorzea (ip-89-102-9-109.net.upcbroadband.cz. [89.102.9.109])
        by smtp.gmail.com with ESMTPSA id h184sm9807937wmh.41.2020.09.04.00.53.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 00:53:30 -0700 (PDT)
Date:   Fri, 4 Sep 2020 09:53:28 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/4] xfs: Convert xfs_attr_sf macros to inline
 functions
Message-ID: <20200904075328.drcjnnfbq4zn55im@eorzea>
Mail-Followup-To: linux-xfs@vger.kernel.org
References: <20200903161724.85328-1-cmaiolino@redhat.com>
 <20200903161859.85511-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903161859.85511-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 03, 2020 at 06:18:59PM +0200, Carlos Maiolino wrote:
> xfs_attr_sf_totsize() requires access to xfs_inode structure, so, once
> xfs_attr_shortform_addname() is its only user, move it to xfs_attr.c
> instead of playing with more #includes.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Changelog:
> 	V2:
> 	 - keep macro comments above inline functions
> 	V3:
> 	- Add extra spacing in xfs_attr_sf_totsize()
> 	- Fix open curling braces on inline functions
> 	- use void * casting on xfs_attr_sf_nextentry()
> 	V4:
> 	- Fix open curling braces
> 	- remove unneeded parenthesis
> 

hmmm, my apologies Darrick, looks like my ctrl+c/ctrl+v on the msgid tricked me
This patch was supposed to be sent as in-reply-to the v3 4/4, looks like I sent
it to the wrong id. Do you want me to resend everything? Again, my apologies for
the confusion.

-- 
Carlos

