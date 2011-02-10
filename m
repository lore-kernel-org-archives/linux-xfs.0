Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1AKgrdd155992 for <xfs@oss.sgi.com>; Thu, 10 Feb 2011 14:42:54 -0600
Received: from skyrim.simplex.ro (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92D9ED5CAE0
	for <xfs@oss.sgi.com>; Thu, 10 Feb 2011 12:45:28 -0800 (PST)
Received: from skyrim.simplex.ro (skyrim.simplex.ro [109.169.51.118]) by
	cuda.sgi.com with ESMTP id q7AtaJwfhjGELLoB for
	<xfs@oss.sgi.com>; Thu, 10 Feb 2011 12:45:28 -0800 (PST)
Date: Thu, 10 Feb 2011 22:42:54 +0200
From: Petre Rodan <petre.rodan@simplex.ro>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20110210204254.GA10451@peter.simplex.ro>
References: <20101223165532.GA23813@peter.simplex.ro>
	<20101227021904.GA24828@dastard>
	<20101227061629.GA2275@pandora.simplex.ro>
	<20101227140750.GB24828@dastard>
	<20101227171939.GA7759@pandora.simplex.ro>
	<20101231001323.GD15179@dastard>
	<20110120100143.GA2007@peter.simplex.ro>
	<20110120234310.GV16267@dastard>
MIME-Version: 1.0
In-Reply-To: <20110120234310.GV16267@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4003501150447557150=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============4003501150447557150==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Dave,

On Fri, Jan 21, 2011 at 10:43:10AM +1100, Dave Chinner wrote:
> .....
> > in other words xfsyncd and xfsbufd now alternate at 18s intervals
> > keeping the drive busy with nothing constructive hours after the
> > last write to the drive.
>=20
> This is a different problem, and not one I've seen before. Looking
> at the traces, it appears that we have not empties the AIL. At
> least, that's what I'm assuming at this point because log IO
> completion is not updating log tail. When we start a log IO, we set
> the log header lsn to the current head:
>=20
> >    xfssyncd/sdc1-1413  [000]  3356.093456: xfs_log_reserve: dev 8:33 ty=
pe DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC=
_INITED reserveq empty writeq empty grant_reserve_cycle 2 grant_reserve_byt=
es 428523008 grant_write_cycle 2 grant_write_bytes 428523008 curr_cycle 2 c=
urr_block 836959 tail_cycle 2 tail_block 810683
>=20
> Which in this case is: curr_cycle 2 curr_block 836959
>=20
> When the log IO completes, that value gets written to the
> l_last_sync_lsn. When the AIL tail is removed, the tail lsn is
> updated to the new tail item. If the AIL is empty, then the
> l_last_sync_lsn is used. That means then next dummy transaction
> made to cover the log should have the cycle/block of the above
> current cycle.
>=20
> Instead, what I see is that the next dummmy transaction shows:
>=20
> >    xfssyncd/sdc1-1413  [000]  3392.067122: xfs_log_reserve: dev 8:33 ty=
pe DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC=
_INITED reserveq empty writeq empty grant_reserve_cycle 2 grant_reserve_byt=
es 428524032 grant_write_cycle 2 grant_write_bytes 428524032 curr_cycle 2 c=
urr_block 836961 tail_cycle 2 tail_block 810683
>=20
> The current head has moved: curr_cycle 2 curr_block 836961
>=20
> But the tail hasn't: tail_cycle 2 tail_block 810683
>=20
> So effectively we've got some item on the AIL that we haven't
> flushed and isn't being flushed by xfssyncd. That's the problem I
> need to get to the bottom of and it also explains why it's an
> intermitten problem...

I have been watching the stream of patches that go into 2.6.38, but I proba=
bly missed the one that might be the answer to the problem above. can you p=
lease tell me which one to try, or can I help with anything?

much appreciated,
peter


--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk1UTc4ACgkQixMPpwVd7zHJdgCdHM2LCCxx8R8BwV84/up+/UQa
MuUAn13msnxU+izQdOnzZf02T7YQZByL
=mSzf
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--


--===============4003501150447557150==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4003501150447557150==--
