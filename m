Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 065EB7F51
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:22:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA81A8F804C
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:22:35 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nE3aHZ5XKzqWSVO5 for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 23:22:34 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vr0bM-0000oF-Kn
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 18:22:28 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vr0bM-0005Bo-Ju
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 18:22:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] repair: translation lookups limit scalability
Date: Thu, 12 Dec 2013 18:22:21 +1100
Message-Id: <1386832945-19763-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1386832945-19763-1-git-send-email-david@fromorbit.com>
References: <1386832945-19763-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

A bit of perf magic showed that scalability was limits to 3-4
concurrent threads due to contention on a lock inside in something
called __dcigettext(). That some library somewhere that repair is
linked against, and it turns out to be inside the translation
infrastructure to support the _() string mechanism:

# Samples: 34K of event 'cs'
# Event count (approx.): 495567
#
# Overhead        Command      Shared Object          Symbol
# ........  .............  .................  ..............
#
    60.30%     xfs_repair  [kernel.kallsyms]  [k] __schedule
               |
               --- 0x63fffff9c
                   process_bmbt_reclist_int
                  |
                  |--39.95%-- __dcigettext
                  |          __lll_lock_wait
                  |          system_call_fastpath
                  |          SyS_futex
                  |          do_futex
                  |          futex_wait
                  |          futex_wait_queue_me
                  |          schedule
                  |          __schedule
                  |
                  |--8.91%-- __lll_lock_wait
                  |          system_call_fastpath
                  |          SyS_futex
                  |          do_futex
                  |          futex_wait
                  |          futex_wait_queue_me
                  |          schedule
                  |          __schedule
                   --51.13%-- [...]

Runtime of an unpatched xfs_repair is roughly:

        XFS_REPAIR Summary    Fri Dec  6 11:15:50 2013

Phase           Start           End             Duration
Phase 1:        12/06 10:56:21  12/06 10:56:21
Phase 2:        12/06 10:56:21  12/06 10:56:23  2 seconds
Phase 3:        12/06 10:56:23  12/06 11:01:31  5 minutes, 8 seconds
Phase 4:        12/06 11:01:31  12/06 11:07:08  5 minutes, 37 seconds
Phase 5:        12/06 11:07:08  12/06 11:07:09  1 second
Phase 6:        12/06 11:07:09  12/06 11:15:49  8 minutes, 40 seconds
Phase 7:        12/06 11:15:49  12/06 11:15:50  1 second

Total run time: 19 minutes, 29 seconds

Patched version:

Phase           Start           End             Duration
Phase 1:        12/06 10:36:29  12/06 10:36:29
Phase 2:        12/06 10:36:29  12/06 10:36:31  2 seconds
Phase 3:        12/06 10:36:31  12/06 10:40:08  3 minutes, 37 seconds
Phase 4:        12/06 10:40:08  12/06 10:43:42  3 minutes, 34 seconds
Phase 5:        12/06 10:43:42  12/06 10:43:42
Phase 6:        12/06 10:43:42  12/06 10:50:28  6 minutes, 46 seconds
Phase 7:        12/06 10:50:28  12/06 10:50:29  1 second

Total run time: 14 minutes

Big win!

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dinode.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 7469fc8..8f14a9e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -522,6 +522,11 @@ _("illegal state %d in rt block map %" PRIu64 "\n"),
  * file overlaps with any duplicate extents (in the
  * duplicate extent list).
  */
+static char	*__forkname_data;
+static char	*__forkname_attr;
+static char	*__ftype_real_time;
+static char	*__ftype_regular;
+
 static int
 process_bmbt_reclist_int(
 	xfs_mount_t		*mp,
@@ -552,15 +557,30 @@ process_bmbt_reclist_int(
 	xfs_agnumber_t		locked_agno = -1;
 	int			error = 1;
 
+	/*
+	 * gettext lookups for translations of strings use mutexes internally to
+	 * the library. Hence when we come through here doing parallel scans in
+	 * multiple AGs, then all do concurrent text conversions and serialise
+	 * on the translation string lookups. Let's avoid doing repeated lookups
+	 * by making them static variables and only assigning the translation
+	 * once.
+	 */
+	if (!__forkname_data) {
+		__forkname_data = _("data");
+		__forkname_attr = _("attr");
+		__ftype_real_time = _("real-time");
+		__ftype_regular = _("regular");
+	}
+
 	if (whichfork == XFS_DATA_FORK)
-		forkname = _("data");
+		forkname = __forkname_data;
 	else
-		forkname = _("attr");
+		forkname = __forkname_attr;
 
 	if (type == XR_INO_RTDATA)
-		ftype = _("real-time");
+		ftype = __ftype_real_time;
 	else
-		ftype = _("regular");
+		ftype = __ftype_regular;
 
 	for (i = 0; i < *numrecs; i++) {
 		libxfs_bmbt_disk_get_all(rp + i, &irec);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
