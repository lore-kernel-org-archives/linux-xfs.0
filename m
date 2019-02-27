Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54762 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725914AbfB0FBV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Feb 2019 00:01:21 -0500
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock
 filesystems
References: <20190226181407.44612-1-bfoster@redhat.com>
 <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190226232212.GD16436@dastard>
 <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>
 <ed870e00-1931-d7b1-a3ed-8a184889f6fc@gmx.com>
 <CAOQ4uxhNdzbSiPREmMtv5_81=7bxCRbTaa_KUN00g7De_j6a4Q@mail.gmail.com>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <1f5c2280-f4db-2c13-bf2b-f4dc4111613a@suse.de>
Date: Wed, 27 Feb 2019 13:01:09 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhNdzbSiPREmMtv5_81=7bxCRbTaa_KUN00g7De_j6a4Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dyLq0DsQThJuDmPrAhPa0GFnWq5tN3ZCT"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, Josef Bacik <josef@toxicpanda.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dyLq0DsQThJuDmPrAhPa0GFnWq5tN3ZCT
Content-Type: multipart/mixed; boundary="du2YZIcAwOiOTTr4PuJDd2aTA55WasN3H";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Amir Goldstein <amir73il@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>,
 Josef Bacik <josef@toxicpanda.com>, fstests <fstests@vger.kernel.org>,
 linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <1f5c2280-f4db-2c13-bf2b-f4dc4111613a@suse.de>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock
 filesystems
References: <20190226181407.44612-1-bfoster@redhat.com>
 <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190226232212.GD16436@dastard>
 <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>
 <ed870e00-1931-d7b1-a3ed-8a184889f6fc@gmx.com>
 <CAOQ4uxhNdzbSiPREmMtv5_81=7bxCRbTaa_KUN00g7De_j6a4Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxhNdzbSiPREmMtv5_81=7bxCRbTaa_KUN00g7De_j6a4Q@mail.gmail.com>

--du2YZIcAwOiOTTr4PuJDd2aTA55WasN3H
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/27 =E4=B8=8B=E5=8D=8812:49, Amir Goldstein wrote:
[snip]
>>> Indeed.
>>
>> May I ask a stupid question?
>>
>> How does it matter whether the device is clean or not?
>> Shouldn't the journal/metadata or whatever be self-contained?
>>
>=20
> Yes and no.
>=20
> The most simple example (not limited to xfs and not sure it is like tha=
t in xfs)
> is how you find the last valid journal commit entry. It should have cor=
rect CRC
> and the largest LSN. But it you replay IO on top of existing journal wi=
thout
> wiping it first, then journal recovery will continue past the point to =
meant to
> replay or worse.

The journal doesn't have some superblock like system to tell where to
stop replaying?

If not, then indeed we need to discard the journal before writing new one=
=2E

>=20
> The problem that Brian describes is more complicated than that and not
> limited to the data in the journal IIUC, but I think what I described a=
bove
> may plague also ext4 and xfs v4.
>=20
>>>
>>>> i.e. this sounds like a "block device we are replaying onto has
>>>> stale data in it" problem because we are replaying the same
>>>> filesystem over the top of itself.  Hence there are no unique
>>>> identifiers in the metadata that can detect stale metadata in
>>>> the block device.
>>>>
>>>> I'm surprised that we haven't tripped over this much earlier that
>>>> this...
>>>>
>>>
>>> I remember asking myself the same thing... it's coming back to me
>>> now. I really remember having this discussion during test review.
>>> generic/482 is an adaptation of Josef's test script [1], which
>>> does log recovery onto a snapshot on every FUA checkpoint.
>>>
>>> [1] https://github.com/josefbacik/log-writes/blob/master/replay-fsck-=
wrapper.sh
>>>
>>> Setting up snapshots for every checkpoint was found empirically to ta=
ke
>>> more test runtime, than replaying log from the start for each checkpo=
int.
>>> That observation was limited to the systems that Qu and Eryu tested o=
n.
>>>
>>> IRC, what usually took care of cleaning the block device is replaying=
 the
>>> "discard everything" IO from mkfs time.
>>
>> This "discard everything" assumption doesn't look right to me.
>> Although most mkfs would discard at least part of the device, even
>> without discarding the newly created fs should be self-contained, no
>> wild pointer points to some garbage.
>>
>=20
> It's true. We shouldn't make this assumption.
> That was my explanation to Dave's question, how come we didn't see
> this before?
>=20
> Here is my log-writes info from generic/482:
> ./src/log-writes/replay-log -vv --find --end-mark mkfs --log
> $LOGWRITES_DEV |grep DISCARD
> seek entry 0@2: 0, size 8388607, flags 0x4(DISCARD)
> seek entry 1@3: 8388607, size 8388607, flags 0x4(DISCARD)
> seek entry 2@4: 16777214, size 4194306, flags 0x4(DISCARD)
>=20
>> I though all metadata/journal write should be self-contained even for
>> later fs writes.
>>
>> Am I missing something? Or do I get too poisoned by btrfs CoW?
>>
>=20
> I'd be very surprised if btrfs cannot be flipped by seeing stale data "=
from
> the future" in the block device. Seems to me like the entire concept of=

> CoW and metadata checksums is completely subverted by the existence
> of correct checksums on "stale metadata from the future".

It seems that metadata CoW makes it impossible to see future data.

All btree trees get updated CoW, so no metadata will be overwritten
during one transaction.
Only super block is overwritten and normally superblock is updated
atomically.

So either old superblock is still here, all we can see is old tree pointe=
rs.
Or new superblock is here, all we can see is new tree pointers.
And new metadata will never be written into old metadata, there is no
way to see future metadata.

Thanks,
Qu

>=20
> Thanks,
> Amir.
>=20


--du2YZIcAwOiOTTr4PuJDd2aTA55WasN3H--

--dyLq0DsQThJuDmPrAhPa0GFnWq5tN3ZCT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx2GZUACgkQwj2R86El
/qjV4Af/YO3jjJuzwm4SUY7II05k/CTKxfEhnwj06uGeADW2DDEfSQgyD18jrteP
VEYQ7IAEbhv6uRht4RA87YPp6ZIwDxJyAnAiuOI+AdmKQjowlG4vMH18mSS68dNR
7l4Rq/LYsOCjBnZ9gpD03c2eCiq8A45MoaHlqM2Mp5hIAFkrbCR/ab5YPnkn1HRa
9MNL1vCtdRC94ilpC/ND927tuNpAWZpof3jAn6LOhba2JKYmnYkkgqDZbI8SWqIC
oS6QMJLV5J7gQbr5e56Lr0noqkGxn/uqEWfr4ZPq+izTCCO3GA/LY62IzhQRnTcc
paKbA4iCrXsMYu9c+CyuN6QBdiOh7Q==
=+xOA
-----END PGP SIGNATURE-----

--dyLq0DsQThJuDmPrAhPa0GFnWq5tN3ZCT--
