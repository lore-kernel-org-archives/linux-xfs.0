Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D277441A;
	Tue,  6 Aug 2024 18:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968485; cv=none; b=CbCht8a6YHPXp2l1xJXaqhEgjS55rPskfcoGxAG0lc6eiAZ9pFppnbXoz1p3cdt2PoDw9gyhb3aAAgVGi417WekNoXKwxpI347xvr5NgASLxkpdOUWKogG/VCjY+yn9GLUlu15Mh14B0s5Suz/JOIhE3zi0Az3avZnqWDQZy4n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968485; c=relaxed/simple;
	bh=/zkvtDQSBpXNVN0eKLPUocTq1r6//W6MWVhL+mCxLvU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p6Hrnrv7TKimtF4EKAIFCMG7lt65lRpQgzv0wEkLKvhA54/X0NwXMP95zZD6Fxpqk4bro25wG/WasIvDNFMSxQKpPNmMnjb6f2/fqm4p7LWPDGMnP7qjRuxSnGhjz3sHer9mmlNt93rPTYMh9qMpXym8PVAISH/WgmsuBIPz0kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YuksnlQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YuksnlQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9D0C32786;
	Tue,  6 Aug 2024 18:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968484;
	bh=/zkvtDQSBpXNVN0eKLPUocTq1r6//W6MWVhL+mCxLvU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YuksnlQ6GeoVRA5N/jFRQ2KCn+qqq8vPhbQME9l5xNr4QDp9By1c0n3vOcREpjAt4
	 2C3vfyXBXUpc8jvGyKNg8PYtEAm+XqbM8uHOb8KJNA3E9Pu4bHSLKfsPCzfQAAUYIl
	 QEURT/NgQKBAC9BmmQfmbqAdmt669JV92N8XKNfTgFRxBTHtO43G7bruzzmKoaft1E
	 lB28fl5RKIx8xQxrHSFDcZzK7BHbzL4qTXGJEPs2fzt6Pn0cF83045Pj6qYozPoqBh
	 +cnYoinq9/1Zb12EBmm7Ssbl1d15zW3NJe35cEcNGTo5gMkOPnpP95p3OWbAYci6vm
	 6pvYTbDAE4DaQ==
Date: Tue, 06 Aug 2024 11:21:24 -0700
Subject: [PATCH 1/4] libfrog: define a autofsck filesystem property
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, dchinner@redhat.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <172296825613.3193344.6788691411989910358.stgit@frogsfrogsfrogs>
In-Reply-To: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs>
References: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the ability to set properties on filesystems, create an
"autofsck" property so that sysadmins can control background xfs_scrub
behaviors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/fsproperties.c |   38 ++++++++++++++++++++++++++++++++++++++
 libfrog/fsproperties.h |   13 +++++++++++++
 2 files changed, 51 insertions(+)


diff --git a/libfrog/fsproperties.c b/libfrog/fsproperties.c
index c317d15c1..72485f627 100644
--- a/libfrog/fsproperties.c
+++ b/libfrog/fsproperties.c
@@ -29,11 +29,49 @@ __fsprops_lookup(
 #define fsprops_lookup(values, value) \
 	__fsprops_lookup((values), ARRAY_SIZE(values), (value))
 
+/* Automatic background fsck fs property */
+
+static const char *fsprop_autofsck_values[] = {
+	[FSPROP_AUTOFSCK_UNSET]		= NULL,
+	[FSPROP_AUTOFSCK_NONE]		= "none",
+	[FSPROP_AUTOFSCK_CHECK]		= "check",
+	[FSPROP_AUTOFSCK_OPTIMIZE]	= "optimize",
+	[FSPROP_AUTOFSCK_REPAIR]	= "repair",
+};
+
+/* Convert the autofsck property enum to a string. */
+const char *
+fsprop_autofsck_write(
+	enum fsprop_autofsck	x)
+{
+	if (x <= FSPROP_AUTOFSCK_UNSET ||
+	    x >= ARRAY_SIZE(fsprop_autofsck_values))
+		return NULL;
+	return fsprop_autofsck_values[x];
+}
+
+/*
+ * Turn a autofsck value string into an enumerated value, or _UNSET if it's
+ * not recognized.
+ */
+enum fsprop_autofsck
+fsprop_autofsck_read(
+	const char	*value)
+{
+	int ret = fsprops_lookup(fsprop_autofsck_values, value);
+	if (ret < 0)
+		return FSPROP_AUTOFSCK_UNSET;
+	return ret;
+}
+
 /* Return true if a fs property name=value tuple is allowed. */
 bool
 fsprop_validate(
 	const char	*name,
 	const char	*value)
 {
+	if (!strcmp(name, FSPROP_AUTOFSCK_NAME))
+		return fsprops_lookup(fsprop_autofsck_values, value) >= 0;
+
 	return true;
 }
diff --git a/libfrog/fsproperties.h b/libfrog/fsproperties.h
index b1ac4cdd7..11d6530bc 100644
--- a/libfrog/fsproperties.h
+++ b/libfrog/fsproperties.h
@@ -50,4 +50,17 @@ bool fsprop_validate(const char *name, const char *value);
 
 /* Specific Filesystem Properties */
 
+#define FSPROP_AUTOFSCK_NAME		"autofsck"
+
+enum fsprop_autofsck {
+	FSPROP_AUTOFSCK_UNSET = 0,	/* do not set property */
+	FSPROP_AUTOFSCK_NONE,		/* no background scrubs */
+	FSPROP_AUTOFSCK_CHECK,		/* allow only background checking */
+	FSPROP_AUTOFSCK_OPTIMIZE,	/* allow background optimization */
+	FSPROP_AUTOFSCK_REPAIR,		/* allow background repair & optimization */
+};
+
+const char *fsprop_autofsck_write(enum fsprop_autofsck x);
+enum fsprop_autofsck fsprop_autofsck_read(const char *value);
+
 #endif /* __LIBFROG_FSPROPERTIES_H__ */

