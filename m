Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1T20UjD235334 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 20:00:30 -0600
Received: from nm39-vm7.bullet.mail.ne1.yahoo.com
	(nm39-vm7.bullet.mail.ne1.yahoo.com [98.138.229.167]) by
	cuda.sgi.com with SMTP id 6lg4rUHJceuuDISL for
	<xfs@oss.sgi.com>; Tue, 28 Feb 2012 18:00:28 -0800 (PST)
Message-ID: <1330480826.9688.23.camel@core24>
Subject: Re: Poor performance using discard
From: Thomas Lynema <lyz27@yahoo.com>
Date: Tue, 28 Feb 2012 21:00:26 -0500
In-Reply-To: <20120229012259.GW3592@dastard>
References: <1330469778.9688.7.camel@core24> <20120229012259.GW3592@dastard>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1529318294775511338=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============1529318294775511338==
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Yq7EFps2zeoZy+qiLG9T"


--=-Yq7EFps2zeoZy+qiLG9T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable




On Wed, 2012-02-29 at 12:22 +1100, Dave Chinner wrote:
> On Tue, Feb 28, 2012 at 05:56:18PM -0500, Thomas Lynema wrote:
> > Please reply to my personal email as well as I am not subscribed to the
> > list.
> >=20
> > I have a PP120GS25SSDR it does support trim=20
> >=20
> > cat /sys/block/sdc/queue/discard_max_bytes=20
> > 2147450880
> >=20
> > The entire drive is one partition that is totally used by LVM.
> >=20
> > I made a test vg and formatted it with mkfs.xfs.  Then mounted it with
> > discard and got the following result when deleting a kernel source:
> >=20
> > /dev/mapper/ssdvg0-testLV on /media/temp type xfs
> > (rw,noatime,nodiratime,discard)
> >=20
> > time rm -rf linux-3.2.6-gentoo/
> > real   5m7.139s
> > user   0m0.080s
> > sys   0m1.580s=20
> >=20
>=20
> I'd say your problem is that trim is extremely slow on your
> hardware. You've told XFS to execute a discard command for every
> single extent that is freed, and that can be very slow if you are
> freeing lots of small extents (like a kernel tree contains) and you
> have a device that is slow at executing discards.
>=20
> > There where lockups where the system would pause for about a minute
> > during the process.
>=20
> Yup, that's because it runs as part of the journal commit
> completion, and if your SSD is extremely slow the journal will stall
> waiting for all the discards to complete.
>=20
> Basically, online discard is not really a smart thing to use for
> consumer SSDs. Indeed, it's just not a smart thign to run for most
> workloads and use cases precisely because discard is a very slow
> and non-queuable operation on most hardware that supports it.
>=20
> If you really need to run discard, just run a background discard
> (fstrim) from a cronjob that runs when the system is mostly idle.
> You won't have any runtime overhead on every unlink but you'll still
> get the benefit of discarding unused blocks regularly.
>=20
> > ext4 handles this scenerio fine:
> >=20
> > /dev/mapper/ssdvg0-testLV on /media/temp type ext4
> > (rw,noatime,nodiratime,discard)
> >=20
> > time rm -rf linux-3.2.6-gentoo/
> >=20
> > real   0m0.943s
> > user   0m0.050s
> > sys   0m0.830s=20
>=20
> I very much doubt that a single discard IO was issued during that
> workload - ext4 uses the same fine-grained discard method XFS does,
> and it does it at journal checkpoint completion just like XFS. So
> I'd say that ext4 didn't commit the journal during this workload,
> and no discards were issued, unlike XFS.
>=20
> So, now time how long it takes to run sync to get the discards
> issued and completed on ext4. Do the same with XFS and see what
> happens. i.e.:
>=20
> $ time (rm -rf linux-3.2.6-gentoo/ ; sync)
>=20
> is the only real way to compare performance....
>=20
> > xfs mounted without discard seems to handle this fine:
> >=20
> > /dev/mapper/ssdvg0-testLV on /media/temp type xfs
> > (rw,noatime,nodiratime)
> >=20
> > time rm -rf linux-3.2.6-gentoo/
> > real	0m1.634s
> > user	0m0.040s
> > sys	0m1.420s
>=20
> Right, that's how long XFS takes with normal journal checkpoint
> IO latency. Add to that the time it takes for all the discards to be
> run, and you've got the above number.
>=20
> Cheers,
>=20
> Dave.


Dave and Peter,

Thank you both for the replies.  Dave, it is actually your article on
lwn and presentation that you did recently that lead me to use xfs on my
home computer.

Let's try this with the sync as Dave suggested and the command that
Peter used:

mount /dev/ssdvg0/testLV -t xfs -o
noatime,nodiratime,discard /media/temp/

time sh -c 'sysctl vm/drop_caches=3D3; rm -r linux-3.2.6-gentoo; sync'
vm.drop_caches =3D 3

real	6m35.768s
user	0m0.110s
sys	0m2.090s

vmstat samples.  Not putting 6 minutes worth in the email unless it is
necessary.

procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 0  1   3552 6604412      0 151108    0    0  6675  5982 3109 3477  3 24
55 18
 0  1   3552 6594756      0 161032    0    0  9948     0 1655 2006  1  1
74 24
 0  1   3552 6587068      0 168672    0    0  7572     8 2799 3130  1  1
74 24
 1  0   3552 6580744      0 174852    0    0  6288     0 2880 3215  6  2
74 19
----i/o wait here----
 1  0   3552 6580496      0 174972    0    0     0     0  782 1110 22  4
74  0
 1  0   3552 6580744      0 174972    0    0     0     0  830 1194 22  4
74  0
 1  0   3552 6580744      0 174972    0    0     0     0  771 1117 23  3
74  0
 1  0   3552 6580744      0 174972    0    0     0     4 1538 2637 30  5
66  0
 1  0   3552 6580744      0 174972    0    0     0     0 1168 1946 26  3
72  0
 1  0   3552 6580744      0 174976    0    0     0     0  762 1169 23  4
73  0


 1  0   3552 6580528      0 175052    0    0     0     0  785 1138 25  2
73  0
 2  0   3552 6580528      0 175052    0    0     0     0  868 1350 24  7
69  0
 1  0   3552 6580528      0 175052    0    0     0     0  866 1259 24  5
72  0
 1  0   3552 6580528      0 175052    0    0     0     8  901 1364 26  5
69  0
procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 2  0   3552 6586348      0 175540    0    0   728  1069 1187 2057 26  7
66  1
 2  0   3552 6583344      0 176068    0    0  1812     4 1427 2350 24  8
65  2
 1  0   3552 6580920      0 177116    0    0  1964     0 1220 1961 25  8
67  1
 1  0   3552 6566616      0 190232    0    0 13376     0 1291 1938 24  7
62  8
 1  1   3552 6561780      0 193380    0    0  3344    12 1081 1953 22  4
58 15
 1  1   3552 6532148      0 200548    0    0  7236     0 10488 3630 35
11 42 13
 1  0   3552 6518508      0 200748    0    0   200     0 1929 4038 35 11
52  1
 2  0   3552 6516516      0 200828    0    0    57     0 1308 2019 24  6
69  0

EXT4 sample

mkfs.ext4 /dev/ssdvg0/testLV
mount /dev/ssdvg0/testLV -t ext4 -o
discard,noatime,nodiratime /media/temp/


time sh -c 'sysctl vm/drop_caches=3D3; rm -r linux-3.2.6-gentoo; sync'
vm.drop_caches =3D 3

real	0m2.711s
user	0m0.030s
sys	0m1.330s

#because I didn't believe it, I ran the command a second time.

time sync

real	0m0.157s
user	0m0.000s
sys	0m0.000s
0m1.420s

vmstat 1

procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 1  0   3548 5474268  19736 1191868    0    0     0     0 1274 2097 25
3 72  0
 1  0   3548 5474268  19736 1191872    0    0     0     0 1027 1614 26
3 71  0
 2  1   3548 6649292   4688 154264    0    0  9512     8 2256 3267 11 18
58 12
 2  2   3548 6633188  15920 161592    0    0 18788  7732 5137 6274  5 17
49 29
 0  1   3548 6623044  19624 167936    0    0  9948 10081 3233 4810  4  7
54 35
 0  1   3548 6621556  19624 170068    0    0  2112  2642 1294 2135  4  1
72 23
 0  2   3548 6611140  19624 179420    0    0 10260    50 1677 2930  7  2
64 27
 0  1   3548 6606660  19624 183828    0    0  4181    32 2192 2707  6  2
67 26
 1  0   3548 6604700  19624 185864    0    0  2080     0  961 1451  7  2
74 17
 1  0   3548 6604700  19624 185864    0    0     0     0  966 1715 24  3
73  0
 2  0   3548 6604700  19624 185864    0    0     8   196 1025 1582 24  4
72  0
 1  0   3548 6604700  19624 185864    0    0     0     0 1133 1901 24  3
73  0


This time, I ran a sync.  That should mean all of the discard operations
were completed...right?

If it makes a difference, when I get the i/o hang during the xfs
deletes, my entire system seems to hang.  It doesn't just hang that
particular mounted volumes' i/o.

Please let me know if there anything obvious that I'm missing from this
equation.

~tom


--=-Yq7EFps2zeoZy+qiLG9T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk9NhroACgkQ1SP4uQI29eFNOQCdFqf25AmHTHxW3czhA30T8TtA
N1EAoJjY3Q5kDWOj/seifvdf7OFNQudR
=ERwW
-----END PGP SIGNATURE-----

--=-Yq7EFps2zeoZy+qiLG9T--


--===============1529318294775511338==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1529318294775511338==--
