Return-Path: <SRS0=x8pl=ID=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BC2C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 22:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 725556509E
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 22:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCEWAf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 17:00:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhCEWAY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Mar 2021 17:00:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F420C65092;
        Fri,  5 Mar 2021 22:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614981624;
        bh=XNbsOK6JbyNN7Zwv9RhiEku+oIxk7dfiuwAr7aOiHYA=;
        h=Date:From:To:Cc:Subject:From;
        b=N1g/M1624YVVd4tMPRTVWNH/0IaYjrgrRm4QyXtujQKtpG30E9AVltXFbGDJy1c0K
         0PflYhWoSPgyzEZpLwMLHFt0kDbwcB5apmbYKffNTY1ETWZQSka54iGAYEsqaeTX9n
         2Puk4ZM+OIZPcpXNpQlyK0PDRVBQt9bxKxltBb+SlXdnGgmxEkGNCNY6PpQ0zQHeeb
         ARCPtLcUIuoFl5G0qTbaEWZyIlXmQ2vuRsqae8Fb+W15gEIeZgz6BnnpFym9XwgSUx
         EA6bqmS9BC93ReCrECqmwwJC8etj97BQiCV9XkfVTANVu2DI34bNLWbzWNGYinmZth
         XB1vtIUC3M4YQ==
Date:   Fri, 5 Mar 2021 14:00:21 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_admin: don't hide the xfs_repair output when upgrading
Message-ID: <20210305220021.GI3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, xfs_admin suppresses the output from xfs_repair when it tries
to upgrade a filesystem, and prints a rather unhelpful message if the
upgrade fails.

Neither of these behaviors are useful -- repair can fail for reasons
outside of the filesystem being mounted, and if it does, the admin will
never know what actually happened.

Worse yet, if repair finds corruptions on disk, the upgrade script
silently throws all that away, which means that nobody will ever be able
to report what happened if an upgrade trashes a filesystem.

Therefore, allow the console to capture all of repair's stdout/stderr
reports.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/xfs_admin.sh |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 02f34b73..916050cb 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -51,17 +51,9 @@ case $# in
 		fi
 		if [ -n "$REPAIR_OPTS" ]
 		then
-			# Hide normal repair output which is sent to stderr
-			# assuming the filesystem is fine when a user is
-			# running xfs_admin.
-			# Ideally, we need to improve the output behaviour
-			# of repair for this purpose (say a "quiet" mode).
-			eval xfs_repair $REPAIR_DEV_OPTS $REPAIR_OPTS "$1" 2> /dev/null
+			echo "Running xfs_repair to upgrade filesystem."
+			eval xfs_repair $REPAIR_DEV_OPTS $REPAIR_OPTS "$1"
 			status=`expr $? + $status`
-			if [ $status -ne 0 ]
-			then
-				echo "Conversion failed, is the filesystem unmounted?"
-			fi
 		fi
 		;;
 	*)	echo $USAGE 1>&2
