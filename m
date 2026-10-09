Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8256847607C
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589992; cv=none; b=Wiifnz6pO3lmfDAdfFnFDyuxjIFoevTrqnUMGFiOt9xH77+9jSXLOLuLsfd86dZ4sRFTL4DwQoBQYpYUcsq3NQceUNGUx/sq1LxgpVi6j3iotR/baC2QgkgUHuWZ+3+wCncvX9B3/8tP3ruWyXjJR9Wi2zsn3MnCkKEXk4xPGsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589992; c=relaxed/simple;
	bh=Sa3happOIvVbmDT+E9SBiVBf0SbuyEpmrkqUqYhqqoA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VuCKy8cY6JBL5k7G3vPukpjbaMpO29XJxBECY4OXfAIfbAy9rRj3TcYZOeu3Wu6L86eMwuSEsYIDpAZXjOOXvMzJ+u1zBenYS/6/rupJ6+vOAaAALFsDL6geVPDOrtRgIZkFx5Uqnr/jTGgtA1qus4wwL6PG8xWrAlYkig39MNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ne28aDVa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ne28aDVa"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 598CD1F000FF;
	Fri,  9 Oct 2026 23:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589991;
	bh=hzfWk8qLHTbo8eIU/vAnFoLFXGgpsWsXQUzFW+B2rKs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ne28aDVa0w3UjVfXaiabmG+fmCQK0nYbq7NVcTruD2CWG9UL5DNJyRjTeeYT2j6vj
	 H5FCbupXnjtieHDzUsjzfCJkWx4syQZUyiNsOXzAhW41kcHvzn0Q0M2L5rxsc9gXcg
	 fvfjuhNcIAqo+Ma+KLQEDyWPDnsC2Hh/24Gdo/iVLRInEW96bxfRikQ1nHSDpQHgsr
	 VZ6ytsv0rOavMMiDZoqCbXddgShNiTJhsT5R18W4+VjtKE3VZB5Vf10jMpZxq2RIC1
	 6aqKLuvj/Db7Y1ZkZNPj6II29AfI7uNiTDLyGy3hQRDZuKndcY1gvlgTcjzi6aXW2f
	 +EoofUJI+mpPQ==
Date: Fri, 09 Oct 2026 16:53:10 -0700
Subject: [PATCH 1/3] tools: add a new script to generate fixes tags
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179158948300.3720929.2141793283079787803.stgit@frogsfrogsfrogs>
In-Reply-To: <179158948269.3720929.14224184767079938461.stgit@frogsfrogsfrogs>
References: <179158948269.3720929.14224184767079938461.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a program that can generate Fixes: tags for a new bugfix commit to
cite an older buggy commit.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tools/git-fixes |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100755 tools/git-fixes


diff --git a/tools/git-fixes b/tools/git-fixes
new file mode 100755
index 00000000000000..5729de462e7183
--- /dev/null
+++ b/tools/git-fixes
@@ -0,0 +1,61 @@
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
+	local version_prefix
+
+	# Find the first tag created after this commit.
+	version_prefix="$(git config versionsort.prefix)"
+	test -z "${version_prefix}" && version_prefix="v"
+	tag="$(git tag -l --contains "${arg}" --sort version:refname | \
+		grep "^${version_prefix}[0-9]" | \
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

