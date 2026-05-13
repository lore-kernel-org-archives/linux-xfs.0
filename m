Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B97B3B52FF
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 19:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778700729; cv=none; b=Ke4Z3U4UM4JjTJv8mdZYV2QGIzgRhpGCbkHqVpbSA3IZZLCv+Z5oktXw+wXbDBChDr3Y8qTcaw4jDwwF22I/Ee1sWmt2JJPNUMYItzQr5GinBSWzXGKMuhb7iJlbrxrTyruYdESNkYXxy7sj47fJolR2FahdqbTKJTRCaLfl8Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778700729; c=relaxed/simple;
	bh=+/DHuhOeavEByKMucXyBuBMNfyPK71hcerKaN+QKrSE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoHK+WehF4a+rrZL63ven09Figf3MfQKvu7C/KItk7iawbFgl7fLclWU6p9dSWvd0/+EW7mhxGwV+z+Jp+0dizUL0Qc8A+gGYvWiqi2KYHSwwmDNx26/V7k1d8gdi0mFEziWjjjWI2jB2oU9WOHbwFSDimF19/8WVWSEgRIwx4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AvovowlW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AvovowlW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AvovowlW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AvovowlW"
Received: from localhost.localdomain (unknown [10.128.32.2])
	by smtp-out1.suse.de (Postfix) with ESMTP id 87D516A95E
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 19:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778700716; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oFGBUW/TQaZsFm8mgh9wt8ezGO7i+nezOjVs7V/0R78=;
	b=AvovowlWkMoPgdptDYWU0/SnQTTGJEp9OM00qCCiKjAaKdE9odi6LpBMlCXLk3dCBi+SIW
	8D0lb3jeAlovSzlExUIojty0YrhwWcnApmbUoGfBgJO7IMSUk22Np0XWvXeqwR5xygICiP
	xBUh0ZNQNOZ5+e9+mMNiNJBYGKTZJ9g=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778700716; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oFGBUW/TQaZsFm8mgh9wt8ezGO7i+nezOjVs7V/0R78=;
	b=AvovowlWkMoPgdptDYWU0/SnQTTGJEp9OM00qCCiKjAaKdE9odi6LpBMlCXLk3dCBi+SIW
	8D0lb3jeAlovSzlExUIojty0YrhwWcnApmbUoGfBgJO7IMSUk22Np0XWvXeqwR5xygICiP
	xBUh0ZNQNOZ5+e9+mMNiNJBYGKTZJ9g=
From: Anthony Iliopoulos <ailiop@suse.com>
To: <linux-xfs@vger.kernel.org>
Subject: [PATCH 4/4] gitignore: add xfs_healer binaries and services
Date: Wed, 13 May 2026 21:30:40 +0200
Message-ID: <20260513193040.2130-5-ailiop@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260513193040.2130-1-ailiop@suse.com>
References: <20260513193040.2130-1-ailiop@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.75
X-Spamd-Result: default: False [-2.75 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.15)[-0.735];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,localhost.localdomain:helo]
X-Spam-Level: 

Update gitignore with the various binaries and services that have been
introduced by xfs_healer.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 .gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/.gitignore b/.gitignore
index 6867d669c93d..eb3decd108be 100644
--- a/.gitignore
+++ b/.gitignore
@@ -60,6 +60,9 @@ cscope.*
 /estimate/xfs_estimate
 /fsr/xfs_fsr
 /growfs/xfs_growfs
+/healer/xfs_healer
+/healer/xfs_healer_start
+/healer/*.service
 /io/xfs_io
 /logprint/xfs_logprint
 /mdrestore/xfs_mdrestore
-- 
2.49.0

