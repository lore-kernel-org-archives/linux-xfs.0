Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7VIb6KE116113 for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 13:37:16 -0500
Received: from QMTA05.emeryville.ca.mail.comcast.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D2E31B241B8
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 11:37:58 -0700 (PDT)
Received: from QMTA05.emeryville.ca.mail.comcast.net
	(qmta05.emeryville.ca.mail.comcast.net [76.96.30.48]) by
	cuda.sgi.com with ESMTP id IswmKs3EloTGVikh for
	<xfs@oss.sgi.com>; Mon, 31 Aug 2009 11:37:58 -0700 (PDT)
Date: Mon, 31 Aug 2009 13:37:51 -0500
From: Tim Walberg <twalberg@comcast.net>
Subject: Re: xfs compat_ioctl?
Message-ID: <20090831183751.GC19343@comcast.net>
References: <4A9B759B.7020401@msgid.tls.msk.ru>
	<20090831123010.GA2368@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20090831123010.GA2368@infradead.org>
Reply-To: Tim Walberg <twalberg@comcast.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5130973962771996180=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Michael Tokarev <mjt@tls.msk.ru>, Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com


--===============5130973962771996180==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Content-Disposition: inline


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I still get these on 2.6.30.4 on sparc64 (32-bit userspace a la Debian etch=
):

sparcy:~# uname -a
Linux sparcy 2.6.30.4-sparcy #2 Sat Aug 1 21:14:46 CDT 2009 sparc64 GNU/Lin=
ux
sparcy:~# file $(which xfs_fsr)
/usr/sbin/xfs_fsr: ELF 32-bit MSB executable, SPARC32PLUS, V8+ Required, ve=
rsion 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18=
, stripped
sparcy:~# dmesg | grep xfs | tail -5
[62457.467755] ioctl32(xfs_fsr:18816): Unknown cmd fd(7) cmd(c0a8586d){t:'X=
';sz:168} arg(00028e30) on /export
[62473.400273] ioctl32(xfs_fsr:18816): Unknown cmd fd(7) cmd(c0a8586d){t:'X=
';sz:168} arg(00028e30) on /export
[62481.928844] ioctl32(xfs_fsr:18816): Unknown cmd fd(7) cmd(c0a8586d){t:'X=
';sz:168} arg(00028e30) on /export
[62486.304567] ioctl32(xfs_fsr:18816): Unknown cmd fd(7) cmd(c0a8586d){t:'X=
';sz:168} arg(00028e30) on /export
[62490.833736] ioctl32(xfs_fsr:18816): Unknown cmd fd(7) cmd(c0a8586d){t:'X=
';sz:168} arg(00028e30) on /export

Haven't tried rolling my own xfs_progs binaries yet. xfs_db also fails with
a "Bus error" immediately on startup, but that may be a completely different
issue...



				tw




On 08/31/2009 08:30 -0400, Christoph Hellwig wrote:
>>	On Mon, Aug 31, 2009 at 11:02:51AM +0400, Michael Tokarev wrote:
>>	> Hello!
>>	>
>>	> I tried to resize an xfs filesystem on 64bit 2.6.30 kernel
>>	> using 32bit userland, and that does not work, in dmesg I see:
>>	>
>>	> ioctl32(xfs_growfs:24426): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12=
} arg(ffa56df4) on /mnt
>>	> ioctl32(xfs_growfs:24427): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12=
} arg(ff991254) on /mnt
>>	>
>>	> so apparently there's no compat_ioctl layer for these ioctls.
>>	>
>>	> Are there any plans to add these? :)
>>=09
>>	Are you sure you're testing 2.6.30?  The copat ioctls were added in
>>	2.6.28.
>>	--
>>	To unsubscribe from this list: send the line "unsubscribe linux-kernel" =
in
>>	the body of a message to majordomo@vger.kernel.org
>>	More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>	Please read the FAQ at  http://www.tux.org/lkml/
End of included message



--=20
+----------------------+
| Tim Walberg          |
| 830 Carriage Dr.     |
| Algonquin, IL 60102  |
| twalberg@comcast.net |
+----------------------+

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqcGH8ACgkQw+Wcj22rJWb9gwCdEO1sUsrQJSOAIDeRojsbo85v
ogIAoPBya+Taay/5rIWTwxtU1wcOhCwo
=3hx+
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--


--===============5130973962771996180==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5130973962771996180==--
