Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6HLl7X6114480 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 16:47:07 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id oRSmCL8hwzqp99fd (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Jul 2012 14:47:05 -0700 (PDT)
Date: Wed, 18 Jul 2012 07:47:05 +1000
From: NeilBrown <neilb@suse.de>
Subject: Re: xfs/md filesystem hang on drive pull under IO with 2.6.35.13
Message-ID: <20120718074705.6a5521a6@notabene.brown>
In-Reply-To: <5005D661.8030200@dolby.com>
References: <5005D661.8030200@dolby.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5967948470848831245=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Benedict Singer <bzsing@dolby.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

--===============5967948470848831245==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w+Q/zFA2=x=f/24GqGso_ry"; protocol="application/pgp-signature"

--Sig_/w+Q/zFA2=x=f/24GqGso_ry
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jul 2012 14:17:21 -0700 Benedict Singer <bzsing@dolby.com> wrote:

> Hi XFS and MD experts,
>=20
> I'm experiencing a problem with a setup running XFS on top of an MD=20
> raid. The test I'm running is physically pulling a drive while the=20
> system is running, to simulate hardware failure. When the system is=20
> idle, this works fine; the md subsystem detects the missing drive and=20
> degrades the arrays, and everything keeps running fine. If I pull a=20
> drive while heavy IO activity (mostly if not completely reading) is=20
> happening on the XFS filesystem, then very often the filesystem seems to=
=20
> "hang" - both processes that were accessing the filesystem at the time=20
> hang, as well as any new ones like 'ls'. Luckily, the kernel noticed the=
=20
> hung processes and spit a bunch of useful information to syslog. The=20
> relevant snippets are reproduced below, including the messages=20
> indicating that the drive was pulled, along with other XFS/MD raid=20
> information from the system. The filesystem in question is on=20
> /dev/md126, mounted on /var/showstore, and the disk pulled was /dev/sda.=
=20
> Note that at the time this information was collected, the disk had been=20
> re-inserted and a rebuild was proceeding.
>=20
> Is this a bug (seems like a race condition leading to a deadlock?),=20
> and/or is there something to change in the way the system is set up to=20
> mitigate or workaround this?

Looks a lot like a bug in md.  It is waiting for the metadata to be marked
'dirty', and is waiting forever.=20

2.6.35 is a very old kernel.  It is entirely possible that the bug has been
fixed.
If you can reproduce with something newer I'd certainly be interested.

NeilBrown


--Sig_/w+Q/zFA2=x=f/24GqGso_ry
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAXdWTnsnt1WYoG5AQIBqBAApCSJIDN6+Ih9oatK6YjG1METuIlYgu3x
ioa+GyxirLjzmShEWPEz0I3H7TF9ie+uUq4oHkMwU+uT0jL04d++litboMTpBhPw
cPwBVg5U5DR28bBHJpqml0yHMY6kU7pGgAuXMBJXmtNBXfFkHW9oxBNdyuTY/ChK
xkmcnXc7NAbWSCnHx9FxUx6L7F/E+ejqegHdOyrpPKViElHFVW0+OqM1HUjmJq/M
f3y59U5txbPSDryJR0UsuN99B7WRtQ/H9mbs/qehsJOUTm3/i4O5eo2Navl23Ozn
bZdK4TUsB0dzkGw4jkuilDOzAaD0vnyR025f9jTyAWSnwWOOIjwp6NzqLBcLskTh
JqpiAmtBDZACK6pCcbbrcOK8YYe/yWt0BcxSAmFl0j5oAdAq8q0UnbOgEQbq4hm/
kC3Klo/DcYxYhZ0S4ajoJC1itp9yRHcwtgbRJ6cr8T88jjiGkitPrV8zHvJBNF6e
CGt982dWyXWLMRt/MEJ2JnFPb8i1t+huq/8TVsbjrnwjIE6tKoWxLbqbqSyAOw4O
0iq111T8ecMXsGA+FIdSs9ZTWQQzIP4bODCWkmXXmZDOposdQukDPxtNVnT8zJTd
zFcOo71OcSJgwdF1xiwQtiJR0zOA/dDdVeoH8z+IsNHmuqGftGBfwFBY2y3OTJ7b
gLwbiTXyIQQ=
=erAy
-----END PGP SIGNATURE-----

--Sig_/w+Q/zFA2=x=f/24GqGso_ry--


--===============5967948470848831245==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5967948470848831245==--
