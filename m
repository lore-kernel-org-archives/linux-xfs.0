Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A66C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D4D611F2
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241879AbhIQAlX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 20:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241872AbhIQAlW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CFF2611C4;
        Fri, 17 Sep 2021 00:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839201;
        bh=aaPUDlLInNgEqiNlg2aIZrl6gGhVgTFJ2AwS2DaNqOU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G/5afHtp9TlbXIrL9Y8qTo6D1h31qyxZGr5fE2Kr7GkAxkH7/E1kGgGfyfZrrC5ql
         v2BC+HGAushSkylGpJru2HEMPFPVM7xi00A/qNMnyCxU7QmynVPK/MWQ+ctqGjXI1b
         utSahdWsGZuNOFnvS5OIU999S3IsukiJ9raEoqfQDpnppHo6Tf67Mq6UwPUXNp4eI9
         o7uZRntEEuikT7ZYwyCUEUZvq+Qqbbp76gU5ezuVciDyZp5btuovIcuQtBlHrHmHUB
         93eHLwM5wV95fjgauJXUpr7v3vrigL6WDhlCgh/aUgppfk2SHUeVyCmZa3JdwGGHzJ
         041QOs08hGqiw==
Subject: [PATCH 2/3] new: standardize group name checking
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 16 Sep 2021 17:40:00 -0700
Message-ID: <163183920093.953189.1288298157221770906.stgit@magnolia>
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

Use the same group name validation when reading group names from
standard input or from the command line.  Now that we require all group
names to be documented, there's no reason to leave these separate
requirements.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 new |   68 +++++++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 38 insertions(+), 30 deletions(-)


diff --git a/new b/new
index ea7cf25e..3a657d20 100755
--- a/new
+++ b/new
@@ -91,38 +91,46 @@ group_names() {
 	}' doc/group-names.txt
 }
 
+# Make sure that the new test's groups fit the correct format and are listed
+# in the group documentation file.
+check_groups() {
+	for g in "$@"; do
+		local inval="$(echo "${g}" | tr -d '[:lower:][:space:][:digit:]_')"
+		if [ -n "${inval}" ]; then
+			echo "Invalid characters in group(s): ${inval}"
+			echo "Only lower cases, digits and underscore are allowed in groups, separated by space"
+			return 1
+		elif ! group_names | grep -q -w "${g}"; then
+			echo "Warning: group \"${g}\" not defined in documentation"
+			return 1
+		fi
+	done
+
+	return 0
+}
+
 if [ $# -eq 0 ]; then
+	# interactive mode
 	prompt="Add to group(s) [other] (separate by space, ? for list): "
-    while true
-    do
-	read -p "${prompt}" ans || exit 1
-	test -z "${ans}" && ans=other
-	if [ "${ans}" = "?" ]; then
-	    echo $(group_names)
-	else
-	    # only allow lower cases, spaces, digits and underscore in group
-	    inval=`echo $ans | tr -d '[:lower:][:space:][:digit:]_'`
-	    if [ "$inval" != "" ]; then
-		echo "Invalid characters in group(s): $inval"
-		echo "Only lower cases, digits and underscore are allowed in groups, separated by space"
-		continue
-	    else
-		# remove redundant spaces/tabs
-		ans=`echo "$ans" | sed 's/\s\+/ /g'`
-		break
-	    fi
-	fi
-    done
+	while true; do
+		read -p "${prompt}" -a new_groups || exit 1
+		case "${#new_groups[@]}" in
+		0)
+			new_groups=("other")
+			;;
+		1)
+			if [ "${new_groups[0]}" = "?" ]; then
+				echo $(group_names)
+				continue
+			fi
+			;;
+		esac
+		check_groups "${new_groups[@]}" && break
+	done
 else
-    # expert mode, groups are on the command line
-    #
-    for g in $*
-    do
-	if ! grep -q "^$g" doc/group-names.txt; then
-	    echo "Warning: group \"$g\" not defined in documentation"
-	fi
-    done
-    ans="$*"
+	# expert mode, groups are on the command line
+	new_groups=("$@")
+	check_groups "${new_groups[@]}" || exit 1
 fi
 
 echo -n "Creating skeletal script for you to edit ..."
@@ -139,7 +147,7 @@ cat <<End-of-File >$tdir/$id
 # what am I here for?
 #
 . ./common/preamble
-_begin_fstest $ans
+_begin_fstest ${new_groups[@]}
 
 # Override the default cleanup function.
 # _cleanup()

