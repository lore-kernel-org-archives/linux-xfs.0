Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1BB36F8E7;
	Thu, 30 Jul 2026 05:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389211; cv=none; b=RROVn7/8bMwWawh+758bol2Fc+lckQDDBNgKkg9i71Fqx/f+HfdfaJOCnQkob8AoigSoIz9h2t3ka9mvaR+aa+UiOv0Vj7kYBECJAA9/yhp4z6qVgWDaRa/nH/bpZDLeWCzyayu9GKSVEz9zMqc4ZQL7SX13m7p9VZxpBEJizRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389211; c=relaxed/simple;
	bh=XzmGXlTXVGBSuijnTSK8r11AYCeioERZbE2SNypDPjY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oMGbb+LUFVzEi4rrITyos7fA2uRNvo14N9Pj8IukKkIUuosj5Vlf3qHTqgiHofwyXOxE7g8groMKAFbIgFLpkUFNOz2ApIL6Js06lo7S8DIOR7iB0fT+oZLdZQ3pliNCPrle7AyXKI+8m+I03JxzyEj9N2uwYl88sSazjVyBL3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f80xCaG+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f80xCaG+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A6E8E1F000E9;
	Thu, 30 Jul 2026 05:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785389209;
	bh=T5MGaLjzWrG5f+yekSbxwFV8TfgFGGpdRssj8FXz9K0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=f80xCaG+U4Kr3CIJhuUdqiXZ7QY/jg++jPOpjxDML44N6G/4o5C/Oe407gIsxSzN0
	 03f8dTceD3SLVn93X2h/TJ3Py7sxCEIlfFdfAYDBwRU8ABByJIwnCMQfq0THfX/dob
	 c41q0dTg7KzSlonNOIpuGHD/ObOOswqRMNzoINm/0JVzZVkA53IqgoVdkN1B/uRCFZ
	 wFFUEbtRHaIiW4LfPF18Jpv5mMTA1OtBWvw1RYGDN9S08aiMrAeRvoM855ZG6bJCPU
	 iX77WpMzkRFnrU3OQRKqcv3Wziesbf9lC8isH5arYRjjoH4DW9GqoR3XLSl0Fq+OnI
	 dLfPOGMfSZXow==
Date: Wed, 29 Jul 2026 22:26:49 -0700
Subject: [PATCH 3/6] xfs: fix name string recording in slowpath pptr
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178538912944.4070956.3603642702710474972.stgit@frogsfrogsfrogs>
In-Reply-To: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that we memcpy from the xfs_name object, not the name
string pointed to by the xfs_name.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: b961c8bf1fc3d0 ("xfs: deferred scrub of dirents")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 14aa0ec1f09e4a..362c6d39e9f580 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1640,7 +1640,7 @@ DECLARE_EVENT_CLASS(xchk_pptr_class,
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = I_INO(ip);
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name, name->len);
+		memcpy(__get_str(name), name->name, name->len);
 		__entry->far_ino = far_ino;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name '%.*s' far_ino 0x%llx",

