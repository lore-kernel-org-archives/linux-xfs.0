Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EB05C96
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831318; cv=none; b=qhG4bxBw+CT1+cBxJ3xNyh3mEgRBjjnuA8QotWeX0cKnAgSzOzVkzN0aqthjFrKtUowIAXLhvAn1feEdcx6Fwz0SSFygiS4OSPpaQOmWyiYtinfOxXz/OgTFphiFJuFLk7MvGdE8t68fdbx56RbukCg65+8zPQiol/AGWC59lgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831318; c=relaxed/simple;
	bh=P3HBtNM0d+zelpTnLAQgizzLEpt3i751sBNVWJ8wf48=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pEoDZ43pUxK4PRQyumA8ELZfZi1YTBV85XaOo+UkK2joSmrs74v34HuJKaooQwCZCG39BnbUGtIwXI5cGbjasjQEc/P5eeSDVDGt7EHWTE1Jnwc2f7OVJ2+sue41viJ2yYYyNO1nPePX1lWrZKhtHvXdsCoxeghZh5vkgRmTRj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WHulKo50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHulKo50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258C9C4CEC6;
	Wed,  2 Oct 2024 01:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831318;
	bh=P3HBtNM0d+zelpTnLAQgizzLEpt3i751sBNVWJ8wf48=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WHulKo50BzgAnPi5b1koJGAsQ6Nlq57T6s8ShNQ5WeeaMs/aYVla2OoCjg8ZJm7XS
	 7J9VmFACUzyrqmuXVfYvHF8Gp4/C0GMh72JM7AzwqQtTVasC2dWAhyjwMG3UveYEhm
	 8M6vjWUIXyb94KiXgGDLLS+fSb1bVo9bcyLgkPdiLBceTq+Q0SNGC9XHKKxMcvIcdF
	 +2vzL/3EYB7AMbTUyHaIru/suT3LhYv1c529expKHZx7dZ8YN/dHERWI62Nae0MCCj
	 18uGGrj9JJ/PTmMBNvrYoBNxE2n3uRknXZcs5zSpRs7y3byIBNk+thRxSt0J1Bt5Pp
	 DtShnC+dWA7DQ==
Date: Tue, 01 Oct 2024 18:08:37 -0700
Subject: [PATCH 03/64] xfs: Remove header files which are included more than
 once
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Wenchao Hao <haowenchao22@gmail.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172783101825.4036371.12093348988730327245.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Wenchao Hao <haowenchao22@gmail.com>

Source kernel commit: a330cae8a7147890262b06e1aa13db048e3b130f

Following warning is reported, so remove these duplicated header
including:

./fs/xfs/libxfs/xfs_trans_resv.c: xfs_da_format.h is included more than once.
./fs/xfs/scrub/quota_repair.c: xfs_format.h is included more than once.
./fs/xfs/xfs_handle.c: xfs_da_btree.h is included more than once.
./fs/xfs/xfs_qm_bhv.c: xfs_mount.h is included more than once.
./fs/xfs/xfs_trace.c: xfs_bmap.h is included more than once.

This is just a clean code, no logic changed.

Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_trans_resv.c |    1 -
 1 file changed, 1 deletion(-)


diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index dc405a943..a2cb4d63e 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -19,7 +19,6 @@
 #include "xfs_trans_space.h"
 #include "xfs_quota_defs.h"
 #include "xfs_rtbitmap.h"
-#include "xfs_da_format.h"
 
 #define _ALLOC	true
 #define _FREE	false

