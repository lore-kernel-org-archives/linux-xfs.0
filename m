Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:44269 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750767AbeBZIUa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 03:20:30 -0500
Subject: Re: [RFC PATCH] fstests: Check if a fs can survive random (emulated)
 power loss
References: <20180226073111.3066-1-wqu@suse.com>
 <CAOQ4uxhsvGVH19HZE6b1exnFt3pB6qwLr=PUkjpXeq12F9sNJQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a127175a-50bc-e2e2-9426-02d5d25a4b10@gmx.com>
Date: Mon, 26 Feb 2018 16:20:14 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhsvGVH19HZE6b1exnFt3pB6qwLr=PUkjpXeq12F9sNJQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bqnMEH11SO8OfydVCMdJH4bh1RIJ6lcgl"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Qu Wenruo <wqu@suse.com>
Cc: fstests <fstests@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bqnMEH11SO8OfydVCMdJH4bh1RIJ6lcgl
Content-Type: multipart/mixed; boundary="wmBuEmMbsaYgAsHqPNJmEfrwTaiwpUOwc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Amir Goldstein <amir73il@gmail.com>, Qu Wenruo <wqu@suse.com>
Cc: fstests <fstests@vger.kernel.org>,
 Linux Btrfs <linux-btrfs@vger.kernel.org>,
 linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>,
 Josef Bacik <josef@toxicpanda.com>
Message-ID: <a127175a-50bc-e2e2-9426-02d5d25a4b10@gmx.com>
Subject: Re: [RFC PATCH] fstests: Check if a fs can survive random (emulated)
 power loss
References: <20180226073111.3066-1-wqu@suse.com>
 <CAOQ4uxhsvGVH19HZE6b1exnFt3pB6qwLr=PUkjpXeq12F9sNJQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxhsvGVH19HZE6b1exnFt3pB6qwLr=PUkjpXeq12F9sNJQ@mail.gmail.com>

--wmBuEmMbsaYgAsHqPNJmEfrwTaiwpUOwc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8826=E6=97=A5 16:15, Amir Goldstein wrote:
> On Mon, Feb 26, 2018 at 9:31 AM, Qu Wenruo <wqu@suse.com> wrote:
>> This test case is originally designed to expose unexpected corruption
>> for btrfs, where there are several reports about btrfs serious metadat=
a
>> corruption after power loss.
>>
>> The test case itself will trigger heavy fsstress for the fs, and use
>> dm-flakey to emulate power loss by dropping all later writes.
>>
>=20
> Come on... dm-flakey is so 2016
> You should take Josef's fsstress+log-writes test and bring it to fstest=
s:
> https://github.com/josefbacik/log-writes
>=20
> By doing that you will gain two very important features from the test:
>=20
> 1. Problems will be discovered much faster, because the test can run fs=
ck
>     after every single block write has been replayed instead of just at=
 random
>     times like in your test

That's what exactly I want!!!

Great thanks for this one! I would definitely look into this.
(Although the initial commit is even older than 2016)


But the test itself could already expose something on EXT4, it still
makes some sense for ext4 developers as a verification test case.

Thanks,
Qu

>=20
> 2. Absolute guaranty to reproducing the problem by replaying the write =
log.
>     Even though your fsstress could use a pre-defined random seed to re=
sults
>     will be far from reproduciable, because of process and IO schedulin=
g
>     differences between subsequent test runs.
>     When you catch an inconsistency with log-writes test, you can send =
the
>     write-log recording to the maintainer to analyze the problem, even =
if it is
>     a hard problem to hit. I used that useful technique for ext4,btrfs,=
xfs when
>     ran tests with generic/455 and found problems.
>=20
> Cheers,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--wmBuEmMbsaYgAsHqPNJmEfrwTaiwpUOwc--

--bqnMEH11SO8OfydVCMdJH4bh1RIJ6lcgl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqTwz8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg/RQf+LE3S/HqMJuSAnRDqtqcnyTmY
avJewbqN7k4K4QqrPVCdKfc/VVS0L8QI1aSRQ3yFz5sW3EPGjihAz9gEhocY0XM7
b1EtiAD72Rhik4aLVLOCRXjPPw5qMqtkYOx7m22SPT0b0rPH/Z5I5l2zNwk5HRVs
fQXBFfmQ9DXeCq5dzKPQIO2f5sBAuSRsJbiBdRIXRJ921zR6qHHwR1Sv9OsP07W8
WQYqpKaqLbVg4q2HRi+vDXgjVDXOfds7PmGe2KeGeX/8WAMwt2adRZjTo1q1jj+m
y1Rs1jPROJU8tfxe2b0GtL8wsbb6hTtQ4Oo+05YCDWqcdOSPLPmrBoedIAPsog==
=uqaB
-----END PGP SIGNATURE-----

--bqnMEH11SO8OfydVCMdJH4bh1RIJ6lcgl--
