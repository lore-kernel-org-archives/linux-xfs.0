Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5771547FE;
	Thu, 16 Jan 2025 23:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069974; cv=none; b=sqrVCu7a219h9+9JkKQOytZ0+S4N5WFGjbrxuiUs0afJwF8W1AakMCPG8DjGx3lGAEDsJL0Yk9JN+lRkT2Ri3s3261eDwR7yQnsqqa0lI6RDOFiLOysOOH/UuqvL6zIMVykQ/tEbqrfrnv3tMPmymmzO1dyh7ayLoUxFNktBgIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069974; c=relaxed/simple;
	bh=goLKoTyYnbCb5ETO+PtIizmJs6IzEztQ2cvcOEGVlro=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q/Zv/a0sIDzygbliK2X/JYcZv7aart02RAu+1a+Ow/1HdQRYItGL3A3toBgG/0sb1OKBzVXsG/K0a0MhdtcuIfTP9EAcCU4NfsUpXXS7nANWk4He5YWMKzL6qvQUPnxR7GkynxSyusjgrby9zSccFNSDAPXHknX2Xjssy3vYFIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egHbzbuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egHbzbuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB933C4CED6;
	Thu, 16 Jan 2025 23:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737069973;
	bh=goLKoTyYnbCb5ETO+PtIizmJs6IzEztQ2cvcOEGVlro=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=egHbzbuhcdKnn4dwrZecHwYLsX207iYBUWYz6Urr2uHlMjFgaZo6xEinKxJEp/pdr
	 eXJYxRry6okDjE5pl6o4rO9jpC/nm1NCJiK0/yMFl3jAkLZuzK3LUltJ6apkqCVJvv
	 g+64dC4blDu4g+iajHQdGnovfXIcg5PRVhUI+5NefgL1u3mVrkQcny0kTyTDpj3I/I
	 7Myihf+EoFysuHPDxpMcNToI+DywLgvw2oNTIIQH5G5H9tCA19Uykuy0Y5oC/b008D
	 +CE1iNOU8obD0FsTCkcwJTkwlGWgocAx98Z+PVO8AvPBHR1Vo+vVLxqovtNoVMdDzd
	 fV/eyuKqyLHgg==
Date: Thu, 16 Jan 2025 15:26:13 -0800
Subject: [PATCH 04/23] generic/482: _run_fsstress needs the test filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974137.1927324.11572571998972107262.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The test filesystem is now a hard dependency of _run_fsstress because
the latter copies the fsstress binary to a different name on the test
filesystem:

generic/482       - output mismatch (see /var/tmp/fstests/generic/482.out.bad)
    --- tests/generic/482.out   2024-02-28 16:20:24.262888854 -0800
    +++ /var/tmp/fstests/generic/482.out.bad    2025-01-03 15:00:43.107625116 -0800
    @@ -1,2 +1,3 @@
     QA output created by 482
    +cp: cannot create regular file '/mnt/482.fsstress': Read-only file system
     Silence is golden
    ...
    (Run 'diff -u /tmp/fstests/tests/generic/482.out /var/tmp/fstests/generic/482.out.bad'  to see the entire diff)

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/482 |    1 -
 1 file changed, 1 deletion(-)


diff --git a/tests/generic/482 b/tests/generic/482
index 8c114ee03058c6..0efc026a160040 100755
--- a/tests/generic/482
+++ b/tests/generic/482
@@ -68,7 +68,6 @@ lowspace=$((1024*1024 / 512))		# 1m low space threshold
 
 # Use a thin device to provide deterministic discard behavior. Discards are used
 # by the log replay tool for fast zeroing to prevent out-of-order replay issues.
-_test_unmount
 _dmthin_init $devsize $devsize $csize $lowspace
 _log_writes_init $DMTHIN_VOL_DEV
 _log_writes_mkfs >> $seqres.full 2>&1

