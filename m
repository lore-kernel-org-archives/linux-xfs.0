Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0082C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B948D610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhIOXol (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhIOXok (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:44:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FDD260F25;
        Wed, 15 Sep 2021 23:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749401;
        bh=GRcPOIw1lNn1TdWhOuyKf5aex8PKCEBHDTJwOCI6KVw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Zv0oMebsl+DDyapzqVB15uBYImCcJEHa7aK4fKhjSjm75aEDqI3YKaXUYsJMeimrM
         xhY+CinkHOAj6IoXoelKRNcdxguJ5Gp3qZqwXseean6sCsaz2Q9/SWzbbwscRYF06q
         8qtBZJa2I3m6b8vjIz9XLug5CRHm0RFkdsjV76TAuYVEashcJBXbOmzeBtqzbjHAcw
         9kobXSt3MUIoaanTgkgVX4Lj6PB0Ij8rFVptsxCHGqKvVJiRCrj9jEaaUrkz35BQBa
         +SdJU6A204CEibJZQyPVviJkoUEmN45s/uuD20JyuyDR0rBTDRezTe7XGHeDs4p/xo
         nGUv+E8/WfvwQ==
Subject: [PATCH 8/9] new: only allow documented test group names
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:43:21 -0700
Message-ID: <163174940111.380880.3160888950588893158.stgit@magnolia>
In-Reply-To: <163174935747.380880.7635671692624086987.stgit@magnolia>
References: <163174935747.380880.7635671692624086987.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we require all group names to be listed in doc/group-names.txt,
we can use that (instead of running mkgroupfile) to check if the group
name(s) supplied by the user actually exist.  This has the secondary
effect of being a second nudge towards keeping the description of groups
up to date.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 new |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)


diff --git a/new b/new
index 2097a883..6b7dc5d4 100755
--- a/new
+++ b/new
@@ -83,6 +83,14 @@ then
     exit 1
 fi
 
+# Extract group names from the documentation.
+group_names() {
+	awk '/^[[:lower:][:digit:]_]/ {
+		if ($1 != "" && $1 != "Group" && $2 != "Name:" && $1 != "all")
+			printf("%s\n", $1);
+	}' doc/group-names.txt
+}
+
 if [ $# -eq 0 ]
 then
 
@@ -93,16 +101,7 @@ then
 	[ -z "$ans" ] && ans=other
 	if [ "X$ans" = "X?" ]
 	then
-	    for d in $SRC_GROUPS; do
-		(cd "tests/$d/" ; ../../tools/mkgroupfile "$tmpfile")
-		l=$(sed -n < "$tmpfile" \
-		    -e 's/#.*//' \
-		    -e 's/$/ /' \
-		    -e 's;\(^[0-9][0-9][0-9]\)\(.*$\);\2;p')
-		grpl="$grpl $l"
-	    done
-	    lst=`for word in $grpl; do echo $word; done | sort| uniq `
-	    echo $lst
+	    echo $(group_names)
 	else
 	    # only allow lower cases, spaces, digits and underscore in group
 	    inval=`echo $ans | tr -d '[:lower:][:space:][:digit:]_'`
@@ -120,11 +119,10 @@ then
 else
     # expert mode, groups are on the command line
     #
-    (cd "$tdir" ; ../../tools/mkgroupfile "$tmpfile")
     for g in $*
     do
-	if ! grep -q "[[:space:]]$g" "$tmpfile"; then
-	    echo "Warning: group \"$g\" not defined in $tdir tests"
+	if ! grep -q "^$g" doc/group-names.txt; then
+	    echo "Warning: group \"$g\" not defined in documentation"
 	fi
     done
     ans="$*"

