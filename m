Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3FHLFHH080440 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 12:21:15 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0E0450E3C6
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 10:24:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5GHKYyErDSGSmI1N for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 10:24:38 -0700 (PDT)
Message-ID: <4DA87F43.5040807@redhat.com>
Date: Fri, 15 Apr 2011 11:24:19 -0600
From: Eric Blake <eblake@redhat.com>
MIME-Version: 1.0
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
References: <20110414102608.GA1678@x4.trippels.de>	<20110414120635.GB1678@x4.trippels.de>	<20110414140222.GB1679@x4.trippels.de>	<4DA70BD3.1070409@draigBrady.com>
	<4DA717B2.3020305@sandeen.net>	<20110414225904.GK21395@dastard>
	<4DA7836A.5040604@draigBrady.com>	<20110415000940.GL21395@dastard>
	<87sjtjq4ir.fsf@rho.meyering.net>
	<20110415171629.GA9088@infradead.org>
In-Reply-To: <20110415171629.GA9088@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6052772135936892136=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Jim Meyering <jim@meyering.net>, xfs-oss <xfs@oss.sgi.com>, coreutils@gnu.org, linux-ext4@vger.kernel.org, Markus Trippelsdorf <markus@trippelsdorf.de>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============6052772135936892136==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enigD99D3507C9612B7769610428"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD99D3507C9612B7769610428
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/15/2011 11:16 AM, Christoph Hellwig wrote:
> On Fri, Apr 15, 2011 at 10:53:48AM +0200, Jim Meyering wrote:
>> Can you or anyone else point to authoritative documentation
>> (or even a summary of those "discussions") of FIEMAP semantics?
>=20
> A large part of the problem is that there's none and the semantics
> is a hode-podge of random flags that mostly make little sense
> outside of fs developers debugging the layout that we created.  The
> closest to a description is Documentation/filesystems/fiemap.txt
> in the kernel tree, but that doesn't document most of the delicate
> points.

Would it be worth borrowing from Solaris' semantics and adding SEEK_HOLE
and SEEK_DATA to lseek(2), as a higher level (less-detailed, but easier
to define and easier to use) interface for discovering the regions of a
file that only contain NUL bytes?  FIEMAP is a great interface at
exposing everything possible, but coreutils doesn't necessarily need all
that complexity just for determining when it is safe to skip over a
portion of a file that is either unallocated or unchanged from the
initial 0 contents.

--=20
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enigD99D3507C9612B7769610428
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNqH9DAAoJEKeha0olJ0Nql8sH/0k7s6dpcKOMaJPWHvPcV4PI
eAHboTT6J6t4Z2zovlFLyO4THFPa6Ib9KA8hENqHPQ4VOAeGeeqp+2ACrJXjwSaG
nxe1u3gDGR/DTC2psJys/cjA+6oaIJubTUHIPMrdTVjwjYysdyHBaromTCHxXN+c
VLn+fjo+O/pPFGDYD37aXzhgTJBvpacUSltfN/sdae4ap+u6LQB53eV8u9Arm7lH
BS8RcV16srDVjR9W+Vw2eEkgmZAG20NtM+SjXz6did8iX5e8KDS8nEdAIbVbOCy4
7Vy0D2B9ak5b3mwFGV+7n/nF35A3LLNlmdP4NGGQLvdwlfMBMxdMgEB8LreVpf8=
=JVjL
-----END PGP SIGNATURE-----

--------------enigD99D3507C9612B7769610428--


--===============6052772135936892136==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6052772135936892136==--
