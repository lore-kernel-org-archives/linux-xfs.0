Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3AD1BE238
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214460; cv=none; b=J2O2uID1bE8yNxwIg48Pz5ovyz5O3h+FB5T03O/ofjQ8Fj69MHECE5DR83TfjtxBu5qxkrd6jafWy2h1NjC+WyUkvJ5sUvHIAbRC6Ol9xP50n5RqTALO36D/bN06ltYnQVyt4OwufHDSN+wsI3ih7c/6NvPMLt5mWgr1H9KM8gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214460; c=relaxed/simple;
	bh=RhSh6YnPiAXeCm2NqGBpcUJrPziaGZ6S+nHU2wnUVxI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZxflhkxAgqVRmA8VKk7UfmLfqLDdsjTC5/sV5o1Tx7z9DRb5YYdFuVai5on5bCH26OADUOQWAteoWV6uV+2muLWH86m6QQOIlw+9jq+RQTqHMtrGtn6aAlhLH1g+lCPXnbwjt/LbPYIH2dpK759ZzCJKlz6vLEFdqr6lv+Giu+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgTwLAh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgTwLAh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E008BC4CEE2;
	Wed,  9 Apr 2025 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214459;
	bh=RhSh6YnPiAXeCm2NqGBpcUJrPziaGZ6S+nHU2wnUVxI=;
	h=Date:From:To:Cc:Subject:From;
	b=FgTwLAh6FDJkuZVADgsPHq0FaI2X6AOHR4ypPY2hKArgfINph08rCSSvTJ9YbpRNS
	 QnRY2i+5nrnyCtM7OK2GGjk/zg2kXuoH4GJB0pkwSZXrm3PUgdA78CcDjvYgGjQbl0
	 XYaN3TyU0deVJ5HnpAzbuLFbBC/GAxzE1KkGJMNPJpDLxqBcpnVgaPHb/+f3AOsk6Y
	 PhUTZ5x/Nr/L/dylyvATBNM2XLySjQy2SFvxd5xfeeD0geUxsb6y6K7bu2cM7iMrxA
	 qUVNPYBpVXwqIrDDECPoQlIQtx/wzYlI9sH22c9iA3YARuLPX1aZrccJiVmZqegXoG
	 GHEfzxpJ0OwJA==
Date: Wed, 9 Apr 2025 09:00:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH] man: fix missing cachestat manpage
Message-ID: <20250409160059.GA6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Fix missing cachestat documentation so that xfs/514 doesn't fail.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/xfs_io.8 |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index f36f1577a2b6c8..3c06e1b4d0fe2c 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1101,6 +1101,9 @@ .SH FILE I/O COMMANDS
 Do not print timing information at all.
 .PD
 .RE
+.TP
+.BI "cachestat off len
+Print page cache statistics for the given file range.
 
 .SH MEMORY MAPPED I/O COMMANDS
 .TP
