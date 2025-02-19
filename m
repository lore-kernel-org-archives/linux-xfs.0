Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155F91FDA8E
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739981128; cv=none; b=ips2FZDPyAmcdgG0TItjCRKHzxc8qZ+olqObN/BnjP9BI4VteYGXo6JSC2OEbpzMPb/GxV6RSoIOsjD0Lv2OvpDLHXtXJjiGnWE210FDqhZpmNblSQbJV8EkdfzUNKeVDRVQ1L5NK1JXzWXtJmEYOXv8e1TccWyFUsXgn4SPb1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739981128; c=relaxed/simple;
	bh=k3aDaJlE3UvWbKVkOfELTFJAa1K5troYLUGzx+zk1fs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hy/wJMqHauqqWPPpWUz7qLVrBwjReThEaWMzP4DSY4hn1cclKzWAaloDms1NUlwCXF723r3gPVdMvQQKUQCIZXtqqdF6Va3G212wxpgQV9oygyKGgih+Gm+ukzkjpOZS2ICiaQHjrDb7eRTOt0m89q90wWGhtpwC1DQMmbdsiZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-127-146.bstnma.fios.verizon.net [173.48.127.146])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 51JG58AC001618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Feb 2025 11:05:09 -0500
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5FCB92E011A; Wed, 19 Feb 2025 11:05:08 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [XFSPROGS PATCH] make: remove the .extradep file in libxfs on "make clean"
Date: Wed, 19 Feb 2025 11:05:00 -0500
Message-ID: <20250219160500.2129135-1-tytso@mit.edu>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 6e1d3517d108 ("libxfs: test compiling public headers with a C++
compiler") will create the .extradep file.  This can cause future
builds to fail if the header files in $(DESTDIR) no longer exist.

Fix this by removing .extradep (along with files like .ltdep) on a
"make clean".

Fixes: 6e1d3517d108 ("libxfs: test compiling public headers with a C++ compiler")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 include/buildrules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/buildrules b/include/buildrules
index 7a139ff0..6b76abce 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -7,7 +7,7 @@ _BUILDRULES_INCLUDED_ = 1
 include $(TOPDIR)/include/builddefs
 
 clean clobber : $(addsuffix -clean,$(SUBDIRS))
-	@rm -f $(DIRT) .ltdep .dep
+	@rm -f $(DIRT) .ltdep .dep .extradep
 	@rm -fr $(DIRDIRT)
 %-clean:
 	@echo "Cleaning $*"
-- 
2.47.2

