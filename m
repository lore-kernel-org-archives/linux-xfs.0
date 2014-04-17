Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6CDD87F53
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 21:38:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 40EA08F8039
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 19:38:49 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id zXvD964HAS6v2ywe (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 19:38:47 -0700 (PDT)
Date: Thu, 17 Apr 2014 12:38:37 +1000
From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 10/19] NET: set PF_FSTRANS while holding sk_lock
Message-ID: <20140417123837.5987e5e9@notabene.brown>
In-Reply-To: <20140416.090002.2186526865564557549.davem@davemloft.net>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040336.10604.96000.stgit@notabene.brown>
	<1397625226.4222.113.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140416.090002.2186526865564557549.davem@davemloft.net>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8009023064719903036=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: David Miller <davem@davemloft.net>
Cc: linux-nfs@vger.kernel.org, eric.dumazet@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org

--===============8009023064719903036==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SSVtvNA+Qn7U/.GV8.0daYz"; protocol="application/pgp-signature"

--Sig_/SSVtvNA+Qn7U/.GV8.0daYz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Apr 2014 09:00:02 -0400 (EDT) David Miller <davem@davemloft.net>
wrote:

> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Tue, 15 Apr 2014 22:13:46 -0700
>=20
> > For applications handling millions of sockets, this makes a difference.
>=20
> Indeed, this really is not acceptable.

As you say...
I've just discovered that I can get rid of the lockdep message (and hence
presumably the deadlock risk) with a well placed:

		newsock->sk->sk_allocation =3D GFP_NOFS;

which surprised me as it seemed to be an explicit GFP_KERNEL allocation that
was mentioned in the lockdep trace.  Obviously these traces require quite
some sophistication to understand.

So - thanks for the feedback, patch can be ignored.

Thanks,
NeilBrown

--Sig_/SSVtvNA+Qn7U/.GV8.0daYz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU08+rTnsnt1WYoG5AQLRZhAAw2OqHGStjcH4tCI4w3eDMVb87MK1AVtQ
U3pUF/WbzPSl0yhxDaa3vIg6L2ogkASESK6Oiiu8PZbG3TunCNwq63XXTKvE6EIY
nABc2yOb9u/cixXtIuMC9E8ydnZa/dEkIyFY9oMXBjuOwb3L/ugKFm0upzBUVokw
VtyZs8rl9s9IwgvuErpFbDR3ZxEk0VaMdREFwGCpkUD6DjknMTpGdaUelPxe+DEd
Ffy6B7fjrkdG/8B4vYZKlW2c5on1lLqc+hgY24LrLUpLxHwu4HCuIrAuhzILDex/
X5hZbQQhj2reLB8rsqJWOjmKn19/y8EbapUwa6BUMkSVHDCf0voCUjkHI8dOYcvM
TnrmEzJS3Ym/x5rbenUCr2hEOEbZ80UEcMbdbrVm3rhPoMDtSifdtU2LEKro8oCk
GPoOR3fYSLyxXNGQTlGiG3vSuSAIxF8tznBLnuCPIAPXK8LtXIn3oIOxNsN1J/LK
TxZJsdA+I9YmV5uIn7cJarNYKdXvhR6x0YPoxUFzQZkngChosN3ZkGOHQeG2moyA
JewuEtWT5Z1n1as19big3XukdBNnhJ/B11DpyI3TlfhIYN0mROFEAQkvXuOYYO+o
CqkHfQp765IaTt0WOiVFu9bibhdxWwt1jwfasn1TE9LtvVlwlUlbPVL/8NrMXnOa
Nkz7UZ1IxWU=
=WfY/
-----END PGP SIGNATURE-----

--Sig_/SSVtvNA+Qn7U/.GV8.0daYz--


--===============8009023064719903036==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8009023064719903036==--
