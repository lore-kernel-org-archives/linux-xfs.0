Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8675329DFB
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 09:48:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B6D78F804C
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 07:48:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 9YXZgb9eLcjcgHtG for <xfs@oss.sgi.com>;
	Mon, 11 May 2015 07:48:03 -0700 (PDT)
Message-ID: <5550C123.8060806@sandeen.net>
Date: Mon, 11 May 2015 09:48:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE, DISCUSS] xfsprogs: libxfs-4.1-update branch created
References: <20150511000508.GD16689@dastard>
In-Reply-To: <20150511000508.GD16689@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/10/15 7:05 PM, Dave Chinner wrote:
> Hi folks,

...

> This userspace update work needs to
> be distributed over the developers making the API and functionality
> changes, so I'm throwing this out there to see what people think
> about solving this problem.

...

> So, what do the people I'm asking to do more work so I don't have
> to spend so much time on time consuming maintenance tasks think?

I think it makes perfect sense, and I'm happy to do it.  The giant
sync-ups after the fact have never been ideal from any perspective.

I'm glad you brought this up; I don't think anyone ever meant to simply
leave this to the maintainer - it just ended up that way, because the
rules or best practices weren't necessarily clear.

So; do you envision a 0/8 patch series, 4 of which touch libxfs, to
now be a 0/12 patch series, with the userspace bits i.e. at the end?
I'd be perfectly happy with this; once libxfs stays up to date in
userspace, it should be trivial.

- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJVUMEiAAoJECCuFpLhPd7gwsEP/24cd6X9CQAAiCQGmB5rfTON
jj2QcvyANY0AFIxZGiJWlaulSGYsnzcN55G1W0JkoIDSfCwQq+I1UgCVtcns9nUU
LXaPgWQh0LgJSfYs+LezkwlulOAYWW2LOolDPPIyEyoVxkAHmm6M9kajj2NaHd5S
OmvoqBxRM/nl3DfRw3H/b5ARH2EDWQvgkbBoPwzD74oYMrxBK0bDV7dHrBh9I4yu
HE3R8zI+eIZxMy6hAV2WGRQg00GPW9bWJfuDp2HvekcdsbGc8JJN1fF/j5nlJX/r
h8dz0HbkB2ioZ2ErgcB7v4xZjpvcqg/sD6Zo7ehSyW0TE1Nxr9I4L7x1k048fh4P
JCZWViR4ddo5h4Wiheq7wFmNqSu0VL6lPzYpty/M8wIt2nLZcgjKq1agtDMHKcvJ
PeDanT2u6PkgrJIlZORnhCaGLfu1bNBqtnUGJXtPUMKGwl+CdZBqAsEe3pg5LH4f
3007zGBHhPg93/ZTdmgkjjbZlGt3qeT+tpFgnYJYSNTzj3Pom1ZvxXvXl3TnATTu
3phKrSpuWvHETmm9vz1xj/a2KXeyLOMpdgZYkDULfrwJnERbyE5wcNFNwSmUH0lI
69Ul/KvSY1TdrhvuAPA121TsuhSPP9YTZaeZnkITDn841P4wnaKb1TtP6NKldje0
f/4574r8AUVM5RoLuW9K
=PWIs
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
