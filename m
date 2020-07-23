Return-Path: <SRS0=I6cU=BC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DAEC433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jul 2020 09:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12BEE2071A
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jul 2020 09:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NmevssvP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgGWJCk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jul 2020 05:02:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47779 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728170AbgGWJCj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jul 2020 05:02:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595494958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wjk22UxoW0Cdbt+18K758jgjkgB2ArLGT31PqDWubI=;
        b=NmevssvPqadY3EcM+wuiOrmFBDkWlAUJFIFB+pQfUyyNqn7jVbXX6E5RabYx9byYn7HOCY
        Af4ZV4WDhMG+fs20eldpAx01WFlV8q6A7IYdR3bFHaUjrfmI3FVkQKjVekKvL2TGhhFkQA
        HrY3qDw4+mOpEIhOR9j3ZOnMK2Z+iig=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-MmTV7nmcNXuvgrMRDH3oEw-1; Thu, 23 Jul 2020 05:02:36 -0400
X-MC-Unique: MmTV7nmcNXuvgrMRDH3oEw-1
Received: by mail-ej1-f69.google.com with SMTP id op28so2140844ejb.15
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2020 02:02:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=7wjk22UxoW0Cdbt+18K758jgjkgB2ArLGT31PqDWubI=;
        b=U8lPtEH+lE7FsuRfkZLjMG21w30boU+21M21Z6wJeVqINiIC/izhTgpZicuz6SNUxY
         rG6RR1Q40mjHtGSOWVdM9Q1scx05nEZ0OdoWHPFCzht5AQzM0ozzihg595Cq06Xl34dY
         rOuEYbDkH49gZ6GgLCBQkYa3gDnMIoA1wXgkvx9HVXIVQfzCNpWaBBE2TdKb5zdoJvDa
         ieRBfQY7R2XogahfPOCsqmMJm76r8W3Ap/kgFOOf/Zx7HCbzaIuu101270jiJo3hgEef
         gtH/zK25Ap7iCGtHML93h8t9Qb4ow9Ix6K6IrtyGY6D3tc9eBXqe9kkCB9BmsanRFR4j
         wp8w==
X-Gm-Message-State: AOAM533Om4BGcWq5IltNEz44q2zwS0PpiHGpStQSva1nle4KULrgj4Ik
        OE05rp8I7IcZnaAQ7NPMzIbgLmnB0S8QZJbBTCk7bMOEhyBrTERDeK9s6APqKlY34c5s5AruQne
        R/PxgTpU0WXM5YIVVCIE/
X-Received: by 2002:a17:906:b353:: with SMTP id cd19mr3422354ejb.395.1595494954638;
        Thu, 23 Jul 2020 02:02:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyn262LkLrTQxLi5LkdUlMInapey7MkXA3qgMwTcoxQoGee6P/WJDiBgUZZ5uhobLI+HTp6yQ==
X-Received: by 2002:a17:906:b353:: with SMTP id cd19mr3422325ejb.395.1595494954198;
        Thu, 23 Jul 2020 02:02:34 -0700 (PDT)
Received: from eorzea (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id z101sm1657560ede.6.2020.07.23.02.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 02:02:33 -0700 (PDT)
Date:   Thu, 23 Jul 2020 11:02:31 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: Remove kmem_zone_alloc() usage
Message-ID: <20200723090231.ulsyoikyzvfjo3mo@eorzea>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
References: <20200722090518.214624-1-cmaiolino@redhat.com>
 <20200722090518.214624-2-cmaiolino@redhat.com>
 <20200722141346.GA20266@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722141346.GA20266@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 22, 2020 at 03:13:46PM +0100, Christoph Hellwig wrote:
> On Wed, Jul 22, 2020 at 11:05:14AM +0200, Carlos Maiolino wrote:
> > -	/*
> > -	 * if this didn't occur in transactions, we could use
> > -	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
> > -	 * code up to do this anyway.
> > -	 */
> > -	ip = kmem_zone_alloc(xfs_inode_zone, 0);
> > -	if (!ip)
> > -		return NULL;
> > +	ip = kmem_cache_alloc(xfs_inode_zone, GFP_KERNEL | __GFP_NOFAIL);
> > +
> 
> I would have kept a version of this comment.  But if this on your
> radar for the next merge window anyway this should be ok:

I thought it makes no sense to keep the comment, and yes, I'll keep an eye on it
and rework this as soon as we have PF_FSTRANS back.

Thanks for the review.

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

-- 
Carlos

