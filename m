Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55853F39C1;
	Fri, 26 Jun 2026 11:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474376; cv=none; b=YF0rNvYU4CGjRKHXuXBIAXRagNMl43LFAOdLnyxuDM/v0+Me7zsYvHIImwSkN6R/7Y7oZrD4iF87NUS0AFou8Aoxmct4xNOYUlmr1jWv1XwK2MqkwRFofWiCUXiI1TjAXYCVhpG1pSMDhV9Wo9qxH1t5+f8yfifVwKkPRmQVw/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474376; c=relaxed/simple;
	bh=pd20xb3Uvs8FTbSzb1gUYlsZmo1E3h/zsAZn9BTcaKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRcghM63NNT183ZrOq8zxsbaawhVG4XwjyJWDDeopLyy1F+A6hiw2GbpOFTo7KKysyTTQzYL4dBviuLs0b5Gq1N5ZSA3EROldMX6hm0FgYsjetaBxkvJcUTewHi0dKmg3fMMAhs5ZRXjPokWmZE1f7YlXHdeWTSQ9Rkd8bGhUy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KO7heSD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KO7heSD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9E81F000E9;
	Fri, 26 Jun 2026 11:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782474375;
	bh=uuT7zEeg0ndGYB6NqxKnvU+pYG3YksFEeHsTzYD3Ehc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KO7heSD034vhFSOX8UqlE8VIIiV/j+rrJ29rzSZ7q6T3HaFIZ5IsK0Il2JZ9Vrf3i
	 6MOxnIrCEGQVAqt0WIFfbprNchgOogf43uUqmZ9MPiEhePHq+YK2kssacNt0zAGgCr
	 p4zB9CSPvaGZ5jbQi9SnOEvczjFWvZ5DY1NU1jpV+oj/m+YZ/Jky7xlfvzOVNWIUhR
	 g6WXNIyhuUrrgs28jWIy7r6UmGQ1XmB+JkF91yElM+pTtbDe9WUc+0aAaXWB9Ckr+g
	 8cbOHmlFBPmxgzIcG3mUpP3FWR4WC4MXak3MZ4Jhje0nfVqdGwduHtVIMBPTN12k7p
	 buvYrqU0E65rw==
From: cem@kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: jack@suze.cz,
	djwong@kernel.org,
	hch@lst.de,
	serge@hallyn.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: [RFC PATCH 4/4] capability: unexport has_capability_noaudit
Date: Fri, 26 Jun 2026 13:45:23 +0200
Message-ID: <20260626114533.102138-5-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626114533.102138-1-cem@kernel.org>
References: <20260626114533.102138-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This has been originally exported to be used in xfs. Givin we are not
using it anymore, unexport for consistency.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
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

