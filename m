Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout03-q02.e.movistar.es ([86.109.101.162]:33273 "EHLO
        relayout03-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751934AbdICMcl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 08:32:41 -0400
Received: from relayout03-redir.e.movistar.es (unknown [86.109.101.203])
        by relayout03-out.e.movistar.es (Postfix) with ESMTP id 3xlXS81fq0zQkvk
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2017 14:32:40 +0200 (CEST)
Received: from Telcontar.valinor (130.red-79-146-117.dynamicip.rima-tde.net [79.146.117.130])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2)
        by relayout03.e.movistar.es (Postfix) with ESMTPSA id 3xlXS800vZzMlmd
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2017 14:32:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 6D77912094D
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2017 14:32:37 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Mnz9fHwHvIvc for <linux-xfs@vger.kernel.org>;
        Sun,  3 Sep 2017 14:32:37 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 48CDC120946
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2017 14:32:37 +0200 (CEST)
Subject: Re: error: "Your hard drive is failing" ???
References: <7f2b8d9d-3748-0ce1-7e88-76409e8717cb@zoho.com>
 <b699dac3-321a-9029-87cb-2b5ced17ddd1@sandeen.net>
 <4b74027e-34ee-d365-e454-d3a0f524c408@zoho.com>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <b2a570b1-d062-b880-5371-33c454fac70f@telefonica.net>
Date: Sun, 3 Sep 2017 14:32:29 +0200
MIME-Version: 1.0
In-Reply-To: <4b74027e-34ee-d365-e454-d3a0f524c408@zoho.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="mQ5Xa7wSc2T0qtNV5jquE2jLDdNmXMX9T"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mQ5Xa7wSc2T0qtNV5jquE2jLDdNmXMX9T
Content-Type: multipart/mixed; boundary="Um5BrGcQnPrAGrlrMjeiQ7GU0nI7QSgVV";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <b2a570b1-d062-b880-5371-33c454fac70f@telefonica.net>
Subject: Re: error: "Your hard drive is failing" ???
References: <7f2b8d9d-3748-0ce1-7e88-76409e8717cb@zoho.com>
 <b699dac3-321a-9029-87cb-2b5ced17ddd1@sandeen.net>
 <4b74027e-34ee-d365-e454-d3a0f524c408@zoho.com>
In-Reply-To: <4b74027e-34ee-d365-e454-d3a0f524c408@zoho.com>

--Um5BrGcQnPrAGrlrMjeiQ7GU0nI7QSgVV
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 2017-09-03 05:18, ToddAndMargo wrote:
> On 09/02/2017 08:08 PM, Eric Sandeen wrote:
>> On 9/2/17 9:48 PM, ToddAndMargo wrote:
>>> Dear Xfs,
>>>
>>> Scientific Linux 7.3
>>>
>>> $ rpm -qa \*xfsdump\*
>>> xfsdump-3.1.4-1.el7.x86_64
>>>
>>> When I do a backup to /dev/sda1 (/lin-bak), I get told
>>>
>>>      WARNING: Your hard drive is failing
>>>      Device: /dev/sda [SAT], unable to open device
>>
>> That's a message from smartctl, it has nothing to do with
>> xfs or xfsdump.  It's probably related to your creative use
>> of hotplug.

> Then I am just going to ignore it then.

smartctl daemon may not be aware that you swapped a disk and be
confused. You may have to restart it.

--=20
Cheers / Saludos,

		Carlos E. R.
		(from 42.2 x86_64 "Malachite" at Telcontar)


--Um5BrGcQnPrAGrlrMjeiQ7GU0nI7QSgVV--

--mQ5Xa7wSc2T0qtNV5jquE2jLDdNmXMX9T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlmr9mUACgkQtTMYHG2NR9UzXgCeLz1/zt2pJjOWtEytUg4D3ag9
hsIAn36n2+PpazT2fzdJ0RwG768q58Pz
=A+uD
-----END PGP SIGNATURE-----

--mQ5Xa7wSc2T0qtNV5jquE2jLDdNmXMX9T--
