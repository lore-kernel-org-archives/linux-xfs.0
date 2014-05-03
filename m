Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E0577F37
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 19:26:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DFBCDAC002
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 17:26:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id thJSG9kHb1KSdOvN for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 17:26:22 -0700 (PDT)
Message-ID: <536437AD.9020303@sandeen.net>
Date: Fri, 02 May 2014 19:26:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE] xfsprogs: 3.2.0-rc2 release tagged
References: <20140502000508.GA26353@dastard>
In-Reply-To: <20140502000508.GA26353@dastard>
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

On 5/1/14, 7:05 PM, Dave Chinner wrote:
> Hi folks,
> 
> The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
> just been updated.
> 
> The new head of the master branch is commit:
> 
> 67fcc94 xfsprogs: v3.2.0-rc2 release
> 
> This commit has been tagged with v3.2.0-rc2. I'd like everyone who
> can test this to test it, as all the issues that needed to be solved
> before a release coul dbe made have now been addressed. If there are
> no new regressions or critical issues reported in the next week or
> so, I will make an official 3.2.0 release. So, please test. :)

Any chance for a signed tarball?

- -Eric

> -Dave.
> 
> New Commits:
> 
> Dave Chinner (10):
>       [b511ff4] db: don't claim unchecked CRCs are correct
>       [9ba69ce] db: verify buffer on type change
>       [adbb357] repair: ensure prefetched buffers have CRCs validated
>       [8e7e14b] repair: detect and correct CRC errors in directory blocks
>       [8f657d7] repair: detect CRC errors in AG headers
>       [a76a5a7] repair: report AG btree verifier errors
>       [641e65b] repair: remove more dirv1 leftovers
>       [7cb3f7f] repair: handle remote symlink CRC errors
>       [3a1d34e] repair: detect and handle attribute tree CRC errors
>       [67fcc94] xfsprogs: v3.2.0-rc2 release
> 
> Eric Sandeen (2):
>       [847bbbe] xfs_logprint: Fix error handling in xlog_print_trans_efi
>       [aabc02b] mkfs.xfs: prevent close(-1) on protofile error path
> 
> 
> Code Diffstat:
> 
>  VERSION              |   2 +-
>  db/fprint.c          |  15 ++-
>  db/io.c              |  26 ++++++
>  db/io.h              |  13 ++-
>  db/type.c            |   9 +-
>  doc/CHANGES          |   5 +
>  include/libxfs.h     |   3 +
>  libxfs/rdwr.c        |  58 ++++++++----
>  logprint/log_misc.c  |   5 +-
>  mkfs/proto.c         |   3 +-
>  repair/attr_repair.c |  45 +++++++--
>  repair/dinode.c      | 251 +++------------------------------------------------
>  repair/dinode.h      |   6 --
>  repair/phase6.c      |  94 +++++++++++++++----
>  repair/prefetch.c    |   7 +-
>  repair/scan.c        | 108 +++++++++++++++-------
>  16 files changed, 311 insertions(+), 339 deletions(-)
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTZDesAAoJECCuFpLhPd7gYR4P/idUYSSHbppJClmu7JreDlja
yh8RvNxLxopQ96y4CrPmEqupT/n8ZO/T9xElr0mPEIltoFrFL1CTALa/u3cBNkf0
MOHdPmLB1t6JvavMSjSMzBoPmbkH6v2FH8TjZvuIDMJOeYgWPKspYKHGNesT2t+b
nKfnyn00Z2hROSjHJozYNSYcmcXIZUI7RhlTaA+eXa2j8PrPBgqd+qmzN9NBUzmM
NH8zkHerNrZLknMlZrTA4gKUaHYXgR1kPEdXC5IzBtlVqjVWv4o2ASDAlAUO1KAR
mxCOdVcCxKBjbzn2pu4LgdNKhe7XFYenFwXxbxHs2gLwOaHnFlwCa45wEDm0g40W
U60lwX2zlvmOP5QwqXUN13xeixR0Qsu/mAhuj5gXsj2SBPKPHvK1i9IC1pwvMwZE
fSa8Al/0TTjZ2IwRfLSaLX5xruC486pdCCEVEYxkpdh4F6baSSbMsE6BsXDUJMs+
ouQXecjtmMA437o2h4stExKx2VVHrVpst/p7nPsR+1RISuqmyyOLq79riRHgGm5l
YNQiwfmmxoXpdIcnh0QQ2WHvCed8zZA3YT6gLVG/KW8vEUB2/zFtfSS8jm2FKXKz
rb2cPqOJ3KjMnMXu1QGZUb/UozS5jRls3LmYPRdQVo+/C1ceY2J6zLqdPeVI3Com
bozat+0vW2lahDB8SVFi
=SWEH
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
