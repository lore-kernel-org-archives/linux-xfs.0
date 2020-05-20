Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C35C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 13:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E41D52070A
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 13:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgETNZn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 09:25:43 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:27337 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgETNZn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 09:25:43 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2020 09:25:42 EDT
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id DDC5B5474F2;
        Wed, 20 May 2020 09:15:43 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 3DDD460AF66;
        Wed, 20 May 2020 09:15:43 -0400 (EDT)
Date:   Wed, 20 May 2020 15:15:10 +0200
From:   Emmanuel Florac <eflorac@intellique.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [XFS SUMMIT] Deprecating V4 on-disk format
Message-ID: <20200520151510.11837539@harpe.intellique.com>
In-Reply-To: <20200520011430.GS2040@dread.disaster.area>
References: <20200513023618.GA2040@dread.disaster.area>
        <20200519062338.GH17627@magnolia>
        <20200520011430.GS2040@dread.disaster.area>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/YlkVLxS1SmA8SbScWsco5Zy"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/YlkVLxS1SmA8SbScWsco5Zy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Wed, 20 May 2020 11:14:30 +1000
Dave Chinner <david@fromorbit.com> =C3=A9crivait:

> Well, there's a difference between what a distro that heavily
> patches the upstream kernel is willing to support and what upstream
> supports. And, realistically, v4 is going to be around for at least
> one more major distro release, which means the distro support time
> window is still going to be in the order of 15 years.

IIRC, RedHat/CentOS v.7.x shipped with a v5-capable mkfs.xfs, but
defaulted to v4. That means that unless you were extremely cautious
(like I am :) 99% of RH/COs v7 will be running v4 volumes for the
coming years. How many years, would you ask?

As for the lifecycle of a filesystem, I just ended support on a 40 TB
archival server I set up back in 2007. I still have a number of
supported systems from the years 2008-2010, and about a hundred from
2010-2013. That's how reliable XFS is, unfortunately :)

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/YlkVLxS1SmA8SbScWsco5Zy
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAl7FLYEACgkQX3jQXNUicVaBbQCfSyaq1x3lkUeFY1HmzHWBUT/R
O5oAoMMW46Fx2uMKrEjX8E3/5XuqD22e
=Wm9K
-----END PGP SIGNATURE-----

--Sig_/YlkVLxS1SmA8SbScWsco5Zy--
