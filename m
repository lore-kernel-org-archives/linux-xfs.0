Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B28C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E73C861216
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241848AbhIQAlR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 20:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241821AbhIQAlQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:41:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B598B611EE;
        Fri, 17 Sep 2021 00:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839195;
        bh=hAoEiKSz7HwtWsrHBERX4sHFy3K76eWmeT0zUxCj/Yw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PmSgq8oFEmXqIlvk1dUCdgOyIY+H7jcGJBdFJ6z0OXUfhk4nt22TCXW0DsUro5QK5
         m8lmACOHN7kauXPBG1tHP8+Ty/5bCYiIZOrbKWcudo8gnINw6Iu+QnPc2YIDYGrHHQ
         oxjR8xItw56LUc0yDHSE7TQ/QmHCa7usfJzoWZvzwKkxWNEdorN8Tdp+L1JaulmtSF
         mm1qGt385rQUhrJibrEAfJOId3gYd+FVOSMzfPmPIKz3eBhlKTzTiTykHxkRKs3gVJ
         AvoxG/OI9odXLE/Fu3gGIfTWOxqReL/ZEBYoWuxTgHfGs3fwn4en8DxSDYIXCDT4fq
         UrFeWuMda6tKQ==
Subject: [PATCH 1/3] new: clean up the group name input code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 16 Sep 2021 17:39:55 -0700
Message-ID: <163183919544.953189.7870290547648551530.stgit@magnolia>
In-Reply-To: <163183918998.953189.9876855385681643134.stgit@magnolia>
References: <163183918998.953189.9876855385681643134.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clean up the code that reads group names in from the command line to
take advantage of the read command's ability to display a prompt.  While
we're at it, we should abort the script if the group list encounters
EOF, and we can tighten up some of the other sh-isms too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 new |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)


diff --git a/new b/new
index 6b7dc5d4..ea7cf25e 100755
--- a/new
+++ b/new
@@ -91,16 +91,13 @@ group_names() {
 	}' doc/group-names.txt
 }
 
-if [ $# -eq 0 ]
-then
-
+if [ $# -eq 0 ]; then
+	prompt="Add to group(s) [other] (separate by space, ? for list): "
     while true
     do
-	echo -n "Add to group(s) [other] (separate by space, ? for list): "
-	read ans
-	[ -z "$ans" ] && ans=other
-	if [ "X$ans" = "X?" ]
-	then
+	read -p "${prompt}" ans || exit 1
+	test -z "${ans}" && ans=other
+	if [ "${ans}" = "?" ]; then
 	    echo $(group_names)
 	else
 	    # only allow lower cases, spaces, digits and underscore in group

