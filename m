Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5383B777B
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 19:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778700711; cv=none; b=AUOMBhGELrFqpS5WLBCt75kfKfkg7LAOsa94Ia3TV8gXRWH6HE9jYkF0Bn5OTUbedxsvbwc8OjIPAnpnD2+mPFumcJ65zvcEJd1WIIXg2CPCFQ9+xxWvWI5znP7CPq856NN3mf9BI/0d3Umt84n0Nfm5CUOY2sAMZ6TPsKJk6cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778700711; c=relaxed/simple;
	bh=VhO+DD11IWwkIstmwYaDuntC7BAn0TeatopwYcRWLD4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTxUcx6SLl3ifM5jRdMVXD7dAlxwav8m/zrsBCru1VQK2u2IW1HMhWev5utONryfJcoRjYuJllw+78fC4kVTPMesDJiezwgn4Qf8+IAD4R3jBwUW6ZAzvgWJltLVDL4wtEdFLixdM+srxZPCIXHlWDnLQkJnovl7H3S8hvbboyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BocN3xqX; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=luJ1yYgF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BocN3xqX";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="luJ1yYgF"
Received: from localhost.localdomain (unknown [10.128.32.2])
	by smtp-out1.suse.de (Postfix) with ESMTP id F21006A802
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 19:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778700707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YYZbR37KegtY3iCKDW/z9oswetniZwuYG62OPCDjvco=;
	b=BocN3xqXPJVj40iveLmjzQFYIx/V5CF0QtOjAumeUat5G3h/W6tr6c2XdOMmkl2lQFk0fk
	ZEGnwnl+Pf9hUm+ZCt+SOvsS2RIrTLxPZWxj6ZdPoDrr7KYPSVGTBHsFja5AFeNs8iYKhl
	VcVKx8qkBtZcWdIOztPhXSjmGjHzDH0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778700706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YYZbR37KegtY3iCKDW/z9oswetniZwuYG62OPCDjvco=;
	b=luJ1yYgFxc79EWrm7/ZyzwTHBXmnKrI+0uh6TV7d9XF67ExvwkaWPXSndmWw+sxr0pP3Jl
	UvXKpHS8JMPPGyCyJPKaYSt5MaagL/nntEkqIII+JSF20nOsXQ3PJUb+QXbyeginB7IfzX
	yhAWklexU3hFNnX9z1YAgbvcK+IGlT8=
From: Anthony Iliopoulos <ailiop@suse.com>
To: <linux-xfs@vger.kernel.org>
Subject: [PATCH 1/4] configure: always check for statmount supported_mask
Date: Wed, 13 May 2026 21:30:37 +0200
Message-ID: <20260513193040.2130-2-ailiop@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,configure.ac:url,localhost.localdomain:helo]
X-Spam-Level: 

On systems with kernel headers older than v6.8 that preceed the addition
of the statmount syscall, have_listmount will be set to false and thus
checking of the statmount supported_mask is being skipped since the
check is currently conditional to listmount support.

This causes compilation failures since need_internal_statmount will not
be set, and thus struct statmount will not be available to xfs_healer.

Fix this by always checking for statmount supported_mask support even
when listmount is not available.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 2ac5e3d8181a..fe2ffddd9ec4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -192,8 +192,8 @@ AC_HAVE_CLOSE_RANGE
 AC_HAVE_LISTMOUNT
 if test "$have_listmount" = "yes"; then
 	AC_HAVE_LISTMOUNT_NS_FD
-	AC_HAVE_STATMOUNT_SUPPORTED_MASK
 fi
+AC_HAVE_STATMOUNT_SUPPORTED_MASK
 AC_HAVE_FANOTIFY_MOUNTINFO
 
 if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
-- 
2.49.0

