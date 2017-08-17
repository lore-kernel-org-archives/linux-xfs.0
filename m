Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38666 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750943AbdHQFV1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 01:21:27 -0400
Subject: Re: xfs_repair fails: mismatched UUID?
References: <1502946903.3034.25.camel@sub-pop.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d31ec46a-cc4c-5865-6ee4-fffdcb32c254@sandeen.net>
Date: Thu, 17 Aug 2017 00:21:19 -0500
MIME-Version: 1.0
In-Reply-To: <1502946903.3034.25.camel@sub-pop.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xeMvHpxPt05rjBwTkBtgimH9U0WdpGSOV"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Link Dupont <link@sub-pop.net>, linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xeMvHpxPt05rjBwTkBtgimH9U0WdpGSOV
Content-Type: multipart/mixed; boundary="vkTfqHUnVqVNnSkmOsmkWBnnodva94Xex";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Link Dupont <link@sub-pop.net>, linux-xfs@vger.kernel.org
Message-ID: <d31ec46a-cc4c-5865-6ee4-fffdcb32c254@sandeen.net>
Subject: Re: xfs_repair fails: mismatched UUID?
References: <1502946903.3034.25.camel@sub-pop.net>
In-Reply-To: <1502946903.3034.25.camel@sub-pop.net>

--vkTfqHUnVqVNnSkmOsmkWBnnodva94Xex
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/17/17 12:15 AM, Link Dupont wrote:
> Hello,
>=20
> I have a JMicron USB RAID enclosure that is exhibiting read failures.
>=20
>> [59996.137762] sd 5:0:0:0: [sdd] tag#0 FAILED Result: hostbyte=3DDID_O=
K
>> driverbyte=3DDRIVER_SENSE
>> [59996.137786] sd 5:0:0:0: [sdd] tag#0 Sense Key : Aborted Command [cu=
rrent]=20
>> [59996.137792] sd 5:0:0:0: [sdd] tag#0 Add. Sense: No additional sense=

>> information
>> [59996.137798] sd 5:0:0:0: [sdd] tag#0 CDB: Read(16) 88 00 00 00 00 00=
 a6 42
>> 1d d8 00 00 00 08 00 00
>> [59996.137804] blk_update_request: I/O error, dev sdd, sector 27893508=
72
>> [59996.137816] Buffer I/O error on dev sdd, logical block 348668859, a=
sync
>> page read
>>
>=20
> I ran ddrescue to block copy the device to another external USB drive. =
This
> appears to have been successful (though not without errors). The new dr=
ive shows
> an identical UUID to the original.
>=20
>> # xfs_admin -u /dev/sdc1
>> UUID =3D 7b2fc6f7-0f6b-40fb-b264-75d25e9d0d1e
>> # xfs_admin -u /dev/sdd1
>> UUID =3D 7b2fc6f7-0f6b-40fb-b264-75d25e9d0d1e
>=20
> I'm still unable to mount the file-system on sdc1.
>=20
>> # mount /dev/sdc1 mnt
>> mount: /root/mnt: mount(2) system call failed: Structure needs cleanin=
g.
>=20
> I ran xfs_repair.
>=20
>> # xfs_repair /dev/sdc1
>> Phase 1 - find and verify superblock...
>>         - reporting progress in intervals of 15 minutes
>> Phase 2 - using internal log
>>         - zero log...
>> * ERROR: mismatched uuid in log
>> *            SB : 7b2fc6f7-0f6b-40fb-b264-75d25e9d0d1e
>> *            log: 00000001-0038-8e56-0000-000100388e2e

Thjat looks suspiciously /not/ like a UUID.

Which makes me think that the "log" was not the log, and your enclosure
scrambled data around somehow.

Forcing that mess through repair may have yielded more harm than good.
So, good thing it was on the clone.

Did the enclosure contain multiple disks?  Did they possibly get
re-ordered or otherwise scrambled?


=2E..

> All of this has been performed on my ddrescue clone (not the original d=
evice).

<cue applause!>  :)

> And with kernel 4.12.5 and xfsprogs 4.10.0.

> I understand corrupt blocks and the data lost incurred from that. I can=
 poke
> around and try to recover what I can when mounted in 'norecovery'. What=
 I am
> perplexed by is the total loss of file-system info when xfs_repair -L i=
s run;
> not even a lost+found?

Collecting and sharing the xfs_repair output might yield some insight as =
well,
but first I'd look at what you're copying from; just how badly damaged is=
 it?
xfs_repair restores filesystem consistency but it is not a data recovery =
or
storage repair tool.  ;)

-Eric


--vkTfqHUnVqVNnSkmOsmkWBnnodva94Xex--

--xeMvHpxPt05rjBwTkBtgimH9U0WdpGSOV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJZlSfWAAoJECCuFpLhPd7gCyAP/1gM4DgMuddDBi7cuCCXxhtP
Y4/gpr69rwSB92ofV/Hqdm0XsOs3zXaLMfEKBwalDzK4arDRMMiiouU9FImMqWST
M37BeJA2Ngnz3P///J+SjDPfugt6duOlF9wYSnDnye1eZKpNQwfT35c6nFfB/qjx
+8oB5YBDuqpIZFuMcWaywy1XjOsW3hD7f440aB99swTNTBuVJnwEz5bvXMvuvcff
BU+xzbWcCA6wfc7fThaReyCGj/wd6cJlFWiIuJjMKR3Excni5qdVsLLvhTZE7soJ
sUEoD39tSbT2TOBj3dIyzHCEQBlJ/y2oEUp/wouTQjUdzTBXI5pZumlNZRnZ9Lxt
s6bzRSITojTqJykm0baPHsK1u3hKJwobqVDMB00YrsPukjqirebgsOJvINqWT+9S
F+uJDudhv7jepjap2+51jJpSkp6aV9flf1NUALZq5XVDQ//FPEGHuNgWd4KlHHOk
LxgPvLooMdwbmyYa+nvweCObhDgtkcVzvGe7h6fN4OSlyTWBVfPgpDi0vKsq14Cg
qImkjmTF1HOyjCzoabtVL/MSUC48ENCa3f2mLe00tv5dp8u9nZv4uyP2AV1rBPtg
zlmHnO2x5PeQngbg81Ddujq+L5fP3PrOPj9Ts73bjGDA9qtyDQapIU9O/3wQiICr
ZVmSmUfGLwU2+F++0onw
=o0/W
-----END PGP SIGNATURE-----

--xeMvHpxPt05rjBwTkBtgimH9U0WdpGSOV--
