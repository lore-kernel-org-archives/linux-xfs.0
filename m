Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6MBQrMx237278 for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 06:26:54 -0500
Received: from mail.michael-prokop.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A18E8ABFA7A
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 04:35:45 -0700 (PDT)
Received: from mail.michael-prokop.at (mail.michael-prokop.at [88.198.6.110])
	by cuda.sgi.com with ESMTP id 7L4K9EQMuSmk9eet for
	<xfs@oss.sgi.com>; Wed, 22 Jul 2009 04:35:45 -0700 (PDT)
Date: Wed, 22 Jul 2009 13:27:25 +0200
From: Michael Prokop <mika@grml.org>
Subject: Re: xfs tries to write on readonly device on unmount
Message-ID: <2009-07-22T13-22-51@devnull.michael-prokop.at>
References: <2009-07-21T12-28-50@devnull.michael-prokop.at>
	<20090721111909.GA29399@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20090721111909.GA29399@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4661825566266914863=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


--===============4661825566266914863==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Christoph Hellwig <hch@infradead.org> [20090721 13:19]:
> On Tue, Jul 21, 2009 at 12:51:20PM +0200, Michael Prokop wrote:

> > This issue might be related to
> > http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D413

> > A XFS partition is set to read-only mode (using 'blockdev --setro')
> > and mounted. As soon as I *un*mount the filesystem there seem to
> > happen write requests.

> > I've a Tableau Forensic Bridge? which avoids the write requests and
> > attached it to a Linux live-system running kernel 2.6.28 inside
> > VMware and Virtualbox. I can easily reproduce the problem.

> Block 0 is the superblock, so it appears like there is a superblock
> write somewhere not guarded by an read-only check.  Can you still
> reproduce this with a current kernel?  We now do have a testcase in
> xfsqa (test 200) that checks exactly that scenario, but it doesn't
> show issues on recent kernels.

I reran the test procedure with kernel 2.6.31-rc3 and could not
reproduce the issue.

Thanks.

regards,
-mika-
--=20
http://michael-prokop.at/  || http://adminzen.org/
http://grml-solutions.com/ || http://grml.org/

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKZved2N9T+zficugRAonRAJ9OJoS8M8eEzJu4QM+8G+JnR/bMDwCeMbYi
EPnW/npavyijj5fjPe5ZYQI=
=ZnLA
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--


--===============4661825566266914863==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4661825566266914863==--
