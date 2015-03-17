Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 54FA57F55
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 15:33:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 263078F8066
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 13:33:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kQuHEZixqZT57uf8 for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 13:33:19 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 06/13] xfs_repair: remove impossible tests in process_sf_dir2
Date: Tue, 17 Mar 2015 15:33:08 -0500
Message-Id: <1426624395-8258-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
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

We're testing for an impossible case in here:

                if (i == num_entries - 1)  {
...
                } else  {
...
                                if (i == num_entries - 1)
                                    /* can't happen! */
...
                }

So, remove the impossible case.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 repair/dir2.c |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index 25793e9..7aede6a 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -928,26 +928,12 @@ _("size of last entry overflows space left in in shortform dir %" PRIu64 ", "),
 				do_warn(
 _("size of entry #%d overflows space left in in shortform dir %" PRIu64 "\n"),
 					i, ino);
-				if (!no_modify)  {
-					if (i == num_entries - 1)
-						do_warn(
-						_("junking entry #%d\n"),
-							i);
-					else
-						do_warn(
-						_("junking %d entries\n"),
-							num_entries - i);
-				} else  {
-					if (i == num_entries - 1)
-						do_warn(
-						_("would junk entry #%d\n"),
-							i);
-					else
-						do_warn(
-						_("would junk %d entries\n"),
-							num_entries - i);
-				}
-
+				if (!no_modify)
+					do_warn(_("junking %d entries\n"),
+						num_entries - i);
+				else
+					do_warn(_("would junk %d entries\n"),
+						num_entries - i);
 				break;
 			}
 		}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
