Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 22:41:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m335fPl1013122
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 22:41:26 -0700
Received: from smtps.tip.net.au (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 612B67336D5
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2008 22:42:00 -0700 (PDT)
Received: from smtps.tip.net.au (chilli.pcug.org.au [203.10.76.44]) by cuda.sgi.com with ESMTP id GpkLCf7mUexoKBfv for <xfs@oss.sgi.com>; Wed, 02 Apr 2008 22:42:00 -0700 (PDT)
Date: Thu, 3 Apr 2008 16:41:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 4/7] XFS: Return case-insensitive match for dentry cache
Message-Id: <20080403164120.87e2e44b.sfr@canb.auug.org.au>
In-Reply-To: <20080403052209.GR103491721@sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com>
	<20080402062708.654277049@chook.melbourne.sgi.com>
	<20080403052209.GR103491721@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Apr_2008_16_41_20_+1100_c+Qi.M.Lqw5pZLpj"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

--Signature=_Thu__3_Apr_2008_16_41_20_+1100_c+Qi.M.Lqw5pZLpj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 3 Apr 2008 15:22:09 +1000 David Chinner <dgc@sgi.com> wrote:
>
> On Wed, Apr 02, 2008 at 04:25:12PM +1000, Barry Naujok wrote:
> > This implements the code to store the actual filename found
> > during a lookup in the dentry cache and to avoid multiple entries
> > in the dcache pointing to the same inode.

I haven't really been following this, but I was wondering if this could
be made generic and used in the CIFS code as well.  They currently (I
think) have an awefull hack where they update the name in the dentry
(which throws a warning about dropping a const attribute in the memcpy).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Apr_2008_16_41_20_+1100_c+Qi.M.Lqw5pZLpj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH9G4FTgG2atn1QN8RAlVEAJ93zSowne9T1LxgC2zOGYJNVJZ/qwCeMO1U
Xe9szYD4r2MkJMjvBeF6nBA=
=ECoH
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Apr_2008_16_41_20_+1100_c+Qi.M.Lqw5pZLpj--
