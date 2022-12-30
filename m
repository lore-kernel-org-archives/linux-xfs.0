Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EABC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235964AbiLaAuK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiLaAuK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:50:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380F91C90A;
        Fri, 30 Dec 2022 16:50:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9D19ECE19DE;
        Sat, 31 Dec 2022 00:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8C9C433D2;
        Sat, 31 Dec 2022 00:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447805;
        bh=LReZUtiiLtA24sAwo5AE7gGUUPGAkzXUG2q0DJXRAPA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qHuCvGPLuAVCU37R34JWKtjKsJT6TOvjLcnmnnabM3aguvJzpA+GjoGv4SuWvh+cg
         n5H+bHw0tmrhl2FsbCU0XYkIu9wAziVtxoU2RWjHjg+epkMnJ+2/JpmwqO4VoaMl6S
         rI6B5R8we/AmmtZHJF+MaP6cm/ElEtGcM8ptCb/2OkdfG3U4KdnL5TyzGn9/uu67L8
         4MgOZDA0AF+xWEG+ycvWYdA6LFTFLyoyWPhmIXOfST3FEmfDY9iGP7Zu1h7ARpt/2N
         ndZQnDbO64NRHa+EensWUYbRQvmoextpsXbG9h96axhPDYfBK9K8P41sfAI7ZHaDpA
         yohJ6qdXiEPCg==
Subject: [PATCH 23/24] xfs: improve metadata array field handling when fuzzing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:42 -0800
Message-ID: <167243878198.730387.15283951286419535093.stgit@magnolia>
In-Reply-To: <167243877899.730387.9276624623424433346.stgit@magnolia>
References: <167243877899.730387.9276624623424433346.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, we use some gnarly regular expressions to try to constrain
the amount of time we spend fuzzing each element of a metadata array.
This is pretty inflexible (and buggy) since we limit some arrays
(e.g. dir hashes) to the first ten elements and other arrays (e.g.
extent mappings) that use compact index ranges to the first one.

Replace this whole weird mess with logic that can tease out the array
indices, unroll the compact indices if needed, and give the user more
flexible control over which array elements get used.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   52 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 9 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index f34fcadefe..53fe22db69 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -53,12 +53,46 @@ _scratch_scrub() {
 	esac
 }
 
-# Filter out any keys with an array index >= 10, collapse any array range
-# ("[1-195]") to the first item, and ignore padding fields.
-__filter_xfs_db_keys() {
-	sed -e '/\([a-z]*\)\[\([0-9][0-9]\+\)\].*/d' \
-	    -e 's/\([a-zA-Z0-9_]*\)\[\([0-9]*\)-[0-9]*\]/\1[\2]/g' \
-	    -e '/pad/d'
+# Expand indexed keys (i.e. arrays) into a long format so that we can filter
+# the array indices individually, and pass regular keys right through.
+#
+# For example, "u3.bmx[0-1] = [foo,bar]" is exploded into:
+# u3.bmx[0] = [foo,bar]
+# u3.bmx[1] = [foo,bar]
+#
+# Note that we restrict array indices to [0-9] to reduce fuzz runtime.  The
+# minimum and maximum array indices can be changed by setting the variables
+# SCRATCH_XFS_{MIN,MAX}_ARRAY_IDX.
+#
+# Also filter padding fields.
+__explode_xfs_db_fields() {
+	local min_idx="${SCRATCH_XFS_MIN_ARRAY_IDX}"
+	local max_idx="${SCRATCH_XFS_MAX_ARRAY_IDX}"
+
+	test -z "${min_idx}" && min_idx=0
+	test -z "${max_idx}" && max_idx=9
+	test "${max_idx}" = "none" && max_idx=99999
+
+	grep ' = ' | \
+	sed -e 's/^\([.a-zA-Z0-9_]*\)\[\([0-9]*\)-\([0-9]*\)\]\(.*\) = \(.*\)$/\1[%d]\4 \2 \3 = \5/g' \
+	    -e 's/^\([.a-zA-Z0-9_]*\)\[\([0-9]*\)\]\(.*\) = \(.*\)$/\1[%d]\3 \2 \2 = \4/g' | \
+	while read name col1 col2 rest; do
+		if [[ "${name}" == *pad* ]]; then
+			continue
+		fi
+
+		if [ "${col1}" = "=" ]; then
+			echo "${name} ${col1} ${col2} ${rest}"
+			continue
+		fi
+
+		test "${min_idx}" -gt "${col1}" && col1="${min_idx}"
+		test "${max_idx}" -lt "${col2}" && col2="${max_idx}"
+
+		seq "${col1}" "${col2}" | while read idx; do
+			printf "${name} %s\n" "${idx}" "${rest}"
+		done
+	done
 }
 
 # Filter out metadata fields that are completely controlled by userspace
@@ -96,14 +130,14 @@ __filter_xfs_db_print_fields() {
 	if [ -z "${filter}" ] || [ "${filter}" = "nofilter" ]; then
 		filter='^'
 	fi
-	grep ' = ' | while read key equals value; do
-		fuzzkey="$(echo "${key}" | __filter_xfs_db_keys)"
+	__explode_xfs_db_fields | while read key equals value; do
+		fuzzkey="$(echo "${key}")"
 		if [ -z "${fuzzkey}" ]; then
 			continue
 		elif [[ "${value}" == "["* ]]; then
 			echo "${value}" | sed -e 's/^.//g' -e 's/.$//g' -e 's/,/\n/g' | while read subfield; do
 				echo "${fuzzkey}.${subfield}"
-			done | __filter_xfs_db_keys
+			done
 		else
 			echo "${fuzzkey}"
 		fi

