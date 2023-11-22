Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865B1C61D97
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbjKVXHW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbjKVXHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:07:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D52F1AB
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:07:17 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311B7C433C7;
        Wed, 22 Nov 2023 23:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694437;
        bh=i9tmMkUvnDjPofWgjMT3xzPxJOD2WAZW77uZ00KAIpQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tVhJa+TXbRfKFc6Pxo5TZXdnmv1rWYgUWIoaxryncCWj9VE3pXD+z3g1phxY/Ir+a
         D+gp0a+Cmkt0jTdG7JQvQAyXUqCq4ASxRplg0SX3pgNS9XQqIny8BlT82EwDVrpJ40
         cvNmega5VOq7rh/lEU9ZEKKLDLYAFOQtq5s4aRHujdui+DlmumT8qIbPVH9WwWWN3u
         PR/Pajz8RRJd5Wt6GYoxCQIpFS7VRJimhqb0gYkupLa9sK5gfHlYuOZ5b65OMFkNtm
         9HhWapmW9BsI8B+E090WNw9mm1gHekl379g1EwvQEJFRQFnxto5BBQVsvzlzoyZqzB
         XWzi8g/KN8CvQ==
Subject: [PATCH 5/9] xfs_metadump.8: update for external log device options
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:07:16 -0800
Message-ID: <170069443670.1865809.2265862857261044359.stgit@frogsfrogsfrogs>
In-Reply-To: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the documentation to reflect that we can metadump external log
device contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_mdrestore.8 |    6 +++++-
 man/man8/xfs_metadump.8  |    7 +++++--
 2 files changed, 10 insertions(+), 3 deletions(-)


diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index 6e7457c0445..f60e7b56ebf 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -14,6 +14,10 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
 .br
 .B xfs_mdrestore
 .B \-i
+[
+.B \-l
+.I logdev
+]
 .I source
 .br
 .B xfs_mdrestore \-V
@@ -52,7 +56,7 @@ Shows metadump information on stdout.  If no
 is specified, exits after displaying information.  Older metadumps man not
 include any descriptive information.
 .TP
-.B \-l " logdev"
+.BI \-l " logdev"
 Metadump in v2 format can contain metadata dumped from an external log.
 In such a scenario, the user has to provide a device to which the log device
 contents from the metadump file are copied.
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index 1732012cd0c..496b5926603 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -132,8 +132,11 @@ is stdout.
 .TP
 .BI \-l " logdev"
 For filesystems which use an external log, this specifies the device where the
-external log resides. The external log is not copied, only internal logs are
-copied.
+external log resides.
+If the v2 metadump format is selected, the contents of the external log will be
+copied to the metadump.
+The v2 metadump format will be selected automatically if this option is
+specified.
 .TP
 .B \-m
 Set the maximum size of an allowed metadata extent.  Extremely large metadata

