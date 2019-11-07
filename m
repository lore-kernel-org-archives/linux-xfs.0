Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C47C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 17:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FAFB2166E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 17:55:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SlVm1Ndh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731013AbfKGRzC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 12:55:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35368 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730510AbfKGRzC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 12:55:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573149301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OcNFikfjq1BX5+nPgo4efKiLi5+1HMQMe6Ro0KRZSBk=;
        b=SlVm1NdhEguG68WRZqQkrjZ4GyvkeA+ORUYnyidxOY21VBU54fs8KCqGrVQPwwd/skHGJb
        AQpp/4/Fw5Oon0wjzuW4KdLZqRBHVMfIesLE262FJkBtUHdX0gTvrIL5VPCRFmrgT1x5/G
        6Uosl2jY2uTUO1bVEkPFuGRQETDnuG8=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-X6Gj3d0BNMOq4yK6jbYHaA-1; Thu, 07 Nov 2019 12:54:57 -0500
Received: by mail-ot1-f70.google.com with SMTP id j16so2607300otl.9
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 09:54:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PTyEtIAxeTb5uCPTzRm1VfghpAdZyRKOiXCNpposzoM=;
        b=nymutbEMyVe4eOoA5jFS6E4TEFzcZFhdbu1fqgczV5imZ8fka9nYyPcDf0wGLuqTmW
         BvgJyUUU3dSfQf0plsHjL50YfVrJ/cV4QoRJGee+SE4uM6Dtd4zfx8nQ/jjbw0nBFqgS
         uzW/jItagy61EMcb3PxVslZJrxqLryMM6PZcmO2MiMPRjwDjjtTAqOyCVSG7fdfPo0Cc
         syWjEq4wyrIus3Cq5NqrOEfXI2xsPjcJFsmhRXG5yzpUkucg7j+9pPJ/KrQTkQVKKJDP
         PahYjuYmuHMVpeA9yRaFsMlqSK9tgTq1YdhPI/sApqxFoQxoeGEfa8+djPjmgwbXHocI
         xGyA==
X-Gm-Message-State: APjAAAXsm9WpYpLCACwzn6AfEqk16gSWegEw6o80kz12YVYM32xcz3Zm
        YQ9CNHM28Lx3Q3dtx2LKZGdFMOYr+I6aFrTx2uKDzFwtSlIkkhjQEsLtUbg5+7LuHgfGw0SQo23
        Yks88HG4pDv9/gl2ktAVGqtB6+qWscx0jQYdY
X-Received: by 2002:a05:6808:a93:: with SMTP id q19mr4586985oij.178.1573149297222;
        Thu, 07 Nov 2019 09:54:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqw0A2DoTN7Dd2YoA7wNZdzvb4Bs3F8W8ZXlYA+sAvpG9vN1il3FFfXJ85lmrnNflzjHOBC3OdkylYKZdk7tGrA=
X-Received: by 2002:a05:6808:a93:: with SMTP id q19mr4586966oij.178.1573149297020;
 Thu, 07 Nov 2019 09:54:57 -0800 (PST)
MIME-Version: 1.0
References: <20191106190400.20969-1-agruenba@redhat.com> <20191106191656.GC15212@magnolia>
 <CAHc6FU4BXZ7fiLa_tVhZWZmqoXNCJWQwUvb7UPzGrWt_ZBBvxQ@mail.gmail.com> <20191107153732.GA6211@magnolia>
In-Reply-To: <20191107153732.GA6211@magnolia>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 7 Nov 2019 18:54:45 +0100
Message-ID: <CAHc6FU4MbJ5T+W_ku2gQzoquvMeh3Wbvus-c+tjOc6ZrOwTRiQ@mail.gmail.com>
Subject: Re: [PATCH] iomap: Fix overflow in iomap_page_mkwrite
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
X-MC-Unique: X6Gj3d0BNMOq4yK6jbYHaA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 7, 2019 at 4:37 PM Darrick J. Wong <darrick.wong@oracle.com> wr=
ote:
> I'll fix it on commit.

Thanks.

So now the one remaining issue I have with those two functions is why
we check for (offset > size) instead of (offset >=3D size) in

  if (page->mapping !=3D inode->i_mapping || offset > size)

When (offset =3D=3D size), we're clearly outside the page, and so we should=
 fail?

Thanks,
Andreas

