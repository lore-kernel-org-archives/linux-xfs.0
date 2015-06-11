Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 836527F61
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 17:53:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73713304032
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 15:53:16 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LUpbHFWihUFMlMoc for <xfs@oss.sgi.com>;
	Thu, 11 Jun 2015 15:53:12 -0700 (PDT)
Date: Fri, 12 Jun 2015 08:53:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
Message-ID: <20150611225308.GF24666@dastard>
References: <5579296A.8010208@skylable.com>
	<20150611151620.GB59168@bfoster.bfoster>
	<5579A904.3020204@skylable.com> <5579AE85.5080203@sandeen.net>
	<5579B034.4070503@sandeen.net> <5579B804.9050707@skylable.com>
	<5579EA91.3090707@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5579EA91.3090707@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, Luca Gibelli <luca@skylable.com>, xfs@oss.sgi.com, Christopher Squires <christopher.squires@hgst.com>, =?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@skylable.com>, Wayne Burri <wayne.burri@hgst.com>

On Thu, Jun 11, 2015 at 03:07:45PM -0500, Eric Sandeen wrote:
> On 6/11/15 11:32 AM, T=F6r=F6k Edwin wrote:
> > [4745016.650000] XFS (loop0): metadata I/O error: block 0xa000 ("xfs_tr=
ans_read_buf_map") error 117 numblks 8
> =

> ok, block 0xA000 (in sectors) is sector 40960...
> =

> xfs_db> daddr 40960
> xfs_db> fsblock =

> current fsblock is 8192
> xfs_db> type text
> xfs_db> p
> 000:  58 46 53 42 00 00 10 00 00 00 00 00 00 00 28 00  XFSB............
> 010:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 020:  64 23 d2 06 32 2e 4c 20 82 6e f0 36 a7 d9 54 f9  d...2.L..n.6..T.
> =

> ...
> =

> Right, so it's reading the 2nd superblock in xfs_dir3_data_read_verify.  =
Huh?
> (I could have imagined some weird scenario where we read block 0, but 819=
2?
> Very strange).
> =

> Hm, I don't think this can be readahead, it'd not get to this verifier AF=
AICT.
> =

> Given that the image is enough to reproduce via just mount; ls - we shoul=
d be
> able to reproduce this, given the right hardware, and get to the bottom o=
f it.

OK, so I've had a look at the on disk layout via xfs_db and there is
no corruption present on disk. I've confirmed that by mounting on
x86-64 (on 4.1-rc6) and no errors have been issued, and xfs_repair
(from for-next branch) doesn't see anything wrong, either.

So this is looking like either: a) a kernel bug we've subsequently
fixed; or b) an arm specific compiler or kernel bug.

I'd like to see a) ruled out as quickly as possible. Torok, can you
build a more recent kernel and see if the problem persists?

Can you also let us know what compiler version you are using and how
you are compiling (e.g. cross compile)? ISTR a previous incarnation
of this problem showed up when a specific compiler version was used
to cross-compile the armv7 kernel from x86-64, and it went away with
a compiler update. So it would be good to rule out the
compiler/build environment as the cause, too.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
