Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869AFC432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 08:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 581B320717
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 08:50:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TPI1NOL0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfKVIul (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 03:50:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48025 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725999AbfKVIul (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 03:50:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574412639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7vOy8PSKH+hX0rDvoZ3FnmWARTtPe1QhxrzLbH5ZdCM=;
        b=TPI1NOL0sKb95qpJr1NhdN7tASCnayn2LCP6Hc5230SWiAN3AMIkqGNnDxoVQ9fs9PHnH0
        pTxhZUkYYvaLn4m1AuGax9xeAJmijMmvoJUoNUvVeTOOT5f2uT15M+pf2mleaM/6qfv9Lv
        vYn+HZnUJXVX7/hjIiSQoLG5ZE+Xb6k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-ul3gnYKgNSutM4HVUaXfAg-1; Fri, 22 Nov 2019 03:50:38 -0500
Received: by mail-wm1-f69.google.com with SMTP id 18so361919wmg.1
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 00:50:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=rNuy7bu8WKtYbj3qrOefaXjt/x657qNMIyyQkmiQiW4=;
        b=ChZ0y00u5bHpqABRPWxpkD+UFsCSRjKeFS46DDe2kw0sf+viRqe2DCN1sUqB5mKb4d
         zPHKjG/BeBR/UJ8bc2ycndzz5UuZzCpRG2KKv4mOCFstZ97UqaRH722/iqG9uqNnM/DA
         RaX1rywan39snUULXTEY4ohLsEi5cj2ZGyNaeJF9D825Vn4qNdAeytTSc1UnM7qPYKSq
         LZTzpDmsy18MnfSKSKBNO94m5U81EuPztDi0g9rmiFzsgKe67pI/d681jIwAhYdAc3ZF
         ai0HNN5OQQDJQn/u/8aiMrQwViUD5r743ErtM3+Dih40RXuA1Xb1QPsfh0HdwVFup8wV
         lb3A==
X-Gm-Message-State: APjAAAVsYvi4gf+mEahLFhtrQu2TzKHESipNLXQ37UQ7OQbUu6K/XCd2
        jsVrb+mGmimXDjOs8hTebQ1NDal65pjM56PjjyHJrtYxPwNm6CakN7zroOaPHeD/v2Ick3Qyr6f
        M16jrdlbGcuy1WUGtFskD
X-Received: by 2002:adf:fa87:: with SMTP id h7mr7108412wrr.172.1574412637528;
        Fri, 22 Nov 2019 00:50:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqw33GZ760cqzl5z8rB+T2ov6R4Pb2Aqi17whVoFns8d6aKYGJCx1LBjTQtTb4cyDRaUf6o/8A==
X-Received: by 2002:adf:fa87:: with SMTP id h7mr7108392wrr.172.1574412637303;
        Fri, 22 Nov 2019 00:50:37 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id o7sm5315609wrv.63.2019.11.22.00.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 00:50:36 -0800 (PST)
Date:   Fri, 22 Nov 2019 09:50:33 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com
Subject: Re: [PATCH 4/4] xfs: Remove kmem_free()
Message-ID: <20191122085033.nluuuvomf64pu3qx@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, dchinner@redhat.com
References: <20191114200955.1365926-1-cmaiolino@redhat.com>
 <20191114200955.1365926-5-cmaiolino@redhat.com>
 <20191114210000.GL6219@magnolia>
 <20191115142055.asqudktld7eblfea@orion>
 <20191115172322.GO6219@magnolia>
 <20191118083008.ttbikkwmrjy4k322@orion>
 <20191121054352.GW6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191121054352.GW6219@magnolia>
X-MC-Unique: ul3gnYKgNSutM4HVUaXfAg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick.


> > >=20
> > > Sure, but I'll believe that when I see it.  And given that Christoph
> > > Lameter seems totally opposed to the idea, I think we should keep our
> > > silly wrapper for a while to see if they don't accidentally revert it=
 or
> > > something.
> > >=20
> >=20
> > Sure, I don't have any plans to do it now in this series or in a very n=
ear
> > future, I just used the email to share the idea :P
>=20
> Eh, well, FWIW I took a second look at all the kvfree/kfree and decided
> that the usage was correct.  For future reference, please do the
> straight change as one patch and straighten out the usages as a separate
> patch.
>=20

I'm not sure what you meant by 'straight change' and 'straighten out'.

Do you mean to do send a single patch with only the changes made by the
'find&replace' command, followed up by a kfree() -> kvfree() where appropri=
ate?

Cheers.

> In any case it seemed to test ok over the weekend (and still seems ok
> with your series from today), so...
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>=20

> --D
>=20
> > Thanks for the review.
> >=20
> > --=20
> > Carlos
> >=20
>=20

--=20
Carlos

