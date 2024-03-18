Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9140059B42
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798308; cv=none; b=bIt2e8DRKOu/ADSZj/IdE3bvD6s2xwdVFpcT1RIOpftPEhzrSazcU990D5g/QKS9ob8FDRusz+ZX24dQbyfzoM/SC+25jzo5t/ZGJcM32MgszGerGhK3pbOHkgfi+VeMBBBjCHUj9ANorE0/dqjhfWVXh0i8AwnLjHgsim1AEKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798308; c=relaxed/simple;
	bh=8U95mqGDvfvZsoWKvp6vcNU5u9D6WpjWU3ge8ZB51Ug=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dB6JZeboowiWLpFYcpGV7vdzdK6ycQ5gHzzz0BtXkZNmEIoMc8PQw8GDXNOMye1fLSd1GDXsdGs46JCcuf/Jmd7Aqbly0Lcfa0P9R9YSAQZBue0Z2gdQvPuVl9+c86peSWPFQxtoC0sRATaz+AqisaQfZ3wuF8MSvuoBGFWGglY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q8eiTJxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q8eiTJxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29093C433F1;
	Mon, 18 Mar 2024 21:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798308;
	bh=8U95mqGDvfvZsoWKvp6vcNU5u9D6WpjWU3ge8ZB51Ug=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q8eiTJxn1rA5HqjAdNHlfVhp81KUikpjW4CMRT0ILqjJwHW0rQ15CHUSLWb3pVGxQ
	 nNewmaAWBUBIPDcQg/EZSXEhdwvK7bUOhepHQtt9urVmLRXzXz2zP1ingzjmToH8kx
	 AqzRmN1htzf1rAHOubf6oK9+ykQ0uRWOjVy7VtEkd5tnViFi7+OlVr85ija/zVn1EI
	 ULh85KlcHSLK2WEL+CHdUSIUN04dmOcK148NWIr+4rYurkrW2VNwAjmCnptjdL2Ecg
	 9XGQ0f+5j4tlE/iinMhexj3c67NROCyWkHVuORAYFaGk8yTXNf3FXWXs0OFpeImR5C
	 wZyqvuZS/k1+g==
Date: Mon, 18 Mar 2024 14:45:07 -0700
Subject: [PATCH 12/23] xfs: Filter XFS_ATTR_PARENT for getfattr
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802070.3806377.10488984594084209492.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Parent pointers returned to the get_fattr tool cause errors since
the tool cannot parse parent pointers.  Fix this by filtering parent
parent pointers from xfs_xattr_put_listent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_xattr.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index a12cfc4d345ee..30428249f838f 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -220,6 +220,9 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	if (flags & XFS_ATTR_PARENT)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&

