Return-Path: <SRS0=Mbmt=WN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D6FC3A59F
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 08:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 206AD21744
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 08:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfHQI0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Aug 2019 04:26:00 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37856 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfHQIZ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Aug 2019 04:25:59 -0400
Received: by mail-ot1-f66.google.com with SMTP id f17so11785923otq.4
        for <linux-xfs@vger.kernel.org>; Sat, 17 Aug 2019 01:25:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jvdMEsGfymC76a7uG5PwO2y4dMCW+deyQ48R7uE+/MU=;
        b=p3gEcKpuyVDsh5ryTtxXuqdic9k1CaWoZzj7TniMcVxnhlMYvK2E/HgUns/SnQnLHQ
         FPZqfAQlT5WYDrlJ+eAV2FGJpHOxPAMZ3GpML/iH77oHzqeT5aEnNHAXe55ikCM+yqUf
         3xvx/KAOj7w8K66ugHMnpIynVjNFEpgFDcJ/ROcaEbPcNmjatcRJIUia4acaJJH42MzE
         +q3QZT6NSyRx5XXrknKwKA7lUaNaSjyWIFy2v0K5eqNhZE/nLyiFutavD2xgXpLEo7zl
         Np8N+CiBGFWWYDjDR0wMNrkUo2OU52aYx04W+2i9RaHUs1a9P8LQjGW2oRzcnkor2cli
         Nr6A==
X-Gm-Message-State: APjAAAU+mub/jsIBh1+26Z5U/gSWbGa/ZaRWj/WAvd2oLvDsRgrEtyLZ
        KQUczet/3dnuDg6DB77imeLpuuEyOlOjR4o2JFSwSQ==
X-Google-Smtp-Source: APXvYqx6k/zgLSMkM1rApUpsoy+RhYN5+WYZVoeoL9mCyLZ03LqU+ku6jTp1ZW1nexIw0F+l6Nz9SwoAR7hAW6uOM/I=
X-Received: by 2002:a05:6830:22f4:: with SMTP id t20mr9344290otc.58.1566030358976;
 Sat, 17 Aug 2019 01:25:58 -0700 (PDT)
MIME-Version: 1.0
References: <156444945993.2682261.3926017251626679029.stgit@magnolia>
 <20190816065229.GA28744@infradead.org> <20190817014633.GE752159@magnolia>
In-Reply-To: <20190817014633.GE752159@magnolia>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Sat, 17 Aug 2019 10:25:47 +0200
Message-ID: <CAHc6FU6GzaNNT6kBw9XE20TOAFZKusR7dC2cQAnM6CQzj0T3Mw@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] iomap: lift the xfs writepage code into iomap
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 17, 2019 at 3:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Thu, Aug 15, 2019 at 11:52:29PM -0700, Christoph Hellwig wrote:
> > Darrick,
> >
> > are you going to queue this up?
>
> Yes, I'll go promote the iomap writeback branch to iomap-for-next.  I
> haven't 100% convinced myself that it's a good idea to hook up xfs to it
> yet, if nothing else because of all the other problems I've had getting
> 5.3 testing to run to completion reliably...
>
> ...I assume gfs2 and zonedfs are getting ready to send stuff based on
> that branch?

It doesn't look like the gfs2 bits are going to be ready for 5.4.

Andreas
