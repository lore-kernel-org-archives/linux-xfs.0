Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 689E77F78
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 07:55:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 52AFA8F8065
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 05:55:28 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id vMTZ4xq8Id1aoNkB (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jan 2014 05:55:27 -0800 (PST)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 703C5AC6E
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 13:55:26 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] xfstests: don't suggest to run full diff when DIFF_LENGTH
	is 0
Date: Wed, 22 Jan 2014 14:55:25 +0100
Message-Id: <1390398925-8552-1-git-send-email-dsterba@suse.cz>
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
Cc: David Sterba <dsterba@suse.cz>

If DIFF_LENGTH is set to 0, the full output is available and the message
does not make sense.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

v2: added missing \

 check | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/check b/check
index 2fb4efe31771..268417c258ec 100755
--- a/check
+++ b/check
@@ -511,11 +511,11 @@ do
 				cat
 			else
 				head -n "$DIFF_LENGTH"
+				echo "..."
+				echo "(Run '$diff $seq.out $seqres.out.bad'" \
+					" to see the entire diff)"
 			fi; } | \
 			sed -e 's/^\(.\)/    \1/'
-		    echo "     ..."
-		    echo "     (Run '$diff $seq.out $seqres.out.bad' to see the" \
-			 "entire diff)"
 		    err=true
 		fi
 	    fi
-- 
1.8.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
