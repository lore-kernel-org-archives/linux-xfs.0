Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D02722FF5D;
	Thu,  6 Feb 2025 22:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882185; cv=none; b=mM10qHw1ArCs8R5ue6YgvbjNw3fb6ECcvVUWKb21huBpFfPPOb1nsfgOyfTjL97er5HiyT2MgGNnrDtyz51n/k4UoavC/9RAmcycJ01SXI76oY7Ro9hWwJhOgCS4dAFDlc6/0ZHCT5V5Bcq/XLtj3yrbZJQxNGn1uBXBnnQHxgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882185; c=relaxed/simple;
	bh=q83gbOaTr0eMhOhyC3YcY1GYoT9LITTfvFLoRShhPEg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l5C6hBvRHkq21PUDzfAvQUn0cn19KmxpJicFxUS1kOCYX5CH7lG85ZUmPwwvsfGnj/A0ft5SVm/fiMu+XH7HwNgIxjZU8B3CaBvWV/bnrKysIsLieWvKOR0UTFC+8zGh73HCg2Lkau2l9m5hr9lMEeIkVT7tdPtVTRx2tqdrV/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+ej2t1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+ej2t1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B21C4CEDD;
	Thu,  6 Feb 2025 22:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882184;
	bh=q83gbOaTr0eMhOhyC3YcY1GYoT9LITTfvFLoRShhPEg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L+ej2t1lZULCcS0yfvXcZV7yoX22fH8kVQZCHeAZpFKbW1BNDUahohF/UzC1bUEmU
	 H1yCmkrozEJvW5JNNTL7kSfOwtp7Nb6U8QCMs/NgxJHc5y3rima9yu0Ke5hziGeH5a
	 T1cr7qNS2PwglQvvsrsDoX3UGjtAiQzA6MUZfI07YCj6it4zzNRkk2ycKZ47FVWZ40
	 hPCZcbqVTGYdIUuudRtsnKio7OTFHPx2ZydfAD/1c0UHNmaqO46aRECuNoufU3v1vg
	 qT3dV2fZMAnIiJn5GtAYP4smwi6bLpBO4eUcl6C9t1UxJ06fm6mT9wG2lN/jc2/9RS
	 d45N90PGXLhZw==
Date: Thu, 06 Feb 2025 14:49:44 -0800
Subject: [PATCH 56/56] xfs/libxfs: replace kmalloc() and memcpy() with
 kmemdup()
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, chandanbabu@kernel.org, dchinner@redhat.com,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 mtodorovac69@gmail.com, cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087646.2739176.5488711241017629414.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Mirsad Todorovac <mtodorovac69@gmail.com>

Source kernel commit: 9d9b72472631262b35157f1a650f066c0e11c2bb

The source static analysis tool gave the following advice:

./fs/xfs/libxfs/xfs_dir2.c:382:15-22: WARNING opportunity for kmemdup

→ 382         args->value = kmalloc(len,
383                          GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
384         if (!args->value)
385                 return -ENOMEM;
386
→ 387         memcpy(args->value, name, len);
388         args->valuelen = len;
389         return -EEXIST;

Replacing kmalloc() + memcpy() with kmemdump() doesn't change semantics.
Original code works without fault, so this is not a bug fix but proposed improvement.

Link: https://lwn.net/Articles/198928/
Fixes: 94a69db2367ef ("xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS")
Fixes: 384f3ced07efd ("[XFS] Return case-insensitive match for dentry cache")
Fixes: 2451337dd0439 ("xfs: global error sign conversion")
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/kmem.h    |    9 +++++++++
 libxfs/xfs_dir2.c |    3 +--
 2 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 16a7957f1acee3..66f8b1fbea8fdf 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -79,4 +79,13 @@ static inline void kfree_rcu_mightsleep(const void *ptr)
 __attribute__((format(printf,2,3)))
 char *kasprintf(gfp_t gfp, const char *fmt, ...);
 
+static inline void *kmemdup(const void *src, size_t len, gfp_t gfp)
+{
+	void *p = kmalloc(len, gfp);
+
+	if (p)
+		memcpy(p, src, len);
+	return p;
+}
+
 #endif
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 29e64603d4ae82..1285019b674423 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -378,12 +378,11 @@ xfs_dir_cilookup_result(
 					!(args->op_flags & XFS_DA_OP_CILOOKUP))
 		return -EEXIST;
 
-	args->value = kmalloc(len,
+	args->value = kmemdup(name, len,
 			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
 	if (!args->value)
 		return -ENOMEM;
 
-	memcpy(args->value, name, len);
 	args->valuelen = len;
 	return -EEXIST;
 }

