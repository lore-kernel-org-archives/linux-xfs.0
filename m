Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 631F429DF8
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 11:07:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 05A12AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 09:07:22 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id GhVQD9HsScLKTDVw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Jan 2014 09:07:21 -0800 (PST)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 01A42AC56
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 17:07:21 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/5] xfstests: don't suggest to run full diff when DIFF_LENGTH
	is 0
Date: Thu, 16 Jan 2014 18:07:13 +0100
Message-Id: <49b0cf305ade3444c3dcf3fbabb5e1e5e720c16d.1389891730.git.dsterba@suse.cz>
In-Reply-To: <cover.1389891730.git.dsterba@suse.cz>
References: <cover.1389891730.git.dsterba@suse.cz>
In-Reply-To: <cover.1389891730.git.dsterba@suse.cz>
References: <cover.1389891730.git.dsterba@suse.cz>
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
 check | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/check b/check
index 9e4275b1fa37..d578e49b78d4 100755
--- a/check
+++ b/check
@@ -510,11 +510,11 @@ do
 				cat
 			else
 				head -n "$DIFF_LENGTH"
+				echo "..."
+				echo "(Run '$diff $seq.out $seqres.out.bad'"
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
