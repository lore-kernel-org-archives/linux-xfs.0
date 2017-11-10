Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38472 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752494AbdKJAoj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 19:44:39 -0500
Subject: [PATCH 2/4] common/fuzzy: ignore padding fields on xfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 09 Nov 2017 16:44:34 -0800
Message-ID: <151027467429.13147.14380548261091097144.stgit@magnolia>
In-Reply-To: <151027466195.13147.10381301768189156101.stgit@magnolia>
References: <151027466195.13147.10381301768189156101.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Padding fields are never checked and can have arbitrary values (if we
ever put them to use there'll be a feature flag) so there's no point
in fuzz-testing them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/fuzzy |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 87f7acc..b9c7399 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -79,6 +79,14 @@ _scratch_scrub() {
 	esac
 }
 
+# Filter out any keys with an array index >= 10, collapse any array range
+# ("[1-195]") to the first item, and ignore padding fields.
+__filter_xfs_db_keys() {
+	sed -e '/\([a-z]*\)\[\([0-9][0-9]\+\)\].*/d' \
+	    -e 's/\([a-zA-Z0-9_]*\)\[\([0-9]*\)-[0-9]*\]/\1[\2]/g' \
+	    -e '/pad/d'
+}
+
 # Filter the xfs_db print command's field debug information
 # into field name and type.
 __filter_xfs_db_print_fields() {
@@ -87,15 +95,13 @@ __filter_xfs_db_print_fields() {
 		filter='^'
 	fi
 	grep ' = ' | while read key equals value; do
-		# Filter out any keys with an array index >= 10, and
-		# collapse any array range ("[1-195]") to the first item.
-		fuzzkey="$(echo "${key}" | sed -e '/\([a-z]*\)\[\([0-9][0-9]\+\)\].*/d' -e 's/\([a-zA-Z0-9_]*\)\[\([0-9]*\)-[0-9]*\]/\1[\2]/g')"
+		fuzzkey="$(echo "${key}" | __filter_xfs_db_keys)"
 		if [ -z "${fuzzkey}" ]; then
 			continue
 		elif [[ "${value}" == "["* ]]; then
 			echo "${value}" | sed -e 's/^.//g' -e 's/.$//g' -e 's/,/\n/g' | while read subfield; do
 				echo "${fuzzkey}.${subfield}"
-			done
+			done | __filter_xfs_db_keys
 		else
 			echo "${fuzzkey}"
 		fi

