Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6426C7F6B
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 17:33:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14CDEAC00A
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 15:33:27 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0IsI3e3Dk07Jmo29 for <xfs@oss.sgi.com>;
	Mon, 09 Jun 2014 15:33:22 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Wu880-0004nI-2I
	for xfs@oss.sgi.com; Tue, 10 Jun 2014 08:33:20 +1000
Date: Tue, 10 Jun 2014 08:33:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [DISCUSS] Planning for new dev cycle (3.17)
Message-ID: <20140609223320.GE9508@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0073447818351948264=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0073447818351948264==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi everyone,

Now that the 3.16 dev cycle has drawn to a close (one more
linux-next build and I'll tag for-next and send a pull request),
it's time to look ahead for the next couple of months. I think the
current major pieces of work that are currently outstanding are
these:

	- Jeff's bulkstat rework
	- Brian's EOF prealloc scanning
	- Namjae's FALLOC_FL_INSERT_RANGE work
	- Eric's XFS_ERROR() macro removal and return () cleanup.

There's also two major pieces of infrastructure work I'd like to get
done:

	- convert XFS to negative error returns
	- restructure code to have a fs/xfs/libxfs structure similar
	  to userspace

Because Eric's XFS_ERROR removal touches the entire codebase, as
does the negative error return and the libxfs restructuring, I'd
like to get these done first and base the rest of the dev cycle work
on top of that. Eric's patches just need a minor rebase and the
libxfs restructure needs some makefile rework and review and they
should be good to go.

The issue is the negative error number patchset, and how to handle
review and testing. The patchset is already 62 patches long and it
converts roughly half the code base. It'll take me another couple of
days to convert the rest of the code, and that will probably take
another 60 patches.

I understand that reviewing 100+ patches is going to be a pain, but
each patch currently averages about +/- 10 lines. The current
diffstat is:

	37 files changed, 723 insertions(+), 722 deletions(-)

And that will probably double, so it's still going to be a fair
amount of change.

So the big question is how do we handle the review side of things.
I think testing won't be a huge issue because of the time we have in
the cycle (a couple of months to the 3.17 merge, and then a couple
more months in the 3.17-rcX cycle) to find and catch regressions,
but I'd like to know what people think about the best way to review
this change will be.

I'm happy for people to say "no, we need to review it patch by
patch, so delay it for a cycle while we work through it", but I'm
also happy for a "apply it all and look at error sources and
inversion points for problems". The second is probably easier, as
there will be very few remaining inversion points (only embedded
errors in ioctl structures, I think) and all error sources should be
negated at their definition and hence any error value (E* values)
that are not defined as "-E*" is likely to be an mistake....

I'll be spending the next couple of days finishing this all off, so
once it is done I can focus on review and bug fixes for the rest of
the 3.17 dev cycle. That allows me to  concentrate on a xfsprogs
3.2.1 release, subsequent userspace libxfs resync with the new
kernel structure, and starting to work on some of the smart block
device concepts I've been talking about recently....

These are not concrete plans - just what I'd *like* to do in the
next couple of months. Reality is bound to mess up any plans I have,
so I figure I mays as well mess them up straight away....

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTljYvAAoJEK3oKUf0dfodIlIP/10LhZYLfrpobEb9QDW/7D1y
ETu5WtbrB7mA5F0ZFxV7LltK3GPYKw3bPw7EqdUEHYiHsxPAY2PtIs/cRReU9zaU
9ZcuFsWpNYYs3/HvcmwpAfQEdy/RSsfWXx5x7LGJeyPFf3EM/qTpMT6xTseUifC6
X6dZdu79RN9AdUprmwNCR9SBVSZ8tNRNgXoyJUgxvM2y964hc79mCpdghYn4NkvN
AxEVBTPFdtPe8HsMMwvEY7YapyZ28571JbJts7ksq/g64IoV+BcYw6DtfEhfQQ+s
JbwngujjK3mEWRM39jnsysPyY2AAgzpBMuAryLEqgO+AyBB+jfFGwvkzKhrlJegO
a7PKN1NFubhH1DkFBvPc/NG8Nh0g8tRjh/jQjaG6fDqLbfVH7YtnNQOZOKBzCoNO
Gtpbkfu+HE0Hf0wTBgLmJNvyXipx8mftdJri8QrJHsKH0/FeceF9o4s24pj1xXpe
RD+PeG7nZubFwVTeDRppQMOMd6Gu99vKVutWiBF4GLf6iem5/CU6zItzGvLtYsQQ
AqOmn+BkwP4nmb9CT8R4TLuwmXCS2nde1cE4eFwCXqCCVuNkZU71D8TPP3yjGYk7
bRPoA/IdF4CxDJwwaYm/88uYCjQzAtMOCjuUgR/sUykH1TMFNL3sXS/iuoxS5Gmv
DmAwADVqamiea1CshrQs
=o8It
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--


--===============0073447818351948264==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0073447818351948264==--
