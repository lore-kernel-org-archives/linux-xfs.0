Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout02-q02.e.movistar.es ([86.109.101.152]:52195 "EHLO
        relayout02-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753036AbdIDAFJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 20:05:09 -0400
Received: from relayout02-redir.e.movistar.es (unknown [86.109.101.202])
        by relayout02-out.e.movistar.es (Postfix) with ESMTP id 3xlqq732nrzhYHL
        for <linux-xfs@vger.kernel.org>; Mon,  4 Sep 2017 02:05:07 +0200 (CEST)
Received: from Telcontar.valinor (240.red-83-33-32.dynamicip.rima-tde.net [83.33.32.240])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2)
        by relayout02.e.movistar.es (Postfix) with ESMTPSA id 3xlqq608N5zdZrg
        for <linux-xfs@vger.kernel.org>; Mon,  4 Sep 2017 02:05:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id DE08112091F
        for <linux-xfs@vger.kernel.org>; Mon,  4 Sep 2017 02:05:02 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id aNr_Ne08TZKi for <linux-xfs@vger.kernel.org>;
        Mon,  4 Sep 2017 02:05:02 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 4E54C120901
        for <linux-xfs@vger.kernel.org>; Mon,  4 Sep 2017 02:05:02 +0200 (CEST)
Subject: Re: error: "Your hard drive is failing" ???
References: <7f2b8d9d-3748-0ce1-7e88-76409e8717cb@zoho.com>
 <b699dac3-321a-9029-87cb-2b5ced17ddd1@sandeen.net>
 <4b74027e-34ee-d365-e454-d3a0f524c408@zoho.com>
 <b2a570b1-d062-b880-5371-33c454fac70f@telefonica.net>
 <11db60f4-746c-ea37-96e3-90c43ebc1b2c@zoho.com>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <ca6c56aa-87e0-f55b-39ea-8a3173abfa72@telefonica.net>
Date: Mon, 4 Sep 2017 02:05:01 +0200
MIME-Version: 1.0
In-Reply-To: <11db60f4-746c-ea37-96e3-90c43ebc1b2c@zoho.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="cJPEjRhD082oWl2leuRCj6L1FNIPoFcDi"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cJPEjRhD082oWl2leuRCj6L1FNIPoFcDi
Content-Type: multipart/mixed; boundary="HAUxRISF8KRDMr07PITRqDPhqjCoJxRbN";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <ca6c56aa-87e0-f55b-39ea-8a3173abfa72@telefonica.net>
Subject: Re: error: "Your hard drive is failing" ???
References: <7f2b8d9d-3748-0ce1-7e88-76409e8717cb@zoho.com>
 <b699dac3-321a-9029-87cb-2b5ced17ddd1@sandeen.net>
 <4b74027e-34ee-d365-e454-d3a0f524c408@zoho.com>
 <b2a570b1-d062-b880-5371-33c454fac70f@telefonica.net>
 <11db60f4-746c-ea37-96e3-90c43ebc1b2c@zoho.com>
In-Reply-To: <11db60f4-746c-ea37-96e3-90c43ebc1b2c@zoho.com>

--HAUxRISF8KRDMr07PITRqDPhqjCoJxRbN
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 2017-09-04 01:59, ToddAndMargo wrote:
> On 09/03/2017 05:32 AM, Carlos E. R. wrote:
>> On 2017-09-03 05:18, ToddAndMargo wrote:


>>> Then I am just going to ignore it then.
>>
>> smartctl daemon may not be aware that you swapped a disk and be
>> confused. You may have to restart it.
>>
>=20
> Hi Carlos,
>=20
> I am not finding a smartctl daemon running.  Is it
> known by another name?
>=20
> # systemctl status smartctld
> Unit smartctld.service could not be found.

Telcontar:~ # systemctl status smartd.service=20
=E2=97=8F smartd.service - Self Monitoring and Reporting Technology (SMAR=
T) Daemon
   Loaded: loaded (/usr/lib/systemd/system/smartd.service; enabled; vendo=
r preset: enabled)
   Active: active (running) since Thu 2017-08-17 04:13:21 CEST; 2 weeks 3=
 days ago
     Docs: man:smartd(8)
           man:smartd.conf(5)
 Main PID: 1588 (smartd)
    Tasks: 1 (limit: 512)
   CGroup: /system.slice/smartd.service
           =E2=94=94=E2=94=801588 /usr/sbin/smartd -n


> And can I just do a "systemctl restart xxx" on it?  Or will
> it just confuse the issue.

I would try a reload first, it works here (openSUSE).

--=20
Cheers / Saludos,

		Carlos E. R.
		(from 42.2 x86_64 "Malachite" at Telcontar)


--HAUxRISF8KRDMr07PITRqDPhqjCoJxRbN--

--cJPEjRhD082oWl2leuRCj6L1FNIPoFcDi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlmsmK0ACgkQtTMYHG2NR9VJdACgj1RD/CUXjAn3wl9Th+tS19Cm
RfUAnjuw2WlcNuVhnISCFO0oQ3potqCo
=wi97
-----END PGP SIGNATURE-----

--cJPEjRhD082oWl2leuRCj6L1FNIPoFcDi--
