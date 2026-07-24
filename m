Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6054334BC
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 13:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900055; cv=none; b=hFrXMvP12wFzRog+Ri08a1u8K2Lo9HQyNtAaNL9+pxiPXr1nrOp+UAw1ilSi/DLXHb0idSWOqFh8BCBJnGQ8yKGMeut7ih4DRuLGigogPzv0ZJMfDM/L81ksz3dU+syb535QIJi3q8NGeOldG/8OvscLU1pvHFNm6uXM/+APgco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900055; c=relaxed/simple;
	bh=hnwtKjMFpbqni3KEHtsSKZ4HjgpP+awBUEFlfTotlKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsFfwJHwjgou1vOM/QM+u/j5zptjk5rs60KkoXKt9TFK0hpEmlWU8tEonBTySeZEEN/Ymo4AgGxfpAmLu9MHxQ8HkeC6prZIiK65U+pVVHmK8JxRMHcKSX1HxR/26fkb/WJaeZ0K8VGxnMTCjyOOAGeTurctXhR8K79pm1Wn6xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m2Js7+uy; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m2Js7+uy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m2Js7+uy";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m2Js7+uy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5CEAD7B843;
	Fri, 24 Jul 2026 13:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784900029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FCPBEO/DTcWGc2EV6pDMg3i2d+mYiLvgUXSYOcNfwsI=;
	b=m2Js7+uyvuAWmT5bNMp63zSSf99fi2uFE31wbd0VPaNmiiRL0ObuxKDjew8ufiZNy4rOuE
	cB20sMqfby0MpSQHWilmaBrV9vOM7k/n2JBezKoXWKrRd8g4AAblpH1VdK8TUzH8O3ktPq
	jOI82jWwk7ccQdh9Yoo6qQOddTkOYc4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784900029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FCPBEO/DTcWGc2EV6pDMg3i2d+mYiLvgUXSYOcNfwsI=;
	b=m2Js7+uyvuAWmT5bNMp63zSSf99fi2uFE31wbd0VPaNmiiRL0ObuxKDjew8ufiZNy4rOuE
	cB20sMqfby0MpSQHWilmaBrV9vOM7k/n2JBezKoXWKrRd8g4AAblpH1VdK8TUzH8O3ktPq
	jOI82jWwk7ccQdh9Yoo6qQOddTkOYc4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45324779C3;
	Fri, 24 Jul 2026 13:33:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6EFyDrxpY2pIJgAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 24 Jul 2026 13:33:48 +0000
From: Daniel Vacek <neelx@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org,
	David Sterba <dsterba@suse.com>,
	Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 08/12] fstests: properly test for v1 encryption policies in encrypt tests
Date: Fri, 24 Jul 2026 15:33:24 +0200
Message-ID: <20260724133328.1837318-9-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724133328.1837318-1-neelx@suse.com>
References: <20260724133328.1837318-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

From: Josef Bacik <josef@toxicpanda.com>

With btrfs adding fscrypt support we're limiting the usage to plain
v2 policies only.  This means we need to update the _require's for
generic/593 that tests both v1 and v2 policies.  The other sort of
tests will be split into two tests in later patches.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---
 common/encrypt    | 2 ++
 tests/generic/593 | 1 +
 2 files changed, 3 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index 81c3d032..4c3fd904 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -68,6 +68,8 @@ _require_scratch_encryption()
 	# policy required by the test.
 	if [ $# -ne 0 ]; then
 		_require_encryption_policy_support $SCRATCH_MNT "$@"
+	else
+		_require_encryption_policy_support $SCRATCH_MNT -v 1
 	fi
 
 	_scratch_unmount
diff --git a/tests/generic/593 b/tests/generic/593
index 05f868f9..a80c28f2 100755
--- a/tests/generic/593
+++ b/tests/generic/593
@@ -15,6 +15,7 @@ _begin_fstest auto quick encrypt
 . ./common/filter
 . ./common/encrypt
 
+_require_scratch_encryption -v 1
 _require_scratch_encryption -v 2
 _require_command "$KEYCTL_PROG" keyctl
 
-- 
2.53.0

