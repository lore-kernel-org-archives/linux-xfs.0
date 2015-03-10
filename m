Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 483307F3F
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 16:01:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1A2878F8071
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 14:01:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id RwuFKbZzHzkxDBc2 for <xfs@oss.sgi.com>;
	Tue, 10 Mar 2015 14:01:28 -0700 (PDT)
Received: from Liberator.local (unknown [40.139.179.11])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B245263C3A20
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 16:01:27 -0500 (CDT)
Message-ID: <54FF5BA6.4000508@sandeen.net>
Date: Tue, 10 Mar 2015 17:01:26 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/4] xfs_repair: remove impossible tests in process_sf_dir2
References: <54FF59DA.60700@sandeen.net>
In-Reply-To: <54FF59DA.60700@sandeen.net>
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
---

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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
