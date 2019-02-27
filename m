Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57694 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725946AbfB0Fcm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Feb 2019 00:32:42 -0500
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock
 filesystems
References: <20190226181407.44612-1-bfoster@redhat.com>
 <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190226232212.GD16436@dastard>
 <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>
 <ed870e00-1931-d7b1-a3ed-8a184889f6fc@gmx.com>
 <CAOQ4uxhNdzbSiPREmMtv5_81=7bxCRbTaa_KUN00g7De_j6a4Q@mail.gmail.com>
 <1f5c2280-f4db-2c13-bf2b-f4dc4111613a@suse.de>
 <CAOQ4uxihcTPhJnNKc3siZs3a9iwRnqG1fiXa64_Rgo5rd-hM=Q@mail.gmail.com>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <7aa13461-0f5f-af48-b3d1-48d03108da09@suse.de>
Date: Wed, 27 Feb 2019 13:32:31 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxihcTPhJnNKc3siZs3a9iwRnqG1fiXa64_Rgo5rd-hM=Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L279JkXhA1UmNb6UhC5dBQbFOZYv3vQg3"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, Josef Bacik <josef@toxicpanda.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L279JkXhA1UmNb6UhC5dBQbFOZYv3vQg3
Content-Type: multipart/mixed; boundary="TPFnHb7Rc7XYCasnzDSKpfOnUIgjfBmgN";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Dave Chinner <david@fromorbit.com>,
 Brian Foster <bfoster@redhat.com>, Josef Bacik <josef@toxicpanda.com>,
 fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <7aa13461-0f5f-af48-b3d1-48d03108da09@suse.de>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock
 filesystems
References: <20190226181407.44612-1-bfoster@redhat.com>
 <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190226232212.GD16436@dastard>
 <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>
 <ed870e00-1931-d7b1-a3ed-8a184889f6fc@gmx.com>
 <CAOQ4uxhNdzbSiPREmMtv5_81=7bxCRbTaa_KUN00g7De_j6a4Q@mail.gmail.com>
 <1f5c2280-f4db-2c13-bf2b-f4dc4111613a@suse.de>
 <CAOQ4uxihcTPhJnNKc3siZs3a9iwRnqG1fiXa64_Rgo5rd-hM=Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxihcTPhJnNKc3siZs3a9iwRnqG1fiXa64_Rgo5rd-hM=Q@mail.gmail.com>

--TPFnHb7Rc7XYCasnzDSKpfOnUIgjfBmgN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/27 =E4=B8=8B=E5=8D=881:19, Amir Goldstein wrote:
> On Wed, Feb 27, 2019 at 7:01 AM Qu Wenruo <wqu@suse.de> wrote:
>>
>>
>>
>> On 2019/2/27 =E4=B8=8B=E5=8D=8812:49, Amir Goldstein wrote:
>> [snip]
>>>>> Indeed.
>>>>
>>>> May I ask a stupid question?
>>>>
>>>> How does it matter whether the device is clean or not?
>>>> Shouldn't the journal/metadata or whatever be self-contained?
>>>>
>>>
>>> Yes and no.
>>>
>>> The most simple example (not limited to xfs and not sure it is like t=
hat in xfs)
>>> is how you find the last valid journal commit entry. It should have c=
orrect CRC
>>> and the largest LSN. But it you replay IO on top of existing journal =
without
>>> wiping it first, then journal recovery will continue past the point t=
o meant to
>>> replay or worse.
>>
>> The journal doesn't have some superblock like system to tell where to
>> stop replaying?
>>
>=20
> Yes, it does. My statement was inaccurate.
> The point is how can filesystem trust that journal superblock is not co=
rrupted?
> If filesystem observes data from the future in the journal that is not
> expected to
> be there, or any checksumed metadata on the device, it may fail sanity =
checks
> that superblock or other metadata are not corrupted.
>=20
> Suppose filesystem has a bug that overwrites new metadata from time N
> with old stale metadata buffer from time N-1. That would look not much =
different
> than log-writes replay to time N-1 over non clean device from time N.
>=20
>> If not, then indeed we need to discard the journal before writing new =
one.
>>
> ...
>=20
>>>> Am I missing something? Or do I get too poisoned by btrfs CoW?
>>>>
>>>
>>> I'd be very surprised if btrfs cannot be flipped by seeing stale data=
 "from
>>> the future" in the block device. Seems to me like the entire concept =
of
>>> CoW and metadata checksums is completely subverted by the existence
>>> of correct checksums on "stale metadata from the future".
>>
>> It seems that metadata CoW makes it impossible to see future data.
>>
>> All btree trees get updated CoW, so no metadata will be overwritten
>> during one transaction.
>> Only super block is overwritten and normally superblock is updated
>> atomically.
>>
>> So either old superblock is still here, all we can see is old tree poi=
nters.
>> Or new superblock is here, all we can see is new tree pointers.
>> And new metadata will never be written into old metadata, there is no
>> way to see future metadata.
>>
>=20
> Those assumptions could fail if you have unreliable hardware that
> reorders IO across FUA, just drops IO on the floor or a bug in the file=
system
> or block layer.

Well, if hardware has problem, we can't really do anything to help.

Maybe that's reason why there are more corruption report for btrfs as
there are more problematic hardware than we thought?

>=20
> Existence of metadata from the future could look like any of
> the above has happened.

Btrfs has an extra layer to prevent such problem from happening, each
metadata pointer has its expected generation.

If one metadata has a mismatch generation with its parent, then kernel
will know something went wrong.

And in fact, that's the most common failure mode for btrfs (although
most of them is seeing too old metadata), and we're looking into the
problem (but not much progress yet).

Thanks,
Qu

>=20
> Thanks,
> Amir.
>=20


--TPFnHb7Rc7XYCasnzDSKpfOnUIgjfBmgN--

--L279JkXhA1UmNb6UhC5dBQbFOZYv3vQg3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx2IO8ACgkQwj2R86El
/qh02gf5ASDaORwi6TB+B9+OiE4a5UX6hK+Msdm7Y5nv8ECKnDNngPCx134kNY57
TyR+EglwXY0qsmbKSSXu1Dd9mqFc66qBPyjS1KDUCYun0wf5uOaLCpOJZILMKrx4
8Wqle1KlDiKay3gaynUEivL/f4qT5oOkU3JhN2D/CkDTZ3TKlNg/9ma8YGIsxtsc
m8OBq8A02pKBd/ai2lsisZQyPCpKkW/SBjJs7dR7o/4OWbP410pxUsBrVrOSG8c8
odOMNNq2qE7bYir6hJ23qDl8ac6t28FQeoEBQhHqpPGpyLc2DeO29tt23Zz4ws9v
mJJWKMVWltTdKFOhhsZwMSNfE6jGCQ==
=aH/L
-----END PGP SIGNATURE-----

--L279JkXhA1UmNb6UhC5dBQbFOZYv3vQg3--
