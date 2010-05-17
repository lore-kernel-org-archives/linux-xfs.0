Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4HMGFsJ010845 for <xfs@oss.sgi.com>; Mon, 17 May 2010 17:16:16 -0500
Received: from smtp-auth.no-ip.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF77E13F3547
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 15:18:32 -0700 (PDT)
Received: from smtp-auth.no-ip.com (smtp-auth.no-ip.com [204.16.252.94]) by
	cuda.sgi.com with ESMTP id 3YqF27YkFLpoJ8Tn for
	<xfs@oss.sgi.com>; Mon, 17 May 2010 15:18:32 -0700 (PDT)
Message-ID: <4BF1C0B4.5090009@redhat.com>
Date: Mon, 17 May 2010 18:18:28 -0400
From: Doug Ledford <dledford@redhat.com>
MIME-Version: 1.0
Subject: Re: xfs and raid5 - "Structure needs cleaning for directory open"
References: <20100510022033.GB7165@dastard> <4BF1B4FE.7020503@redhat.com>
	<20100517214532.GL8120@dastard>
In-Reply-To: <20100517214532.GL8120@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5544411952365528590=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-raid@vger.kernel.org, Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============5544411952365528590==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4EE3AC9ADF5C31DF579B67EA"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4EE3AC9ADF5C31DF579B67EA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/17/2010 05:45 PM, Dave Chinner wrote:
> On Mon, May 17, 2010 at 05:28:30PM -0400, Doug Ledford wrote:
>> On 05/09/2010 10:20 PM, Dave Chinner wrote:
>>> On Sun, May 09, 2010 at 08:48:00PM +0200, Rainer Fuegenstein wrote:
>>>>
>>>> today in the morning some daemon processes terminated because of
>>>> errors in the xfs file system on top of a software raid5, consisting=

>>>> of 4*1.5TB WD caviar green SATA disks.
>>>
>>> Reminds me of a recent(-ish) md/dm readahead cancellation fix - that
>>> would fit the symptoms of (btree corruption showing up under heavy IO=

>>> load but no corruption on disk. However, I can't seem to find any
>>> references to it at the moment (can't remember the bug title), but
>>> perhaps your distro doesn't have the fix in it?
>>>
>>> Cheers,
>>>
>>> Dave.
>>
>> That sounds plausible, as does hardware error.  A memory bit flip unde=
r
>> heavy load would cause the in memory data to be corrupt while the on
>> disk data is good.
>=20
> The data dumps from the bad blocks weren't wrong by a single bit -
> they were unrecogni=D1=95able garbage - so that it very unlikely to be
> a memory erro causing the problem.

Not true.  It can still be a single bit error but a single bit error
higher up in the chain.  Aka a single bit error in the scsi command to
read various sectors, then you read in all sorts of wrong data and
everything from there is totally whacked.

>> By waiting to check it until later, the bad memory
>> was flushed at some point and when the data was reloaded it came in ok=

>> this time.
>=20
> Yup - XFS needs to do a better job of catching this case - the
> prototype metadata checksumming patch caught most of these cases...
>=20
> Cheers,
>=20
> Dave.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig4EE3AC9ADF5C31DF579B67EA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvxwLQACgkQg6WylM+/8ZQChgCfWmTFOjnepMDqZT8gVFbA3ndr
ibQAnAkq0TVEgGm+CEHqmbO2+Ei8ilEp
=snZS
-----END PGP SIGNATURE-----

--------------enig4EE3AC9ADF5C31DF579B67EA--


--===============5544411952365528590==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5544411952365528590==--
