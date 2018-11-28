Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46650 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbeK2Glf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 01:41:35 -0500
Received: by mail-pl1-f195.google.com with SMTP id t13so17865728ply.13
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 11:38:51 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <4C297F47-C508-4DC9-8360-5E0873873833@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E18FEC91-F3F9-48CF-BEDA-01D625B3A34F";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [RFC PATCH v1 0/7] Block/XFS: Support alternative mirror device
 retry
Date: Wed, 28 Nov 2018 12:38:47 -0700
In-Reply-To: <20181128054923.GF8125@magnolia>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
 <20181128053303.GL6311@dastard> <20181128054923.GF8125@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Allison Henderson <allison.henderson@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Martin Petersen <martin.petersen@oracle.com>, shirley.ma@oracle.com, bob.liu@oracle.com


--Apple-Mail=_E18FEC91-F3F9-48CF-BEDA-01D625B3A34F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 27, 2018, at 10:49 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
> On Wed, Nov 28, 2018 at 04:33:03PM +1100, Dave Chinner wrote:
>> On Tue, Nov 27, 2018 at 08:49:44PM -0700, Allison Henderson wrote:
>>> Motivation:
>>> When fs data/metadata checksum mismatch, lower block devices may =
have other
>>> correct copies. e.g. If XFS successfully reads a metadata buffer off =
a raid1
>>> but decides that the metadata is garbage, today it will shut down =
the entire
>>> filesystem without trying any of the other mirrors.  This is a =
severe
>>> loss of service, and we propose these patches to have XFS try harder =
to
>>> avoid failure.
>>>=20
>>> This patch prototype this mirror retry idea by:
>>> * Adding @nr_mirrors to struct request_queue which is similar as
>>>  blk_queue_nonrot(), filesystem can grab device request queue and =
check max
>>>  mirrors this block device has.
>>>  Helper functions were also added to get/set the nr_mirrors.
>>>=20
>>> * Expanding bi_write_hint to bi_rw_hint, now @bi_rw_hint has three =
meanings.
>>> 1.Original write_hint.
>>> 2.end_io() will update @bi_rw_hint to reflect which mirror this i/o =
really happened.
>>> 3.Fs set @bi_rw_hint to force driver e.g raid1 read from a specific =
mirror.
>>>=20
>>> * Modify md/raid1 to support this retry feature.
>>>=20
>>> * Add b_rw_hint to xfs_buf
>>>  This patch adds a new field b_rw_hint to xfs_buf.  We will use this =
to set the
>>>  new bio->bi_rw_hint when submitting the read request, and also to =
store the
>>>  returned mirror when the read completes
>=20
>> the retry iterations. That allows us to let he block layer ot pick
>> whatever leg it wants for the initial read, but if we get a failure
>> we directly control the mirror we retry from and all bios in the
>> buffer go to that same mirror.
>> 	- is it generic/abstract enough to be able to work with
>> 	  RAID5/6 to trigger verification/recovery from the parity
>> 	  information in the stripe?
>=20
> In theory we could supply a raid5 implementation, wherein rw_hint =3D=3D=
 0
> lets the raid do as it pleases; rw_hint =3D=3D 1 reads from the =
stripe; and
> rw_hint =3D=3D 2 forces stripe recovery for the given block.

Definitely this API needs to be useful for RAID-5/6 storage as well, and
I don't think that needs too complex an interface to achieve.

Basically, the "nr_mirrors" parameter would instead be "nr_retries" or
similar, so that the caller knows how many possible data combinations
there are to try and validate.  For mirrors this is easy, and as it is
currently implemented.  For RAID-5/6 this would essentially be the
number of data rebuild combinations in the RAID group (e.g. 8 in a
RAID-5 8+1 setup, and 16 in a RAID-6 8+2).

For each call with nr_retries !=3D 0, the MD RAID-5/6 driver would skip
one of the data drives, and rebuild that part of the data from parity.
This wouldn't take too long, since the blocks are already in memory,
they just need the parity to be recomputed in a few different ways to
try and find a combination that returns valid data (e.g. if a drive
failed and the parity also has a latent corrupt sector, not uncommon).

The next step is to have an API that says "retry=3DN returned the =
correct
data, rebuild the parity/drive with that combination of devices" so
that the corrupt parity sector isn't used during the rebuild.

Cheers, Andreas






--Apple-Mail=_E18FEC91-F3F9-48CF-BEDA-01D625B3A34F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlv+7sgACgkQcqXauRfM
H+BeOw//Uxw6p/zGQaKjPUSXqnxgyftkyceAkIzeVS82sSgLCxntgcAitmsam3+H
r6aNJglW47gAn0SufpWkidA1pJGiV5zxSU4frApyGbGaVOl9AqzgfV1JGoWxVggw
O0cr/MSECJmQD/Za/9hIEY5ENF5PMhIOyaXe8vP0sEH45yKzlL02Fafyy3vR2Fxj
CRijCgOj7AYv+0BZayjmHT0yPK1psbchWxR7eezXNK1ggebJ3EaMFCSmalRNTUV6
k2XvUHl+SyiRn6zr+CORoZXPnu+mmOpvdERxcjmeAF0fDRtyER3kbEJc0unqL7Tm
5JiXWD/SlCLRMEMNsv0XdexNdzjD4fvnScJZ/GG92EktfgkjD/6IpStEmwmTflTQ
u98S8Fws/hOrvJSW1pDdobmxrSmI4UviVj98BDzZQbkPLvUHW8fJy+us7a7iwBS4
euECiA4J0XAREwtROnfpvJSyYQ1W758669H7bylydI8Pu29gt4XISWgIJA18ZaIo
YXTO8YAJCTpF/okwBgEfJ6i6ad05bYjQjAXjKNZf/Y7fV9f4rkoUNhnBTkETZsvR
SZlZkwljw9nAqPtjqbuyoQ2hZAK8o6IlyNwhHHhqw3POKIYdmsnqNtZplKauVw98
HZSChSjU156Xc+axJ4YpYdMTAI5aQf61uvUWtr9hdnHJF8DRaIQ=
=DyFV
-----END PGP SIGNATURE-----

--Apple-Mail=_E18FEC91-F3F9-48CF-BEDA-01D625B3A34F--
