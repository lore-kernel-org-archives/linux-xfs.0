Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80BAEB64D8
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Jun 2023 11:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjFUL4P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 07:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjFUL4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 07:56:12 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F6A170C
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 04:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1687348569; x=1687953369; i=polynomial-c@gmx.de;
 bh=PummN8OyP8iD2XUUIbg9MxKuvxl3NSL0QOZLnHSXc6g=;
 h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
 b=qp0IEsbkL6JcHRV7R99RG0+h3/Uvmj7cMzgKRLf1YMKxPN4Yv0ra0nTdnZ4H3ZuEfdBf88a
 LFfIgoa3V3Vl5f+2vA3PWI75cX4ZramtLcFk1IGLLWf/9sFte00QWGXApQgUKT/PvmUT2hA3H
 2YNiit9bYCZ7GQhxc81MGaK45WMg0+xtdqtB2G2iYOnpaKykLh+Br33/pfPeQOsAuY0Q38cXV
 bZ8pd8FNu0Pxrwo5gBEfLUE10YSUZZ1O0Qa/9k6jKpiyx0/IHY+azhrV5qHvB5DleP8+p3Vi9
 JiI+F/RwvBXX40KXsGhkkJJWMmjxKyNmevwMZqdrLW2wpIX29h4g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from chagall.paradoxon.rec ([79.234.209.71]) by mail.gmx.net
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MNbkp-1qR1Vq0UWZ-00P8I3; Wed, 21 Jun 2023 13:56:09 +0200
Date:   Wed, 21 Jun 2023 13:56:08 +0200
From:   Lars Wendler <polynomial-c@gmx.de>
To:     Holger =?UTF-8?B?SG9mZnN0w6R0dGU=?= 
        <holger@applied-asynchrony.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] po/de.po: Fix possible typo which makes gettext-0.22
 unhappy
Message-ID: <20230621135608.25db01bb@chagall.paradoxon.rec>
In-Reply-To: <a08995aa-2003-be8f-dab1-6d8ed6687e12@applied-asynchrony.com>
References: <20230621105520.17560-1-polynomial-c@gmx.de>
        <a08995aa-2003-be8f-dab1-6d8ed6687e12@applied-asynchrony.com>
Organization: privat
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pBx4D7vmN4PNKxCB5mNrq93Awwi6VDDz23RNtt525FcOu2k58Ps
 wZ2dEb7DIyf6DtUJsBLHCgzVQAUHNk3avyUOso/oR8YcN8NBbHpHMLZRnVzhfQO+0HREcp1
 mW2JpjX14po4C7c23PlD1fWJLZaESPudJ0YZNnbWu4ebUmBbi4nD0i35fLRHJufHiRD4+j4
 UfKqF0riEERo8fikpKx3w==
UI-OutboundReport: notjunk:1;M01:P0:TgL0EQ8+pE4=;drIHTmqX276Mi5oNzv9tKqblNji
 hZxqpzxzG2JfvHOFsqPc0dfFfbTsrS0Qu3yFVOmjdA/YyFkA9gwFg7NevVojjlA9+AIHXhUN3
 USl04fD4vJYCdv7xJ/13jHxj/9q3iELWtkEMoRi5i6suxRauoWizzVYdjaJTouzkAuDtDCCp8
 f5YLYaFeDhD4sSQrdy5Fjri0DkU88Y9Uvu1Z3Iwn23CHzH1aWrB3B8aU6f/MK8lHKtWFJrOKK
 WqOnTYElhS41ECpdzhfc5/Xl950T9H8Dgn9P6DVnlXYJCMdpheBzEyrEAVaT4IMUMb/Q9IFxh
 ktLxLRcm83xynPETfRce5oAVzSArqU0dbQOvA8SY3tXXM3gmnBvVKDKswC+BZi7y1us5g6mWM
 8f3s6voowt7KL/iLqCg7o0nrxXSsLupemLH2k1x36tgYtVV4nYFnCtMIZQ7Wza+jOH911qiOk
 9u4KtfrXVoLEHEaRTF0UHlSUvcmZPr5eQnLkm7/9TSF9TuQaatrENrNJao+aGdXl6Ne9XPbVC
 hKTQXcoSzbvGpKoPvc93oLPCaD0G4jqGVyaVGv282NzDlNAxieJOeYS/gwH2zI6qlA85LDmxy
 YeTVKzDCMWphTeAE0bGhd49hk7X0EJMuDQGUojFRjvfONw2mL4JYvOq5F4+fbzYPfwGGzJWGy
 K5Xcy+hj8i39voA5Q2lLUugUqV7iBd5YjuKjhU7cirvi4kMGfVHXczowPHinoyt8euSQcTR5G
 Aghz6bX5aOCEurJD98fYzDtG+zO1JGfY7gwzwQem5bYVJ1UobUd4cu/GAUM7WWGrmalvB8F1k
 9FJFvq8AtM2L2fCAUlHEVGJbU00lI5BtNCelVOg6gX/kM2iNVxmC4krys42KOYWt7dFCDH5h4
 kZNBU4aYvDRhN/uqrNNOmJBaC83Rjzat+1TVaPO/RwQsAduOasCieySUVhkxlip6vbrMOMVZV
 hGjqExSqj05Z70itKb3TNwcZydc=
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Am Wed, 21 Jun 2023 13:29:03 +0200
schrieb Holger Hoffst=C3=A4tte <holger@applied-asynchrony.com>:

> On 2023-06-21 12:55, Lars Wendler wrote:
> > diff --git a/po/de.po b/po/de.po
> > index 944b0e91..a6f8fde1 100644
> > --- a/po/de.po
> > +++ b/po/de.po
> > @@ -3084,7 +3084,7 @@ msgstr "%llu Spezialdateien\n"
> >   #: .././estimate/xfs_estimate.c:191
> >   #, c-format
> >   msgid "%s will take about %.1f megabytes\n"
> > -msgstr "%s wird etwa %.lf Megabytes einnehmen\n"
> > +msgstr "%s wird etwa %.1f Megabytes einnehmen\n"
>=20
> I don't see the difference..?
> Both the added and removed line are the same.
>=20
> -h

I suppose depending on the font, it's quite hard to distinguish the two
lines.
The removed line contains "%.lf" with a lowercase letter L.
The added line contains "%.1f" where the lowercase letter L was replaced
with the digit 1.

Cheers
Lars
