Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748863375CD;
	Wed, 15 Oct 2025 16:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760546266; cv=none; b=jIFdafqmyibZ/lre7LI/6ah+KVLN5VOS4zK21Uy67626M+xDg6Nvd32ybum4vi9K6QsWJfHbiaWgzUjolOsUYcCWHsK6A7gzar70S4uWilQ0vfEdIsurKxNfULIgZuImUACwfEu9gWnFQlBax5NiAIsk49iWZ3N6r4d7K5HoLk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760546266; c=relaxed/simple;
	bh=y5sFnTAmgq4K9TabHjoGBI2qdIeeuydfLonhoiXVZ9o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZfpHHvdnkUnYsFLcHcNZtFZXh7PgCPqdMpKbrMzEpRgJNkpLrKr+oVEnbs5hPKGQTTNg/ARkqLiBIIm1Uia9av0ATuxhNA6W5nQvOY7tyH1TUuevvyp7ZEpelBER/Zhl/0yEoIyDgXtzI1VqFfnWGxxbSOs+lGbTyKaI+Hri3Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYlWOGcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYlWOGcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9CAC4CEF8;
	Wed, 15 Oct 2025 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760546266;
	bh=y5sFnTAmgq4K9TabHjoGBI2qdIeeuydfLonhoiXVZ9o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GYlWOGcdbIRRk3qJqnXVSdWCoedRoMtYov8XylGbUij6/46Hx3elYp+r4xcPC5wMJ
	 9UtSP7iyCwziDdeAZ6n1XJN2VtEHGtuzQ5+C46sgKKYDp9buzeu48HQNVcjQDuqvp+
	 Gq3YLPs0mianUWeMZzdW5byzq5x4yQsPeDNa5zA9tgby+MvzyfQnnczo6vqGAugfeL
	 XHOQK/bV1WptFLcR24vYh4ACbVwK2aADjVfSIy9ibgY5sjdLPJjgRuzfIjtmumjApX
	 zWbF4I7ZnzvPw7aj/u4mfY7232I8x57Aka7SFhYQkRzAGRc1UkbFACl9xRUqOObw7e
	 i1qHY4HKwWiGg==
Date: Wed, 15 Oct 2025 09:37:45 -0700
Subject: [PATCH 4/8] generic/{482,757}: skip test if there are no FUA writes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176054617970.2391029.13902894502531643815.stgit@frogsfrogsfrogs>
In-Reply-To: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Both of these tests fail if the filesystem doesn't issue a FUA write to
a device, but ... there's no requirement that filesystems actually use
FUA at all.  For example, a fuse filesystem that writes to the block
device's page cache and issues fsync() will not cause the block layer to
issue FUA writes for the dirty pages.  Change that to _notrun.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/482 |    2 +-
 tests/generic/757 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/generic/482 b/tests/generic/482
index 8c114ee03058c6..25e05d7cdb1c0d 100755
--- a/tests/generic/482
+++ b/tests/generic/482
@@ -82,7 +82,7 @@ _log_writes_remove
 prev=$(_log_writes_mark_to_entry_number mkfs)
 [ -z "$prev" ] && _fail "failed to locate entry mark 'mkfs'"
 cur=$(_log_writes_find_next_fua $prev)
-[ -z "$cur" ] && _fail "failed to locate next FUA write"
+[ -z "$cur" ] && _notrun "failed to locate next FUA write"
 
 while [ ! -z "$cur" ]; do
 	_log_writes_replay_log_range $cur $DMTHIN_VOL_DEV >> $seqres.full
diff --git a/tests/generic/757 b/tests/generic/757
index 6c13c6af41c57c..725f3a5cc6da3a 100755
--- a/tests/generic/757
+++ b/tests/generic/757
@@ -71,7 +71,7 @@ _log_writes_remove
 prev=$(_log_writes_mark_to_entry_number mkfs)
 [ -z "$prev" ] && _fail "failed to locate entry mark 'mkfs'"
 cur=$(_log_writes_find_next_fua $prev)
-[ -z "$cur" ] && _fail "failed to locate next FUA write"
+[ -z "$cur" ] && _notrun "failed to locate next FUA write"
 
 while _soak_loop_running $((100 * TIME_FACTOR)); do
 	_log_writes_replay_log_range $cur $DMTHIN_VOL_DEV >> $seqres.full

