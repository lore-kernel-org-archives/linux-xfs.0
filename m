Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA1EA7F37
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 07:54:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B24830404E
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 05:54:01 -0700 (PDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	paiV3Moc4oJ4Muzo (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2015 05:53:58 -0700 (PDT)
Received: by wiclk2 with SMTP id lk2so25954125wic.1
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 05:53:57 -0700 (PDT)
Date: Tue, 15 Sep 2015 14:53:55 +0200
From: Iustin Pop <iustin@k1024.org>
Subject: Re: xfsrestore and multi-tape backups
Message-ID: <20150915125355.GA28436@teal.hq.k1024.org>
References: <20150908144806.GA22811@teal.hq.k1024.org>
	<20150915093653.GA31370@teal.hq.k1024.org>
	<55F80B70.4090103@opensuse.org>
MIME-Version: 1.0
In-Reply-To: <55F80B70.4090103@opensuse.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8677619360139412377=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>


--===============8677619360139412377==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2015-09-15 14:13:36, Carlos E. R. wrote:
> On 2015-09-15 11:36, Iustin Pop wrote:
> > So what's the correct way to restore a multi-tape dump? (Man page
> > says to start with tape 1, but that doesn't seem to be working).
>=20
> I don't know about your case, so I maybe totally wrong. But it is
> possible that the catalog or index is stored on the last tape only,
> which might explain why starting with the second tape works (if I read
> correctly your post).

I suspect as much myself - since if during the backup if you run out of
tape writing a normal object, you can't write the index anymore.

But then why does the man page recommend starting with the first tape?
And why, when starting with the last tape, doesn't it know exactly which
tapes are needed?

If the man page is just wrong, I'll happily update it. Just want to get
a confirmation from someone familiar with the code.

thanks!
iustin

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJV+BTjAAoJEPZuPkGfhPTedlQP/1qp/oGey1NO7bGT9AFG+zpV
/53eBGPne2wRc+EOElszqalDZIiNYhH1pzyMD2xopHtB4TmSwGq/biVP7Vj1P/Vf
X6xhvTNtAQxuM7GdpWxtxVc/lsQ9YX5fEXLHG8Vh/BuxflA8Y1mDIFfT+YD9+OX7
TeFlPiaOZh0PntFVLBFLhDs0gX3C6CnSX+Vm9m/I50p4rfRbR9IyvmW+/V0hQxPA
a0hnC57H8JcdplmB/djDZIbNZTMgZ/nuwT3+Hx9GY2IVsqqSgHeORUoee8de7al+
9qVHDo8B/mCQC5q383Sk6FNoRvHthOquMPbMrNJjo33/L2p6gOUTWep5VCLylB2m
Qg9W6Gs+EsZMgn5CeUdph5HquRumf4ejThPxaG4lurjRWBIvXXALXh5DXwP32nbH
3WGRaJfsV4ZCy/ht9RItWmSIuC0YKYKSRCUTz2AlETBQZ4/rMeBXaCAoGEUaXCJT
3OUUPmY3EUi5pD29CB23iefp9ysD61mFZSt+14ixjm/psX70+FIiqSItI08yoifK
j3X+CNUvkDJldiiugPLPJrZvh01SDWm2PlHhW1looAOWlKz4R4nXt5OctvfvSu2D
Ll5aDUvA9OlnN1nHx0Ch5yobjnVOKH5t7MuncetHf/W6JlGDCCqwsTPFl2UjDWqP
NetghZDmcp5dpdY/ty6N
=8r/8
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--


--===============8677619360139412377==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8677619360139412377==--
