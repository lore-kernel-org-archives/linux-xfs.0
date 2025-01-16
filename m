Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E611F153D;
	Thu, 16 Jan 2025 23:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070443; cv=none; b=Iy7Hs8871HAeXLBB0GAdwYw52WjBiRJrfW+XSR6pipUzseJ6/WZp95OrrOVNoBS1hXkbglPhmgmwg3414nANLZveAX++8+AaPYo/+e33nd1TuAmfcz+qY8c3HPfHLRzgj24hFrJI6qAFdp5osA+A7JPEQWbFdwGdw6ythqAObqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070443; c=relaxed/simple;
	bh=IifR8vjFBLOTcIWgGqWJQLnSreQDquGjh+9n+9XMPuQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RzFBMWvPFoP9Uqj0Io/FEva7q5kT7rnx6PUBOAdh9ozQY51tkTNC6nb4v3imIHG3nK6Hg1vLAkeY8i4J+dJ1d4lu+IW0PUober06Z91jzvMrxXrvrqpq1JT4GqzDj8STCaJ/BCN6oHh+JKMT1kNFlrYAl7Ia2BcPPYQjNQljW6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oEe9PjTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEe9PjTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B846FC4CED6;
	Thu, 16 Jan 2025 23:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070442;
	bh=IifR8vjFBLOTcIWgGqWJQLnSreQDquGjh+9n+9XMPuQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oEe9PjTqZSywuxa4dyxzHp1wtnNWj4HC869r5RjC8c7YLf9122WLH6S3wbELVMd3R
	 X4N0anlG+yV6ku1zAG98YyMFNdGLoCxJf4JjS0Ht/RiuJ3lNrTwNuhz7mHKX+a0a0F
	 NjzVT2vU4tNsIgf97vMonQsNczOy5GxnouLyeP+ZxOnVKzMdwMUMgDySTKeLbxFJ+g
	 MiK7rTh7hRN6eUJkdvu4yiNaHv/GYS52/nVj40NnwVpPW2idaXe7Ay3uMByULPcstA
	 y34iZGxuI77fDvBzaJJzOGtBVc4JaFDI6dDS8FzHIMbaZkdaMcFPPQ0aBBR+BLKrS0
	 hMQNc4EVmDG0w==
Date: Thu, 16 Jan 2025 15:34:02 -0800
Subject: [PATCH 08/11] xfs/163: bigger fs for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706975289.1928284.8057584815780423729.stgit@frogsfrogsfrogs>
In-Reply-To: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
References: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Adjust filesystem size up so we can pass this test even with metadir
and rtgroups enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/163 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/163 b/tests/xfs/163
index 75c3113dc2fd03..015a82cdffaa68 100755
--- a/tests/xfs/163
+++ b/tests/xfs/163
@@ -42,7 +42,7 @@ echo "Format and mount"
 
 # agcount = 1 is forbidden on purpose, and need to ensure shrinking to
 # 2 AGs isn't feasible yet. So agcount = 3 is the minimum number now.
-_scratch_mkfs -dsize="$((512 * 1024 * 1024))" -dagcount=3 2>&1 | \
+_scratch_mkfs -dsize="$((900 * 1024 * 1024))" -dagcount=3 2>&1 | \
 	tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs
 t_dblocks=$dblocks

