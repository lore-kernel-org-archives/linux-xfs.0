Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2RGVm8x253349 for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 11:31:58 -0500
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56EDA1CCFBA
	for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 09:31:02 -0700 (PDT)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id NoZ9vg5lwpHpCso5 for
	<xfs@oss.sgi.com>; Fri, 27 Mar 2009 09:31:02 -0700 (PDT)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Fri, 27 Mar 2009 12:30:59 -0400
References: <200902240010.25434.vapier@gentoo.org>
	<200903081409.28808.agruen@suse.de>
	<20090327160204.GA9306@infradead.org>
In-Reply-To: <20090327160204.GA9306@infradead.org>
MIME-Version: 1.0
Message-Id: <200903271231.01055.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8452216075095254796=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: nathans@debian.org, xfs-oss <xfs@oss.sgi.com>, Eric Sandeen <sandeen@sandeen.net>

--===============8452216075095254796==
Content-Type: multipart/signed;
  boundary="nextPart2531250.rhzhurNsDd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2531250.rhzhurNsDd
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 27 March 2009 12:02:04 Christoph Hellwig wrote:
> I did some make dist and build the tarball tests with
> acl,attr,xfsprogs & co.
>
> We still run libtoolize, aclocal and autoconf when building a clean
> tree.  I wonder if we should just get rid of the whole configure target
> and require a manual ./configure like most tools?

`make dist` should produce a tarball that, when unpacked, people can run:
./configure && make && make install
-mike

--nextPart2531250.rhzhurNsDd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJzP9EAAoJEEFjO5/oN/WBPsYP/3U7Jxx00499xHd1+EHXCfPn
0FHGvSxuDbf5ibVaYORgozEkJT0cnhXjl8dFjes5ZSvx6xHIe4/8LU2WbCZIVitW
cpGIRuDQjylzuJ+SzcmZ3PutsOH/RqA7XoXmVfnCDpuXiUa4o3h/nvMt5o6B3ZfJ
zLaP4QONuAWvTBdtilFjT/RaEOqT/8kwNSVuyc2X2OAVkgFqe9evcnKdv4dModj1
MmbL7w2qotP4fBFVuHfyQJ8MjJYj6vRCAvQtq1d5c1M0wD8ZJAgNLAR14mTFaLCs
hzRBDKoId/onYhA/YtQDYE54zNRaLMC5rTAB7m+roRoqDLWw/lyC74rFeN+w1l25
WVEC32OlQneLrbt59lMXoD3u2jmDttb28DEE9ZkS+TYwGy5Ruo1zdTLgmUlHNw2k
PnyKMJGbqboan+Eo27W+9tWvRhXVjHXfCnmGyLPgbHE3fqpOitbMO8Hob0obaZ5B
91s0ss3+yEa5LzhsfHRUP7atFaD9dUt4tgenFlqMpYBeg7+OpXt5bNckBdiEWXi3
5mbdmjrahlnjQn3WoHHWmQlXHG7VVq6gpVkbSDJZFodCexn9KpRvGqsNA+BSM+Pv
Tj/tPiSEY/y2Vkr5nc/BP7rIGMSEwz5IRqEQbtpPreni8P92O1Jluhsr/OGlIlB+
+0MpVfT7MGh8T5nZT0aC
=QfBO
-----END PGP SIGNATURE-----

--nextPart2531250.rhzhurNsDd--


--===============8452216075095254796==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8452216075095254796==--
