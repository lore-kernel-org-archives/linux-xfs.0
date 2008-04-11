Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 09:40:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3BGeINV024259
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 09:40:19 -0700
Received: from smtp-out4.iol.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E136B781CD1
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 09:40:56 -0700 (PDT)
Received: from smtp-out4.iol.cz (smtp-out4.iol.cz [194.228.2.92]) by cuda.sgi.com with ESMTP id SK959vpqVT8W25iv for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 09:40:56 -0700 (PDT)
Received: from antivir6.iol.cz (unknown [192.168.30.215])
	by smtp-out4.iol.cz (Postfix) with ESMTP id 754DDCE5228
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 16:40:53 +0000 (UTC)
Received: from localhost (antivir6.iol.cz [127.0.0.1])
	by antivir6.iol.cz (Postfix) with ESMTP id 5708AAD0057
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 18:40:53 +0200 (CEST)
Received: from antivir6.iol.cz ([127.0.0.1])
	by localhost (antivir6.iol.cz [127.0.0.1]) (amavisd-new, port 10224)
	with LMTP id v6lMO3Jl5+Au for <xfs@oss.sgi.com>;
	Fri, 11 Apr 2008 18:40:53 +0200 (CEST)
Received: from smtp-out4.iol.cz (mta-out4 [192.168.30.31])
	by antivir6.iol.cz (Postfix) with ESMTP id 26495AD0058
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 18:40:53 +0200 (CEST)
Received: from gw.uhercice.ipv6ia.org (238.18.broadband9.iol.cz [90.176.18.238])
	by smtp-out4.iol.cz (Postfix) with ESMTP id ED08F7042AD
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 18:40:52 +0200 (CEST)
Received: from ou.uhercice.ipv6ia.org ([2002:5ab0:12ee:1:20c:f1ff:fe85:8b99] helo=ou)
	by gw.uhercice.ipv6ia.org with smtp (Exim 4.69)
	(envelope-from <petr.pisar@atlas.cz>)
	id 1JkMJ0-0000pR-H6
	for xfs@oss.sgi.com; Fri, 11 Apr 2008 18:40:50 +0200
Date: Fri, 11 Apr 2008 18:40:45 +0200
From: petr.pisar@atlas.cz
Subject: Re: Portability of libattr
Message-ID: <20080411164044.GA6928@ou.uhercice.ipv6ia.org>
References: <20080409184103.GD20142@album.bayer.ipv6ia.org> <20080409185445.GA30834@infradead.org> <47FF7D47.40007@thebarn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <47FF7D47.40007@thebarn.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 11, 2008 at 10:01:27AM -0500, Russell Cattelan wrote:
> I have not looked closely at the FreeBSD EA stuff so I don't know how
> different things are. I can't imagine they are that far off?
>
Unfortunatelly, I have no FreeBSD machine available now, but as I found in its
manual pages, they have splitted the names space and the rest of the EA name.
The namespaces are enumerated. So you can't just call
getxattr("user.mime_type', ...). Also they support reading EA from any
arbitrarry offset like Darwin. (Linux reads from first byte always). FreeBSD
API is little more rich.

> I thought the libattr code does compile on IRIX. There was an effort at one
> point to only have one usespace code base that worked on both linux and
> irix.
>
Great. Could you tell me which of these two APIs are the standard interface?
I'm a little confused about all the Linux code in libattr (like syscall
numbers) because glibc-2.6.1 has already syscall wrappers. So If added support
for Darwin of FreeBSD into libattr, which level should I implement?
attr_get(3) or getxattr(2/3) which is still parto of libattr? In other words:
Should I implement IRIX-styled API or the Linux-styled one?

-- Petr


--gKMricLos+KVdGMg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH/5SMuR4f4nEwzHIRAoL4AKCEVaR2diluKfyhSel2QWk5n7674wCfcDEO
CM+reYTtlZ0tkNJ4YwX/c1o=
=uxz3
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
