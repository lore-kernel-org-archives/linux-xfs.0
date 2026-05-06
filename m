Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902303ED13A
	for <linux-xfs@vger.kernel.org>; Wed,  6 May 2026 16:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778085479; cv=none; b=IZUWecbODQ8rJWM61WR3WbzcGdbOy0kMcIzvOqdMy0MOvvXZGh+yn5V8N/vEdDMD5aGsu2cclmdD2yPnOiWxZLXcOrbj/uF2iEPsZfD9gaaVmaFBoKr4TenPq1tXd3EYtbYYVl1khT1V24JDev62yciWjx1tqn+N6t/A+s15YJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778085479; c=relaxed/simple;
	bh=HpVkXoCCKb6qg6yCzJnoqvzyX4twTcv0wpOm1OUwB9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NF+jve6mZyil0pFCf3QvefLUHVra/1mXmJKgZVu1fA+OqVlnDx1PQiixPQx/dlyU9VS6lXhp+0P8t5zalisOG3FhjPoMKg3c3P+1+wos7ZtqC8KhvegqCk9kZN0SIK0CGpkdStLbTu+JakOfg4BsNd7hsM8E8eAN/Hk5q7Gmm7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egay3XJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egay3XJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BB7C2BCB0;
	Wed,  6 May 2026 16:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778085479;
	bh=HpVkXoCCKb6qg6yCzJnoqvzyX4twTcv0wpOm1OUwB9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egay3XJZfz5dPvpIm0xCFcxh9oAUiv8x2BEW/GJ/v0mjZ+QDNYNf/fZwqGgN8swKt
	 GZ2BG9cvoVatZOA/nqRIl9W0dAyPI7PDt8q7P/XhA25bF2rrH/YycKzhQWpCTP4dla
	 bpfEFZxeAFFthEPEwlVStL6rZCiJ+Ut7+z84u/rCe8JQKhfT3rwY2wHXUS/KnPxWuW
	 UQso54e6+W8FIFZ3cjBF1G7tSeMliX7R8AC30JLqh8+/kx9DHxUwudAxTVnm+hlzt4
	 Jos81ndpyq64WGmkYw0+Q5snsuaWur6ZRN0vFh1jpPgNKYkVZ/ww58GVG2WLs4OO87
	 mgeIP2Dcw1K1g==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 1/2] xfsdump: fix permissions on files installed by libtoolize
Date: Wed,  6 May 2026 18:37:43 +0200
Message-ID: <20260506163746.1083845-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260506163746.1083845-1-aalbersh@kernel.org>
References: <20260506163746.1083845-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Libtoolize installs some set of AUX files from its system package.
Not all distributions have the same permissions set on these files.
For example, read-only libtoolize system package will copy those
files without write permissions. This causes build to fail as next
line copies ./include/install-sh over ./install-sh which is not
writable.

Fix this by setting permission explicitly on files copied by
libtoolize.

The same fix in xfsprogs:
6b32423addd2 ("xfsprogs: fix permissions on files installed by libtoolize")

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index e849c7fd6e16..36c7ace3d102 100644
--- a/Makefile
+++ b/Makefile
@@ -70,6 +70,9 @@ LIBTOOLIZE_INSTALL = `libtoolize -n -i >/dev/null 2>/dev/null && echo -i`
 
 configure:
 	libtoolize -c $(LIBTOOLIZE_INSTALL) -f
+	chmod 755 config.guess config.sub install-sh
+	chmod 644 ltmain.sh m4/libtool.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
+		m4/ltversion.m4 m4/lt~obsolete.m4
 	cp include/install-sh .
 	aclocal -I m4
 	autoconf
-- 
2.51.2

