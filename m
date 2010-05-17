Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4HLQKrO008787 for <xfs@oss.sgi.com>; Mon, 17 May 2010 16:26:20 -0500
Received: from smtp-auth.no-ip.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED05213F1D5E
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 14:28:37 -0700 (PDT)
Received: from smtp-auth.no-ip.com (smtp-auth.no-ip.com [204.16.252.94]) by
	cuda.sgi.com with ESMTP id Byn6TeREcvOMXfzN for
	<xfs@oss.sgi.com>; Mon, 17 May 2010 14:28:37 -0700 (PDT)
Message-ID: <4BF1B4FE.7020503@redhat.com>
Date: Mon, 17 May 2010 17:28:30 -0400
From: Doug Ledford <dledford@redhat.com>
MIME-Version: 1.0
Subject: Re: xfs and raid5 - "Structure needs cleaning for directory open"
References: <20100510022033.GB7165@dastard>
In-Reply-To: <20100510022033.GB7165@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2050012788195138447=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-raid@vger.kernel.org, Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============2050012788195138447==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig12D39D0C07117305641FFCF6"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig12D39D0C07117305641FFCF6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/09/2010 10:20 PM, Dave Chinner wrote:
> On Sun, May 09, 2010 at 08:48:00PM +0200, Rainer Fuegenstein wrote:
>>
>> today in the morning some daemon processes terminated because of
>> errors in the xfs file system on top of a software raid5, consisting
>> of 4*1.5TB WD caviar green SATA disks.
>=20
> Reminds me of a recent(-ish) md/dm readahead cancellation fix - that
> would fit the symptoms of (btree corruption showing up under heavy IO
> load but no corruption on disk. However, I can't seem to find any
> references to it at the moment (can't remember the bug title), but
> perhaps your distro doesn't have the fix in it?
>=20
> Cheers,
>=20
> Dave.

That sounds plausible, as does hardware error.  A memory bit flip under
heavy load would cause the in memory data to be corrupt while the on
disk data is good.  By waiting to check it until later, the bad memory
was flushed at some point and when the data was reloaded it came in ok
this time.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig12D39D0C07117305641FFCF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvxtP4ACgkQg6WylM+/8ZQ3DgCcDa1NZVSLv+48QBpuyuLJ27om
qYMAnAwzuxKFke7Lf3x/Uev8uLw8qoP1
=m9de
-----END PGP SIGNATURE-----

--------------enig12D39D0C07117305641FFCF6--


--===============2050012788195138447==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2050012788195138447==--
