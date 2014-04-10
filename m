Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB18A7F87
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 04:55:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8F0C48F8052
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 02:55:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ByMsY2J06ZpDFrJS for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 02:55:42 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3A9tgdb011928
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:55:42 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfstests: fix specifying configuration value with equality
	sign
Date: Thu, 10 Apr 2014 11:55:37 +0200
Message-Id: <1397123737-3478-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

Currently there is a problem with parse_config_section() when the
configuration value contains equality sign like this for example:

MOUNT_OPTIONS="-o data=journal"

the result will be

export MOUNT_OPTIONS="-o data="journal"

which is not going to work. The reason is that the expression used to
parse the configuration options uses greedy matching '.*'. Fix this by
using non greedy expression to match the first equality sign '[^=]'.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/config b/common/config
index 00249e6..49f34cf 100644
--- a/common/config
+++ b/common/config
@@ -349,7 +349,7 @@ parse_config_section() {
 		-e 's/#.*$//' \
 		-e 's/[[:space:]]*$//' \
 		-e 's/^[[:space:]]*//' \
-		-e "s/^\(.*\)=\"\?'\?\([^\"']*\)\"\?'\?$/export \1=\"\2\"/" \
+		-e "s/^\([^=]*\)=\"\?'\?\([^\"']*\)\"\?'\?$/export \1=\"\2\"/" \
 		< $HOST_OPTIONS \
 		| sed -n -e "/^\[$SECTION\]/,/^\s*\[/{/^[^#].*\=.*/p;}"`
 }
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
