Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E5DA77F3F
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 01:12:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 81FE6AC005
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 23:12:51 -0700 (PDT)
Received: from mail-da0-f54.google.com (mail-da0-f54.google.com
	[209.85.210.54]) by cuda.sgi.com with ESMTP id JgPgtwsFkKh5mr6u
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Apr 2013 23:12:50 -0700 (PDT)
Received: by mail-da0-f54.google.com with SMTP id p1so998588dad.27
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 23:12:50 -0700 (PDT)
Message-ID: <5167A5D3.4070903@gmail.com>
Date: Fri, 12 Apr 2013 14:12:35 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix the regex pattern in get_group_list of check
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>, Dave Chinner <dchinner@redhat.com>, xfstests <xfs@oss.sgi.com>

In group files, non comment line starts with a 3-digits, then followed by
space and other characters, but no group names.

The old regex in get_group_list uses the group name as part of the regex,
and fails './check -g xfs' run:
         Group "xfs" is empty or not defined?

The patch removes the pattern for group name, and thus we can trigger tests
like "./check -g xfs" as normal.
	

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  check | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check b/check
index 966fbe5..abc65cb 100755
--- a/check
+++ b/check
@@ -100,7 +100,7 @@ get_group_list()
  		l=$(sed -n < $SRC_DIR/$d/group \
  			-e 's/#.*//' \
  			-e 's/$/ /' \
-			-e "s;\(^[0-9][0-9][0-9]\).* $grp .*;$SRC_DIR/$d/\1;p")
+			-e "s;\(^[0-9][0-9][0-9]\) .*;$SRC_DIR/$d/\1;p")
  		grpl="$grpl $l"
  	done
  	echo $grpl
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
