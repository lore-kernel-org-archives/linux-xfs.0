Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582CFC35647
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 13:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 360A124650
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 13:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgBUNBe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 08:01:34 -0500
Received: from mail1.g1.pair.com ([66.39.3.162]:23390 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbgBUNBe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Feb 2020 08:01:34 -0500
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Feb 2020 08:01:34 EST
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 150735474C1;
        Fri, 21 Feb 2020 07:53:15 -0500 (EST)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 3F67160AF3F;
        Fri, 21 Feb 2020 07:53:14 -0500 (EST)
Date:   Fri, 21 Feb 2020 13:52:59 +0100
From:   Emmanuel Florac <eflorac@intellique.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>
Subject: Re: Modern uses of CONFIG_XFS_RT
Message-ID: <20200221135259.0dc80197@harpe.intellique.com>
In-Reply-To: <20200221121509.GA2053@bfoster>
References: <20200219135715.GZ30113@42.do-not-panic.com>
        <20200220034106.GO10776@dread.disaster.area>
        <20200220142520.GF48977@bfoster>
        <20200220220652.GP10776@dread.disaster.area>
        <20200221121509.GA2053@bfoster>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/RiWxLGnVxcWh43eu7FqS18+"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/RiWxLGnVxcWh43eu7FqS18+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 21 Feb 2020 07:15:09 -0500
Brian Foster <bfoster@redhat.com> =C3=A9crivait:

> > There are almost always downstream modifications in private cloud
> > storage kernels, even if it is just bug fixes. They aren't shipping
> > the code to anyone, so they don't have to publish those changes.
> > However, the presence of downstream changes doesn't mean the
> > upstreram functionality should be considered unused and can be
> > removed....
> >  =20
>=20
> Well that's not what I said. ;P I'm pointing out that as of right now
> this is a downstream only use case. I know there was upstream
> communication and patches posted, etc., but that was a while ago and
> it wasn't clear to me if there was still intent to get things merged
> upstream. If not, then the only real outcome here for anybody outside
> of FB is bitrot.

Maybe, maybe not. Storage tiering is a pretty hot subject, simply
shedding some light on this capability may give it more use. I didn't
know of any actual use case for RT in XFS since IRIX times, but if
there's a way to use it for tiering, this is indeed a very promising
area of development for me (and no doubt many others).

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/RiWxLGnVxcWh43eu7FqS18+
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAl5P0r0ACgkQX3jQXNUicVYZMACfaYr0xKbiLJHKEN9CTx1M6mcU
HuAAnR/8cBSMo6+4qxC2n5lx/Jbl2Lda
=E4ba
-----END PGP SIGNATURE-----

--Sig_/RiWxLGnVxcWh43eu7FqS18+--
