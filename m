Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27E3148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529255; cv=none; b=gvlXYzjfxgF0d8mA06Ix2/dKIimoD+2f7/7BoHCNMRoX1K8n6ItJ0RU7llDTDzykMqeDcGCGhbSW8DjBYBTu17U6ZUFbXzGug4/2rhJGZ+dyd1MEKK5V8UrfJkxqfIJIqb5EocjkyGquEfKaQaiDJkUvK7ztJpCSBVeFB0jbHFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529255; c=relaxed/simple;
	bh=KpbxSDdgsvPM/071J2OA33kMou7IwkHUmPpJeJS3tNA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=koCfN0lfw7MzviMPx3Fat/OcO1QDYuLS/a+RtMi1s2m3HvxNAtsMd0c5B9hotkkkEOYHX3esH8Wz+I9bEyj46QPaPd1mgDSKA2eV6a+6TH/pp20SX56WCt5lKeJy6O3HufgzGJIIg5Dc4kP3l/kvZRo4VSSTCHAqm1XtZt1zRVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ni8xTQhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ni8xTQhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8382EC4CED1;
	Fri,  6 Dec 2024 23:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529254;
	bh=KpbxSDdgsvPM/071J2OA33kMou7IwkHUmPpJeJS3tNA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ni8xTQhzZsObRTavuhcbAiCZUs/VRlWivMee1rp1akAFltrLj7bkmUVeVEX7HJZJR
	 r4Xsjyw3ujaK8RlLgEi/ywW4plwA0wAgsM3kMC/xUuoeJNVCjtZ6t81hrjXc/UdUYJ
	 v9uqB/UyUvaXkchuxmUL1hPBZqaZG4zZucW4wT/YrAjO+QGobzsQgbdnj/OQz+YckL
	 B8JbHvFfWjvI1NSiYaP+2hgdO0zdkBHUM8pLioz6bdg+6T/BP5ntufODu2+3kFc6gN
	 E0T8oaLBw0djUq+yk0+lpakc5Fh6Q1ObO084O6pAUo08bWUSSyhlCO5j9FmvAiUg7T
	 7pg8dmx0XR+AQ==
Date: Fri, 06 Dec 2024 15:54:14 -0800
Subject: [PATCH 11/46] libfrog: add memchr_inv
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750162.124560.17659225168928741500.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add this kernel function so we can use it in userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/util.c |   14 ++++++++++++++
 libfrog/util.h |    4 ++++
 2 files changed, 18 insertions(+)


diff --git a/libfrog/util.c b/libfrog/util.c
index 8fb10cf82f5ca4..46047571a5531f 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -22,3 +22,17 @@ log2_roundup(unsigned int i)
 	}
 	return rval;
 }
+
+void *
+memchr_inv(const void *start, int c, size_t bytes)
+{
+	const unsigned char	*p = start;
+
+	while (bytes > 0) {
+		if (*p != (unsigned char)c)
+			return (void *)p;
+		bytes--;
+	}
+
+	return NULL;
+}
diff --git a/libfrog/util.h b/libfrog/util.h
index 5df95e69cd11da..8b4ee7c1333b6b 100644
--- a/libfrog/util.h
+++ b/libfrog/util.h
@@ -6,6 +6,8 @@
 #ifndef __LIBFROG_UTIL_H__
 #define __LIBFROG_UTIL_H__
 
+#include <sys/types.h>
+
 unsigned int	log2_roundup(unsigned int i);
 
 #define min_t(type,x,y) \
@@ -13,4 +15,6 @@ unsigned int	log2_roundup(unsigned int i);
 #define max_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
 
+void *memchr_inv(const void *start, int c, size_t bytes);
+
 #endif /* __LIBFROG_UTIL_H__ */

