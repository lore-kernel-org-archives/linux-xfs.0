Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161A418DB35
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 06:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933830; cv=none; b=djmOqG389r5BO8+izPWnuJMaz/BNNqDnPp/HRAHiqRkn3zPfm4wfxjCxTADqEgB5o3miXwJGGexf+Ltya9/miDzHUyEhDyVExirvFdLUjhMdmIZvUGKlwwCBWXGUlFst+x9oWR3ljJ2KdWok1yqXWl+56nvGIPCYVq31GD2lXYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933830; c=relaxed/simple;
	bh=kezTpXDyTF92VvqqBZEtqupKMa0VPy1GAyCUJQ2JxzE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iwUXG5JXa39wTJuQqEZtCbMQbnLHdpFjS1b1k5Tz1SJBit+cj3fiQ8dUT3jXvMV16d9Yvq+RzJQWa+k37fpjmx6mmPXfukJ9kit3oR0GHB6AqJWzZbrYQ3OjylirZIoeuMwqh93sngW6RsS+VTlVc5Tz7xGghLf8Kqql6/DEjJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdEeMqi8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdEeMqi8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E04131F00A3D;
	Wed,  9 Sep 2026 06:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933829;
	bh=MWElmyEFZ3c2259MOb8iIuSq37DEEBYlPpsV4qRpMgU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=gdEeMqi8Hcy1kaLGe6X7WVDRejBAnAKN/L9J6l9PAHJu/Yx4cNgXBn/8WvCHxWq0o
	 QCrIftPbt3MBRWgLP9UvoD68TYYqjcPpGb4FGTITozzIWhN8GqXDAzgIAeyfFYV8fQ
	 KzlztF4EEMOUHSFEgB+EPZ+TlUFqwJlLlE1x2gpDCsRBE2SQIxPwrksL6gI3qfUeZa
	 n5tIuarkxSxO2ZeDwyeGG0egJRX8EuPsViWbADg0u0sh/+QiB4JIfeOtyspuh6FdUs
	 ZIxgjLY7051i2Ar0tjhKMsKwdtQBUwVCs4WHD8Iiwt/y9CP3JE9ZVwEwvUYhf96ufE
	 7RB9ZfXst3Yng==
Date: Tue, 08 Sep 2026 23:03:48 -0700
Subject: [PATCH 4/6] xfs: remove redundant function declaration
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <178892936270.4057682.3154685606672752883.stgit@frogsfrogsfrogs>
In-Reply-To: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
References: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Remove this useless code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dabtree.h |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index de291e3b77dd8e..d654c125feb4d8 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -37,8 +37,6 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
 void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
 
-void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
-
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
 int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
 		xchk_da_btree_rec_fn scrub_fn, void *private);

