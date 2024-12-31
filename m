Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAD71B0414
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688550; cv=none; b=qd74nbdkERafKmMOQeTrr9Lzs+fhFJiPscuhnkjcOfut605uBnukE7zB706TO6X0+I/BoTOS7PtZcfgL6fqfWj6aqkqROw9dMkDdt6aLibwwp5/emicPlC3wpAMWw2S+lstGzNyouITwN8dnxTv4PHy99sLeELd4A4AFLW+jdNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688550; c=relaxed/simple;
	bh=ZbpTg5bFXC06JXqSvyMfOw4yOkpn0Ypr2FREpMFen9U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hFL8sL/FuQHYIo4XvQ/HVQ69Vmv+PnM3fWvbmVXrxKkIlsrXy8D8vFNTvPGJzMJJAguI6vh97qweObpFZkDxVAHtXZdEW+8xxtwWQmNOxM7xZQZimTMDRFHGb7GvWk2MJ7we79QdpL6EFeaRdzkRqse8wImWl2+vJ73QDpMW918=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MH5yxZTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MH5yxZTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966E5C4CED2;
	Tue, 31 Dec 2024 23:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688550;
	bh=ZbpTg5bFXC06JXqSvyMfOw4yOkpn0Ypr2FREpMFen9U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MH5yxZTtqS6Xzt1N3VqFOGnjrSRia6bcTO3fKx0HZ7pKhR5Xj5tGq/MDHLL0KpoIf
	 yOmUvqZkzkUrrUGPwVtCUqUyCSM3Vawz8RSXK9WnnzUPS9LJa2PsPQ9KgCOvsaZIwS
	 qZriq0g4hwIUmMW0/W5Y+EIYeoXQWars7tmW0byhL+xxbRRquT0DpGsNBvBGHB5TfZ
	 KU5N5TDiT8BTEi4pBL/2KKeCFOtLT7UBUsNvl799H8wa7lpr980RdncOyiN79BExxr
	 lZDN6J0W2N0q957XgEAKueVuYIvj1v7fL0hZwQhjHEV0hYQDPRkTGm8tusEj97bScl
	 dPm99u2w3Y7oQ==
Date: Tue, 31 Dec 2024 15:42:30 -0800
Subject: [PATCH 14/16] xfs: allow reconfiguration of the health monitoring
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754986.2704911.11270955358261059464.stgit@frogsfrogsfrogs>
In-Reply-To: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
References: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make it so that we can reconfigure the health monitoring device by
calling the XFS_IOC_HEALTH_MONITOR ioctl on it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_healthmon.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 9320f12b60ade9..67f7d4a8cc7f58 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -23,6 +23,8 @@
 #include "xfs_fsops.h"
 #include "xfs_notify_failure.h"
 #include "xfs_file.h"
+#include "xfs_fs.h"
+#include "xfs_ioctl.h"
 
 #include <linux/anon_inodes.h>
 #include <linux/eventpoll.h>
@@ -1228,11 +1230,38 @@ xfs_healthmon_validate(
 	return true;
 }
 
+/* Handle ioctls for the health monitoring thread. */
+STATIC long
+xfs_healthmon_ioctl(
+	struct file			*file,
+	unsigned int			cmd,
+	unsigned long			p)
+{
+	struct xfs_health_monitor	hmo;
+	struct xfs_healthmon		*hm = file->private_data;
+	void __user			*arg = (void __user *)p;
+
+	if (cmd != XFS_IOC_HEALTH_MONITOR)
+		return -ENOTTY;
+
+	if (copy_from_user(&hmo, arg, sizeof(hmo)))
+		return -EFAULT;
+
+	if (!xfs_healthmon_validate(&hmo))
+		return -EINVAL;
+
+	mutex_lock(&hm->lock);
+	hm->verbose = !!(hmo.flags & XFS_HEALTH_MONITOR_VERBOSE);
+	mutex_unlock(&hm->lock);
+	return 0;
+}
+
 static const struct file_operations xfs_healthmon_fops = {
 	.owner		= THIS_MODULE,
 	.read_iter	= xfs_healthmon_read_iter,
 	.poll		= xfs_healthmon_poll,
 	.release	= xfs_healthmon_release,
+	.unlocked_ioctl	= xfs_healthmon_ioctl,
 };
 
 /*

