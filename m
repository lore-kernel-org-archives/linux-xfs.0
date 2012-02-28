Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SMuQ4o223453 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 16:56:26 -0600
Received: from nm6-vm4.bullet.mail.ne1.yahoo.com
	(nm6-vm4.bullet.mail.ne1.yahoo.com [98.138.91.166]) by
	cuda.sgi.com with SMTP id MZBCK2RqEpT68roi for
	<xfs@oss.sgi.com>; Tue, 28 Feb 2012 14:56:25 -0800 (PST)
Message-ID: <1330469778.9688.7.camel@core24>
Subject: Poor performance using discard
From: Thomas Lynema <lyz27@yahoo.com>
Date: Tue, 28 Feb 2012 17:56:18 -0500
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2650297500839475855=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2650297500839475855==
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-u7ZEuJjPAnxQUM3IY6KY"


--=-u7ZEuJjPAnxQUM3IY6KY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please reply to my personal email as well as I am not subscribed to the
list.

I have a PP120GS25SSDR it does support trim=20

cat /sys/block/sdc/queue/discard_max_bytes=20
2147450880

The entire drive is one partition that is totally used by LVM.

I made a test vg and formatted it with mkfs.xfs.  Then mounted it with
discard and got the following result when deleting a kernel source:

/dev/mapper/ssdvg0-testLV on /media/temp type xfs
(rw,noatime,nodiratime,discard)

time rm -rf linux-3.2.6-gentoo/
real   5m7.139s
user   0m0.080s
sys   0m1.580s=20

There where lockups where the system would pause for about a minute
during the process.

ext4 handles this scenerio fine:

/dev/mapper/ssdvg0-testLV on /media/temp type ext4
(rw,noatime,nodiratime,discard)

time rm -rf linux-3.2.6-gentoo/

real   0m0.943s
user   0m0.050s
sys   0m0.830s=20

xfs mounted without discard seems to handle this fine:

/dev/mapper/ssdvg0-testLV on /media/temp type xfs
(rw,noatime,nodiratime)

time rm -rf linux-3.2.6-gentoo/
real	0m1.634s
user	0m0.040s
sys	0m1.420s

uname -a
Linux core24 3.2.5-gentoo #11 SMP PREEMPT Sat Feb 11 15:46:22 EST 2012
x86_64 Intel(R) Core(TM)2 Quad CPU Q6700 @ 2.66GHz GenuineIntel
GNU/Linux


Any suggestions?


--=-u7ZEuJjPAnxQUM3IY6KY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk9NW5cACgkQ1SP4uQI29eGyVwCfQfMzvh+nxhqUHdYvqhxvf6Kp
f/kAnR2JrhN4KDs5mdqGevyT8sZQTPYi
=1ANH
-----END PGP SIGNATURE-----

--=-u7ZEuJjPAnxQUM3IY6KY--


--===============2650297500839475855==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2650297500839475855==--
