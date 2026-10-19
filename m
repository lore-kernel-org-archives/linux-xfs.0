Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792425417;
	b=BBfDJXXs3b4otWjs5YBtodSu1AMe50ss2RHfemE1djparQoTHLbGkT18q9/kuqNrvwkh
	 rUgYH+ZcSG+W4o0tD0rBZTl4M2Nn9rVtI3fh/KMbof6Qi3ppalq0U6nhUJ1cIizQKj1aW
	 6XnVg5rGvIGIIPGRqSzGWiVLim8tzinxnCs8MkEObzhL7yRG3G1Jn7TAfw6f3DyWwCL7V
	 k7oETF9sGoYITl60ziHlRvD1xAl3/DcUkhioOVfCtnNbbs6j4xrPwWZ//c4gzMJYft0qR
	 /cinm+tCit74dyPJ5Q/j5DtFrV73/DRO5ADdIHs/C7S8RhX7izqYgWMauyeVp4PgscA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792425417;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=aMd2xDRTvryB/oPSwb+vSSy7vyHuY2KsMQWYkzVJ800=;
	b=Jj9ny0yn9MGjewrQSJIcgRgoT7/uvlFs6NN3m7Y8pzVRUKRNp85e80IvYxiuorTODd4y
	 x1qQCa0jJWs8/EFdav5QHPyNntggsybpV73lGpS4FINwL/ACcBD06/IyBG9MjlxOIhA9W
	 3MtDG7tABnjGDC27ddzqqETo28jtfq4PFDRMtQ/mXF5VGNYH1l5gVcorJMyvqby2KtKNO
	 bX9z3saUKxZ9PRr2z73chHhcF/0TIlFu4I68b3MgUlqHH77d1Z3vDwFvzadUbmLgvZPGz
	 xCYPI7nknQF7t0CpZPkInZb4JfkS1KQ770LJzTJSZQY7QpHQEfpjF8VkuhRCa4gtp9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FWYHsGeg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CE924606AAE0
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 15:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FWYHsGeg
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 613961F000C5;
	Mon, 19 Oct 2026 15:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425416;
	bh=aMd2xDRTvryB/oPSwb+vSSy7vyHuY2KsMQWYkzVJ800=;
	h=Date:From:To:Cc:Subject;
	b=FWYHsGegcdCmry8kDK6nToe/pN+frxvnCoYe5hBpF9UdBlam6MqkwUiWmCOQQI39l
	 MpKZZo0Svm+h8S8uhyAMe0jNlC0NpU1LHUsl6yxLIxURIFIrmFLVnufdatADzsS+o6
	 5V9vj/cWpr0VzxMKW2Iv04ZRZBpTqJQSjRpFEDDOOW92XHEUD/tlLxFnN9bnvwBHVg
	 +4/iu+ogAnHMUV7hC16kxDcz8PEpABGWKKiCjRUDQymR5D8OIoTNXyZg6xrttlafWz
	 Ikc/z7NcpSDbQ6wNAQZTr6ERSlro2jgOWtEqZTGbTe5AiSkTmKcUWPLRLQiIYUR+uV
	 RLEbxrbgte3MQ==
Date: Mon, 19 Oct 2026 08:56:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v2] tools: add a new script to generate fixes tags
Message-ID: <20261019155655.GD1612213@frogsfrogsfrogs>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Add a program that can generate Fixes: tags for a new bugfix commit to
cite an older buggy commit.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
v2: add a description of the program to the --help output
---
 tools/git-fixes |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100755 tools/git-fixes

diff --git a/tools/git-fixes b/tools/git-fixes
new file mode 100755
index 00000000000000..03f566df2b415e
--- /dev/null
+++ b/tools/git-fixes
@@ -0,0 +1,62 @@
+#!/bin/bash
+
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+# Copyright (c) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+# Cite a list of git hashes in Fixes: tag format.
+
+if [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Usage: $0 commit [commits...]"
+	echo "Generate Fixes: tags for each commit passed in, along with a Cc:"
+	echo "line for the author.  If 'user.stableSubmissionTarget' is set in"
+	echo "the git configuration, a Cc: header will be generated with a"
+	echo "comment identifying the first tag created after the commit."
+	exit 1
+fi
+
+stable_email="$(git config user.stableSubmissionTarget)"
+
+# Find the most recent version tag for this commit.  Assumes that version tags
+# start with v and a digit.
+tag_for_commit() {
+	local arg="$1"
+	local tag
+	local release_tag
+	local rc_suffix
+
+	# Find the first tag created after this commit.
+	tag="$(git tag -l --contains "${arg}" --sort version:refname | \
+		grep "^v[0-9]" | \
+		head -n 1)"
+	test -z "${tag}" && return 1
+
+	# Strip off any version suffix (presumably "-rcX") to construct what
+	# ought to be the tag name for the final release.
+	rc_suffix="$(git config versionsort.suffix)"
+	# shellcheck disable=SC2001
+	release_tag="$(echo "${tag}" | sed -e "s/${rc_suffix}.*//g")"
+
+	# If the release tag actually exists, print that instead of the first
+	# tag.  Otherwise, print that first tag.  We'd rather print "v5.4" than
+	# the more accurate "v5.4-rc1" because stable backports target
+	# releases, not -rcX.
+	if [ -n "$(git tag -l "${release_tag}" 2>/dev/null)" ]; then
+		echo "${release_tag}"
+	else
+		echo "${tag}"
+	fi
+	return 0
+}
+
+gitcc=(git log --format='Cc: <%aE>')
+gitfixes=(git log --format='Fixes: %h ("%s")')
+for arg in "$@"; do
+	"${gitcc[@]}" "${arg}^1..${arg}"
+	if [ -n "${stable_email}" ]; then
+		fixed_in="$(tag_for_commit "${arg}")" && \
+			echo "Cc: <${stable_email}> # ${fixed_in}"
+	fi
+	"${gitfixes[@]}" "${arg}^1..${arg}"
+done
