Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840413C5856;
	Thu, 13 Aug 2026 05:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598690; cv=none; b=t/0wvR1SPvBR79NPypmZTo1nycjQ0KepXcOvw6asv0J+41dlLYczXlNtn9tYk39Zrwc18XQYyN1mF/W28Sg0xBMMjMHnAvhbLkZlTpcO+8jZ5BnxUG/e0Vwg+68lofIJ7b62o73P3HljQGtK7gpviQPvXRI1osRDUzK100yWdRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598690; c=relaxed/simple;
	bh=TLp8dnc/R35xebcaC9ByRgFV7Jp5m7ikCXeR9Qnjt9I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hUa4swj9+xjOdX+QlEItCLSdA/1VHr/567kE6XX+7xTFMEYEXoyTQzNYWP7IoscBW/eCqTUjCBPX69Jw//xRcSoRnyTXiToNZ+FoUCL4o9ILYI4AMOK+vIBGmmuhKFT2+c2TdZuJ/MZ5iSx7blYCr8l0Qqu7ZdHlYnpoQ5ecEqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2YjbpWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2YjbpWg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DC7EB1F00A3D;
	Thu, 13 Aug 2026 05:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598679;
	bh=KiZmLVmPjylIoPf4+fAccLC0B6q7Z0GI33y9OYoZ8+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=f2YjbpWgEy6tiFETr5cqFzajQrjm2CoAQrpxwdHXIQv+wOWlgbyIMmmX/d6KY08co
	 TdWvoSRMtx796TfRFkGSPfW+f8t2J48AkMpnAf0H2SI44hAf+FOWYKLYak0fSkJ/8v
	 NrVVb46U52xGI/CTMRJsP1L6PX1KSJafmx0BslFFLCHt/+VDibWaJndrWR3cVsn4Xm
	 NMHdQokR+KXP6gyFEeSn50QBPt8dQuryItLRbLNEscTrxj2i7Zyc6NgqD5AzsKHFHa
	 v0wSqloqXeo125pnjXJ5ROBg0RB8nTNiGufbmvAOdDR4dT0y4F2wSfZGWaHDNIfmdk
	 Ic2YT/MdRWVBA==
Date: Wed, 12 Aug 2026 22:24:38 -0700
Subject: [PATCH 3/6] xfs: fix name string recording in slowpath pptr
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659861528.833642.5750381236442728243.stgit@frogsfrogsfrogs>
In-Reply-To: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
References: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

