Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 48C7A7FC2
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 19:22:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2668C8F8033
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 17:22:51 -0700 (PDT)
Received: from members.tip.net.au (haggis.pcug.org.au [203.10.76.10]) by
	cuda.sgi.com with ESMTP id t7AaSgBEbFG4gDVj for
	<xfs@oss.sgi.com>; Tue, 20 Aug 2013 17:22:50 -0700 (PDT)
Date: Wed, 21 Aug 2013 10:22:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20130821102246.4e3c4c8fe549d8c7760da96d@canb.auug.org.au>
In-Reply-To: <20130820192844.GC5262@sgi.com>
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
	<20130820120702.000b044e@oracle.com>
	<20130820192844.GC5262@sgi.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6071519106055482795=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: cbe-oss-dev@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dwight Engen <dwight.engen@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-next@vger.kernel.org, Jeremy Kerr <jk@ozlabs.org>, linuxppc-dev@lists.ozlabs.org, Gao feng <gaofeng@cn.fujitsu.com>

--===============6071519106055482795==
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Aug_2013_10_22_46_+1000_EeAL.9Y2BRkRXAed"

--Signature=_Wed__21_Aug_2013_10_22_46_+1000_EeAL.9Y2BRkRXAed
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Tue, 20 Aug 2013 14:28:44 -0500 Ben Myers <bpm@sgi.com> wrote:
>
> I'd prefer not to break Stephen's tree two days in a row.  We could just =
revert
> d6970d4b726c in the xfs tree for the time being as Stephen has done, but =
given
> the choice would prefer the fix.  Do you have a preference between the two
> approaches that Dwight has posted?  The first seems more conservative...

I will automatically revert that commit when I merge the xfs tree until
some other solution is forthcoming (so you don't have to do the revert in
the xfs tree).  This does need to be fixed fairly soon, though.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__21_Aug_2013_10_22_46_+1000_EeAL.9Y2BRkRXAed
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFAhWAAoJEECxmPOUX5FEoQEP/1hWbSlulJwAxE5gM1Z5Sx2S
yniC9fDmRFaPz69pVNy+9CsF1JJvsT6eu1hDd4wb1F8wjBGK2AiE60uAkBTwBIXw
zS8/IBfRclEMxxZH7Jx95chFTr3CaqT5z+APhw4tpSurMr38wi94UTY9+m5KdylW
odgp3cjD4hXfchikf0Pg4zA+yH11vTTmh63QV3IExOHFATRCI5wFGd2BGbb6hNzo
e6t7h6maWqRjYEuyz9kSCxtgQzHeAIrFPuNUA/N42kJ3EFvYhVERAqwMJgeqYYRs
S/9hz599YtSJrQZ7gvTVqpVu2AQ4jBaioWKGFlWZ8tsZmhhykLY9T+yOjHMLmBS0
k9+7Q7ehDBlEHF4v9ZIs1OciQ7cT8SpvH7La+9759ofdCGl7PtjFfTfoGnGj62j/
DwAD1cUtbxZ/JcEERqWNfZ60i3HTRWkt3xw0oU4fMuQ3HcWIfwrSY4J0+h2cJBGC
OK/cU4JNKKZRg6H8w4zne7uTkljkO9MmrF3nQ4FatUgcSLnY5frkzhaP238P4Hgu
3ZWKyBoL34k9tYYuS/cvOqrn3wI8Xm/viqZNoK1pnVmHR49f/3dHv0tCoMROROZa
F76/j9qMi8gY3vhi9sEhBDkWZXDLgyoprcJaCXvmkU/ridGcQmnIm7UcdssySaHO
aMCnucNRR2B0iW65vxV1
=KhY3
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Aug_2013_10_22_46_+1000_EeAL.9Y2BRkRXAed--


--===============6071519106055482795==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6071519106055482795==--
