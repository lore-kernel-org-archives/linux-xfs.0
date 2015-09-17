Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 24C0C7F47
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 19:47:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EC32E30404E
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 17:47:36 -0700 (PDT)
Received: from mail-wi0-f193.google.com (mail-wi0-f193.google.com
	[209.85.212.193]) by cuda.sgi.com with ESMTP id
	AxEHc9yrooC9ugtB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2015 17:47:34 -0700 (PDT)
Received: by wicxq10 with SMTP id xq10so1276071wic.2
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 17:47:33 -0700 (PDT)
Received: from Telcontar.valinor (3.Red-83-42-78.dynamicIP.rima-tde.net.
	[83.42.78.3]) by smtp.gmail.com with ESMTPSA id
	lh11sm7070156wic.18.2015.09.16.17.47.32 for <xfs@oss.sgi.com>
	(version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 16 Sep 2015 17:47:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 62BB960E7E
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 02:47:31 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id sML0khlo4tL0 for <xfs@oss.sgi.com>;
	Thu, 17 Sep 2015 02:47:30 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 9D32B606CF
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 02:47:30 +0200 (CEST)
Subject: Re: XFS FAQ - out of date?
References: <55FA0B1D.8000905@troja.ch>
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Message-ID: <55FA0DA2.5050609@opensuse.org>
Date: Thu, 17 Sep 2015 02:47:30 +0200
MIME-Version: 1.0
In-Reply-To: <55FA0B1D.8000905@troja.ch>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mail list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2015-09-17 02:36, Viktor Trojanovic wrote:
> Hi,
> 
> I just tried to do a fresh install of Arch Linux using XFS for my
> root system. According to the xfs.org FAQ, this is supported. But
> it didn't work.
> 
> I later found (very few) sources that confirmed that Grub is not 
> compatible with the current XFS level 5, that SuSE created a patch
> for the problem but it wasn't adopted upstream. If this is true,
> consider updating the FAQ. If it is not true, I would very much
> appreciate some hints how to do it properly.

I don't know if it is true or not, and I use openSUSE, so I'd have
that patch. However, in the past there have been problems with XFS and
grub, so my routine is to use a separate /boot partition and install
grub there.

- -- 
Cheers / Saludos,

		Carlos E. R.
		(from 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlX6DaAACgkQtTMYHG2NR9UlKQCbB4lfGsxqm/Niq6isjNqGn/Bi
n4EAn3t5NgIumeMwgrEnDxd18rPSoOGY
=Jufm
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
