Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1EF467F37
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 03:11:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 081608F804B
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 01:11:55 -0800 (PST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id yH0LiMjFzkuic5o7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Dec 2015 01:11:50 -0800 (PST)
Received: by mail-wm0-f53.google.com with SMTP id n186so15559755wmn.0
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 01:11:50 -0800 (PST)
Date: Tue, 15 Dec 2015 10:11:45 +0100
From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: Re: BUG: KASAN: use-after-free in xfs_iflush_cluster+0x9d7/0xaf0
Message-ID: <20151215091145.GA19282@glen>
References: <20151214180048.GA15690@glen> <20151214195422.GM26718@dastard>
	<20151214201526.GA25152@glen> <20151214212220.GO26718@dastard>
MIME-Version: 1.0
In-Reply-To: <20151214212220.GO26718@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2455259296155599775=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com


--===============2455259296155599775==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 15, 2015 at 08:22:20AM +1100, Dave Chinner wrote:
> $ gdb vmlinux
> ....
> (gdb) l *(xfs_iflush_cluster+0x9d7)

It's not working. Shame on me, I forgot to set "Compile the kernel with debug info".

I'm recompiling, to try it again.
Maybe, in the meanwhile, you can do something with my files. You can find 'em here:
http://mail.gelma.net/xfs_kasan

Thanks a lot,
Andrea

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQJ8BAEBCgBmBQJWb9lRXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRFQTQyRTkzNjBCNzVERDZFODMyNTQ3RjdB
NDMwOTA3NUYwNTk2MEY2AAoJEKQwkHXwWWD2ENMP/0VmdE06ORv2nMHDtQ2tY0w2
XGG7iiOzANnR8VdTA9MO0rOPXjWSrKfEVKQ2uWKOxAFRaWjWonCnSOqwCrdRbfhJ
vH/gl3YdhJ0mIhCU/lgwXdQtGu8Ep/xbiWycYHLtmZ3kteoFCBp0fQeDRBXxV8L/
Tdtot6jQ425lumiB3AxhL7vflxF91Ryof11pq0Ot1JbeGjhgjCExrRl2qL284GmS
gEh30bPX3bWP/PsjW/qrwUQeM9nsPzHVmKCNoG0Glg8vloULD2TGNt3wqeXhv72H
xyUpBvY0FmqsRe+ipcDX9GUC0eAOdNt79TkmU/N7ff1FNWi6du87sYn3IISWGYfU
utYdx6zIWL+aWYypCVJKtDCs5GrojXRnnEmgyq0XU2WUw8ybUVXK5Ws+BgO2EMtU
5gI6x+OZW/sAiOspImKJvG7thAxSEiihCG0+SL97W1HUank4sQQMTUIBG+3k5L5r
LmZiggp+rI/LyCoEH+a5VKWnY44YRiuies2/mvHcRI4aszLv4Yfb64RSDBIoV18e
S+pJba/4zH5FESrWr2P1rHgUHJhGYq0XfGrfs2nGuGc7yMkCKO8e3X+DguIGlSk6
kzHuHMwEkrec3b+R6vtQZcohf9Zgka7sE+HcorcpH3BDDojHZTww/1p659Yuyxux
dehvRXRqXWtumCgh2+QY
=hgt9
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--


--===============2455259296155599775==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2455259296155599775==--
