Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C3C3F39C9;
	Fri, 26 Jun 2026 11:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474369; cv=none; b=aImAerrv/DO4jUzoG/BWH/UE52vp3Ajt5lllnLBiqZ962w8+Tgz+kCr2TQRgJKbDuGuX3dC5q8FpYEm28aVYW5zev4T5PWgRYf42dcU2CC1bPN8bJqsQzPyWB7w64aM6G9WhcF7MFA7NDc3ygeIRfajXmNnHpMSaseTl5SGgKHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474369; c=relaxed/simple;
	bh=W6oD5FfTE/j/5KYReBMgEHgECtZmI/ojkwlWhQ65evI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3gLiWzJ+9YIYkPZUwzRQ1FAczPX/S1CnUhyKOsDwTIjRmrVALSz0qqs9ai5AAZ08O8DNQ1lsEos8C8gS5KPIQyWdTFiGiKmBpAReuBqoNMyfsN9Ppd0L1Dsn5fT+xs+WIe+5nWA72lykmorLCy5vwKt4hh19Ou8AFobup7wKcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwA77FxU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwA77FxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7751F00A3A;
	Fri, 26 Jun 2026 11:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782474367;
	bh=hK/djOh1XDLN4fLmkmYrh+2JRjNPL0iNtD6/5AEPaew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwA77FxU+JdGymb5qBWfwZ9FfGTFSZjHUAv1KpEemPbOViUQvSr3eyWUifT8IDr4C
	 IgSSx8hKSZzM3IwoKxeDPaZSqZFrIzZlvwksWhSpdvhs+pxIetZihbB8dF2dz4YR4q
	 K64NK4DNL16OevDAewKiZzcyv4i4oSzaKrcPVTx0Z8E8FhV0FmSSlvZQUVe69v5EQw
	 gsrZcazG4OTlTBLHIS+wztKKltOxbE6Pl4H2ONlAVz4zsnjzqEsNGK3U4EPEN4PjzN
	 IiZuoPNp+n0Cp58ciG/ofoap/diGztfuEAWCstBHa1xxmhqh1tSELuAzIZ9Qu5nUU7
	 7hIQ4bU+8EntQ==
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
Subject: [RFC PATCH 1/4] capabily: Add new capable_noaudit
Date: Fri, 26 Jun 2026 13:45:20 +0200
Message-ID: <20260626114533.102138-2-cem@kernel.org>
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

In some situations (quota enforcement bypass in this case) we'd like to
check for a specific capability without triggering spurious audit
messages from security modules like selinux.

Add a new helper so we don't need to use ns_capable_noaudit() directly.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 include/linux/capability.h |  5 +++++
 kernel/capability.c        | 17 +++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 37db92b3d6f8..873416ba884c 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -145,6 +145,7 @@ extern bool has_capability_noaudit(struct task_struct *t, int cap);
 extern bool has_ns_capability_noaudit(struct task_struct *t,
 				      struct user_namespace *ns, int cap);
 extern bool capable(int cap);
+extern bool capable_noaudit(int cap);
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

