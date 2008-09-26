Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 05:34:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8QCXtBi014220
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 05:33:56 -0700
Received: from turing-police.cc.vt.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 481AF1AF7249
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 05:35:30 -0700 (PDT)
Received: from turing-police.cc.vt.edu (turing-police.cc.vt.edu [128.173.14.107]) by cuda.sgi.com with ESMTP id wkXFAuXQHUyHSb9q for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 05:35:30 -0700 (PDT)
Subject: Re: [PATCH 3/3] Add timeout feature
In-Reply-To: Your message of "Fri, 26 Sep 2008 17:52:35 +0900."
             <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
From: Valdis.Kletnieks@vt.edu
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com>
            <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1222432525_7097P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Sep 2008 08:35:25 -0400
Message-ID: <35472.1222432525@turing-police.cc.vt.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org

--==_Exmh_1222432525_7097P
Content-Type: text/plain; charset=us-ascii

On Fri, 26 Sep 2008 17:52:35 +0900, Takashi Sato said:

(Sorry, am reading the threads out of temporal sequence....)

> I think that your concern is that the freezer cannot recognize the occurrence
> of a timeout and it continues the backup process and the backup data is
> corrupted finally.
> If the freezer can recognize it by the unfreeze ioctl's errono, will your concern
>  be solved?
> If so, I will implement it.

That would also address my concerns about merging patches 8 and 10 of the
other patch series (because patch 10 wouldn't be needed then)...


--==_Exmh_1222432525_7097P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI3NcNcC3lWbTT17ARAlfSAJ9koC6IkAWpTwgQQzzxs0CHDfWf6ACgzm8C
gDUF+0x2+mjqNZBumGOhqOA=
=x5uP
-----END PGP SIGNATURE-----

--==_Exmh_1222432525_7097P--
