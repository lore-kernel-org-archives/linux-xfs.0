Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B31257F3F
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 06:49:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A35938F8039
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 04:49:01 -0700 (PDT)
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id pDWE5oUvrhpA061O
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 04:48:57 -0700 (PDT)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: XFS fragmentation on file append
In-Reply-To: <CAJhmKHk5fWVaDTEfL_oESULspavk83eBEsyw7=qEp8bC7f2S2g@mail.gmail.com>
References: <CAJhmKHmwvCBx=arJ6m2ZhuQVq=Jj-XbBGvEPjTPY5a1QtWRTCQ@mail.gmail.com>
	<20140408015012.GB22917@dastard>
	<CAJhmKHnap0vu8m4AXBxJr9L0RKoquFrm3NjKQdDBJwpRTYmfpw@mail.gmail.com>
	<20140408053117.GJ27017@dastard>
	<CAJhmKHk5fWVaDTEfL_oESULspavk83eBEsyw7=qEp8bC7f2S2g@mail.gmail.com>
Date: Wed, 23 Apr 2014 21:48:54 +1000
Message-ID: <874n1k466x.fsf@flamingspork.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1580840241865680205=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Keyur Govande <keyurgovande@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

--===============1580840241865680205==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Keyur Govande <keyurgovande@gmail.com> writes:
> I spent some more time figuring out the MySQL write semantics and it
> doesn't open/close files often and initial test script was incorrect.

MySQL will open/close files depending on some configuration parameters
and the number of tables that exist/are open/are in the working set.

If InnoDB tables, it's innodb_max_open_files (IIRC it's named that, or
something similar). If you have less than that number of tables and
innodb_file_per_table=3Dtrue, then you'll never close. If you have the max
set to 10 times the working set of active tables, you're going to be
opening and closing files a lot - it's basically a LRU of unused tables
(open files).

> It uses O_DIRECT and appends to the file; I modified my test binary to
> take this into account here:
> https://gist.github.com/keyurdg/54e0613e27dbe7946035

You can also make it not use O_DIRECT, but that's generally a bad idea :)

=2D-=20
Stewart Smith

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV6imAAoJEP08notdpDyvZ1QP/iYNntG9pkpy+gSuAvh+HG8f
LwjaHSHAgUAggm15pU0IZxGg4ycaIZROxDtgaycdMSdlQymLj5DdalbJCZvgSrz8
GIUq8IWGQFTeGfTaRuqTzckP00dtRXNrmD+6E+kBWPfqJ7QFg7BG3dlbMD3+bL1n
Xz3CnoVMZAPV+R+gI5TBO7N6WEa1F2JeHuFHc/9Jsr0NOc+DJwIGCp4GTz2W3szS
zkQDL+qdMR2yfoFXpuU/3ND9gP/Y+sRAvLmSPQ6K7JEoeXqqs6JLyQ+RnOPzudFc
VWJZAEAf32252bSXaf1KbKUBu+hozUY2SDxnD/iLFKft47JJx0J/oluBqiwAXyRg
MfN398fxRSGS4TxttR8WFuLZAC1mc5SIUvoZPyLmCTxV+OJcDaOPRfBPYcqOEF4I
9joqEubyJpx0BPmDHbFASIAqyIr2+9XczbDqAFte94A3TEqUuCR0FRoKp7WYyucy
fnFC7RyODUm4u6kmjQf+y0B+XfqrvTILiGF0daj167RkrBpjgeR66EZGr0WCmWr7
lusFOLWBsYCEXQWGeCAK/B5LETWaN0DlweM5W/0TmOmdL5DBX2k5/LGX4KpHI6RJ
U6sTGZxqlH53bD6q9/80H1AHMpMJGdybWm+JntB36hx/N+WIFO+j5LD35ixUGRFP
zCr24FeQYG3iqo9eeGP4
=G4dl
-----END PGP SIGNATURE-----
--=-=-=--


--===============1580840241865680205==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1580840241865680205==--
