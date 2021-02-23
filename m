Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EDAC4332D
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B80864E83
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhBWDBH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:01:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230053AbhBWDBF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:01:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75E4F64E4B;
        Tue, 23 Feb 2021 03:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049224;
        bh=5pnUKDxlNzYshv6ZJSR7usR+mfwHbm6zGSoMv4O+oMI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=F27NN6/7OIOEYVdcjwC1ddrDouI6/jHyE6HxzsZMlDntg6d1jrA976/iQ3i5FaplR
         bl5jHKxQAPOZxV5/vYTfjObA5V/6OETCJZ3FFd0lSzWqOJ6BgzjH8W70xujbi4Efn1
         qLfVbn1g5xZvhcFNIMwpaJr/zmtrfsKr2/nUqCBfqLgPc/7IXM9+XGykoRz/u45vH0
         Yz8a+YdQM6N3rTr1NPWv1BApOO1TpQr5eo1HoHn0t2phahju6TQVyWotoc/EK4D8A/
         ZjH7zSHroeRiBGR5Ey00uz7lLhtXQBpNG8ER3Ho2dhuNTKdyNULDFs6+AwnHb9V6to
         6wWcODKcFjlOQ==
Subject: [PATCH 1/7] xfs_admin: clean up string quoting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:00:24 -0800
Message-ID: <161404922408.425352.8871380789546968040.stgit@magnolia>
In-Reply-To: <161404921827.425352.18151735716678009691.stgit@magnolia>
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clean up the string quoting in this script so that we don't trip over
users feeding us arguments like "/dev/sd ha ha ha lol".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 db/xfs_admin.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index bd325da2..71a9aa98 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -43,7 +43,7 @@ case $# in
 
 		if [ -n "$DB_OPTS" ]
 		then
-			eval xfs_db -x -p xfs_admin $DB_OPTS $1
+			eval xfs_db -x -p xfs_admin $DB_OPTS "$1"
 			status=$?
 		fi
 		if [ -n "$REPAIR_OPTS" ]
@@ -53,7 +53,7 @@ case $# in
 			# running xfs_admin.
 			# Ideally, we need to improve the output behaviour
 			# of repair for this purpose (say a "quiet" mode).
-			eval xfs_repair $REPAIR_OPTS $1 2> /dev/null
+			eval xfs_repair $REPAIR_OPTS "$1" 2> /dev/null
 			status=`expr $? + $status`
 			if [ $status -ne 0 ]
 			then

