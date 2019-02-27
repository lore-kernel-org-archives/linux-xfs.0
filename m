Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51141 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729716AbfB0EUH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Feb 2019 23:20:07 -0500
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock
 filesystems
References: <20190226181407.44612-1-bfoster@redhat.com>
 <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190226232212.GD16436@dastard>
 <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ed870e00-1931-d7b1-a3ed-8a184889f6fc@gmx.com>
Date: Wed, 27 Feb 2019 12:19:46 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ChiFC2KT5KUJIuviS5dy0wrtGv08C8fkt"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ChiFC2KT5KUJIuviS5dy0wrtGv08C8fkt
Content-Type: multipart/mixed; boundary="HKCqvA6W6O9uO40Nyf23IbRsAooZKEfvC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, fstests <fstests@vger.kernel.org>,
 linux-xfs <linux-xfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>,
 Josef Bacik <josef@toxicpanda.com>
Message-ID: <ed870e00-1931-d7b1-a3ed-8a184889f6fc@gmx.com>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock
 filesystems
References: <20190226181407.44612-1-bfoster@redhat.com>
 <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190226232212.GD16436@dastard>
 <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>
In-Reply-To: <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>

--HKCqvA6W6O9uO40Nyf23IbRsAooZKEfvC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/27 =E4=B8=8B=E5=8D=8812:06, Amir Goldstein wrote:
> On Wed, Feb 27, 2019 at 1:22 AM Dave Chinner <david@fromorbit.com> wrot=
e:
>>
>> On Tue, Feb 26, 2019 at 11:10:02PM +0200, Amir Goldstein wrote:
>>> On Tue, Feb 26, 2019 at 8:14 PM Brian Foster <bfoster@redhat.com> wro=
te:
>>>>
>>>> The dm-log-writes mechanism runs a workload against a filesystem,
>>>> tracks underlying FUAs and restores the filesystem to various points=

>>>> in time based on FUA marks. This allows fstests to check fs
>>>> consistency at various points and verify log recovery works as
>>>> expected.
>>>>
>>>
>>> Inaccurate. generic/482 restores to FUA points.
>>> generic/45[57] restore to user defined points in time (marks).
>>> dm-log-writes mechanism is capable of restoring either.
>>>
>>>> This mechanism does not play well with LSN based log recovery
>>>> ordering behavior on XFS v5 superblocks, however. For example,
>>>> generic/482 can reproduce false positive corruptions based on extent=

>>>> to btree conversion of an inode if the inode and associated btree
>>>> block are written back after different checkpoints. Even though both=

>>>> items are logged correctly in the extent-to-btree transaction, the
>>>> btree block can be relogged (multiple times) and only written back
>>>> once when the filesystem unmounts. If the inode was written back
>>>> after the initial conversion, recovery points between that mark and
>>>> when the btree block is ultimately written back will show corruption=

>>>> because log recovery sees that the destination buffer is newer than
>>>> the recovered buffer and intentionally skips the buffer. This is a
>>>> false positive because the destination buffer was resiliently
>>>> written back after being physically relogged one or more times.
>>>>
>>>
>>> This story doesn't add up.
>>> Either dm-log-writes emulated power failure correctly or it doesn't.
>>> My understanding is that the issue you are seeing is a result of
>>> XFS seeing "data from the future" after a restore of a power failure
>>> snapshot, because the scratch device is not a clean slate.
>>> If I am right, then the correct solution is to wipe the journal befor=
e
>>> starting to replay restore points.
>>
>> If that is the problem, then I think we should be wiping the entire
>> block device before replaying the recorded logwrite.
>>
>=20
> Indeed.

May I ask a stupid question?

How does it matter whether the device is clean or not?
Shouldn't the journal/metadata or whatever be self-contained?

>=20
>> i.e. this sounds like a "block device we are replaying onto has
>> stale data in it" problem because we are replaying the same
>> filesystem over the top of itself.  Hence there are no unique
>> identifiers in the metadata that can detect stale metadata in
>> the block device.
>>
>> I'm surprised that we haven't tripped over this much earlier that
>> this...
>>
>=20
> I remember asking myself the same thing... it's coming back to me
> now. I really remember having this discussion during test review.
> generic/482 is an adaptation of Josef's test script [1], which
> does log recovery onto a snapshot on every FUA checkpoint.
>=20
> [1] https://github.com/josefbacik/log-writes/blob/master/replay-fsck-wr=
apper.sh
>=20
> Setting up snapshots for every checkpoint was found empirically to take=

> more test runtime, than replaying log from the start for each checkpoin=
t.
> That observation was limited to the systems that Qu and Eryu tested on.=

>=20
> IRC, what usually took care of cleaning the block device is replaying t=
he
> "discard everything" IO from mkfs time.

This "discard everything" assumption doesn't look right to me.
Although most mkfs would discard at least part of the device, even
without discarding the newly created fs should be self-contained, no
wild pointer points to some garbage.

I though all metadata/journal write should be self-contained even for
later fs writes.

Am I missing something? Or do I get too poisoned by btrfs CoW?

Thanks,
Qu

> dm-log-writes driver should take care
> of zeroing blocks upon replaying a discard IO even on a target device t=
hat
> doesn't support discard, but maybe if original device doesn't support d=
iscard,
> the IO is not recorded at all and therefore not replayed?
>=20
> Brian, can you check if your log-writes stream contains a discard IO fo=
r
> the entire block device? I do remember that the initial log-writes test=
s worked
> very reliably on my laptop with SSD and were a bit flaky on another tes=
t machine
> with spinning rust, but that machine had other hardware reliability iss=
ues at
> the time (bad SATA cable) so I attributed all issues to that problem.
>=20
> BTW, looking closer at generic/482, $prev does not seem to be used at a=
ll
> in the replay loop.
>=20
>>>> Update the dm-log-writes require checks to enforce v4 superblocks
>>>> when running against XFS and skip the test otherwise.
>>>
>>> You might as well disable dm-log-writes test for XFS completely.
>>> Who cares about v4 superblocks these days?
>>
>> Enough of the inflammatory hyperbole, Amir. Statements like this
>> serve no useful purpose.
>>
>=20
> <deep breath> Agreed.
>=20
> Thanks,
> Amir.
>=20


--HKCqvA6W6O9uO40Nyf23IbRsAooZKEfvC--

--ChiFC2KT5KUJIuviS5dy0wrtGv08C8fkt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx2D+IACgkQwj2R86El
/qhAiQgAjOTOgEz21qiWZc9QjQDqMnkaZdkoTMOF0DzIC2Aop3aSOQUf9b3KtWXl
s0TJaApC0kskrDiYSPfk/DXkxtxdvBB8X7gQ1m280vLIdh3UjmSjaCCBXCdQj7QE
JT57RN5n3bdBIpDiGmCznyEALpi3EnUAE/kjczrdlotTGNNIknAdyB/4KwzeGzDV
a3Lat9zHZjRX+Im77KI0k2AjyvFvijB4DgaPCTBaWPdmkNwPy6FBf4GNBv0N60un
OPYr2AOPMhhc0TJeCScdiZLRHHSU4ox29S2tZMlQJtwpahN1+iQSe7HBJoKXDVCK
A8YO6WaQmrUSnV1zTJxC+tgRjw64tg==
=RrWC
-----END PGP SIGNATURE-----

--ChiFC2KT5KUJIuviS5dy0wrtGv08C8fkt--
