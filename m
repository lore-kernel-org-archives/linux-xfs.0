Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E77C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C1E611EE
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241815AbhIQAlI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 20:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241734AbhIQAlI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:41:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 064FA611C8;
        Fri, 17 Sep 2021 00:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839187;
        bh=tHksTrsy5q6LS4W5NwMZgLg5965wSKK+qqzKJy4kPZw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jaxUzTrIW9x065NGf+CGqbiRzrxlDl+ryRZDHOdJ9LzB5Seb/sloJyHDYnOj9k9j2
         IDsft0AlnSraQ8Ua+C/0essU2F0XR12Hy/y9yfKPlUPSigN5BL66vJ9jf1YPPCj3qL
         EPZq++8fgrChz57LqPH/WZ7v5y06feD6zAPDDtkLdsJbOZYKm4bDObtKR9vUWQE2Qc
         E/cWvsCkXb3cdnlxNh6sVTqS+pYAuqCoJGkVplTnTZD+9JAZwQ3Bs1O70cQgcbkzi9
         19dyaM4WBLwL/XYpQKtp+BO324BUDmnyUvZY0MAHQ+dFbMCNvisY8Kahmkt8XPVK26
         88QKegPWzfrOA==
Subject: [PATCH 8/8] new: only allow documented test group names
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 16 Sep 2021 17:39:46 -0700
Message-ID: <163183918676.952957.10906553908004142603.stgit@magnolia>
In-Reply-To: <163183914290.952957.11558799225344566504.stgit@magnolia>
References: <163183914290.952957.11558799225344566504.stgit@magnolia>
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
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
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

