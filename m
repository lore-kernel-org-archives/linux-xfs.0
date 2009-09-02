Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n821JHgJ222472 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 20:19:27 -0500
Received: from ngcobalt07.manitu.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76284419461
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 18:19:55 -0700 (PDT)
Received: from ngcobalt07.manitu.net (ngcobalt07.manitu.net [217.11.48.107])
	by cuda.sgi.com with ESMTP id r09e6zbC9kuoV71R for
	<xfs@oss.sgi.com>; Tue, 01 Sep 2009 18:19:55 -0700 (PDT)
From: Roland Eggner <edvx1@systemanalysen.net>
Subject: free space of root partition decreases unaccountably by some 1024
	blocks on every umount+linux shutdown : additional informations
Date: Wed, 2 Sep 2009 03:16:36 +0200
References: <200908121955.07682.edvx1@systemanalysen.net>
	<4A838598.4000608@sandeen.net>
In-Reply-To: <4A838598.4000608@sandeen.net>
MIME-Version: 1.0
Message-Id: <200909020316.48300.edvx1@systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7553921895753172842=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: SGI Project XFS mailing list <xfs@oss.sgi.com>

--===============7553921895753172842==
Content-Type: multipart/signed;
  boundary="nextPart4021922.nUrLzVR9CD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4021922.nUrLzVR9CD
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday August 13th 05:16:40 2009 Eric Sandeen wrote:
> Roland Eggner wrote:
> > On July 18th I noticed the first time this unaccountable decrease of fr=
ee space of my root partition /dev/hda7:
> > For at least several boot-shutdown-cycles it has decreased on every cyc=
le by some 1020 =E2=80=A6 1030 blocks from originally above 100 MB to 96 MB.
> > Expected change at most =C2=B11 block.  Neither xfs_check nor xfs_repai=
r -dn could detect any flaws.
> Maybe I missed it in the email, but how have you ruled out the
> possibility that files are simply growing, thereby using the space?
Look at the last but one paragraph in my mail from August 12th
http://oss.sgi.com/archives/xfs/2009-08/msg00113.html
(obviously the find argument =E2=80=9C-mount=E2=80=9D got lost on copy+past=
e, sorry).



=46acts summarized:
=2D---------------

(a)  Free space decreases unaccountably even if I circumvent all shutdown s=
cripts und shutdown by SysReq R S U B.  Note: no SIGTERM, no SIGKILL.

(b)  Unaccountable free space decrease is triggered EXACTLY, ALWAYS and EXC=
LUSIVELY by this =E2=80=9Cremount,ro=E2=80=9D.  Note: NOT by any other writ=
e activities.

(c)  Binary comparison of images written with dd exhibited NO unexpected wr=
ites to me (I do not have deeper knowledge of xfs internals):  in a particu=
lar case free space difference reported by df has been 1026 blocks =3D 1050=
624 byte, whereas count of differing bytes reported by =E2=80=9Ccmp -b -l=
=E2=80=9D has been only 135189.  =E2=80=9Ccmp -b -l=E2=80=9D DID exhibit ex=
pected writes e.g. /etc/mtab.  (Eric Sandeen got details via private mail a=
nd offered kindly to have a look at xfs_metadump extraction from this image=
s =E2=80=94 thanks!).

(d)  Until now I could NOT detect this problem at any other partition, it s=
eems that ONLY the root partition is affected.

(e)  I performed xfsdump | mkfs.xfs | xfsrestore and got back some 200 Mbyt=
e free space, but only temporarily =E2=80=94 at subsequent linux shutdowns =
free space CONTINUES to decrease, just starting from a new offset.

(f)  I booted a sidux image and reset the lazy-counter attribute by =E2=80=
=9Cxfs_admin -c 0=E2=80=9D =E2=9E=94 Apart from =E2=80=9CXFS: correcting sb=
_features alignment problem=E2=80=9D message at next mount, EXACTLY the sam=
e result as after measures (e).  (WARNING:  Never use =E2=80=9Cxfs_admin -c=
 0=E2=80=9D unless you have a current backup of your valuable data!!)

(g)  Kernel 2.6.30.4 shows the problem too.  (And introduces some other fla=
ws, =E2=80=9Cshow stopping=E2=80=9D for me =E2=80=94 therefore I stay at ke=
rnel 2.6.29.6).

(h)  Apart from following single incident, I got never any error messages f=
rom this filesystem, neither from xfs_check nor from xfs_repair:
On July 17th a run of xfs_repair yielded following report =E2=80=94 beeing =
busy on that day, I ignored the message apart from saving it for later anal=
ysis:
#  xfs_repair -dn /dev/hda7
bad nblocks 1 for free inode 9722
bad nlink 1 for free inode 9722
bad mode 0100644 for free inode 9722
link count mismatch for inode 9722 (name ?), nlink 0, counted 1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.



If I can provide any additional debugging info, let me know.

=2D-=20
Roland Eggner

--nextPart4021922.nUrLzVR9CD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqdx3QACgkQdN/hKfT7G/KnMQCgtfQhfym9YIHDQn1W4UyKK1yw
DisAnj+6ZYFKYbygHHePkEl6wxw9zKxR
=bNcT
-----END PGP SIGNATURE-----

--nextPart4021922.nUrLzVR9CD--


--===============7553921895753172842==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7553921895753172842==--
