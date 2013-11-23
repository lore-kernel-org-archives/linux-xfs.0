Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5250F7F3F
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 23:12:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3FFD78F8059
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 21:12:54 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id CtfM9S7GzrJlTJH3 for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 21:12:49 -0800 (PST)
Date: Sat, 23 Nov 2013 16:12:34 +1100
From: NeilBrown <neilb@suse.de>
Subject: Re: bio_add_page rw mode check by merge_bvec_fn
Message-ID: <20131123161234.20ae4f9d@notabene.brown>
In-Reply-To: <20131122153618.GB15143@infradead.org>
References: <528E4A50.7040609@itwm.fraunhofer.de>
	<528E4C19.70507@itwm.fraunhofer.de>
	<20131122153618.GB15143@infradead.org>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0646379520130984605=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, xfs@oss.sgi.com, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, Kent Overstreet <kmo@daterainc.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org

--===============0646379520130984605==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kJU+Y90G7.7Isi0HWk6i/YX"; protocol="application/pgp-signature"

--Sig_/kJU+Y90G7.7Isi0HWk6i/YX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Nov 2013 07:36:18 -0800 Christoph Hellwig <hch@infradead.org>
wrote:

> While this is trivial to fix it's also fairly unexpected and easy
> to get wrong for new callers.  Neil, can you explain why you
> desperately need it?

Desperately?  Not at all?
Need?  Not really.  This is just in RAID5 and merge_bvec_fn is purely an
optimisation for RAID5.
Limiting read BIOs to one chunk allows us to bypass the stripe-cache, so can
be good.
Limiting write BIOs is completely unnecessary so we currently don't bother.

So I have no objection to bvm->bi_rw being removed.

Thanks,
NeilBrown

--Sig_/kJU+Y90G7.7Isi0HWk6i/YX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpA5Qjnsnt1WYoG5AQJ0PQ//Tc7Z87QuBtjhXmEq8zwwumqR/Jzfg+ok
Q3VZBYu6kgpR2QZCoi94cdHo9vbmfHYcbrJT8DsheKvljqFOOb5uUsarbLmSI95P
FuUbSmUvmHMhh7N1dCovviFmiCuNwdFgsUbA3VpKsk/3LToypu2k/4jHP+WbbViW
7wTBjqSpM2XxZOLsPwJtBnRxJ/wiZ9tIgYk+8YYWnno/rmjPS2k12YOX6spCiKOs
ndB2NXyToMgBEJHRXXsIZrfnW3r9jGZEEbgcbiHrDyHWNPtwmSfIjI3D1iZZXAtw
Ip/mLaQDqKrwNdIO10rokNHJ8WFGEOuRMPgoH+GzmIrF59ONWkIdj/OX85Ruw9GR
CU8cKfaQFp4xQRflo5BZLycA7sRUixnCRUEaAUi4MkHKZRXQcc51bD3NYO5aqVty
OJGkQ1PQc3iUMkEpd8TDOk1AgNHJCvfla5brMKWWIxaraxzRt58wnSryh3KySInY
zGF9LU/16pkCKedTtkLfUYNkKvjYfYNu/TACDmfz+xKxnf1OcQQSyi1RQ5vvAXIj
bwxDsXRU6x4eeqoNuz5lOU5W9gjSd9gpsublcJLXQqfCneg9OG87s1bs0F16mDfm
q5hOjXikfpWGC8JhAtejfteW9sa4T021z1ircSCG4RhS9EQKNIwHn/dbEM3X4saS
vZMgRHYPECc=
=/BWO
-----END PGP SIGNATURE-----

--Sig_/kJU+Y90G7.7Isi0HWk6i/YX--


--===============0646379520130984605==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0646379520130984605==--
