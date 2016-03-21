Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8164E7CA3
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 13:21:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5558E30405F
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 11:21:56 -0700 (PDT)
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148]) by cuda.sgi.com
	with ESMTP id y1mWzDV5ZBXBRHoq (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 11:21:50 -0700 (PDT)
Date: Mon, 21 Mar 2016 19:20:57 +0100
From: Michael Adam <obnox@samba.org>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
Message-ID: <20160321182057.GF1044@samba.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<20160311140134.GA14808@infradead.org>
	<CAHc6FU4t3yisCM=MXrHRmCja_A8eZOpVa1smJ0gUhv+vuUAuXA@mail.gmail.com>
	<20160315071103.GC19747@infradead.org>
	<20160315154514.GB39038@jra3> <20160315201700.GA22945@sernet.de>
MIME-Version: 1.0
In-Reply-To: <20160315201700.GA22945@sernet.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1741686233670588807=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Volker Lendecke <Volker.Lendecke@SerNet.DE>, Christoph Hellwig <hch@infradead.org>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, Jeremy Allison <jra@samba.org>


--===============1741686233670588807==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NklN7DEeGtkPCoo3"
Content-Disposition: inline


--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2016-03-15 at 21:17 +0100, Volker Lendecke wrote:
> On Tue, Mar 15, 2016 at 08:45:14AM -0700, Jeremy Allison wrote:
> > On Tue, Mar 15, 2016 at 12:11:03AM -0700, Christoph Hellwig wrote:
> > > People have long learned that we only have 'alloc' permissions.  Any
> > > model that mixes allow and deny ACE is a mistake.
> >=20
> > People can also learn and change though :-). One of the
> > biggest complaints people deploying Samba on Linux have is the
> > incompatible ACL models.
>=20
> Just to confirm: I see this a lot in the field. NFSv4 ACLs, while not a
> perfect match for NTFS ACLs are a lot closer much more usable to people
> who want to serve Windows clients.
>=20
> Also in the pure linux world there is a lot that you can not express
> with just rwx, sgid, sticky bits and friends. If you want the additional
> functionality of the richacl bits, I would call it a big mistake to
> omit negative aces, if just for the reason not to create yet another
> ACLs flavor.
>=20
> > Whilst I have sympathy with your intense dislike of the
> > Windows ACL model, this comes down to the core of "who
> > do we serve ?"
>=20
> The world has enough confusion around ACL semanics, please do not add
> more to it by creating your own model of the day.

Exacty: Like it or not, Windows ACLs are a fact. And the
approximation by the NFSv4 ACLs is getting closer and closer
with each iteration... ;-) So it is not only that Windows world
looking into this.

As Volker and Jeremy have pointed out, the lack of ACL semantics
is one of things the users of Samba complain about most bitterly.
While Samba can work around it when it is acting exclusively on
the files, this is not an option when NFS or other protocols are
to access the data concurrently. In that case we need more
precision down in the file system. So because they make use of
*existing* formats and semantics, I think Andreas' richacls are
just the way to go, as alien as they may seem from the pure linux
filesystem point of view at first.

Cheers - Michael

--NklN7DEeGtkPCoo3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: comment

iEYEARECAAYFAlbwO4kACgkQyU9JOBhPkDSbLgCgg014joqbBszyQNQOfv6cNSVX
GSIAoJHvKMybjmmMy0l/xqCBjTDuVjzS
=vumV
-----END PGP SIGNATURE-----

--NklN7DEeGtkPCoo3--


--===============1741686233670588807==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1741686233670588807==--
