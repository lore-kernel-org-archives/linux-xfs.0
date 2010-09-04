Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o84HDDDM062249 for <xfs@oss.sgi.com>; Sat, 4 Sep 2010 12:13:14 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F35515DFD7B
	for <xfs@oss.sgi.com>; Sat,  4 Sep 2010 10:24:44 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 6PJlSzK8GNNLEhwa for
	<xfs@oss.sgi.com>; Sat, 04 Sep 2010 10:24:44 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id A82E042B
	for <xfs@oss.sgi.com>; Sat,  4 Sep 2010 19:13:50 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 55934401C2F
	for <xfs@oss.sgi.com>; Sat,  4 Sep 2010 19:13:50 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: separate project quota from group quota (questions, design issues)
Date: Sat, 4 Sep 2010 19:13:49 +0200
References: <201009041000.55878.arekm@maven.pl>
In-Reply-To: <201009041000.55878.arekm@maven.pl>
MIME-Version: 1.0
Message-Id: <201009041913.49849@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9195721261779496571=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============9195721261779496571==
Content-Type: multipart/signed;
  boundary="nextPart1452010.VipQlhjGaA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1452010.VipQlhjGaA
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Samstag, 4. September 2010 Arkadiusz Miskiewicz wrote:
> My goal is to be able to use user, group and project quota at the
>  same time.  Example usage is a web hosting company which gives some
>  space for customer (group quota), customer splits it into accounts
>  (user quota) and then each account can have multiple vhosts with own
>  quota (project quota).
=20
Nice idea. I'd also like that, but also mixed:
userdir1 -> user quota
userdir2
prjdir1 -> project quota
prjdir2
groupdir1 -> group quota for a group of users=20
groupdir2 -> for a group of projects

=46rom what you write, I'm sure you can't mix groups with users and=20
projects, instead it needs to be defined at mount time. It would be very=20
good if that can be mixed at the same time.

I'd like to say users1-5 can have 500G each, together 2T max. And=20
projects can have 2T each, but project1+2 together max. 2T. users6-9 can=20
have 100G each, together 100G max. Currently I defined everything as a=20
project, and manually check quotas for groups of projects if they cross=20
the "group max" border.


But I'd also be very interested in what you write above - it would be a=20
very welcome expansion of quotas which seems good. Just a question for=20
setup: We use all dirs side-by-side like
domain1
domain2
 |- prj1
 |- prj2
domain3
Now customer1 can have domain1 and domain2, customer2 has domain3. prj1=20
and prj2 can have prjquota. Am I right that this is possible with your=20
approach? Seems like, and I just want to ask to be sure I understand you=20
correctly.

Just how would you account that? Say each customer gets 20G, each domain=20
20G, projects 10G each. When above customer1 has 12G in domain1, he has=20
left 8G for domain2. Are projects also limited to 8G in sum, or is their=20
10G limit the one that's valid? If prj1 has 5G, is the 8G-5G=3D3G what's=20
available for domain2, or are projects completely separate?
I believe there are lots of variations and some people would like to=20
have it accounted, some not. Can this ever be solved?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1452010.VipQlhjGaA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyCfk0ACgkQzhSR9xwSCbR7xwCbBT/DrmvIyOkV0s4wiu+fKhhw
eOoAn2+HO3lOpZzF+7kdEAsFzOo0YI7f
=4sc8
-----END PGP SIGNATURE-----

--nextPart1452010.VipQlhjGaA--


--===============9195721261779496571==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9195721261779496571==--
