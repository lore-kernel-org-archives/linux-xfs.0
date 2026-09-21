Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5442E65192;
	Mon, 21 Sep 2026 06:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971347; cv=none; b=ZA0ESbFdK/poLjvbQctTLHM88UNuTS9j60VscaCRm6GH1NqaSnKfC0q/+ShETsZ28yVTN/FuMhYcbEeVkIkfulbnOWVnUk0IgoXgG3oT462XOx5cqUJNvEiZGkw/MPLSsi4JWrwRXrrSFxYcCYISzQOPSgtmvygrXeTVYWNa0U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971347; c=relaxed/simple;
	bh=hzIAhyRg/etjo0ya1NIiMzOr+Bazi50xRDGkcdq/lWw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TbFxJNRFS3lAVT++Z+vO32EXkijL9obktpQOAyNTbjouaQaLWf8/XZyHsaIkv4ww58E7I38N6ddAscvxFyzQ96Nlg2zrCxRH1rr6Mz1y6n4WFuy+xZyA9puejiJQXAfWS8EIe64vH2baWHorZKUImLV1x+7KHSMfW/+o1bmX4Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BzjuW+Ei; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BzjuW+Ei"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2A8621F00893;
	Mon, 21 Sep 2026 06:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971346;
	bh=44qpsBYMV71RZWWY+uOqTf7ZX6//UmVy30/w4Ju4T20=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=BzjuW+Eig/ZAH/o0diw23zwidl5OFkZVJp6chG8xlwGDHJXpng9PcQ0lPTfQklmmx
	 vWwcSzOvsPNK7qbHwgzEJ8JhCBr14M87fCI1K4ajJVXr2Cvyt4XvBl204cpzJW5VI8
	 VwO4spMW9dO8FJ4uZDQSH8s4Pyw0qUBB48d1D/6B+DIIUZwxMqiXNVCb9A5xp0gj0Z
	 YDi7C+Rh2Zj3CaYFITt1tggwWKc90Uubc9Ub0jPUGOUxTIZ+CdAp5TMPds9zuJ+PCa
	 1yYbUbNBaIbIAjETZZP8MzKnIGdadMOP/tYFgu1toT6CPuy3RV8vJmK8x8CaXipp7w
	 RVdy1oMpdgavw==
Date: Sun, 20 Sep 2026 23:15:45 -0700
Subject: [PATCH 03/14] xfs: fix buffer overruns in xfs_ioc_attr_list
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178996120615.181988.8935770811414289563.stgit@frogsfrogsfrogs>
In-Reply-To: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we converted the al_offset array in struct xfs_attrlist into a VLA,
the size of the object shrank by 4 bytes.  Unfortunately, the buffer
size validation in the attrlist ioctl wasn't updated to notice this, so
the al_offset[0] assignment blindly writes off the end of the buffer.
LOLLM noticed the omitted check and complained.  Probably should've left
working code alone but for everyone wanting these ***n static checkers.

Cc: <stable@vger.kernel.org> # v6.5
Fixes: 371baf5c9750a2 ("xfs: convert flex-array declarations in struct xfs_attrlist*")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_handle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index 0689cade8f74c2..fd9d4d8258fff2 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -409,7 +409,7 @@ xfs_ioc_attr_list(
 	void				*buffer;
 	int				error;
 
-	if (bufsize < sizeof(struct xfs_attrlist) ||
+	if (bufsize < struct_size(alist, al_offset, 1) ||
 	    bufsize > XFS_XATTR_LIST_MAX)
 		return -EINVAL;
 

