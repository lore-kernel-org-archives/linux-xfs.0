Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06522119
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882626; cv=none; b=Daqyr72JzSo951eJJnztCxMSp62ea84fRSlVaAIc7lbP6Y7JKXugi2LE+TkQT1jcDsJ1zT1f69LTYvm+PSGQiZboLDE6X5Mrukfbj08xpiFXoGGnfjjvHU51vRmZGQKeZrGUN351d8RtHjM5Cr5dgH3v1kPC10rDuwkGfgy9Adc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882626; c=relaxed/simple;
	bh=rODyl56E8htbf3lOKTO39Qh9sP+UbS7aIu+ceyIXP4U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Py1yHQLOPtOpaj61IHQvo1r8PpcKt8Q/jSkRnkj5l3UYN3Flz8Mfc/fJFCMUTlnkbQorO+wNjNVeSMYgdJRvqBK9UTKkmLOMhUOKyT6wQ0ZlvtKECDoeA5rcCBm4d5KgIoYxfJLKgdtwQKBkI7ehM7IiRb3b6EHZg1/klgQhQPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uFnNo+Ll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uFnNo+Ll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8C2C116B1;
	Tue,  2 Jul 2024 01:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882626;
	bh=rODyl56E8htbf3lOKTO39Qh9sP+UbS7aIu+ceyIXP4U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uFnNo+Ll4gyXKIxv+QxdQFPrkXJO/tjLRnvM1g+2AXJI6rkdRggmRYNZp+L7oHv7G
	 mPewGW8arLmSoomHKiojmO4MjIiKYQZ6hx1k1EP742Ydj9P7/N2/RfkbSa1m2Euu7+
	 jXJN5hj+kU8Yt6ofUCbisrdSNQH9UXnJ7YHjzAfOgDYAuDdchDpVl5nnr4OX9n0+xC
	 7w3ysDb4owNxd+9vRsmJvkLdz4votPMtV6V+uCONivkuqH9+Ebkoz4kISCZBV2DH4M
	 5EJvf0BAwdQ0GokG/zo6UMGPW8MCDMARteINwuuu/IsefkqgcVk/9tC3IL9mXCnFxN
	 0uTWp/0Z16Lhg==
Date: Mon, 01 Jul 2024 18:10:25 -0700
Subject: [PATCH 2/3] xfs_repair: enforce one namespace bit per extended
 attribute
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988120632.2009101.8080215211983761365.stgit@frogsfrogsfrogs>
In-Reply-To: <171988120597.2009101.16960117804604964893.stgit@frogsfrogsfrogs>
References: <171988120597.2009101.16960117804604964893.stgit@frogsfrogsfrogs>
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

Enforce that all extended attributes have at most one namespace bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/attr_repair.c     |   15 +++++++++++++++
 2 files changed, 16 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index cc670d93a9f2..2d858580abfe 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -36,6 +36,7 @@
 
 #define xfs_ascii_ci_hashname		libxfs_ascii_ci_hashname
 
+#define xfs_attr_check_namespace	libxfs_attr_check_namespace
 #define xfs_attr_get			libxfs_attr_get
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 0f2f7a284bdd..a756a40db9b0 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -291,6 +291,13 @@ process_shortform_attr(
 			}
 		}
 
+		if (!libxfs_attr_check_namespace(currententry->flags)) {
+			do_warn(
+	_("multiple namespaces for shortform attribute %d in inode %" PRIu64 "\n"),
+				i, ino);
+			junkit = 1;
+		}
+
 		/* namecheck checks for null chars in attr names. */
 		if (!libxfs_attr_namecheck(currententry->flags,
 					   currententry->nameval,
@@ -641,6 +648,14 @@ process_leaf_attr_block(
 			break;
 		}
 
+		if (!libxfs_attr_check_namespace(entry->flags)) {
+			do_warn(
+	_("multiple namespaces for attribute entry %d in attr block %u, inode %" PRIu64 "\n"),
+				i, da_bno, ino);
+			clearit = 1;
+			break;
+		}
+
 		if (entry->flags & XFS_ATTR_INCOMPLETE) {
 			/* we are inconsistent state. get rid of us */
 			do_warn(

