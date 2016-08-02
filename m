Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B34CA7CA7
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 08:20:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7EF6F8F8035
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 06:20:30 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id ZyqTAH5fprQGkLWm (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 06:20:28 -0700 (PDT)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4EA69ABC9
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 13:20:26 +0000 (UTC)
From: Jeff Mahoney <jeffm@suse.com>
Subject: Old bugs in xfsprogs?
Message-ID: <7e185931-8830-5f31-7abb-5419bb255991@suse.com>
Date: Tue, 2 Aug 2016 09:20:22 -0400
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4280378878682409584=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============4280378878682409584==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ec8K5VL5fk6GuveFqfwfAPxxF0jhJRIk7"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ec8K5VL5fk6GuveFqfwfAPxxF0jhJRIk7
Content-Type: multipart/mixed; boundary="exDkSN8ViMSwQtfv8lh2kUx0xVrvueI6C"
From: Jeff Mahoney <jeffm@suse.com>
To: xfs@oss.sgi.com
Message-ID: <7e185931-8830-5f31-7abb-5419bb255991@suse.com>
Subject: Old bugs in xfsprogs?

--exDkSN8ViMSwQtfv8lh2kUx0xVrvueI6C
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all -

While investigating a weird report on an internal list I found a few old
commits that don't look quite right and that may be very old bugs.  I
know it's hard to go back nearly 15 years, especially in the days where
very short commit messages were still acceptable, and try to remember
why certain changes happened.  In this case, a weird corner case[1]
would've been caught, xfs_repair would've bailed, and a file system may
have survived (despite obvious user error).

1/ Commit 5000d01d212f (white space cleanup)

diff --git a/libxlog/util.c b/libxlog/util.c
index 7aca165..aa3093d 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -49,8 +49,10 @@ header_check_uuid(xfs_mount_t *mp, xlog_rec_header_t
*head)
     printf("* ERROR: mismatched uuid in log\n"
            "*            SB : %s\n*            log: %s\n",
             uu_sb, uu_log);
+
+    memcpy(&mp->m_sb.sb_uuid, head->h_fs_uuid, sizeof(uuid_t));

-    return 1;
+    return 0;
 }

This one may well have been intended as a repair operation or perhaps it
was accidentally duplicated from another chunk in the patch.  At any
rate, it hides a mismatched UUID between the log and the superblock from
the rest of xfs_repair.  The user sees the "error" message but it
carries on anyway.

2) Commit d321ceac8da (add libxlog directory.)

I believe this was supposed to be as simple as pushing some
functionality from logprint into a new libxlog library, but the result
is that things that used to return an error no longer did.  The
print_exit global that was initialized to 1 in logprint is initialized
to 0 in libxlog and never set.  So we always print an error message but
then carry on.  So even if the header_check_uuid() call above would fail
properly, the error is printed and then the error condition ignored.

-Jeff

[1] The details are still murky, but what I got was that the user ran
xfs_repair -L (yup, i know) on an image file that contained partitions.
It found a valid XFS superblock and then "repaired" the file system to
an empty state since everything it found was "corrupt."  I suspect that
there was an XFS file system on the raw image file, which was then
partitioned without clearing the MBR, and the expected XFS file system
was created on the first partition.  xfs_repair was pointed at the whole
image file, discovered the old superblock, and remade the fs in its own
image since nothing was at the proper locations.

--=20
Jeff Mahoney
SUSE Labs


--exDkSN8ViMSwQtfv8lh2kUx0xVrvueI6C--

--ec8K5VL5fk6GuveFqfwfAPxxF0jhJRIk7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXoJ4XAAoJEB57S2MheeWyeeoP/0Mo5oetJ+hsqCMFTyaAD7+/
rLehRKJSAQtZTUICPhuWvT5YKNUjMuIYdcSDeDnPd0HIGW31RgDWTxlJhuTNVtpT
kuo2XEFVhtUuU9T206+I8XC+kmpH2KnQrhvQOAQHl/GLMCY5DpMOJANXOmvSHlVi
R4ffYVybeXo+uaLuOMLPK8bD3CV4ppwz3i5LWJvGBEwrdosNx3PTJ5fk68GDE+2E
d1st+ADu988AaMDLbAOKx0jplQl0oFIGd5x7gdS/98u9BV6vA9ioe4X6c1VBrKr7
d2wfEDdJe7/8PhKO33GKAcCF2MdF12MVyYxirxToRHKX/V7yPKlywvrPeRhF/tXn
qekWQpBJY1Onwgr3QB2UZMS3BdAXd7Qf5RnAioRcxjDVGMqXZAmraNzKD96jSDfq
RmvGLUhst6NqKsrGDNeFltuhiBKUrdo5vOL/kI6V2DStPlMU8w4cBsXuo8560/F9
tObSlfgVGyFEuVKh2BJW6v7yUgAOedW4Vpjlf+SfPB1Jhy1q+nVjsm5kjW+J6WBE
lQuu3K2JezBSFLCEqzxDgipC1aogiWBC5W3pXklqCH8msxr/M6J90N8m7NCFtg/m
tQDad/Fh/0fgnaOiiBIUhvduBjI2kmOns84IjrxnNEQVfgM0MreWkSF0iraXaSFY
TD6GbUx4PvwyPJ6x82LA
=9vPb
-----END PGP SIGNATURE-----

--ec8K5VL5fk6GuveFqfwfAPxxF0jhJRIk7--


--===============4280378878682409584==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4280378878682409584==--
