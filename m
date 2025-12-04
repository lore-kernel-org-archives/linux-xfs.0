Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD4E2853F1
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 21:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764884656; cv=none; b=uD8i46BAC5K0XHjffwm+visz+s/vJfvGkVwKJqXGIcsXGxXZZW5Oo3hz45xEeeoSWC8+AN0CGnlepqz4HMNf1VonXygOAu0UfChNObK4uY5EuttP1VVaH8ug+nyTR6MyjQxITJQ2KT+n9zPGWMx8bCnPZCxF86vPFEt4NbWHwD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764884656; c=relaxed/simple;
	bh=ZEhozK3yh6ROVMwFYE9Ht+wKzF1O8qVXDcleX8wsq6k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CwIzUc2axDlz+eJShFfnqnUJFhsaL6zyU8bk/I5K6lxGJmAcIGKBYyb4zyKmPF7Vwb2OIMJLoQnFa9CRO/D/lglqc4tZEZDrZUiBrODKQ1/bGcbC/7BnXn4k0UnAbK3Mqbu0ogrqCZMrmb/1PWYg61GqC2Qnxu2e3Dxz9bax8i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I97I8Ei5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I97I8Ei5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB249C4CEFB;
	Thu,  4 Dec 2025 21:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764884656;
	bh=ZEhozK3yh6ROVMwFYE9Ht+wKzF1O8qVXDcleX8wsq6k=;
	h=Date:From:To:Cc:Subject:From;
	b=I97I8Ei5oOSlMVQj6FbM+646aOVvSD0hRjc2ChzXXEBX9l79kAn4omZ7rz4/URWfm
	 4lkC8CNvfwVyBVA3gbQNV0yk3wpTVRYebFwPLRk8sCmlGkdOWYlI1JG7CJoChhFq05
	 aCKzdVbf7rtLITTxMnQBsEyhxJlmcG2NXeopaFO/CZX95LFkoTuF5Al+Qe0IN7GTZe
	 h5Nj0hW9Ktuy/b3mai4cfF1yjgr+JoU9rCNbK0SCIRBgFEavxqVWHZ82bwzC0lnCrz
	 N73/wl/q5WTCtlUX5Co3pTOvgGmdHQDXp+xmLuQPHZyg8+RY/SZDbSRgUIuXpaDYKp
	 Nu3g/pNRZpifw==
Date: Thu, 4 Dec 2025 13:44:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix stupid compiler warning
Message-ID: <20251204214415.GN89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

gcc 14.2 warns about:

xfs_attr_item.c: In function ‘xfs_attr_recover_work’:
xfs_attr_item.c:785:9: warning: ‘ip’ may be used uninitialized [-Wmaybe-uninitialized]
  785 |         xfs_trans_ijoin(tp, ip, 0);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
xfs_attr_item.c:740:42: note: ‘ip’ was declared here
  740 |         struct xfs_inode                *ip;
      |                                          ^~

I think this is bogus since xfs_attri_recover_work either returns a real
pointer having initialized ip or an ERR_PTR having not touched it, but
the tools are smarter than me so let's just null-init the variable
anyway.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: e70fb328d52772 ("xfs: recreate work items when recovering intent items")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c3a593319bee71..e8fa326ac995bc 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -737,7 +737,7 @@ xfs_attr_recover_work(
 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
 	struct xfs_attr_intent		*attr;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
-	struct xfs_inode		*ip;
+	struct xfs_inode		*ip = NULL;
 	struct xfs_da_args		*args;
 	struct xfs_trans		*tp;
 	struct xfs_trans_res		resv;
