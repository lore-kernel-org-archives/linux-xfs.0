Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E544243E075;
	Tue,  4 Aug 2026 09:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836775; cv=none; b=FaDz2B0SJLMvNOTKCICoigjLgOX6QILcS9R5n+KWRDSxPzUxxvWqLkeBZmUJeaT0wortTQgbFnNwAr0cypWFFRppxggYPf9pcBFSefCqp2CVsK9Uyk+NbKuhWqBIeBupHyldU61uU+Xr0nkO2KUgBpr8OfF67BYAtjhJKbwhmTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836775; c=relaxed/simple;
	bh=puZMXUzMNDejvn1Pt4WdHdwlaLg2yCHSADSCep5H2Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsbcXaYr81+Ud+9uayaREmRJ9Kgb8e17g3G0Z4BTnfJ1uUKw4ky5xJ23NR9a1b678cx/lNHiZeZFZ3Mb1RK6qkITLGKNBb+0ic7U66rv91fgtv8/S8OR8jKHoRhqVQ/3thr6Oh31or0l/8FBLG38cwbIutpMaVa0+d7OwZGG5g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xk+K+6oD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xk+K+6oD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA681F000E9;
	Tue,  4 Aug 2026 09:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785836773;
	bh=gHdx+vPLDmMwBvC3c6ZsFC43tVpxURokFAMVbXNY29k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xk+K+6oDyQw5AKz0RzhIujmmQWaISw7PohmMYo/1/B18zF221DxbIx+VmIa9Ijeur
	 Us9vL2GuBhge9kuJZAY2/9xR+fXOvgFi3Hedq880GztixT507eeEOIdRSGZDBlYflE
	 ol0NBZisJLd4K131zTdGfvjt7F/QXe82sr1PsA4PohyrL8yK89hu7mDFLc2BzIcBz5
	 2kGNadalg6hVyD1kYASBKexTd4E+ht5cVBxe2vERucRaAkuiurbcyEeuvNn1MD00nR
	 HmnyAY0Et/tMXtJngLg2Fe7/gUo/J4UQGzHLtmev/E2blL1bSR6MpvmYgTEtgEytbi
	 Aer7OE+pO4bUQ==
From: cem@kernel.org
To: cem@kernel.org
Cc: jack@suse.cz,
	djwong@kernel.org,
	hch@lst.de,
	serge@hallyn.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 2/5] capability: Add new capable_noaudit
Date: Tue,  4 Aug 2026 11:45:52 +0200
Message-ID: <20260804094602.84766-3-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804094602.84766-1-cem@kernel.org>
References: <20260804094602.84766-1-cem@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

V4: Mention capable_noaudit check for process effective capabilities
V3: remove the extern declaration

 include/linux/capability.h |  5 +++++
 kernel/capability.c        | 18 ++++++++++++++++++
 2 files changed, 23 insertions(+)

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
index 829f49ae07b9..f4a7f1963c9d 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -416,6 +416,24 @@ bool capable(int cap)
 	return ns_capable(&init_user_ns, cap);
 }
 EXPORT_SYMBOL(capable);
+
+/**
+ * capable_noaudit - Determine if the current task has a superior
+ * capability in effect by checking the process's effective
+ * capabilities (unaudited).
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
2.55.0

