Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A8227F3F
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 16:14:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0AE95AC003
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 14:14:31 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id SjOjVcYCtCkDhDlx (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Dec 2013 14:14:27 -0800 (PST)
Date: Fri, 27 Dec 2013 09:14:07 +1100
From: NeilBrown <neilb@suse.de>
Subject: Re: md-RAID5/6 stripe_cache_size default value vs performance vs
	memory footprint
Message-ID: <20131227091407.2ac401d1@notabene.brown>
In-Reply-To: <52BBF5B0.8020206@hardwarefreak.com>
References: <52B102FF.8040404@pzystorm.de> <52B2FE9E.50307@hardwarefreak.com>
	<52B41B67.9030308@pzystorm.de> <201312202343.47895.arekm@maven.pl>
	<52B57912.5080000@hardwarefreak.com>
	<20131226085510.GB32660@infradead.org>
	<52BBF5B0.8020206@hardwarefreak.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8430431263562188633=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============8430431263562188633==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tIziOH9cKrE+.8RfYN9tXTg"; protocol="application/pgp-signature"

--Sig_/tIziOH9cKrE+.8RfYN9tXTg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Dec 2013 03:24:00 -0600 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 12/26/2013 2:55 AM, Christoph Hellwig wrote:
> > On Sat, Dec 21, 2013 at 05:18:42AM -0600, Stan Hoeppner wrote:
> >> The powers that be, Linus in particular, are not fond of default
> >> settings that create a lot of kernel memory structures.  The default
> >> md-RAID5/6 stripe_cache-size yields 1MB consumed per member device.
> >=20
> > The default sizing is stupid as it basically makes RAID unusable out
> > of the box, I always have to fix that up, as well as a somewhat
> > reasonable chunk size for parity RAID to make it usable.  I'm also
> > pretty sure I complained about it at least once a while ago, but never
> > got a reply.
>=20
> IIRC you Dave C. and myself all voiced criticism after the default chunk
> size was changed from 64KB to 512KB.  I guess we didn't make a strong
> enough case to have it reduced, or maybe didn't use the right approach.
>=20
> Maybe Neil is waiting for patches to be submitted for changing these
> defaults, and to argue the merits in that context instead of pure
> discussion?  Dunno.  Just guessing.  Maybe he'll read this and jump in.
>=20

Good guess.

NeilBrown

--Sig_/tIziOH9cKrE+.8RfYN9tXTg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUryqLznsnt1WYoG5AQLoHg//UItjEDouIilQklR4madQsEbK3UCw7lII
eIA+mci0diPdTpgZa1PAXaeAU4A0hf1GNUaMXsZRMzeSiR2pfW+UVKDGG02VkzNz
QzchxXX6K5l1dNBQqcSGDtSKpcFuj9CJ0Z/GHdid/FzJVG9yJ3vYz9eLBk0UD6UA
4ehWxwhAjIA4pSmCJA81/T3n/cVPA53i8XWzXCCO5/sCZ9v6/pPxAt2TZKspbCZF
o/S+x5O9g8h7QHbiwT2BkdJaJMGB+BzqUe4N5Ytd74JF/a388BQgi7Z2ZFb2ihhW
USuMgt2JvRo50zYMiD9mnCSERAQWnNedUnWEnoj3y1cx0KeS1Fcce08MctQ578Q+
5jl0NMoqyvWZ60rmjfWGPKnyPlxuDkFhPH5fKouuwk3L93WwbvQMBRhgiG3qSTv8
kM5NGSRgbu/V6fU5ZU0fydwqpJfgo1oV26eiztPD/IBcK3EltJ8wtgFO36CO5Pa1
iYG19K79Zj099e2WdCdbi6nnhKdE2fQNsXcgGRMaBgkMxHN8kccvb91YzQBbqdVA
RDr5/8o9leukHuclL9EdRdwQoyEhgrbFTcbe5j+AcTv50MhNb5izCUeit63Plj73
xWw20eFaWq8DsEh0vvBA3SzuG+xeKWSBRtLiTNFQsAl6BuJFfVff4SdjirjQZRpm
x+LSZDZlv0g=
=NrrL
-----END PGP SIGNATURE-----

--Sig_/tIziOH9cKrE+.8RfYN9tXTg--


--===============8430431263562188633==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8430431263562188633==--
