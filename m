Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 01DA67F37
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 14:34:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D0D8F304066
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 12:34:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dFSmBK7MbtC8SsR5 for <xfs@oss.sgi.com>;
	Wed, 09 Sep 2015 12:34:14 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/13] xfs_repair: recombine cut&waste code in
	dir2.c/attr_repair.c
Date: Wed,  9 Sep 2015 14:33:58 -0500
Message-Id: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

repair/dir2.c and repair/attr_repair.c got cut and pasted
long, long ago and have diverged since.

This series brings them back together, presumably fixes some
bugs, and loses a few hundred lines in the process.

o/~ reunited, and it feels so so good ... o/~

The series accomplishes this through a combination of trivial changes
(removing unused structure members, whitespace, etc) as well
as by "cross-porting" changes & fixes which happened to one
file but not the other over the past many years.

Along the way, a graphical diff of dir2 vs. attr_repair should
show the convergence.

Up until the last patch, I don't worry about dir vs. attr naming
in comments or error messages; the goal is to make these chunks
of the two files sufficiently similar so that by patch 11, the
reviewer can do a diff and say "yeah, ok, those really are
substantially the same now."

Also instructive is to apply up to patch 11, copy dir2.c and
attr_repair.c to /tmp, apply patch 12, and do a 3-way graphical
diff of the 3 files to see that the move really is OK and
didn't play any significant tricks.

The last patch fixes up the dir vs. attr text in error messages
and comments.  I do have a question about whether this is ok
for i8n:

	printf(_("This string is %s"), _("awesome"));

because that's essentially the trick I used...

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
