Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D5648A2C3;
	Thu,  2 Jul 2026 09:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782985195; cv=none; b=n+bWaPoDn2dstsBE5JaYLt7dNnLpUEXeNNtP2W9iIKR3at4cARSBXAiYdsRUQBeJvZWnr9KaNbCtOiEcbVkt5eOMOdKRACWdbVz6n5jciQsA0PHY22lcPHic4oBDIlz8jk/yFdp1Q49KEghz2rFhSMsTII/1d63+QmPR3QQ3r5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782985195; c=relaxed/simple;
	bh=UaC8hQGS+I8KjtWbS7G5GuBhXDcQyxYhmx9kD+nYgFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTqb7qLCHfcI75Erd4h2kMCXdgK6XYbt6x9c4iQcCdKJnaXV/oojzfare0fIc4nDMagGZE6mMW+1rhuMM0aljhkPiA/2TKPbKjkbfkfdUt2kOs63Mn3wcxdf0VDIPnGMbYYWazkN+9jntk0KEePhFrOiUYf/rz+qQAHCu6MTHLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLt8v8fW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLt8v8fW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D291F000E9;
	Thu,  2 Jul 2026 09:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782985193;
	bh=WYCIRw2VEpiVhadO+aosOWZWEboI4uJ1AJyBmZgZTbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLt8v8fWrK3l+GGt3y8Om0RDM8yLZHu4P3gz4qeMHjD+IYy+nRkb9Tr0EL6uuhAXB
	 1JxGj3uXU74Ppw5c/PxmFmMJoyBzxS6ZWm7bIJcdSTHSmAAYbos6J2Otdnqni54UEQ
	 n275uLzeXMeizeBDch/BV1/onNNXd5A6o214xxuDnx3VupuCQ6n81Z5tPSt/sOdu9C
	 AfFLF6U0d7mQzOb/P86uclT1L8CPM7XfhKJFiiGQ2+qX4Wg7CO8TAKlNTdhMMDrSWC
	 QvB8oSMSqdGdKbompxDS8sOIA7o8FfSQhl6gmz74cTu+JEDD7TFQmvq/S1cVBYkLm0
	 K6qW9IkAXBhVg==
From: cem@kernel.org
To: cem@kernel.org
Cc: Jan Kara <jack@suse.cz>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 5/5] capability: unexport has_capability_noaudit
Date: Thu,  2 Jul 2026 11:33:25 +0200
Message-ID: <20260702093324.127450-11-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260702093324.127450-1-cem@kernel.org>
References: <20260702093324.127450-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This has been originally exported to be used in xfs. Giving we are not
using it anymore, unexport for consistency.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 kernel/capability.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index 2c2d1e8300bd..3d0387fb93a3 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -326,7 +326,6 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
 {
 	return has_ns_capability_noaudit(t, &init_user_ns, cap);
 }
-EXPORT_SYMBOL(has_capability_noaudit);
 
 static bool ns_capable_common(struct user_namespace *ns,
 			      int cap,
-- 
2.54.0

