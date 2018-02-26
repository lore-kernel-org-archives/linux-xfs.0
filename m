Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:38639 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751589AbeBZImH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 03:42:07 -0500
Subject: Re: [RFC PATCH] fstests: Check if a fs can survive random (emulated)
 power loss
References: <20180226073111.3066-1-wqu@suse.com>
 <CAOQ4uxhsvGVH19HZE6b1exnFt3pB6qwLr=PUkjpXeq12F9sNJQ@mail.gmail.com>
 <a127175a-50bc-e2e2-9426-02d5d25a4b10@gmx.com>
 <CAOQ4uxhXmoaJbJVCUk-9VXipTxuYhmTHAh89bWZ1xrWUUd76GA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5c46dfaa-296e-4882-5205-13a2a6739d79@gmx.com>
Date: Mon, 26 Feb 2018 16:41:54 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhXmoaJbJVCUk-9VXipTxuYhmTHAh89bWZ1xrWUUd76GA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="94VehvaGlNxMbLsamsWM3M0IQI0UgfVYK"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>, fstests <fstests@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--94VehvaGlNxMbLsamsWM3M0IQI0UgfVYK
Content-Type: multipart/mixed; boundary="CTvUTObFZBznI2jHZW8sxGi6qrNaH2Zbg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>, fstests <fstests@vger.kernel.org>,
 Linux Btrfs <linux-btrfs@vger.kernel.org>,
 linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>,
 Josef Bacik <josef@toxicpanda.com>
Message-ID: <5c46dfaa-296e-4882-5205-13a2a6739d79@gmx.com>
Subject: Re: [RFC PATCH] fstests: Check if a fs can survive random (emulated)
 power loss
References: <20180226073111.3066-1-wqu@suse.com>
 <CAOQ4uxhsvGVH19HZE6b1exnFt3pB6qwLr=PUkjpXeq12F9sNJQ@mail.gmail.com>
 <a127175a-50bc-e2e2-9426-02d5d25a4b10@gmx.com>
 <CAOQ4uxhXmoaJbJVCUk-9VXipTxuYhmTHAh89bWZ1xrWUUd76GA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhXmoaJbJVCUk-9VXipTxuYhmTHAh89bWZ1xrWUUd76GA@mail.gmail.com>

--CTvUTObFZBznI2jHZW8sxGi6qrNaH2Zbg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8826=E6=97=A5 16:33, Amir Goldstein wrote:
> On Mon, Feb 26, 2018 at 10:20 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>>
>>
>> On 2018=E5=B9=B402=E6=9C=8826=E6=97=A5 16:15, Amir Goldstein wrote:
>>> On Mon, Feb 26, 2018 at 9:31 AM, Qu Wenruo <wqu@suse.com> wrote:
>>>> This test case is originally designed to expose unexpected corruptio=
n
>>>> for btrfs, where there are several reports about btrfs serious metad=
ata
>>>> corruption after power loss.
>>>>
>>>> The test case itself will trigger heavy fsstress for the fs, and use=

>>>> dm-flakey to emulate power loss by dropping all later writes.
>>>>
>>>
>>> Come on... dm-flakey is so 2016
>>> You should take Josef's fsstress+log-writes test and bring it to fste=
sts:
>>> https://github.com/josefbacik/log-writes
>>>
>>> By doing that you will gain two very important features from the test=
:
>>>
>>> 1. Problems will be discovered much faster, because the test can run =
fsck
>>>     after every single block write has been replayed instead of just =
at random
>>>     times like in your test
>>
>> That's what exactly I want!!!
>>
>> Great thanks for this one! I would definitely look into this.
>> (Although the initial commit is even older than 2016)
>>
>=20
> Please note that Josef's replay-individual-faster.sh script runs fsck
> every 1000 writes (i.e. --check 1000), so you can play with this argume=
nt
> in your test. Can also run --fsck every --check fua or --check flush, w=
hich
> may be more indicative of real world problems. not sure.
>=20
>>
>> But the test itself could already expose something on EXT4, it still
>> makes some sense for ext4 developers as a verification test case.
>>
>=20
> Please take a look at generic/456
> When generic/455 found a reproduciable problem in ext4,
> I created a specific test without any randomness to pin point the
> problem found (using dm-flakey).
> If the problem you found is reproduciable, then it will be easy for you=

> to create a similar "bisected" test.

Yep, it's definitely needed for a pin-point test case, but I'm also
wondering if a random, stress test could also help.

Test case with plain fsstress is already super helpful to expose some
bugs, such stress test won't hurt.

Thanks,
Qu
>=20
> Thanks,
> Amir.
>=20


--CTvUTObFZBznI2jHZW8sxGi6qrNaH2Zbg--

--94VehvaGlNxMbLsamsWM3M0IQI0UgfVYK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqTyFIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qissAf+L67x3QnN0/wGWcoammxRfW1E
ku5NKDHY6v9U9ooYeRBxN4vdekuRCHTJ6sRIuLS8B8JXCbECwkg2By5Ymfx6Yn5N
oD9WJfxFrVIp54LF37e8QCkYhn7n268jIqO06WcTWYzjN2oTsFHYvzTIpnSHdSV9
Zx93tTPOoAyRVrNa0tsfQIJameYXbOWfyuhpc7XuZJ0UttX2ISd9WxKR0sdDczTk
McqydLg4Cr5+BYyh2/SYmN8KusTW3RMb9BlH0IYlMugRAt7PK509T7/W118+W3um
YXw0lp6BFijc6zmVVzONg2AHFcZPi/6coBCnn9xbTCao37ub0hG+vJNmt9TD3A==
=0La/
-----END PGP SIGNATURE-----

--94VehvaGlNxMbLsamsWM3M0IQI0UgfVYK--
