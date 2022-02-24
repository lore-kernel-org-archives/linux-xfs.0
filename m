Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B59C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 12:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiBXMKZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 07:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiBXMKY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 07:10:24 -0500
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAB215F35E
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 04:09:53 -0800 (PST)
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id B64EA54755D;
        Thu, 24 Feb 2022 07:09:52 -0500 (EST)
Received: from harpe.intellique.com (unknown [195.135.69.188])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 0D6CC60AEBC;
        Thu, 24 Feb 2022 07:09:51 -0500 (EST)
Date:   Thu, 24 Feb 2022 13:09:53 +0100
From:   Emmanuel Florac <eflorac@intellique.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: experience with very large filesystems
Message-ID: <20220224130953.4906c7e3@harpe.intellique.com>
In-Reply-To: <20220223211006.GL59715@dread.disaster.area>
References: <20220223163513.43f1f054@harpe.intellique.com>
        <20220223211006.GL59715@dread.disaster.area>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/DHQwAIqUr41EbH5jggHAisG"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/DHQwAIqUr41EbH5jggHAisG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 24 Feb 2022 08:10:06 +1100
Dave Chinner <david@fromorbit.com> =C3=A9crivait:

> From the storage side, you really want to expand the storage with
> chunks that have the same geometry (stripe unit and stripe width)
> so that it doesn't screw up the alignment of the filesystem to the
> new storage.

That part should be easy, I plan to use the same type of hardware anyway
(12 TB Ultrastar disks).
=20
> And that's where the difficultly may lie. If the existing storage
> volume the filesystem sits on doesn't end exactly on a stripe width
> boundary, you're going to have to offset the start of the new
> storage volumes part way into the first stripe width in the volumes
> to ensure that when the filesystem expands, then end of the first
> stripe width in the new volume is exactly where the filesystem
> expects it to be.

That should be somewhat more manageable given that I've setup
everything as an LVM volume. I may use partitions on the new devices to
precisely align the PVs before expanding the LV.=20

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/DHQwAIqUr41EbH5jggHAisG
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAmIXdZEACgkQX3jQXNUicVb38ACfZJ4uNp/hqyjYIBt0XOXVnKIO
2RMAn0BfTByXeZgWUbbZv5dCwyfkb1W3
=oj5j
-----END PGP SIGNATURE-----

--Sig_/DHQwAIqUr41EbH5jggHAisG--
