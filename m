Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EBE287506
	for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 16:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763743178; cv=none; b=FaHR/5j7k0VN1JcAUBXdpoPt02E24UcjLsfUCm1NCCMhTfE3GPjsJNEmW9aIJZW1teSIdESIR5nE0EWDSIMb+WaOMVSS39AcP8EH0sQ5T8IEJdzCpbp+0Wc5aJtYKmJfJ2fY5VNN21hR3o5JvKXTC1M5fHQwo1TqIc4H5ctD+u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763743178; c=relaxed/simple;
	bh=pvKUtCLS3gLmoycOlqJGYyrHIDNMkKmPk347VIRzn1s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qY6IkOIAZBqSDDDANtd8URC9V21mefFjM/vEdwF7gG6GhOCl7tsXpPIYZdpa4AgGz3WLy2T4N5yNKRj5yUqR2v4sB/39H3Eq4CzcH4cLlnokbVcthXGfHD1pE3orsA1EtVPKMa5Uwe1VDsyYG5Oz6z9ddO+oNTYFnEZiXZ7svNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZfKf8YD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZfKf8YD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E799C4CEF1;
	Fri, 21 Nov 2025 16:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763743177;
	bh=pvKUtCLS3gLmoycOlqJGYyrHIDNMkKmPk347VIRzn1s=;
	h=Date:From:To:Cc:Subject:From;
	b=GZfKf8YD92PK6MTdTVnNHqmbcZCRvvM7Nu5ygFNQyy08Pk5M+IkK9L6IvP58gJI7N
	 p1qZmsNRYsvxTpvj1wpaM/F9G9/+yVF7MWAo1gV88NoKE0Db+lgiCeCuynGMZMqczx
	 0sbiJqr1i4Upypxn89w7BaybxDT7+2BKFUpQvPH3o/8khMiobeTUQNZen67yhV7W5/
	 M8IeEhFTSx/TYsoPwZmKa9t1i2MNtO5gldjOCpLqpjfanzP2VET1UBf7WT+nZvPRUH
	 EPQuU9FLH+8GC0xOa4D+eoWn1N5vy2eM4XNtCDcjXO4sDBgLu9/j9Px+7zcOYFefIa
	 8Lp1R9U52WxmA==
Date: Fri, 21 Nov 2025 08:39:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_scrub: fix null pointer crash in scrub_render_ino_descr
Message-ID: <20251121163937.GN196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Starting in Debian 13's libc6, passing a NULL format string to vsnprintf
causes the program to segfault.  Prior to this, the null format string
would be ignored.  Because @format is optional, let's explicitly steer
around the vsnprintf if there is no format string.  Also tidy whitespace
in the comment.

Found by generic/45[34] on Debian 13.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 9a8b09762f9a52 ("xfs_scrub: use parent pointers when possible to report file operations")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/common.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/scrub/common.c b/scrub/common.c
index a50c810a7bd5a1..49f13466d389c1 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -404,7 +404,7 @@ within_range(
 /*
  * Render an inode number into a buffer in a format suitable for use in
  * log messages. The buffer will be filled with:
- * 	"inode <inode number> (<ag number>/<ag inode number>)"
+ *	"inode <inode number> (<ag number>/<ag inode number>)"
  * If the @format argument is non-NULL, it will be rendered into the buffer
  * after the inode representation and a single space.
  */
@@ -506,8 +506,11 @@ scrub_render_ino_descr(
 	pathlen = ret;
 
 report_format:
-	va_start(args, format);
-	pathlen += vsnprintf(buf + pathlen, buflen - pathlen, format, args);
-	va_end(args);
+	if (format) {
+		va_start(args, format);
+		pathlen += vsnprintf(buf + pathlen, buflen - pathlen, format,
+				args);
+		va_end(args);
+	}
 	return pathlen;
 }
