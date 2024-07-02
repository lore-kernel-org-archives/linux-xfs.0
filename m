Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D2479DF
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882861; cv=none; b=KJtwR4+Cqu0WwJnHSeFiDYpvPLdyqjGxbHHvknsrOKGtN+bndHp9Kqh/4gY2ugqkqGRTJSh4KuEsQsO5XlDlVr+l0yIwDhjE6uLcsHdoYD9DXmGvcenRkgjCkm9Ld156ybSa3a2P5+PUnulqcjuFkhldLbrVQu60sRyA+rpzzTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882861; c=relaxed/simple;
	bh=/Rz1GR2Wqnj3QjDNwIOMbkufBLPVQcJfesnOXIa9qxU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UlIuEQvXZlugdukSDQBjHgsyIkx81yyjzZOtGwvAs27wynS4MqztdzyMI07Nuq5/ctPTdnnKWoXF5qM2haI2xpXsLLd8mLCN/WGFIy+ykF+94XHf50ohY8Go54rPu2xTfbCImXT40ZgKE+1W29bUDpfkA9wnFfcgZzetELEIuC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ACeTzFuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ACeTzFuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05885C116B1;
	Tue,  2 Jul 2024 01:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882861;
	bh=/Rz1GR2Wqnj3QjDNwIOMbkufBLPVQcJfesnOXIa9qxU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ACeTzFuvsxbMkAYeF1MPwzNj1gemeS32YveSZMTyVCtY1CGTYL6vcdnqbE6VO1ZR5
	 TvkbmmK5CZSyHV6ma0OrlgO0ESR2xkIXWZJODL5gPwOqsj7eqNCrrC/vfSHWl0LOQu
	 PndQvSpc8WNgpM84MClODtNsYIhWGvIlYCASqnIwJt1HHe+GHj4nijqx8MwBNZs22x
	 XmBfq00N+pyiASyV0GljBjk2kvh7Adq7Fb1rNkUvfYSNSIwzG9zSUg6QfSkq8F84K/
	 yhlly0cjKumwA6CMPbEaTm81+NtiMAOExRQxeijz9tIne+mxYn1xvkrP3ABCc2MICQ
	 pCukKB0SXQ3qQ==
Date: Mon, 01 Jul 2024 18:14:20 -0700
Subject: [PATCH 14/24] xfs_db: report parent bit on xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121279.2009260.4036237222136719544.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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

Display the parent bit on xattr keys

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 db/attr.c      |    3 +++
 db/attrshort.c |    3 +++
 2 files changed, 6 insertions(+)


diff --git a/db/attr.c b/db/attr.c
index de68d6276337..3252f388614e 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -82,6 +82,9 @@ const field_t	attr_leaf_entry_flds[] = {
 	{ "local", FLDT_UINT1,
 	  OI(LEOFF(flags) + bitsz(uint8_t) - XFS_ATTR_LOCAL_BIT - 1), C1, 0,
 	  TYP_NONE },
+	{ "parent", FLDT_UINT1,
+	  OI(LEOFF(flags) + bitsz(uint8_t) - XFS_ATTR_PARENT_BIT - 1), C1, 0,
+	  TYP_NONE },
 	{ "pad2", FLDT_UINT8X, OI(LEOFF(pad2)), C1, FLD_SKIPALL, TYP_NONE },
 	{ NULL }
 };
diff --git a/db/attrshort.c b/db/attrshort.c
index 7c386d46f88f..978f58d67a7b 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -43,6 +43,9 @@ const field_t	attr_sf_entry_flds[] = {
 	{ "secure", FLDT_UINT1,
 	  OI(EOFF(flags) + bitsz(uint8_t) - XFS_ATTR_SECURE_BIT - 1), C1, 0,
 	  TYP_NONE },
+	{ "parent", FLDT_UINT1,
+	  OI(EOFF(flags) + bitsz(uint8_t) - XFS_ATTR_PARENT_BIT - 1), C1, 0,
+	  TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(EOFF(nameval)), attr_sf_entry_name_count,
 	  FLD_COUNT, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_sf_entry_value_offset,

