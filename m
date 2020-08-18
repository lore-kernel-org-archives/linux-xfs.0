Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67719C433E3
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 10:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4738320786
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 10:07:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E5TM3Af6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgHRKH1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 06:07:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45138 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726043AbgHRKH1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 06:07:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597745246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1hpL6DEwUd1smOXQLXeZsHLSUxnXNu+oLlO4+HAzvog=;
        b=E5TM3Af6bHv/lHei9WpxVZwP1ui2EHeX60XKInjXzwZEjaV5nXh1x1ZUD7fJuN4z7/F+bq
        geSN1RJgBhC684jh27ycBFqv3QDzgkqY8zy02l1ouy3KsLhfgrV0dLGbRP5WVB+GI5nsn0
        6IJgQG11MyMbUrOoW3X/B+0AZdO+uew=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-WYQ8DeZFOcWOKD_Y82SRyQ-1; Tue, 18 Aug 2020 06:07:24 -0400
X-MC-Unique: WYQ8DeZFOcWOKD_Y82SRyQ-1
Received: by mail-wm1-f72.google.com with SMTP id z10so7206786wmi.8
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 03:07:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=1hpL6DEwUd1smOXQLXeZsHLSUxnXNu+oLlO4+HAzvog=;
        b=cstysSbLmIepndVz8bqOAKkaEeGu/zjpWu8Czg5eV30sWabfZBFk/QMmqhWUrGMtlr
         5HCm3H95eKE+bNbPkOfsqSzv8DnwwiCjOzSIytkzUrzc8deNmGOcN53x97wmcpjIoMOP
         zao/iYwg+Y8kBIxMwyW+DrLIf6oPTEb0rr88oQsKjDfWdX6KaYUb+zaKs4xs4FghoYvG
         nP1mB0tS7HVCjBAG5IlZzwHVpAHfmIONT8faR5kYLWK8/3dWi6FnJZZW+rlmRvLhTBlP
         T7SzAg8gqNZR1gs8C+Bgu/a4aqFMuxE1JdKuJm7zBadDwwmyzrypNgiaVTJXcobpmBIr
         9QpA==
X-Gm-Message-State: AOAM533Bkto1BnGuXWzm7BWMdyurv5FgMdwTQYy7svlozpBllv9GFTnU
        ItctXV5DgfmmVfa8aZi5f/w3QIlZz653uGDBQGgZyWBRTlquwSi4wD/eFLG8wUwQ5G8nkaRca5s
        X9OC2Rt413AVjVSuKTZ5M
X-Received: by 2002:a1c:24d5:: with SMTP id k204mr18049456wmk.159.1597745243084;
        Tue, 18 Aug 2020 03:07:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ+1cONYDUB8CGWbTu3DUu2DbLNXuwZur57bVPdx7e5bNfqO8ANIH4FnQnJz+dsrPVhjsfPg==
X-Received: by 2002:a1c:24d5:: with SMTP id k204mr18049445wmk.159.1597745242888;
        Tue, 18 Aug 2020 03:07:22 -0700 (PDT)
Received: from eorzea (ip-86-49-45-232.net.upcbroadband.cz. [86.49.45.232])
        by smtp.gmail.com with ESMTPSA id y203sm33358617wmc.29.2020.08.18.03.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 03:07:22 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:07:20 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Get rid of kmem_realloc()
Message-ID: <20200818100720.oiwqk3yi2dsvjqav@eorzea>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
References: <20200813142640.47923-1-cmaiolino@redhat.com>
 <20200817065533.GG23516@infradead.org>
 <20200817101716.mmcgbdpkimc6wvl7@eorzea>
 <20200817153922.GJ6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817153922.GJ6096@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 17, 2020 at 08:39:22AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 17, 2020 at 12:17:16PM +0200, Carlos Maiolino wrote:
> > On Mon, Aug 17, 2020 at 07:55:33AM +0100, Christoph Hellwig wrote:
> > > Both patches looks good:
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > although personally I would have simply sent them as a single patch.
> > 
> > Thanks Christoph. I have no preference, I just submitted the patches according
> > to what I was doing, 'remove users, nothing broke? Remove functions', but I
> > particularly have no preference, Darrick, if the patches need to be merged just
> > give me a heads up.
> 
> Yes, the two patches are simple enough that they ought to be merged.

Ok, you want me to resend or it's just a heads up for the next time?


-- 
Carlos

