Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 797A27CA0
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 05:48:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B9A48F8050
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 03:48:09 -0700 (PDT)
Received: from smtp.movistar.es (smtp20.acens.net [86.109.99.144]) by
	cuda.sgi.com with ESMTP id j0dAPPWVXKVtNFC0 for
	<xfs@oss.sgi.com>; Fri, 29 Jul 2016 03:48:06 -0700 (PDT)
Received: from minas-tirith.valinor (79.149.87.62) by smtp.movistar.es
	(8.6.122.03) (authenticated as robin.listas2)
	id 5784B02500FBDEBD for xfs@oss.sgi.com; Fri, 29 Jul 2016 10:48:05 +0000
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id 785C21814D8
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 12:48:04 +0200 (CEST)
Date: Fri, 29 Jul 2016 12:48:04 +0200 (CEST)
From: "Carlos E. R." <robin.listas@telefonica.net>
Subject: Re: partition 100% full No space left on device. looks like xfs is
	corrupted or a bug
In-Reply-To: <4278AB9734C1445A8E48635B155149F8@dinulap>
Message-ID: <alpine.LSU.2.20.1607291240530.18210@zvanf-gvevgu.inyvabe>
References: <4278AB9734C1445A8E48635B155149F8@dinulap>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	BOUNDARY="-1463758550-1875274906-1469789284=:18210"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463758550-1875274906-1469789284=:18210
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256



El 2016-07-29 a las 12:01 +0300, Lista Unx escribió:

>Hello xfs experts,
> 
>I am crawling in the dark from few days and I have no idea how to fix the following problem. On a centos 7 system:

I'm not an expert, far from it, but... may I suggest you add the output 
of a plain "mount" command? To show the partitions. Or perhaps:

lsblk --output NAME,TYPE,FSTYPE,SIZE,TYPE,MOUNTPOINT


- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlebNGQACgkQja8UbcUWM1y9WgEAhICHy+Td+nf5SFkIXshTL0hi
9KQinIbllstvICOAPhUBAIcP1gcc+LmfO6b4f4gsgUH6L3dwemQoeW6OYrdPvV/Q
=NyhW
-----END PGP SIGNATURE-----
---1463758550-1875274906-1469789284=:18210
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463758550-1875274906-1469789284=:18210--
