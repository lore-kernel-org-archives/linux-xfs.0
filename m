Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82BoUUx261420 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 06:50:40 -0500
Received: from QMTA03.westchester.pa.mail.comcast.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5ABB241AE9B
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 04:51:26 -0700 (PDT)
Received: from QMTA03.westchester.pa.mail.comcast.net
	(qmta03.westchester.pa.mail.comcast.net [76.96.62.32]) by
	cuda.sgi.com with ESMTP id s7rpZksdLmc0Dx6n for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 04:51:26 -0700 (PDT)
Date: Wed, 2 Sep 2009 06:51:23 -0500
From: Tim Walberg <twalberg@comcast.net>
Subject: Re: xfs compat_ioctl?
Message-ID: <20090902115123.GA13355@comcast.net>
References: <4A9B759B.7020401@msgid.tls.msk.ru>
	<20090831123010.GA2368@infradead.org>
	<20090831183751.GC19343@comcast.net>
	<20090831184822.GA10393@infradead.org>
	<20090831184918.GB10393@infradead.org>
	<20090831190209.GD19343@comcast.net>
MIME-Version: 1.0
In-Reply-To: <20090831190209.GD19343@comcast.net>
Reply-To: Tim Walberg <twalberg@comcast.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3027215352312020063=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Tim Walberg <twalberg@comcast.net>, Christoph Hellwig <hch@infradead.org>, Linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com


--===============3027215352312020063==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Ok, that patch has fixed my issues with xfs_fsr. Now I just need to
pull a new copy of xfs_progs to get the xfs_db alignment issue fix...


		Thanks,
			tw


On 08/31/2009 14:02 -0500, Walberg, Tim wrote:
>>=09
>>=09
>>	On 08/31/2009 14:49 -0400, Christoph Hellwig wrote:
>>	>>	On Mon, Aug 31, 2009 at 02:48:22PM -0400, Christoph Hellwig wrote:
>>	>>	> On Mon, Aug 31, 2009 at 01:37:51PM -0500, Tim Walberg wrote:
>>	>>	> > Linux sparcy 2.6.30.4-sparcy #2 Sat Aug 1 21:14:46 CDT 2009 sparc=
64 GNU/Linux
>>	>>	> > sparcy:~# file $(which xfs_fsr)
>>	>>	> > /usr/sbin/xfs_fsr: ELF 32-bit MSB executable, SPARC32PLUS, V8+ Re=
quired, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Li=
nux 2.6.18, stripped
>>	>>	>=20
>>	>>	> I'll take a look at that, thanks.
>>	>>=09
>>	>>	Err, sorry - is that with the patch I posted in this thread or withou=
t?
>>	End of included message
>>=09
>>=09
>>	No, that's the generic 2.6.30.4... I can attempt with that patch as well=
, but
>>	it might be a day or two...
>>=09
>>					tw
>>=09


End of included message



--=20
twalberg@comcast.net

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqeXDsACgkQw+Wcj22rJWaHTgCcDXj5l5OCxgtqjI0yX3/iqjEz
I9gAnA1wnOpQh6vGhmNxMMvJOphas5tM
=mAQt
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--


--===============3027215352312020063==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3027215352312020063==--
