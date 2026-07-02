Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9114747F2FB;
	Thu,  2 Jul 2026 09:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782984995; cv=none; b=kzyHZUV2W/JrP7tX4MxLLuqiQkn3PcbHhr5pLT9x6NoHiZ0K1J6+9UPxvcs86tOTHz/dOwYmsxzY9s5Ihkm51jSf4vX18+US/lW0YqsGn8gIy6ZvgY6NeOhnOCUgYYcUAproYdEfy5AGh8K0CZS7nKhO7V/eqVhXGlGwNiLzVdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782984995; c=relaxed/simple;
	bh=Hn1k/D1ClXZsM/kgBtPcAtcOgTvg6izGNl2wimsfMkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sf65tBzuBQKv9LQ0aXSDFVN7jBAPqCWHSmL3sphnqJoKxqvRfket4QE70PONt7Tw6Fxg60ycJdyZnVOpyBUjXSpj/Hm7dbrZ9nGY9yevHvD3qgjFmLWYZbDRsVhK6kTWTh7i65sEV1/iAUtLTVQb2vd3RQhofvehXimsqyd5DN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dN+SAJnl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dN+SAJnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A931F000E9;
	Thu,  2 Jul 2026 09:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782984994;
	bh=NvufOs32I4haHGafE2VQL3eyYoeYK0iSWCEBHiuHF+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dN+SAJnl6i61MbeGVC12bXTVR0Yd61lYyJIpGDGoy6y+r6r0XcLUnvD/OhItpNoFf
	 lULtGRtI09dz2Wu+BWijiJMmXbpBFJIdTj0xsf6K/uOWx3RAhVZFp6xU+AibrIq1rE
	 Ungy5XXARG1HaiYfT9KCFY5TpSAm4V1r0LVibDYUQkbdxwGTZC9WUho7JUXlBYDyuv
	 wlOkM6GhzTTtPjpTszmEuyQC/mISEP62YwFB28whO07l/IFssKycsIgaTd0m0rbvrB
	 mXgqT6Yrz67G38smYlnMiwgppc1y4r8CBiiNf3Kho2zhmWVYaDA1ezgDQa0o9r4D4d
	 3cug001AxW9Qw==
From: cem@kernel.org
To: cem@kernel.org
Cc: Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Serge Hallyn <serge@hallyn.com>
Subject: [PATCH v3 2/5] capability: Add new capable_noaudit
Date: Thu,  2 Jul 2026 11:33:19 +0200
Message-ID: <20260702093324.127450-5-cem@kernel.org>
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

In some situations (quota enforcement bypass in this case) we'd like to
check for a specific capability without triggering spurious audit
messages from security modules like selinux.

Add a new helper so we don't need to use ns_capable_noaudit() directly.

V3: remove the extern declaration

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Serge Hallyn <serge@hallyn.com>
---
 include/linux/capability.h |  5 +++++
 kernel/capability.c        | 17 +++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 37db92b3d6f8..f8532d92fcad 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -145,6 +145,7 @@ extern bool has_capability_noaudit(struct task_struct *t, int cap);
 extern bool has_ns_capability_noaudit(struct task_struct *t,
 				      struct user_namespace *ns, int cap);
 extern bool capable(int cap);
+bool capable_noaudit(int cap);
 extern bool ns_capable(struct user_namespace *ns, int cap);
 extern bool ns_capable_noaudit(struct user_namespace *ns, int cap);
 extern bool ns_capable_setid(struct user_namespace *ns, int cap);
@@ -167,6 +168,10 @@ static inline bool capable(int cap)
 {
 	return true;
 }
+static inline bool capable_noaudit(int cap)
+{
+	return true;
+}
 static inline bool ns_capable(struct user_namespace *ns, int cap)
 {
 	return true;
diff --git a/kernel/capability.c b/kernel/capability.c
index 829f49ae07b9..2c2d1e8300bd 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -416,6 +416,23 @@ bool capable(int cap)
 	return ns_capable(&init_user_ns, cap);
 }
 EXPORT_SYMBOL(capable);
+
+/**
+ * capable_noaudit - Determine if the current task has a superior
+ * capability in effect (unaudited).
+ * @cap: The capability to be tested for
+ *
+ * This is the same as capable(), except it uses CAP_OPT_NOAUDIT as to prevent
+ * issuing spurious audit messages.
+ *
+ * This sets PF_SUPERPRIV on the task if the capability is available on the
+ * assumption that it's about to be used.
+ */
+bool capable_noaudit(int cap)
+{
+	return ns_capable_noaudit(&init_user_ns, cap);
+}
+EXPORT_SYMBOL(capable_noaudit);
 #endif /* CONFIG_MULTIUSER */
 
 /**
-- 
2.54.0

