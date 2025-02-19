Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D0D1BDCF;
	Wed, 19 Feb 2025 01:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927161; cv=none; b=ICR8oZIVTruslrBuKywBdk63XCJ5tA6tjlILWkfX8fG3wFrK/5P/9CRFkHHSqmMs88wi0ZOndO9c96lNXt+TbJOIyXcJmRLl/S5S9Ey482/3k5mksoLo+LbhYMN17VJJGOk40fuVDc2J+SOkBTezxrXi84gHn6NRnBg1fWyEme8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927161; c=relaxed/simple;
	bh=shT/DFMZXyZzO9hua2+Jk4dp45ClIHw1gCYOX8cvR/w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PLEeTIhAbKHwlA6petF0uOWICUYv2pb4S7Mao4XP/cIDlCCbleZzmVbKo/15WowT05HUNXpmeqM6fP7Zu0vYIPygW/qntZbK8wCwrw8XICQr38FVrNe+h13dt6zP5JtdVtrBqd7ma1P1SdGrQzg/MLLcqZUkW8q+FV9/CNb58dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B6wUde4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B6wUde4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BDFC4CEE6;
	Wed, 19 Feb 2025 01:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927160;
	bh=shT/DFMZXyZzO9hua2+Jk4dp45ClIHw1gCYOX8cvR/w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B6wUde4cFN3DMF4WuddOdQ7VYcnDD/JEJnZt8vCFURXHLMluoJRw2efhJ1kFHd8W0
	 4GzJv/K2r8WTdrhJOC0sMYdzGM9VDBl9eTp9sNT4NUSrAR9ujO4mSeV86Rx1bDCCyw
	 lNB4ThOnmuw/DkAOIu4tQGtbnjWpuNBYJgDbJDOGaAQ069+TDm1fDNDV6xviKzKgJn
	 YqnXTsvHB2o34WU24a0LDVcQv52xTIU+nj83DzTiRIPsYkpHRorKC/40QNpGLubDym
	 jjJFb6NiqYszKvgn5SAjqjF7B/UXJL7dVSpA0Ldj8pf2moKbtmg5T6KCVgdZW0ySE2
	 Fmfzb7XDOsfbg==
Date: Tue, 18 Feb 2025 17:05:59 -0800
Subject: [PATCH 09/13] xfs: skip tests if formatting small filesystem fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591276.4080556.2717402179307349211.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

There are a few tests that try to exercise XFS functionality with an
unusually small (< 500MB) filesystem.  Formatting can fail if the test
configuration also specifies a very large realtime device because mkfs
hits ENOSPC when allocating the realtime metadata.  The test proceeds
anyway (which causes an immediate mount failure) so we might as well
skip these.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/104 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/104 b/tests/xfs/104
index cd625d6b74aaaf..e95a3b25c3e514 100755
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -16,6 +16,7 @@ _create_scratch()
 {
 	echo "*** mkfs"
 	_scratch_mkfs_xfs $@ | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+	test "${PIPESTATUS[0]}" -eq 0 || _notrun "formatting small scratch fs failed"
 	. $tmp.mkfs
 
 	echo "*** mount"

