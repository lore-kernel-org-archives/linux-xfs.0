Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:41617 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbeBZIud (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 03:50:33 -0500
Subject: Re: [RFC PATCH] fstests: Check if a fs can survive random (emulated)
 power loss
References: <20180226073111.3066-1-wqu@suse.com>
 <CAOQ4uxhsvGVH19HZE6b1exnFt3pB6qwLr=PUkjpXeq12F9sNJQ@mail.gmail.com>
 <a127175a-50bc-e2e2-9426-02d5d25a4b10@gmx.com>
 <CAOQ4uxhXmoaJbJVCUk-9VXipTxuYhmTHAh89bWZ1xrWUUd76GA@mail.gmail.com>
 <5c46dfaa-296e-4882-5205-13a2a6739d79@gmx.com>
 <CAOQ4uxgJ=eKMLwQ05HcK6Rk2znx_Q5ujv77NFJr86ksXTC9Qtw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bea53ec3-1795-4744-97f8-ac86d133e166@gmx.com>
Date: Mon, 26 Feb 2018 16:50:20 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgJ=eKMLwQ05HcK6Rk2znx_Q5ujv77NFJr86ksXTC9Qtw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0N0bcH78MbpGxBsNx4ICfyA1HEgrofCKB"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>, fstests <fstests@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0N0bcH78MbpGxBsNx4ICfyA1HEgrofCKB
Content-Type: multipart/mixed; boundary="zUDk41nEsTwGyh66r10ot2xntowCI8LD2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>, fstests <fstests@vger.kernel.org>,
 Linux Btrfs <linux-btrfs@vger.kernel.org>,
 linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>,
 Josef Bacik <josef@toxicpanda.com>
Message-ID: <bea53ec3-1795-4744-97f8-ac86d133e166@gmx.com>
Subject: Re: [RFC PATCH] fstests: Check if a fs can survive random (emulated)
 power loss
References: <20180226073111.3066-1-wqu@suse.com>
 <CAOQ4uxhsvGVH19HZE6b1exnFt3pB6qwLr=PUkjpXeq12F9sNJQ@mail.gmail.com>
 <a127175a-50bc-e2e2-9426-02d5d25a4b10@gmx.com>
 <CAOQ4uxhXmoaJbJVCUk-9VXipTxuYhmTHAh89bWZ1xrWUUd76GA@mail.gmail.com>
 <5c46dfaa-296e-4882-5205-13a2a6739d79@gmx.com>
 <CAOQ4uxgJ=eKMLwQ05HcK6Rk2znx_Q5ujv77NFJr86ksXTC9Qtw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgJ=eKMLwQ05HcK6Rk2znx_Q5ujv77NFJr86ksXTC9Qtw@mail.gmail.com>

--zUDk41nEsTwGyh66r10ot2xntowCI8LD2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8826=E6=97=A5 16:45, Amir Goldstein wrote:
> On Mon, Feb 26, 2018 at 10:41 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>>
>>
>> On 2018=E5=B9=B402=E6=9C=8826=E6=97=A5 16:33, Amir Goldstein wrote:
>>> On Mon, Feb 26, 2018 at 10:20 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> =
wrote:
>>>>
>>>>
>>>> On 2018=E5=B9=B402=E6=9C=8826=E6=97=A5 16:15, Amir Goldstein wrote:
>>>>> On Mon, Feb 26, 2018 at 9:31 AM, Qu Wenruo <wqu@suse.com> wrote:
>>>>>> This test case is originally designed to expose unexpected corrupt=
ion
>>>>>> for btrfs, where there are several reports about btrfs serious met=
adata
>>>>>> corruption after power loss.
>>>>>>
>>>>>> The test case itself will trigger heavy fsstress for the fs, and u=
se
>>>>>> dm-flakey to emulate power loss by dropping all later writes.
>>>>>>
>>>>>
>>>>> Come on... dm-flakey is so 2016
>>>>> You should take Josef's fsstress+log-writes test and bring it to fs=
tests:
>>>>> https://github.com/josefbacik/log-writes
>>>>>
>>>>> By doing that you will gain two very important features from the te=
st:
>>>>>
>>>>> 1. Problems will be discovered much faster, because the test can ru=
n fsck
>>>>>     after every single block write has been replayed instead of jus=
t at random
>>>>>     times like in your test
>>>>
>>>> That's what exactly I want!!!
>>>>
>>>> Great thanks for this one! I would definitely look into this.
>>>> (Although the initial commit is even older than 2016)
>>>>
>>>
>>> Please note that Josef's replay-individual-faster.sh script runs fsck=

>>> every 1000 writes (i.e. --check 1000), so you can play with this argu=
ment
>>> in your test. Can also run --fsck every --check fua or --check flush,=
 which
>>> may be more indicative of real world problems. not sure.
>>>
>>>>
>>>> But the test itself could already expose something on EXT4, it still=

>>>> makes some sense for ext4 developers as a verification test case.
>>>>
>>>
>>> Please take a look at generic/456
>>> When generic/455 found a reproduciable problem in ext4,
>>> I created a specific test without any randomness to pin point the
>>> problem found (using dm-flakey).
>>> If the problem you found is reproduciable, then it will be easy for y=
ou
>>> to create a similar "bisected" test.
>>
>> Yep, it's definitely needed for a pin-point test case, but I'm also
>> wondering if a random, stress test could also help.
>>
>> Test case with plain fsstress is already super helpful to expose some
>> bugs, such stress test won't hurt.
>>
>=20
>=20
> Yes, but the same stress test with dm-log-writes instead of dm-flakey
> will be as useful and much more, so no reason to merge the less useful
> stress test.

OK, I'll try to use dm-log to enhance the test case.

Thanks,
Qu

>=20
> Thanks,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--zUDk41nEsTwGyh66r10ot2xntowCI8LD2--

--0N0bcH78MbpGxBsNx4ICfyA1HEgrofCKB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqTyk0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhbBAf+MUHb/RvTxDUOE5gvtVBni6+D
ntukB8iLQZPdJR+kPnspPAYD1BRVx1HSENQqnhjxhppr/FwfohJdOSpRMj7+cxmc
C6fRGXXqVO9pvRa1E1VvYtnEdB5n8sjBXzp1r6U1j7HO3fdQ+QnVkVyW6H8FGcBy
CKaVduJVHrbI4hoOy8obWHRDkqwT4Zexs+sBAllen8ieIEkXh5ONND36j4d30tPx
88mP97DDaDReRy4qbNC/hcH22jr3O0h+69RU4UAslkur72/RX0Q2f39qWd9ltPv7
2NSAC0zr3O5W4vwUFDn1eEOM+zObW9XyaA27uyNI2+5MDgPacvoDrgze6lXo1w==
=o/y0
-----END PGP SIGNATURE-----

--0N0bcH78MbpGxBsNx4ICfyA1HEgrofCKB--
