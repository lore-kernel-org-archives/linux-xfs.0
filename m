Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F147FA372A
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 19:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16A9C222BE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 19:08:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Y8TvENLa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436638AbfJPTIw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 15:08:52 -0400
Received: from mout.gmx.net ([212.227.17.21]:57093 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730057AbfJPTIw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Oct 2019 15:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1571252931;
        bh=VUV7qWtLkRGfbCxKGo9szoBT7k7BIlRt4JeDVGJ+YdU=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=Y8TvENLa4uza4h+xYouEP6fePh3pRZqDBPNItjgy1YuULPyM+WNKLr/h4mIWrkVpf
         R5oVrVO+Oce/6mcAEbSZAqr6Wep7ev8EOyx8N2i594kXyU3lcEkFrDI+kXU90pD1bn
         MOlLldpInz0XqHbT/cV2nef6oMa5vapw06t9gz4M=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [2.50.152.200] ([2.50.152.200]) by web-mail.gmx.net
 (3c-app-gmx-bs59.server.lan [172.19.170.143]) (via HTTP); Wed, 16 Oct 2019
 21:08:51 +0200
MIME-Version: 1.0
Message-ID: <trinity-92785614-c99b-4de9-98e8-71be71c0df0d-1571252931141@3c-app-gmx-bs59>
From:   =?UTF-8?Q?=22Marc_Sch=C3=B6nefeld=22?= <marc.schoenefeld@gmx.org>
To:     linux-xfs@vger.kernel.org
Subject: Sanity check for m_ialloc_blks in libxfs_mount()
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 16 Oct 2019 21:08:51 +0200
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: quoted-printable
X-Priority: 3
X-Provags-ID: V03:K1:UE06zkszPMk7n+l/guBzLrcI5UcVQ0K8TBQVBSS8B1DYNDcpSfVNVQpqq4HAxAi0eayq7
 9AFte8pvUwxIBgg1BmlNDGRulZT14ZQT8zxyjDWGRhq+SCNgwknZJPfyVT2j5R5/owB7LVZfpEsn
 AHSJk9X4ZFUejOxswf10VVYlOhaVDZ3EDtVYvDTJxjo+49z6FcIV7ADjVoB5EoF9BT1XNMm3wV1Z
 3qUoGOVhmzZpi0VYWdsw8PbPOLVN02bg72g11JCQLD+Nhkk2fJZPOAozywBURNfipBOd+Ly02LqR
 G4=
X-UI-Out-Filterresults: notjunk:1;V03:K0:+jc44KPO7kA=:W/orDBDWYLGHF+hfqE/e8T
 PkW8k2fnYP748H56Rq/Tbod95joshB9hVhD9Hpu5HmAp5cUbyPHYUvQfKXhTpVphN28v3qsMI
 aYYE6GU0Ab46KBQF+Nt6ax3c9+ih2Tc/OiZGfLxYgAfPoeqFiy/wOegYkm9dhwGqRt3pQBzS8
 dFLD4OHONBK1vP+Z9jQMdvvb5nU3q9xvOpEfOS6AZmMsC1iMbUG6Y5FE5qPLFtXCfa2yJZX1m
 RD2vpVn0IruL/tO8kRWrrUWJYeWXt02PdNSbIa5xkJ2R48KreUGFF6/NM/KRvcdR/1k9Y/NEu
 jJf8/ekOR34UKvrX2GRO2fvCzWWxwzvepwgJYV55AZEhPgAhmVdCBFZ7pMV5JMEkh/uCqDMph
 eBiMPlHohXpX6R55HZwO5BMMsyxO0Gv297u8C0YbNwR6kpIG1K5Z+vsY0h24GtvTIOddqJdvK
 UdRu7OMPpwoB5mQvAXsTMUHAxqIWlXFAgFDB1IdNfUh5113rnwS1nxye6TNjgURQzC1vXEKM8
 KKyXdyaE6H4BRICulMYbcaGCQUvmRmKLLKl4dKSVeBSMZWbUeWQMZvcLGCn1jRCu7dIFANuk3
 +G+ze2n5yv0EyQ7vQWsrGnFZk/SI9OQpFFBB8tx9lcisHcKBCpun7h+0SNroOOgjuPEw0cPxA
 pQw6Bv/3q1EFYG2Hw0n229EaPATNMosnJnfyOQI8wZjMCbLImnnexNyyXydt9PNc/rHs=
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,=C2=A0

it looks like there is a sanity check missing for the divisor (m_ialloc_bl=
ks) in line 664 of xfsprogs-5=2E2=2E1/libxfs/init=2Ec:=C2=A0
Program received signal SIGFPE, Arithmetic exception=2E

0x0000000000427ddf in libxfs_mount (mp=3Dmp@entry=3D0x6a2de0 <xmount>, sb=
=3Dsb@entry=3D0x6a2de0 <xmount>, dev=3D18446744073709551615,=C2=A0
=C2=A0 =C2=A0 logdev=3D<optimized out>, rtdev=3D<optimized out>, flags=3Df=
lags@entry=3D1) at init=2Ec:663

which is=C2=A0

=C2=A0 =C2=A0 663 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
mp->m_maxicount =3D XFS_FSB_TO_INO(mp,
=C2=A0 =C2=A0 664 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (mp->m_maxicount / =
mp->m_ialloc_blks) *
=C2=A0 =C2=A0 665=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mp->m_ialloc=
_blks);

In case it would be required I=C2=A0have a reproducer file for this, which=
 I can share via pm=2E The bug is reachable from user input via the "xfs_db=
 -c _cmd_=C2=A0_xfsfile_" command=2E=C2=A0=C2=A0=C2=A0

Sincerely
Marc Schoenefeld=C2=A0
=C2=A0

