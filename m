Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB18C7081A
	for <linux-xfs@vger.kernel.org>; Sat, 22 Feb 2025 15:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740236938; cv=none; b=FhN43HkzqzIziJ8KFoEFvchDgNM/TrU18Wo2odSrfcbh+O3YhFB5j0zrm/TNqDz+T7APN4x/5CsZ09Q7d8QFj0QBULsMh/qZTr4CI5EIoi1W3TJNqLGOWqEa2TCwBAchXxmZk9+uQV0DbYG63Q0rO1boywPN/q+l/YiN45Yo0Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740236938; c=relaxed/simple;
	bh=OSfakw2IBETPveck1pX1djhmjf13QH55+2l5TQgG3/c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=JUj+/eaSiyZYyeeZvuzWVFPZp3RNIEfeFGzJK7b8r7typ+emsv6qaty5vnCk5w5T1F+1XmqxhDgeCefxfvxp4AQ7zaN7RoPjc8bchaNrzR98w7OODZyr+m8Rh/4fcGq+8Q411IClz9ivAfFpvw9Kb8TeTD2CPISySetlCtq7pgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Z+53QocH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LEIIHvOf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Z+53QocH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LEIIHvOf"
Received: from kunlun.arch.suse.cz (unknown [10.100.128.76])
	by smtp-out1.suse.de (Postfix) with ESMTP id A5FBB2116F
	for <linux-xfs@vger.kernel.org>; Sat, 22 Feb 2025 15:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1740236927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=G21CoTtJCQTJ9E1JGiajgiVnYfRktDs6vQPo7AXs7AM=;
	b=Z+53QocHYYiyq+7A+Qpaxv/9yH23qIGFq40j5G2lxonGYO9nfplc3n7LoXXyadrIvKPuHh
	RzJl2Rmk1xZw1dokTfKFcHBzihm59cz2TjwbH9CV8aXk2EJ+BqaNyqxic3gEi0Vwt8QYQc
	YU4e/uNyXn57TAqIts5D4wL3+o3kUuk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1740236926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=G21CoTtJCQTJ9E1JGiajgiVnYfRktDs6vQPo7AXs7AM=;
	b=LEIIHvOfyJQENzECN64SsdawmSQQImOxUPr/R83uP7Rm19QeUdaXbCp7Fvv3ZJNLyZnsQ7
	tvBrJhrLkYtbAWVGWhJyDONtOLRFm9xJtSlJYoNbCbbXwxSZGb7Wl8heTw6A/DLwZ4MfrN
	GpEn4sPbigdTW/R4VEqFW4xXXrFBrgY=
From: Anthony Iliopoulos <ailiop@suse.com>
To: <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_io: don't fail FS_IOC_FSGETXATTR on filesystems that lack support
Date: Sat, 22 Feb 2025 16:08:32 +0100
Message-ID: <20250222150832.133343-1-ailiop@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,kunlun.arch.suse.cz:helo]
X-Spam-Flag: NO
X-Spam-Level: 

Not all filesystems implement the FS_IOC_FSGETXATTR ioctl, and in those
cases -ENOTTY will be returned. There is no need to return with an error
when this happens, so just silently return.

Without this fstest generic/169 fails on NFS that doesn't implement the
fileattr_get inode operation.

Fixes: e6b48f451a5d ("xfs_io: allow foreign FSes to show FS_IOC_FSGETXATTR details")
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 io/stat.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io/stat.c b/io/stat.c
index 3ce3308d0562..d27f916800c0 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -104,8 +104,10 @@ print_extended_info(int verbose)
 	struct fsxattr fsx = {}, fsxa = {};
 
 	if ((ioctl(file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
-		perror("FS_IOC_GETXATTR");
-		exitcode = 1;
+		if (errno != ENOTTY) {
+			perror("FS_IOC_FSGETXATTR");
+			exitcode = 1;
+		}
 		return;
 	}
 
-- 
2.47.0

