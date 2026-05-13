Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282613B5851
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 19:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778700705; cv=none; b=nMzjlevtQPhdj4Ip9gjxywDHYyt/CJ78kYmRZjttkwEY8nb9irnOn2MrfhkbZh/7B8C6f2yCDq5fEAWWRiurJ3kMNNS4mTg2s+oD2GAt66vic7OJFHjnoNvub/ky6YTyspEBdg6wWdSnbeluDIDjP2/NLGmL0fs7lA2KuirVzrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778700705; c=relaxed/simple;
	bh=Bz08CcsCLJ4StBIFel9aVygkAMDVdaOjObgZoxqg64M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=cS8BdvYE+hV105uJGr1hnOyRiR/dxP+SCe9cEviOirj6oMAZzkcdZdLuyfwEc9FscjMljvM5E076o7iOJPiIWFfqQWXV5dS+Ig9Di3IUmRPIx5RzEApWgl5mGWW/GDFUBKDOmPWrsIxoFXw6DmIlI/6AAIgwGiSrWUqqIisl7kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fJjqu3Ul; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fJjqu3Ul; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fJjqu3Ul";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fJjqu3Ul"
Received: from localhost.localdomain (unknown [10.128.32.2])
	by smtp-out1.suse.de (Postfix) with ESMTP id 659866A802
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 19:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778700702; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J9MReDWO+EwVH+eHxRZIk6UnsczAQMGSbDm3pnxwDN8=;
	b=fJjqu3Ulso6xc0ieNWJKXX7hEbNJrP6QdW1vr3xv+MbiZE7qHHXVpMAlkda7vjbORQHXLI
	Qt4dapju1gjuVwo4n3gMm+vBxU7zG1M98o1kVDWpQvyyG4d8iQ1HG24HUtRVadxo4I+bgK
	500Vg+L2h6/GC4ds+H/IbUSiaMwNy0M=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778700702; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J9MReDWO+EwVH+eHxRZIk6UnsczAQMGSbDm3pnxwDN8=;
	b=fJjqu3Ulso6xc0ieNWJKXX7hEbNJrP6QdW1vr3xv+MbiZE7qHHXVpMAlkda7vjbORQHXLI
	Qt4dapju1gjuVwo4n3gMm+vBxU7zG1M98o1kVDWpQvyyG4d8iQ1HG24HUtRVadxo4I+bgK
	500Vg+L2h6/GC4ds+H/IbUSiaMwNy0M=
From: Anthony Iliopoulos <ailiop@suse.com>
To: <linux-xfs@vger.kernel.org>
Subject: [PATCH 0/4] xfsprogs: fix xfs_healer build issues on older kernels
Date: Wed, 13 May 2026 21:30:36 +0200
Message-ID: <20260513193040.2130-1-ailiop@suse.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.79
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.19)[-0.945];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[configure.ac:url,localhost.localdomain:helo,suse.com:mid]
X-Spam-Level: 

This patch series addresses several build issues that arise when
compiling xfs_healer on systems with older kernel headers. The patches
fix various problems, including missing statmount flag definitions,
incorrect configure checks, and missing stubs for statmount-related
functions. Additionally, the series updates .gitignore to ignore
xfs_healer-generated files.

Anthony Iliopoulos (4):
  configure: always check for statmount supported_mask
  libfrog: add missing statmount flag definitions
  libfrog: add fallback stubs for libfrog_statmount and fstatmount
  gitignore: add xfs_healer binaries and services

 .gitignore          |  3 +++
 configure.ac        |  2 +-
 libfrog/statmount.h | 22 +++++++++++++++++++++-
 3 files changed, 25 insertions(+), 2 deletions(-)

--
2.49.0
