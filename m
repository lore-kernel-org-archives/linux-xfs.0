Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55312 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750784AbdBADMI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jan 2017 22:12:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: error propagation problem on xfs over dm stripe
Message-ID: <b44b5dc2-eac0-cd40-6de8-b615cb4dece8@sandeen.net>
Date: Tue, 31 Jan 2017 21:12:07 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>, dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>

xfstest generic/108 creates a stripe then fails one leg to
see if io errors on only a subset of an io get reported
to userspace:

# Test partial block device failure. Calls like fsync() should report failure
# on partial I/O failure, e.g. a single failed disk in a raid 0 stripe.
#
# Test motivated by an XFS bug, and this commit fixed the issue
# xfs: return errors from partial I/O failures to files


This started failing with a recent xfs commit, but the change wasn't
expected to change anything related to this behavior at all.

My best guess was that allocation and IO patterns shifted over
the stripe, and I think that turned out to be right.

I tracked this down to being unique to dm; an md stripe of
the same geometry doesn't have this issue.  Root cause seems
to be that dm's dec_pending() overwrites a bio's bi_error regardless
of current state, and in some cases will overwrite an -EIO with
a zero.  This seems to fix it for me:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3086da5..3555ba8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -808,7 +808,9 @@ static void dec_pending(struct dm_io *io, int error)
 		} else {
 			/* done with normal IO or empty flush */
 			trace_block_bio_complete(md->queue, bio, io_error);
-			bio->bi_error = io_error;
+			/* don't overwrite or clear existing errors */
+			if (!bio->bi_error)
+				bio->bi_error = io_error;
 			bio_endio(bio);
 		}
 	}

but Mike was a little uneasy, not knowing for sure how we got here to
overwrite this bio's error (hopefully I'm representing his concerns
fairly and correctly).

One other clue is that I think this is a chained bio, something xfs
does use.

I'll submit the above as a proper dm patch if it seems sane, but figured
I'd throw this out on the lists as a bit of a heads up / question / RFC
before I do that.

-Eric
