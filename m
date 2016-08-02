Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 40C587CB1
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:00:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9CB08F8039
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 08:00:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XzsRGeC6x7iVZghR for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2016 08:00:41 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0D5244AC133
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:00:41 -0500 (CDT)
Subject: Re: Old bugs in xfsprogs?
References: <7e185931-8830-5f31-7abb-5419bb255991@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <626eedea-2b9a-4ca3-cd3d-1e528f45526f@sandeen.net>
Date: Tue, 2 Aug 2016 10:00:31 -0500
MIME-Version: 1.0
In-Reply-To: <7e185931-8830-5f31-7abb-5419bb255991@suse.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1583160561754384724=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============1583160561754384724==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="iLBvSeQx8lh6327t3Tg3qwh5oF1C4gT3u"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iLBvSeQx8lh6327t3Tg3qwh5oF1C4gT3u
Content-Type: multipart/mixed; boundary="bfplggHAvDEWDw2HAdsXMLhxxeVI54wmu"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs@oss.sgi.com
Message-ID: <626eedea-2b9a-4ca3-cd3d-1e528f45526f@sandeen.net>
Subject: Re: Old bugs in xfsprogs?
References: <7e185931-8830-5f31-7abb-5419bb255991@suse.com>
In-Reply-To: <7e185931-8830-5f31-7abb-5419bb255991@suse.com>

--bfplggHAvDEWDw2HAdsXMLhxxeVI54wmu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/2/16 8:20 AM, Jeff Mahoney wrote:
> Hi all -
>=20
> While investigating a weird report on an internal list I found a few ol=
d
> commits that don't look quite right and that may be very old bugs.  I
> know it's hard to go back nearly 15 years, especially in the days where=

> very short commit messages were still acceptable, and try to remember
> why certain changes happened.  In this case, a weird corner case[1]
> would've been caught, xfs_repair would've bailed, and a file system may=

> have survived (despite obvious user error).
>=20
> 1/ Commit 5000d01d212f (white space cleanup)

Meh, not a white space cleanup, is it!

> diff --git a/libxlog/util.c b/libxlog/util.c
> index 7aca165..aa3093d 100644
> --- a/libxlog/util.c
> +++ b/libxlog/util.c
> @@ -49,8 +49,10 @@ header_check_uuid(xfs_mount_t *mp, xlog_rec_header_t=

> *head)
>      printf("* ERROR: mismatched uuid in log\n"
>             "*            SB : %s\n*            log: %s\n",
>              uu_sb, uu_log);
> +
> +    memcpy(&mp->m_sb.sb_uuid, head->h_fs_uuid, sizeof(uuid_t));
>=20
> -    return 1;
> +    return 0;
>  }

However, after seeing the mismatch, it "fixes" it by copying the header
uuid into the mount point uuid.

But that doesn't seem like the right approach at all, and it renders all
the callers who check the return value of header_check_uuid pointless.
So yeah, doesn't look good to me.

> This one may well have been intended as a repair operation or perhaps i=
t
> was accidentally duplicated from another chunk in the patch.  At any
> rate, it hides a mismatched UUID between the log and the superblock fro=
m
> the rest of xfs_repair.  The user sees the "error" message but it
> carries on anyway.
>=20
> 2) Commit d321ceac8da (add libxlog directory.)
>=20
> I believe this was supposed to be as simple as pushing some
> functionality from logprint into a new libxlog library, but the result
> is that things that used to return an error no longer did.  The
> print_exit global that was initialized to 1 in logprint is initialized
> to 0 in libxlog and never set.  So we always print an error message but=

> then carry on.  So even if the header_check_uuid() call above would fai=
l
> properly, the error is printed and then the error condition ignored.

Sigh, yeah, the old commits are wild west.  :(

In this case header_check_uuid returned 0 anyway,so print_exit would
not have helped, but I think you're right.

A perfect storm of derp.  ;)

> -Jeff
>=20
> [1] The details are still murky, but what I got was that the user ran
> xfs_repair -L (yup, i know) on an image file that contained partitions.=

> It found a valid XFS superblock and then "repaired" the file system to
> an empty state since everything it found was "corrupt."  I suspect that=

> there was an XFS file system on the raw image file, which was then
> partitioned without clearing the MBR, and the expected XFS file system
> was created on the first partition.  xfs_repair was pointed at the whol=
e
> image file, discovered the old superblock, and remade the fs in its own=

> image since nothing was at the proper locations.

Oh, so it found 4 matching, old, valid, superblocks?  Ugh.  I don't know
how to protect against that, although <handwave> it probably should have
found a few non-matching supers along the way as well.  I wonder if we
should be more cautious in that case.

I could imagine that maybe for each candidate super we find, we should
look at its geometry, and spot-check the other locations that it indicate=
s
should contain a superblock.  If we get enough semi-valid but conflicting=

"sets," maybe we should bail out and ask.  It's quite a corner case, tho.=


Any chance you have full xfs_repair output?

-Eric


--bfplggHAvDEWDw2HAdsXMLhxxeVI54wmu--

--iLBvSeQx8lh6327t3Tg3qwh5oF1C4gT3u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXoLWYAAoJECCuFpLhPd7ggLEQAIXsnGsLvUeHDUDRHHA+R4eZ
hGdgGO4sUC/9KbnAgPm1hsyYiVUIZRGoV7E1Q48xujS8B3w1p6Uvfh5ifFKj0zwa
+W60KZ15B03TFs1GxQf9iXainL1O1zOLcpBQMOX2ny5/M1yc/9ReYbU8Ofby4Q7f
w2zDbGHFCRiB8k9mf4iqm3bNzsf6bwMLnspntkokV8ozW7wwG4qdyhTbL1mFXzMi
3aFMSJns1Fy18gkc/K19O0qkmu0hD8vPPoVXVq8oBPHK8b9OfYh8ruKXy/5X7MQI
bAwLrwsPUhGvBJLsjzguBDIcnvKX11kxl0c2MK6eQYWKLXIoM2BfgCRJVCvMt6VW
+bz2lLboguWhBW6GtCtyY7dr/2LsXbqTBWAV+Q8DJIku4ENZVZC63FcZMvHIti0A
9IbMd60VMs7HqSSm/yuNvkl4QjrCmgBVlEzVipjBM1nhuqCZC7xsYh+yfOZHcNlh
/J6mc6z8ruNqPchV7pEWVc0EfkU7+69ElUVbkTtsAIUpFQyjhHn88VD/g/4VXdX0
lkAyy0vfqjud8JMCD1gVFsLEJxfTOJn7wnuJZv0YtAWLa4m9yBhMi0LZ7jtxCowZ
QTDKckyt3V22bA+jSqCquARQH115hRPOWvNXbhktV+KHXwIbpuAT8COeFbfCKtP5
amxG0cdtdbSC8oGLSaHj
=yCyY
-----END PGP SIGNATURE-----

--iLBvSeQx8lh6327t3Tg3qwh5oF1C4gT3u--


--===============1583160561754384724==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1583160561754384724==--
