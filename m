Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38958 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbdHQF0N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 01:26:13 -0400
Subject: Re: xfs_repair fails: mismatched UUID?
From: Eric Sandeen <sandeen@sandeen.net>
References: <1502946903.3034.25.camel@sub-pop.net>
 <d31ec46a-cc4c-5865-6ee4-fffdcb32c254@sandeen.net>
Message-ID: <e285d801-755b-b84e-028a-b889f4ee336c@sandeen.net>
Date: Thu, 17 Aug 2017 00:26:12 -0500
MIME-Version: 1.0
In-Reply-To: <d31ec46a-cc4c-5865-6ee4-fffdcb32c254@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="69nsliAH8HGixaDCfVuqjccw7nwa7lvsu"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Link Dupont <link@sub-pop.net>, linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--69nsliAH8HGixaDCfVuqjccw7nwa7lvsu
Content-Type: multipart/mixed; boundary="mrXLsC7x8sk3HokMcX5I62bm0eA73L8qO";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Link Dupont <link@sub-pop.net>, linux-xfs@vger.kernel.org
Message-ID: <e285d801-755b-b84e-028a-b889f4ee336c@sandeen.net>
Subject: Re: xfs_repair fails: mismatched UUID?
References: <1502946903.3034.25.camel@sub-pop.net>
 <d31ec46a-cc4c-5865-6ee4-fffdcb32c254@sandeen.net>
In-Reply-To: <d31ec46a-cc4c-5865-6ee4-fffdcb32c254@sandeen.net>

--mrXLsC7x8sk3HokMcX5I62bm0eA73L8qO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/17/17 12:21 AM, Eric Sandeen wrote:
> On 8/17/17 12:15 AM, Link Dupont wrote:
>> Hello,
>>
>> I have a JMicron USB RAID enclosure that is exhibiting read failures.
>>
>>> [59996.137762] sd 5:0:0:0: [sdd] tag#0 FAILED Result: hostbyte=3DDID_=
OK
>>> driverbyte=3DDRIVER_SENSE
>>> [59996.137786] sd 5:0:0:0: [sdd] tag#0 Sense Key : Aborted Command [c=
urrent]=20
>>> [59996.137792] sd 5:0:0:0: [sdd] tag#0 Add. Sense: No additional sens=
e
>>> information
>>> [59996.137798] sd 5:0:0:0: [sdd] tag#0 CDB: Read(16) 88 00 00 00 00 0=
0 a6 42
>>> 1d d8 00 00 00 08 00 00
>>> [59996.137804] blk_update_request: I/O error, dev sdd, sector 2789350=
872
>>> [59996.137816] Buffer I/O error on dev sdd, logical block 348668859, =
async
>>> page read
>>>
>>
>> I ran ddrescue to block copy the device to another external USB drive.=
 This
>> appears to have been successful (though not without errors). The new d=
rive shows
>> an identical UUID to the original.
>>
>>> # xfs_admin -u /dev/sdc1
>>> UUID =3D 7b2fc6f7-0f6b-40fb-b264-75d25e9d0d1e
>>> # xfs_admin -u /dev/sdd1
>>> UUID =3D 7b2fc6f7-0f6b-40fb-b264-75d25e9d0d1e
>>
>> I'm still unable to mount the file-system on sdc1.
>>
>>> # mount /dev/sdc1 mnt
>>> mount: /root/mnt: mount(2) system call failed: Structure needs cleani=
ng.
>>
>> I ran xfs_repair.
>>
>>> # xfs_repair /dev/sdc1
>>> Phase 1 - find and verify superblock...
>>>         - reporting progress in intervals of 15 minutes
>>> Phase 2 - using internal log
>>>         - zero log...
>>> * ERROR: mismatched uuid in log
>>> *            SB : 7b2fc6f7-0f6b-40fb-b264-75d25e9d0d1e
>>> *            log: 00000001-0038-8e56-0000-000100388e2e
>=20
> Thjat looks suspiciously /not/ like a UUID.
>=20
> Which makes me think that the "log" was not the log, and your enclosure=

> scrambled data around somehow.
>=20
> Forcing that mess through repair may have yielded more harm than good.
> So, good thing it was on the clone.
>=20
> Did the enclosure contain multiple disks?  Did they possibly get
> re-ordered or otherwise scrambled?

Oh right, you did say RAID enclosure.

My money is on the enclosure no longer presenting you with sectors in
the original order, or in an otherwise severely damaged form, for
whatever reason.

IOWS: I think this is a storage problem that xfs_repair can't solve.

-Eric


--mrXLsC7x8sk3HokMcX5I62bm0eA73L8qO--

--69nsliAH8HGixaDCfVuqjccw7nwa7lvsu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJZlSj0AAoJECCuFpLhPd7gKxMP/2scZK4PjkG0R2MEve760L+5
SHjRKeXehoxnpWoZUG9MPd7bDcVjTBNAD0KqB8nm/s2tyw+yvUTyYIR6Qgm3EY06
mdLheQPRtVwQmD2sEEBskLidgXeVV7zbhcThAu1DbJyozvDVYWuTxDPIfB9rKTgl
gK3vEL2CkiqKQtdBHdTsNzYbM4/R8fud08Xnm05kF0BSiiZEcXJ5jTn9SQU4RZFY
8rdOJ779gA9uugiB6hc0n5ChxVshcS/75aASGEwUk8knATQtBxb2dvjGnKQ2x6OD
meA0VWDo2s6Y09A8ncAJ0RxzfExd3Wguyx9/aKMdiHbI3tANPUCsUF2TbK6I4oYI
VqEKKINUcOazUo4XOSI3kd7Z6KUoDgRVKVMY2ZZwSj67vrTDJyWCdfYI3FM38z8T
9sdgsOY3L+LlN7/H1FwXX5+JIAFaNRJmHYYBj48vX4ZIDzNPPtlQj1w6fMFBJ/jj
nPq2jrMyDiM5HeaAb+V1vyUC1VeXXmn1YZST54SK5HQ80bgcczQWSzc+2U+UeT3E
bxoeFADL+xyEu77nvfgqwl4pgrd13EJJeuMyqlh5UUDGO01UE1Q86meAUt0SvrCA
6ynFjAZzNSJ0nxkMFcX3dPm5h/AZRSNGlBEBxa1aiQS6WnG3ode5LmtxMexxAP4c
IUln9KakFnt5mEclQOWx
=7Eej
-----END PGP SIGNATURE-----

--69nsliAH8HGixaDCfVuqjccw7nwa7lvsu--
