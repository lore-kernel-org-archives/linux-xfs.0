Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5F9qODA076905 for <xfs@oss.sgi.com>; Fri, 15 Jun 2012 04:52:24 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id nah0qznNfabx52Cj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Jun 2012 02:52:21 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106014.dyn.cm.kabsi.at [81.217.106.14])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id CADE1182242B
	for <xfs@oss.sgi.com>; Fri, 15 Jun 2012 11:52:18 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id C11AACD7C8C
	for <xfs@oss.sgi.com>; Fri, 15 Jun 2012 11:53:45 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
Date: Fri, 15 Jun 2012 11:52:17 +0200
Message-ID: <47854255.KfXFdqTbOZ@saturn>
In-Reply-To: <20120615001602.GF7339@dastard>
References: <4FD66513.2000108@xsnews.nl> <4FD9F5B3.3040901@xsnews.nl>
	<20120615001602.GF7339@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6265942276436351649=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6265942276436351649==
Content-Type: multipart/signed; boundary="nextPart1580229.4qEDSPxr3i"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart1580229.4qEDSPxr3i
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Freitag, 15. Juni 2012, 10:16:02 schrieb Dave Chinner:
> So, the average service time for an IO is 10-16ms, which is a seek
> per IO. You're doing primarily 128k read IOs, and maybe one or 2
> writes a second. You have a very deep request queue: > 512 requests.
> Have you tuned /sys/block/sda/queue/nr_requests up from the default
> of 128? This is going to be one of the causes of your problems - you
> have 511 oustanding write requests, and only one read at a time.
> Reduce the ioscehduer queue depth, and potentially also the device
> CTQ depth.

Dave, I'm puzzled by this. I'd believe that a higher #req. would help=20=

the block layer to resort I/O in the elevator, and therefore help to=20=

gain throughput. Why would 128 be better than 512 here?

And maybe Matthew could profit from limiting the vm.dirty_bytes, I've=20=

seen when this value is too high the server stucks on lots of writes,=20=

for streaming it's better to have this smaller so the disk writes can=20=

keep up and delays are not too long.

> Oh, I just noticed you are might be using CFQ (it's the default in
> dmesg). Don't - CFQ is highly unsuited for hardware RAID - it's
> hueristically tuned to work well on sngle SATA drives. Use deadline,
> or preferably for hardware RAID, noop.

Wouldn't deadline be better with a higher rq_qu size? As I understand=20=

it, noop only groups adjacent I/Os together, while deadline does a bit=20=

more and should be able to get bigger adjacent I/O areas because it=20
waits a bit longer before a flush.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1580229.4qEDSPxr3i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk/bBdEACgkQzhSR9xwSCbRQqwCfZHLzIq0OWxIGd3AI7PjC55PF
skEAn2PRHzn54RnosMSAVThbuXA2l6Zc
=U8sC
-----END PGP SIGNATURE-----

--nextPart1580229.4qEDSPxr3i--


--===============6265942276436351649==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6265942276436351649==--
