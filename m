Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A6AC433F4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 15:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6A0F20771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 15:07:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K4HktgZt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgGOPHI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 11:07:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43593 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727971AbgGOPHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 11:07:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594825624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d6Yy3aaYJIDySBn8AJaIADLLjeSFkvL8kuy86tdQObs=;
        b=K4HktgZtLYiXN+nCK98fytS1EyHYy5UyI4/1v6b3MNJaUmpfqxNCPI7dfEDz7EG74Txlma
        iXa1Snew5Phsv6QeoTBXpkFDwzVkmeMiendtLDLTaElOcdKi2v9WmdtGdRepa03McYyt20
        1Pclrcftnmt/AWMEWRmgAG0xKWKd5fk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-pA5so5m2PDuMyKN_dd8-hA-1; Wed, 15 Jul 2020 11:07:03 -0400
X-MC-Unique: pA5so5m2PDuMyKN_dd8-hA-1
Received: by mail-wr1-f71.google.com with SMTP id i10so1490492wrn.21
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 08:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=d6Yy3aaYJIDySBn8AJaIADLLjeSFkvL8kuy86tdQObs=;
        b=kxGm+1bawYt68r0BdVvxH8JMwB1Kwn0NwlvCVUlroD7sFRy0ikONX69c4Tipv/qbjn
         UqDcxjFytL/MoQdA+zPpC/QLIai2X7EvJYRIwfPlaCx0MWy7YUDUCBKi2vZI3+cWGvF3
         1j3MPBf25IiJ7Ez1a09RBki4mOafKL4auJwh7Yi9uPyw8VP04KgYWzQ2sJnHCEABMkAX
         VKWeuX8UZpwvHUQBxabi0nPtPktqqAwGvGnCPeXxr3hHgTO8Vgqhozs/sXuhossG+sht
         CgCLY4yoco1V462kBj8rCY2r1iSLg2iFwK/KJLQsi1TupDD03/pCDU0mEMwLIbYYPA1Q
         wEjg==
X-Gm-Message-State: AOAM531Lv7ng6voQ+H2YJb6v2kKSNg+dFi64bjiuD52+dFFPY1ydZo51
        z+TPd7LKjSbSuahk9pFzBfDoMKjNlt6gpjqpA5ATmXWE27iH3uYCzmHhg3z6eAXusyWKqj9/SjU
        pEd9yNET11BMuugtsX1A2
X-Received: by 2002:a1c:bdc3:: with SMTP id n186mr9095896wmf.84.1594825621758;
        Wed, 15 Jul 2020 08:07:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhW8FOdOP/yekwaRgkZcsfRWLC6fDK052B5eLYNnnG30Uhe0a3aPHMmwyBlJ3aPb1R2UbWXA==
X-Received: by 2002:a1c:bdc3:: with SMTP id n186mr9095880wmf.84.1594825621560;
        Wed, 15 Jul 2020 08:07:01 -0700 (PDT)
Received: from eorzea (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id y6sm3834593wrr.74.2020.07.15.08.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 08:07:01 -0700 (PDT)
Date:   Wed, 15 Jul 2020 17:06:59 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 1/5] xfs: Remove kmem_zone_alloc() usage
Message-ID: <20200715150659.crao7yuq3hkh3tmq@eorzea>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-2-cmaiolino@redhat.com>
 <20200710160804.GA10364@infradead.org>
 <20200710222132.GC2005@dread.disaster.area>
 <20200713091610.kooniclgd3curv73@eorzea>
 <20200713161718.GW7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713161718.GW7606@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > No problem in splitting this change into 2 patches, 1 by unconditionally use
> > __GFP_NOFAIL, and another changing the behavior to use NOFAIL only inside a
> > transaction.
> > 
> > Regarding the PF_FSTRANS flag, I opted by PF_MEMALLOC_NOFS after reading the
> > commit which removed PF_FSTRANS initially (didn't mean to ignore your suggestion
> > Dave, my apologies if I sounded like that), but I actually didn't find any commit
> > re-adding PF_FSTRANS back. I searched most trees but couldn't find any commit
> > re-adding it back, could you guys please point me out where is the commit adding
> > it back?
> 
> I suspect Dave is referring to:
> 
> "xfs: reintroduce PF_FSTRANS for transaction reservation recursion
> protection" by Yang Shao.
> 
> AFAICT it hasn't cleared akpm yet, so it's not in his quiltpile, and as
> he doesn't use git there won't be a commit until it ends up in
> mainline...
> 

Thanks, I think I'll wait until it hits the mainline before trying to push this
series then.


-- 
Carlos

