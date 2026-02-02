Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A222F90C4
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 19:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770059646; cv=none; b=TFwKdr1P0nTc74kk3YiaBq9747OHnwbCYld4BGFsGJ7MLlvwQTWfjVne51shrwUGtptLjei6NO0aSEx0d49MoDBzzckAjZRYz+Ax3C8IuY9aKGtM00Uz9h06UvxrGzALhkbB/AJqoozNwnUgM/xMc+uL5JUj0IWD7wZTjph0+HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770059646; c=relaxed/simple;
	bh=SEnIx4Pvwq06/oOINURkiQVK1SDWdD6gR78UDQO9ZAw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=M69+1LnvLA+AtgV14SM6dEMSUiFtwXEku4ndn3jtp0Crz1EgbQUQzZzhmFV8/DsubF8+5k/EH0ZnexduST7gRt4UvJ1rRmFxIWDkggk9iDwGCb5V6zwJPVG2jpcJs90n59bA8xM6RhPECBj1fcz1xEw6xxBAz01eMD1xVdDeZ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jUOj+DiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jUOj+DiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528B5C116C6;
	Mon,  2 Feb 2026 19:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770059646;
	bh=SEnIx4Pvwq06/oOINURkiQVK1SDWdD6gR78UDQO9ZAw=;
	h=Date:From:To:Cc:Subject:From;
	b=jUOj+DiZiIzxxdQwVFRWApwY7ES3QagOCK5ceCmRv1GyxzSn2M8aPP6jmdtmVOdiH
	 YQA2+McZsGDZ0LzZIOWXHiiM6k/xnXAcOz0q0ItAb5Q5VEz+dsExvpBB64DDUfuH0x
	 tlVyi9fuwKfZny/tScUxEsxJaHe6aXzmRjCNjHzS+T7BhrtLILUUK3SjCwmMJIIB8f
	 6N+UNFc2lYpaLUX97YulgoitwTx6uxyqTwIZ1zjSmCesft3MFAY9vFQSTCEoYZ9mMZ
	 yQ3nvyQg+iHwWl4VuJsbPn/ShjPQ3nJ5muWV5IhS/UrieQKOjiYns4dbXbkAv3O5bn
	 zGr7lYvSZdqOw==
Date: Mon, 2 Feb 2026 11:14:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_scrub_all: fix non-service-mode arguments to xfs_scrub
Message-ID: <20260202191405.GK7712@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Back in commit 7da76e2745d6a7, we changed the default arguments to
xfs_scrub for the xfs_scrub@ service to derive the fix/preen/check mode
from the "autofsck" filesystem property instead of hardcoding "-p".
Unfortunately, I forgot to make the same update for xfs_scrub_all being
run from the CLI and directly invoking xfs_scrub.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1125314
Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 7da76e2745d6a7 ("xfs_scrub: use the autofsck fsproperty to select mode")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/Makefile            |    2 +-
 scrub/xfs_scrub_all.py.in |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scrub/Makefile b/scrub/Makefile
index 6375d77a291bcb..ff79a265762332 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -16,7 +16,7 @@ LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all.py
 XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
-XFS_SCRUB_ARGS = -p
+XFS_SCRUB_ARGS = -o autofsck
 XFS_SCRUB_SERVICE_ARGS = -b -o autofsck
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
diff --git a/scrub/xfs_scrub_all.py.in b/scrub/xfs_scrub_all.py.in
index ce251daea6a5d5..9f861639a43ce4 100644
--- a/scrub/xfs_scrub_all.py.in
+++ b/scrub/xfs_scrub_all.py.in
@@ -102,7 +102,8 @@ class scrub_subprocess(scrub_control):
 		cmd = ['@sbindir@/xfs_scrub']
 		if 'SERVICE_MODE' in os.environ:
 			cmd += '@scrub_service_args@'.split()
-		cmd += '@scrub_args@'.split()
+		else:
+			cmd += '@scrub_args@'.split()
 		if scrub_media:
 			cmd += '-x'
 		cmd += [mnt]
