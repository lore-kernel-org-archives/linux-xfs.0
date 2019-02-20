Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44591 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfBTHrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Feb 2019 02:47:42 -0500
Received: by mail-pg1-f193.google.com with SMTP id y1so11437813pgk.11
        for <linux-xfs@vger.kernel.org>; Tue, 19 Feb 2019 23:47:41 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <8778DF81-C710-473B-9817-574DE9D7DE9B@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_10F92983-9723-4CD5-9FC3-52159FA26C5F";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Date: Tue, 19 Feb 2019 23:47:57 -0800
In-Reply-To: <6a9dc05a-0445-d0ab-0140-1de4fee7ba9b@gmail.com>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
 <6a9dc05a-0445-d0ab-0140-1de4fee7ba9b@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Boaz Harrosh <openosd@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Omar Sandoval <osandov@osandov.com>, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com, linux-api@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org


--Apple-Mail=_10F92983-9723-4CD5-9FC3-52159FA26C5F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 17, 2019, at 8:35 AM, Boaz Harrosh <openosd@gmail.com> wrote:
>=20
> On 15/02/19 00:06, Dave Chinner wrote:
>> On Thu, Feb 14, 2019 at 02:00:07AM -0800, Omar Sandoval wrote:
>>> From: Omar Sandoval <osandov@fb.com>
>>>=20
>>> Hi,
>>>=20
>>> Since statx was added in 4.11, userspace has had an interface for
>>> reading btime (file creation time), but no way to set it. This RFC =
patch
>>> series adds support for changing btime with utimensat(). Patch 1 =
adds
>>> the VFS infrastructure, patch 2 adds the support to utimensat() with =
a
>>> new flag, and the rest of the patches add filesystem support; I =
excluded
>>> CIFS for now because I don't have a CIFS setup to test it on.
>>>=20
>>> Updating btime is useful for at least a couple of use cases:
>>>=20
> [1]
>>> - Backup/restore programs (my motivation for this feature is btrfs =
send)
>>> - File servers which interoperate with operating systems that allow
>>>  updating file creation time, including Mac OS [1] and Windows [2]
>>=20
>> So you're adding an interface that allows users to change the create
>> time of files without needing any privileges?
>>=20
> [2]
>> Inode create time is forensic metadata in XFS  - information we use
>> for sequence of event and inode lifetime analysis during examination
>> of broken filesystem images and systems that have been broken into.
>> Just because it's exposed to userspace via statx(), it doesn't mean
>> that it is information that users should be allowed to change. i.e.
>> allowing users to be able to change the create time on files makes
>> it completely useless for the purpose it was added to XFS for...
>>=20
> <snap>
>=20
> I think the difference in opinion here is that there are two totally
> different BTIme out in the world. For two somewhat opposite =
motivations
> and it seems they both try to be crammed into the same on disk space.
>=20
> One - Author creation time
>  This is a Windows originated creature and later MAC (and all vendors =
who
>  make a living by serving cifs (hint see my email address))
>=20
>  This is a tag carried globally on the globe denoting the time of the
>  original creator of the file. copy, download, backup-restore and so
>  on preserve it from the very first original creation.
>  This creature is a user oriented information. That needs to be =
carefully
>  orchestrated by all parties.

One of the issues with user-supplied "creation time" is that it is =
vague.
If Vim (or many other programs) is writing out an existing file, it
will actually create a new file and rename it over the old file, so even
though the newly-written file is "created" at write time, the content is
older.  Unless the creation time is actually stored internal to the file
itself, rather than as filesystem metadata, it is unlikely to be kept
across filesystems, between systems, etc.

Conversely, there is already such metadata in existing file formats, =
e.g.
.jpg (Exif.Image.DateTime), .png (tEXt Creation Time), .docx (Date =
Completed),
etc. that sticks with the file regardless of the underlying storage =
medium.

Cheers, Andreas






--Apple-Mail=_10F92983-9723-4CD5-9FC3-52159FA26C5F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxtBi0ACgkQcqXauRfM
H+CEjxAAhbR5dOgpALSr9iorpUu/bTTAIVrYRKPTa05jj9GfzyUyV7lb1dkXbOc9
8tpQ9+Ib2P/Xe1kDMXO76mmJbEGuzmegxOhLChr4LfweVTGxSjn4ak3MKQhNTaO5
AyRLMu1alKmkm7DLODd7DV6PidGo2YPVf4bUkyJX03AaaIbfZBVs98i7HdY5e15Z
4NxUkoyKCyo6G3ac+wTe+IT52ZPnrCXysbhTksGEs+7jLOuIXuOC+x4sMA/T20iZ
MChP/g1r54yYAqSqC5+uSU/e1t/AkGAkt9alueGuA+h4UmR/mRpmxuBgvi41sV1+
FT+CdpTiZoTkBOxbgYqYDM+26MOLgZ+lQI5q1+gV/f+4iiB4Lf7ohZ5MhXDzMZ3G
6NfHDgxlknWklcoQ0iaHBLgFzkXK8VLCoU36HqKjKYlfAr5N3rZsRw9sDTInyhFp
eGep9enMgdatdStIurbwoLzJXcwox9cRtD4T0Dow20Pkjm3nUp3JOGIadUYbvtJI
vIwRfHyarTXkrZaRWA3yhaC+5mK2+cXrqGwoeGTFxeQuIoKEjxz7HInRZYmjoGpZ
KVtl9KSwzV/8x23o46A8/pXxlBzN4NJcjT18I52cbBjprNF5CxhfbbaVJ5omaeOs
EmC+xbyZbB3Izf1VjsqnwUj2SPcZyTpILgvI5BPKe2O8vA2Q5Hc=
=P9aX
-----END PGP SIGNATURE-----

--Apple-Mail=_10F92983-9723-4CD5-9FC3-52159FA26C5F--
