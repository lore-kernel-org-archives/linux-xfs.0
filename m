Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3EFC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 10:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2772C2071E
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 10:18:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EkdaCMLU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgHZKSc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 06:18:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25537 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728015AbgHZKSc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 06:18:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598437110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=symE4wOkW6dLsN40iekObYaxC+uVi7Iqkfvk+tuiVfY=;
        b=EkdaCMLUqXTdOJrmvkFQekkpDR5A3ehXmetAIAEJmy+rToGEMkXFhLMq6LTD82Fknq0Qgb
        PjNMqNkXr33duA5W5BGwi/YC1xTIcVzA7cYYeyYaV7Q6FJOl/InBXbPxlViWbqJBFR2qm5
        q2QezyPdAQPnuZzhegJJAa9BUvDyYqE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-F5kR55AWM6qVTV7IBEzaIA-1; Wed, 26 Aug 2020 06:18:28 -0400
X-MC-Unique: F5kR55AWM6qVTV7IBEzaIA-1
Received: by mail-wr1-f70.google.com with SMTP id 89so354316wrr.15
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 03:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=symE4wOkW6dLsN40iekObYaxC+uVi7Iqkfvk+tuiVfY=;
        b=XP2dagK4mfO9QbIg9kn1VBPvPPE67OczwoHuKLQre2v6Px2lx28zN5LdHwofSppmTI
         sj1/uM7p7WvIeRdBYXCTygHclGH2ABrqEDw1Ynd1rXlUZm2druXkkJM9cPyJBeYy+CUh
         mkoORekTVYYCPS9AYyHddIyqkf3yN4W3IuMg7CZtyL7a62XvLPcSNL+1BVPn0jpcVi57
         kMRTzLsq0IgjSvjICtHqMj6m2XnZGUCSytFaaxxIdSLWJpYq9lOEGCfhfpW5Nary4ING
         p8gKFcTPcdyDu1tOM3ci2+nN6IxETJybXt4vd3FjjzFfjlG3gGoR8hTM5UOBxVjC7N67
         gstA==
X-Gm-Message-State: AOAM533rTFhAPLS9S7F9Y9HI/+ibuc2wmsRaHdQVOSlzH0zstr3LoMUU
        GZJ7p1G+4F3Pc6SHxFnswCbAJY9a+bdM9l+5gyqZxdr12AQMRYjvxWj6e68IX6Xs+PhyUbUORAq
        2Je2AxMLPq7uZR1sGoq/v
X-Received: by 2002:adf:94a5:: with SMTP id 34mr16086953wrr.198.1598437106817;
        Wed, 26 Aug 2020 03:18:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwp8Ac1kS73ZJOIt3Om8WMt1zjRJH6Gz7jmviTCeZiDU8iUxBnV71XsOoKLa6ImCzaKfYkpBw==
X-Received: by 2002:adf:94a5:: with SMTP id 34mr16086930wrr.198.1598437106593;
        Wed, 26 Aug 2020 03:18:26 -0700 (PDT)
Received: from eorzea (ip-89-102-9-109.net.upcbroadband.cz. [89.102.9.109])
        by smtp.gmail.com with ESMTPSA id r16sm5601066wrv.33.2020.08.26.03.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 03:18:26 -0700 (PDT)
Date:   Wed, 26 Aug 2020 12:18:24 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Remove kmem_zalloc_large()
Message-ID: <20200826101824.u4snwrzotds5fkli@eorzea>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        linux-xfs@vger.kernel.org
References: <20200825143458.41887-1-cmaiolino@redhat.com>
 <20200825223706.GR12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825223706.GR12131@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 08:37:06AM +1000, Dave Chinner wrote:
> On Tue, Aug 25, 2020 at 04:34:58PM +0200, Carlos Maiolino wrote:
> > This patch aims to replace kmem_zalloc_large() with global kernel memory
> > API. So, all its callers are now using kvzalloc() directly, so kmalloc()
> > fallsback to vmalloc() automatically.
> > 
> > __GFP_RETRY_MAYFAIL has been set because according to memory documentation,
> > it should be used in case kmalloc() is preferred over vmalloc().
> > 
> > Patch survives xfstests with large (32GiB) and small (4GiB) RAM memory amounts.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/kmem.h          | 6 ------
> >  fs/xfs/scrub/symlink.c | 4 +++-
> >  fs/xfs/xfs_acl.c       | 3 ++-
> >  fs/xfs/xfs_ioctl.c     | 5 +++--
> >  fs/xfs/xfs_rtalloc.c   | 3 ++-
> >  5 files changed, 10 insertions(+), 11 deletions(-)
> > 
> > I'm not entirely sure passing __GFP_RETRY_MAYFAIL is the right thing to do here,
> > but since current api attempts a kmalloc before falling back to vmalloc, it
> > seems to be correct to pass it.
> 
> I don't think __GFP_RETRY_MAYFAIL is necessary. If the allocation is
> larger than ALLOC_ORDER_COSTLY (8 pages, I think) then kmalloc()
> will fail rather than retry forever and then it falls back to
> vmalloc. Hence I don't think we need to tell the kmalloc() it needs
> to fail large allocations if it can't make progress...
> 
> Cheers,

Thanks Dave!

If nobody has any other comment, I'll submit a version without RETRY_MAYFAIL
later today.

cheers.

> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

-- 
Carlos

