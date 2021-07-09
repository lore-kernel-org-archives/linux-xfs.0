Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46805C07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 11:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26104613D9
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 11:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhGILKb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 07:10:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229779AbhGILKb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 07:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625828867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xYve4Fb1ntFTWux0G1qTIZ2JxizD+hkq0PRHg0flbPs=;
        b=ZCZWZCrWv1yAxCY9bHdyE8f85aLrt7cKyRoouPa1p0QuV0G+mATcgWkrLrPgQN0jODZwUk
        ygV0ir5i2mFkpfshXQ6b/hSanmMiac6e2zm6deJnjPJ2EreWRPxjNtyvokLc37FhgVASOR
        pldTzBME05yvBORKGlfBBVBVw2lco0U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-IjRFO_TCP-iw-7RhaBJ-eA-1; Fri, 09 Jul 2021 07:07:46 -0400
X-MC-Unique: IjRFO_TCP-iw-7RhaBJ-eA-1
Received: by mail-wr1-f72.google.com with SMTP id h104-20020adf90710000b029010de8455a3aso2744212wrh.12
        for <linux-xfs@vger.kernel.org>; Fri, 09 Jul 2021 04:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xYve4Fb1ntFTWux0G1qTIZ2JxizD+hkq0PRHg0flbPs=;
        b=NqUScdjQQ7n/Pi8xOIj/IJgLK4bi19C4rZXsK8AkoABAj43bwmqIh1Y1MuUHcfV64A
         QAhgGiHn4NTToePcgelO9zmQlR1LnzIPB8UTe0AWe5yXUWf9LtdlwXCzT71YkZvoWjIL
         Irg/7Uk7gN2Dw1PVkcwOT/Jbq+e7Y8dpdfK4Iu62yencdO7hs0HF+59sy5C3ojJZrAk+
         T9cJxLkapVNWavPYUXaZbBivI2WBruSy+VkPyS2Js9/xFISjCL5q55ARtAzTcjT88kAx
         BdWxqBwRj9C+UMBdlDzA2rDiIqHhHGYDr72bgpCcm//ni/G509EJlvctBNAqJQbW4Xfu
         DDVg==
X-Gm-Message-State: AOAM530N1ZlP0AxPDN1wkIAA2Sd14ZijKbwcbRbKYV7rP2cgVmHsmXZy
        bBYCwIH2hhtZjCV/kAY8uht6Cfcd8CDzQWApCO/NtV17wpwjyKtXXlRQ86og2VcGyaiwePm/J0Y
        a5MNuHXtrWnonMF5N7fPgy/J2V7RQALORslrJ
X-Received: by 2002:a5d:64e4:: with SMTP id g4mr34081968wri.377.1625828865438;
        Fri, 09 Jul 2021 04:07:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzZtBvY49sytJNLAgopkmB9OwR4IxiUX+hELjXilJXJ1NRRzW3Ct/VhrnDt5ViyteCotEe0E+oTQmh13qeHuc=
X-Received: by 2002:a5d:64e4:: with SMTP id g4mr34081948wri.377.1625828865289;
 Fri, 09 Jul 2021 04:07:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210707115524.2242151-1-agruenba@redhat.com> <20210707115524.2242151-4-agruenba@redhat.com>
 <20210709042934.GV11588@locust>
In-Reply-To: <20210709042934.GV11588@locust>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Fri, 9 Jul 2021 13:07:34 +0200
Message-ID: <CAHc6FU5xLZvZ94XTxGeobZ7qebG+tsGd7qkJxnfpvF17YTUSbA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] iomap: Don't create iomap_page objects in iomap_page_mkwrite_actor
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 9, 2021 at 6:29 AM Darrick J. Wong <djwong@kernel.org> wrote:
> On Wed, Jul 07, 2021 at 01:55:24PM +0200, Andreas Gruenbacher wrote:
> > Now that we create those objects in iomap_writepage_map when needed,
> > there's no need to pre-create them in iomap_page_mkwrite_actor anymore.
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
>
> I'd like to stage this series as a bugfix branch against -rc1 next week,
> if there are no other objections?

Yes, that would help a lot, thanks.

Andreas

