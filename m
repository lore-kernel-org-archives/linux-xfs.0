Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8833BC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D38B61212
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241859AbhIQAl3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 20:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241821AbhIQAl1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:41:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E82E611EE;
        Fri, 17 Sep 2021 00:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839206;
        bh=lOxPg35IZQjxcnlNins9aJGnfI+XvqldJIH82GknP1g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nGX9tP9//9cRv7WTEZ5uGw3f7kv+s1xqcbyybVev9boed+IJ8wcKNAAR3+jlzF5DT
         +jkfBcM0HuUU/1auoDAh5Judn0ULwZKFuLHtDn7fjutVy+u1aVCgqFf2kklv8ACnyz
         ST+69wsSHQepM25yd39pxtJt1Aq9a04Jg90GdRkXHCX2cFpjhvmbMHnQTZou0lXSCG
         jHTan0e7xkZGqRlU/uyLuBcQxFORHyGmp/w5PVeP7FnRM5Th+mnqlRCKS8y7Smdpf7
         1l9B2MGtdbK6UvsehH14FrcisXzEmLGGKCJ+Elh/aHzcWv9IOceFPLIp3EHZtuaW93
         KPucdCmlqlY8w==
Subject: [PATCH 3/3] new: don't allow new tests in group 'other'
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 16 Sep 2021 17:40:06 -0700
Message-ID: <163183920637.953189.13037781612178012211.stgit@magnolia>
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

The 'other' group is vaguely defined at best -- other than what?  It's
not clear what tests belong in this group, and it has become a dumping
ground for random stuff that are classified in other groups.  Don't let
people create new other group tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 new |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/new b/new
index 3a657d20..9651e0e0 100755
--- a/new
+++ b/new
@@ -100,6 +100,9 @@ check_groups() {
 			echo "Invalid characters in group(s): ${inval}"
 			echo "Only lower cases, digits and underscore are allowed in groups, separated by space"
 			return 1
+		elif [ "${g}" = "other" ]; then
+			echo "Do not add more tests to group \"other\""
+			return 1
 		elif ! group_names | grep -q -w "${g}"; then
 			echo "Warning: group \"${g}\" not defined in documentation"
 			return 1
@@ -111,16 +114,16 @@ check_groups() {
 
 if [ $# -eq 0 ]; then
 	# interactive mode
-	prompt="Add to group(s) [other] (separate by space, ? for list): "
+	prompt="Add to group(s) [auto] (separate by space, ? for list): "
 	while true; do
 		read -p "${prompt}" -a new_groups || exit 1
 		case "${#new_groups[@]}" in
 		0)
-			new_groups=("other")
+			new_groups=("auto")
 			;;
 		1)
 			if [ "${new_groups[0]}" = "?" ]; then
-				echo $(group_names)
+				echo $(group_names | grep -v -w 'other')
 				continue
 			fi
 			;;

