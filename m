Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbeAUHYE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 21 Jan 2018 02:24:04 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 2/2] fstests: expunge tests when doing a dry run
Date: Sat, 20 Jan 2018 23:24:01 -0800
Message-Id: <20180121072401.1047-2-mcgrof@kernel.org>
In-Reply-To: <20180121072401.1047-1-mcgrof@kernel.org>
References: <20180121072401.1047-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

Running ./check with -n will not execute tests, however
when exclude files are used we still show them as if
they are run. Test the exclude file prior to assuming
we can run a test on a dry run.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 check | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/check b/check
index 0ba71d5d2005..43b8d6c3d127 100755
--- a/check
+++ b/check
@@ -666,6 +666,10 @@ for section in $HOST_OPTIONS_SECTIONS; do
 	    echo -n "$seqnum"
 
 	    if $showme; then
+		_expunge_test $seqnum
+		if [ $? -eq 1 ]; then
+			continue
+		fi
 		echo
 		start=0
 		stop=0
-- 
2.15.0

