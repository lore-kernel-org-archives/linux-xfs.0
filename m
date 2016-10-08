Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751314AbcJHIy1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 8 Oct 2016 04:54:27 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs/122: remove dead code
Date: Sat,  8 Oct 2016 16:53:56 +0800
Message-Id: <1475916836-30439-1-git-send-email-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

Seems this hunk of dead code is used for debug purpose to inspect
what the output looks like after _attribute_filter. Just remove it.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/xfs/122 | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tests/xfs/122 b/tests/xfs/122
index 330d3ac..f39ceba 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -196,10 +196,6 @@ echo 'int main(int argc, char *argv[]) {' >>$cprog
 #
 cat /usr/include/xfs/xfs*.h | indent |\
 _attribute_filter |\
-egrep '(} *xfs_.*_t|^struct xfs_[a-z0-9_]*$)' > /tmp/barf
-
-cat /usr/include/xfs/xfs*.h | indent |\
-_attribute_filter |\
 egrep '(} *xfs_.*_t|^struct xfs_[a-z0-9_]*$)' |\
 egrep -v -f $tmp.ignore |\
 sed -e 's/^.*}[[:space:]]*//g' -e 's/;.*$//g' -e 's/_t, /_t\n/g' |\
-- 
2.7.4

