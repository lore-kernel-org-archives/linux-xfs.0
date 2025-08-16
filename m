Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D32345C14
	for <linux-xfs@vger.kernel.org>; Sat, 16 Aug 2025 00:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755304137; cv=none; b=YGR/Wke+mbSzsscTOLoFNIT6z3+GsZO/3HbwpqUJgF0nbkWVoXimlBs0MMNoGskWzCzMamfyM8idjZ/eY1Bx2LpCvNOaIPriUCu7SatAQp2HKD4ZZsD0kURyQjqYqaepxIjEVqJX9OSNk/0j6Lb0qTgHdGkLm24EqB71zvzurQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755304137; c=relaxed/simple;
	bh=b5r+K4VC3CrfiAj3135Sf8FwODRYcpTv5gvII0DjVFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zldf5Qqkh+YzhaEZv73Kl7FHWFZAy1BiQ65O+GzZ6EDoykb+gWtSNDxorp/sX+2AFux1+PLgK1WXQutrR50ZYxLvIZv3z/x2XnA4SE/zbTCh8Ei1RGjLEjBaq6BxOJCb03YXciGsLvrOloHwV9KPQafERqwHsAVPRm6cZahWGQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=sgRFVm6U; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="sgRFVm6U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=brHar0NjCANQeHZmnrVbccGR/393Uds9xHmJ8SOXGg4=; b=sgRFVm6UTLqgCvNW
	gyKe5iSp19LZd48O55ult+R2gnreSmpO2OTRDL5fkU2ZU+o3JXuDySvO6on80jQCHPfeLDEzz7T3t
	UXVIDpTmhUNnnFW9P7I51eJ/suxSphLk9UpQsAAHPbKJdqS/yNeL5AViJ5XbKjlDt1GPQ1ZmoE23i
	9ME75GC2cjA/VmP6mFa1cr6py36qMOXGfOkvlbBaSeWjndnl3YVLyZJpul5G4BFrItVGy9j0kvnOu
	V1ZdcLBKavv3v/YzaDXv+FajFBAVMon0qAMbtfVr4txhoxt6aSJdZfHcOG1xdY32YRzDPIkL2zyDa
	UN0IErI1OlkR9aX5wA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1un4mp-004Hdj-2E;
	Sat, 16 Aug 2025 00:28:43 +0000
From: linux@treblig.org
To: dave@treblig.org,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org
Cc: hch@lst.de,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] man: Fix XFS_IOC_GETPARENTS ioctl example
Date: Sat, 16 Aug 2025 01:28:42 +0100
Message-ID: <20250816002842.112518-1-linux@treblig.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Fix various typos that stopped the example building.
Add perror calls everywhere so it doesn't fail silently
and mysteriously.

Now builds cleanly with -Wpedantic.

Fixes: a24294c2 ("man: document the XFS_IOC_GETPARENTS ioctl")
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 man/man2/ioctl_xfs_getparents.2 | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/man/man2/ioctl_xfs_getparents.2 b/man/man2/ioctl_xfs_getparents.2
index 5bb9b96a..63926016 100644
--- a/man/man2/ioctl_xfs_getparents.2
+++ b/man/man2/ioctl_xfs_getparents.2
@@ -119,7 +119,7 @@ If the name is a zero-length string, the file queried has no parents.
 Calling programs should allocate a large memory buffer, initialize the head
 structure to zeroes, set gp_bufsize to the size of the buffer, and call the
 ioctl.
-The XFS_GETPARENTS_OFLAG_DONE flag will be set in gp_flags when there are no
+The XFS_GETPARENTS_OFLAG_DONE flag will be set in gp_oflags when there are no
 more parent pointers to be read.
 The below code is an example of XFS_IOC_GETPARENTS usage:
 
@@ -142,16 +142,20 @@ int main() {
 		perror("malloc");
 		return 1;
 	}
-	gp->gp_bufsize = 65536;
+	gp.gp_bufsize = 65536;
 
-	fd = open("/mnt/test/foo.txt", O_RDONLY | O_CREAT);
-	if (fd  == -1)
+	fd = open("/mnt/test/foo.txt", O_RDONLY | O_CREAT, 0666);
+	if (fd  == -1) {
+    perror("open");
 		return errno;
+  }
 
 	do {
-		error = ioctl(fd, XFS_IOC_GETPARENTS, gp);
-		if (error)
+		error = ioctl(fd, XFS_IOC_GETPARENTS, &gp);
+		if (error) {
+      perror("ioctl");
 			return error;
+    }
 
 		for (gpr = xfs_getparents_first_rec(&gp);
 		     gpr != NULL;
@@ -166,7 +170,7 @@ int main() {
 			printf("name		= \\"%s\\"\\n\\n",
 					gpr->gpr_name);
 		}
-	} while (!(gp.gp_flags & XFS_GETPARENTS_OFLAG_DONE));
+	} while (!(gp.gp_oflags & XFS_GETPARENTS_OFLAG_DONE));
 
 	return 0;
 }
-- 
2.50.1

