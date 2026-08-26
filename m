Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB7B42A149;
	Wed, 26 Aug 2026 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787769044; cv=none; b=Qo4OSKoB5WeTw4SYcmvx7xsfj2Y4c89oz09XZWJnkZtEFJcj6Al9MNZ9MFXNZQUqMvdsuPW9Mqr/R3v2/CU/DhBP2MZWU3z916C4GpUPZSoLfOSAB1+LeBjeGCLhdH7NHd394NEL2tuDYVQ2XwwW0doAK2ZQfxadgOFc13sO/NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787769044; c=relaxed/simple;
	bh=PNA1bH6owCbCv8tOd2bjwOznE35Hrzq6tWAj3TAtNTg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=K489d/+Hku2vrJd9TCpflbcwz+GGYKMuaUb4X8L2WPXrGV/0jsYaKcC0K6/WNlQlZF6NLLUVdQ6zh4eoAzAOnr31Z1c5hcH07DL+rIhiCbNB9scXeEELdhiePtJBJl7qQjDblyS980CGCRzG4AMEb++txA89THxSG4TIHpsh5AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g4hCOC8f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4hCOC8f"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8291B1F00A3A;
	Wed, 26 Aug 2026 18:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787769026;
	bh=30yMEbTlIeg4fKvAJyIhnlwyFsWTHblpC0kNfLZ0eJA=;
	h=Date:From:To:Cc:Subject;
	b=g4hCOC8fns8msnrTi4rJcvpASFW8Kp7GDwsfp+at5BiKr/bgkTL3bq6QZM5U68RCS
	 bMqfJvh1V8KzMcdIs19KgUOUK7F0ZlDid/vH1Daj0hKmuKxTgxsVpDx3SyuTzH4ZW4
	 C7aeaTs8PxWgVNHCd97t57XikYT/tg5KaOBKQMe9Thb62i0OHaElfYJEKNTCG8J6lO
	 Yp/wvVFndfJN51MMP150wlgqm4LeljFVDIwJjt0gX7fAMAqaYhYxSb2iIM14NezRwI
	 XgKK7GtZSQSx/lzNl1+K23ehYQ0Bzmb6dfk+hpSzqqvDonA8EUvr2KzEM8rcCkOGks
	 A0YcgeitDobBw==
Date: Wed, 26 Aug 2026 11:30:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs/030: skip this test if metadir gets enabled anyway
Message-ID: <20260826183026.GW839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

This test requires metadir not to be enabled, but under certain
circumstances (aka _scratch_mkfs_xfs trying to be helpful and dropping
MKFS_OPTIONS) it can get enabled anyway if mkfs.xfs defaults to enabling
metadir.  Check the fs feature set after formatting and skip the test if
metadir gets enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/030 |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/xfs/030 b/tests/xfs/030
index 22fbdb2fdbc999..d0b8f413bb9afd 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -72,6 +72,7 @@ else
 		_notrun "PQuota are enabled, test needs controlled sb recovery"
 	_scratch_unmount
 fi
+_xfs_has_feature "$SCRATCH_DEV" metadir && _notrun "metadir enabled anyway"
 clear=""
 eval `_scratch_xfs_db -r -c "sb 1" -c stack | perl -ne '
 	if (/byte offset (\d+), length (\d+)/) {
