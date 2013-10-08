Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D71467F89
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 17:05:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C54C98F808F
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 15:05:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EtvvmFJdgRVzdvPX for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 15:05:55 -0700 (PDT)
Received: from Liberator.local (c-98-240-215-156.hsd1.mn.comcast.net
	[98.240.215.156])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7396D60A995B
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 17:05:55 -0500 (CDT)
Message-ID: <525481C2.6040100@sandeen.net>
Date: Tue, 08 Oct 2013 17:05:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfsdump: avoid segfault in partial_reg() in error case
References: <525480A6.3000202@redhat.com>
In-Reply-To: <525480A6.3000202@redhat.com>
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
To: xfs-oss <xfs@oss.sgi.com>

If we go down the "/* Should never get here. */" path
in partial_reg(), we issue a warning but then continue
with the function.  This calls pi_unlock() twice,
but worse, uses a null isptr:

        if ( ! isptr ) {
... isptr is never set if we get to ...
                /* Should never get here. */
                pi_unlock();
...
        }
...
        /* Update this drive's entry */
        bsptr = &isptr->is_bs[d_index];
        if (bsptr->endoffset == 0) {

>From all appearances, because we unlock on that "never get
here" path, it should just be returning after printing the
warning.  So add that, and we avoid the segfault.

The previous fix to partial_reg() should prevent us from
hitting this in the first place.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/restore/content.c b/restore/content.c
index 54d933c..cc49336 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -9007,6 +9007,7 @@ partial_reg( ix_t d_index,
 #ifdef DEBUGPARTIALS
 		dump_partials();
 #endif
+		return;
 	}
 
 found:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
