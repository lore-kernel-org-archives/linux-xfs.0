Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A17934D90E;
	Tue, 21 Oct 2025 18:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072016; cv=none; b=d0cZrzy4gCkghBsou6lMGSHQwR11L6+TOSL3UxYlkFM9ZKHCCM5CRjpX16XxzggKEM+lCiUKgT/yofS5EXjW+VCbVZc/SUBR8LBWBniALU3TfHEcQt/oP/JOyljUATufw672GRUo+VDl86ajfRrJ6xrHTiitdRPgxalfnqz1xAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072016; c=relaxed/simple;
	bh=NCNUdWmgAZzJ5kjtAf97xZXGMxTxwNbpMaOHYQjF/8Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2LLdsZJB2W5V8nzYPGhJnjMwsMVMMcmJOjESY/wxDt2BHVcJxyfQLuX9DtdUt7a21oPdssZYaUIoikgHNj5Tbs1aT+g/JKXqXhS6gAOqBii91gDaKESPmwkinU0NPF9Uz6XEGW4So37tli02gpmgQl/Wa48149IUsk11IGHsF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJoRdGmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJoRdGmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1292AC4CEF1;
	Tue, 21 Oct 2025 18:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761072015;
	bh=NCNUdWmgAZzJ5kjtAf97xZXGMxTxwNbpMaOHYQjF/8Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LJoRdGmL5LpUOR8wFx0L4VOMJI2zAGDxIrvUPkYuHw9ZBMQXzabzbpguR4o4UCvOq
	 yOK+ccfwzLus2RkHhfGslA3802BF2FLs5gx7po+mSJ3nU45LQhlt5WtqT8I4tEJqRS
	 0p0yrrRYaQs7aSRutlIgjdPhv8Oa78FOy6a+5Tkj+4uhDeUnpy26HcRvAMZJZKgNTM
	 JAJr/bGsmugf1bL+vMyneCf5ZLmYRWAFRRahuhtaKj7KD6FugqVtXF2RzAjdsMGVZh
	 yiwjv7T/p7sxJAVcY3mtC6PeprpH8VQ92y2FOHGas+NcWPnysW+BPTWmc837Q6iIX+
	 In67K5x+I+Qsg==
Date: Tue, 21 Oct 2025 11:40:14 -0700
Subject: [PATCH 04/11] generic/{482,757}: skip test if there are no FUA writes
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176107188743.4163693.13401813487181708360.stgit@frogsfrogsfrogs>
In-Reply-To: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
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
index 8c114ee03058c6..3728112ff3f480 100755
--- a/tests/generic/482
+++ b/tests/generic/482
@@ -82,7 +82,7 @@ _log_writes_remove
 prev=$(_log_writes_mark_to_entry_number mkfs)
 [ -z "$prev" ] && _fail "failed to locate entry mark 'mkfs'"
 cur=$(_log_writes_find_next_fua $prev)
-[ -z "$cur" ] && _fail "failed to locate next FUA write"
+[ -z "$cur" ] && _notrun "could not locate any FUA write"
 
 while [ ! -z "$cur" ]; do
 	_log_writes_replay_log_range $cur $DMTHIN_VOL_DEV >> $seqres.full
diff --git a/tests/generic/757 b/tests/generic/757
index 6c13c6af41c57c..11398d8677f72b 100755
--- a/tests/generic/757
+++ b/tests/generic/757
@@ -71,7 +71,7 @@ _log_writes_remove
 prev=$(_log_writes_mark_to_entry_number mkfs)
 [ -z "$prev" ] && _fail "failed to locate entry mark 'mkfs'"
 cur=$(_log_writes_find_next_fua $prev)
-[ -z "$cur" ] && _fail "failed to locate next FUA write"
+[ -z "$cur" ] && _notrun "could not locate any FUA write"
 
 while _soak_loop_running $((100 * TIME_FACTOR)); do
 	_log_writes_replay_log_range $cur $DMTHIN_VOL_DEV >> $seqres.full

