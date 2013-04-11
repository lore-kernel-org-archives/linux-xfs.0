Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 77A687FB8
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 04:45:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 54AE630405F
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 02:45:15 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DMqZIYXQVUcerLOU for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 02:45:13 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UQE48-0005n5-CY
	for xfs@oss.sgi.com; Thu, 11 Apr 2013 19:45:12 +1000
Date: Thu, 11 Apr 2013 19:45:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: xfstests: heads up about coreutils v8.20+ related failures
Message-ID: <20130411094512.GL10481@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Folks,

Debian unstable just transistined to coreutils v8.20 recently, ad
this has caused a bunch of tests to fail due to golden output
mismatches.

A while back, various GNU projects have decided to use the gcc quote
method, which means that the longstanding format of output messages
has changed to what gcc has been using for some time.

This is the typical sort of diff you'll see in a failure:

-mv: cannot move `TEST_DIR/test-mv/ab/aa/' to `TEST_DIR/test-mv/aa': File e=
xists
+mv: cannot move 'TEST_DIR/test-mv/ab/aa/' to 'TEST_DIR/test-mv/aa': File e=
xists

It's subtle, but the difference is `...' vs '...'.(*)

What this means is that we are going to have to add filters to all
the coreutils output in xfstests to convert the quotes to a common
format for the golden output.

I'm not going to get to this in the next couple of weeks (travel to
LF collab summit/LSFMM next week), so someone else might want to
have a look at this in the mean time...

Cheers,

Dave.

(*) Well, it's even more subtle than that, because I've had problems
with GCC quotes for years - they simply don't don't copy-n-paste
very well, even when all terminals and machines are using the same
locale and UTF-8 aware applications:

v8.13
$ LC_ALL=3Den_AU.UTF-8 mv a /etc
mv: cannot move `a' to `/etc/a': Permission denied

v8.20:
$ LC_ALL=3Den_AU.UTF-8 mv a /etc
mv: cannot move =BFa=BF to =BF/etc/a=BF: Permission denied

Yeah, the quotes from v8.20 didn't paste as quotes. gcc has
displayed this behaviour for years, and now coreutils will behave
the same. Welcome to the wonderful new world of screwed up quotes in
bug reports....
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
