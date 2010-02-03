Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13Jqw0t241543 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 13:52:58 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B27E83040B2
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 11:54:05 -0800 (PST)
Subject: xfstests: 219: fix awk filter for duplicate users
From: Alex Elder <aelder@sgi.com>
Date: Wed, 03 Feb 2010 13:54:04 -0600
Message-ID: <1265226844.2848.27.camel@doink1>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The filter I added for removing duplicate users from the
output of repquota didn't do the job very well.  This
fixes that, making it so the first time a user is seen
its line is printed, not thereafter.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 219 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/219
===================================================================
--- a/219
+++ b/219
@@ -86,7 +86,7 @@ test_accounting()
        done

        repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" |
filter_scratch |
-       awk '/^#/ { if (! seen[$1]) { seen[$1]++; next; } } { print }'
+       awk '/^#/ { if (seen[$1]) next; seen[$1]++; } } { print; }'
 }

 # real QA test starts here



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
