Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB69uWeq203983 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 03:56:32 -0600
Received: from ysabell.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19BDE1F431D8
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 01:56:30 -0800 (PST)
Received: from ysabell.rzone.de (ysabell.rzone.de [81.169.144.237]) by
	cuda.sgi.com with ESMTP id pNOtWpOuSWNHwfkd for
	<xfs@oss.sgi.com>; Tue, 06 Dec 2011 01:56:30 -0800 (PST)
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] xfstests: check if qa user can execute commands
Date: Tue,  6 Dec 2011 10:56:29 +0100
Message-Id: <1323165389-5419-1-git-send-email-list.btrfs@jan-o-sch.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

_require_user only checks if the qa user exists in /etc/passwd. It may exist
though still not be able to execute anything (e.g. with a /bin/false shell).

_user_do cannot determine failure to execute the given command, as it uses
_user_do_filter for post-processing which succeeds even if the command
fails. Thus, the check should be performed by _require_user.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 common.rc |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index cab0b64..f540a79 100644
--- a/common.rc
+++ b/common.rc
@@ -897,6 +897,8 @@ _require_user()
     qa_user=fsgqa
     _cat_passwd | grep -q $qa_user
     [ "$?" == "0" ] || _notrun "$qa_user user not defined."
+    echo /bin/true | su $qa_user
+    [ "$?" == "0" ] || _notrun "$qa_user cannot execute commands."
 }
 
 _filter_user_do()
-- 
1.7.2.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
