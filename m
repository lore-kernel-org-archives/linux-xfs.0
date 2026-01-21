Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355E8346A15;
	Wed, 21 Jan 2026 06:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977431; cv=none; b=UPd4zLMV4pv7YHUqfNzJRsNDryo6E/sZzPUPZtE1HEyqvL3RF/0i0tcBQhg9tWTd0gmDljSoFb+7taMLHEtuN+0ecehE7mu3zTLYJmxFhQxBbEkj0aXjuvPZe5o2b5H8OKV893ijlI63m1YOU1gMGwxCq7ys+8BWBJSFkMgRFrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977431; c=relaxed/simple;
	bh=VBE0BOb1Tvh8w9MhsVbgQ4KdftB6NlrORVTJEIAgahg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DonXyIaTX0P5qZpBHO85KEXuTPVSPmU/opsvU+F0YZOJvtdSLLG0myy0PfHpOSid6GQALIfPElobmjwbV51VzQBqWmqAfspgQh9M4UDWivpLO1/cVryHmvmGJDNi7zw/g9jR4O17OahCJg8BhQ/nIR4PP9ENNfVBVeKnEXz4rxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k4QLcOQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k4QLcOQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4458C116D0;
	Wed, 21 Jan 2026 06:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977430;
	bh=VBE0BOb1Tvh8w9MhsVbgQ4KdftB6NlrORVTJEIAgahg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k4QLcOQoqU0pWF52kpAvf98sNpwm9j+pEJb8wtmW50eZcgkk6Ueoqk80JD+6fsk8T
	 zYsfC8xFT5GnjDH6RlEKtv2RmJVeIhy+6/rCv5j9UzQeSAMs4xMk2EpwCl4S9Ag0aB
	 UYqfVZygkRnm6I+jlK6+BXUqPlU3PfkmaNFl1GddspBfMHEawEF9593UjIBQSYNEnr
	 pg+HRW82lZge3A4Yi8TN1IWr3dWCaIplg4EujMux5CYBb9N9JI4RQGOXgTEa5TLy26
	 yHgJW338evldSsV1SfjewWudMq86pfrDn40nFQvz9r1gjSHDBx2h6vPVXWzWUq5UUR
	 Tjfr9fN1WhMQg==
Date: Tue, 20 Jan 2026 22:37:10 -0800
Subject: [PATCH 09/11] xfs: allow toggling verbose logging on the health
 monitoring file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 hch@lst.de
Message-ID: <176897695221.202109.180672138187333244.stgit@frogsfrogsfrogs>
In-Reply-To: <176897694953.202109.15171131238404759078.stgit@frogsfrogsfrogs>
References: <176897694953.202109.15171131238404759078.stgit@frogsfrogsfrogs>
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
calling the XFS_IOC_HEALTH_MONITOR ioctl on it.  As of right now we can
only toggle the verbose flag, but this is less annoying than having to
closing the monitor fd and reopen it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_healthmon.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 1bb4b0adf2470e..4a8cbd87932201 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -23,6 +23,7 @@
 #include "xfs_fsops.h"
 #include "xfs_notify_failure.h"
 #include "xfs_file.h"
+#include "xfs_ioctl.h"
 
 #include <linux/anon_inodes.h>
 #include <linux/eventpoll.h>
@@ -1066,12 +1067,55 @@ xfs_healthmon_show_fdinfo(
 	mutex_unlock(&hm->lock);
 }
 
+/* Reconfigure the health monitor. */
+STATIC long
+xfs_healthmon_reconfigure(
+	struct file			*file,
+	unsigned int			cmd,
+	void __user			*arg)
+{
+	struct xfs_health_monitor	hmo;
+	struct xfs_healthmon		*hm = file->private_data;
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
+
+	return 0;
+}
+
+/* Handle ioctls for the health monitoring thread. */
+STATIC long
+xfs_healthmon_ioctl(
+	struct file			*file,
+	unsigned int			cmd,
+	unsigned long			p)
+{
+	void __user			*arg = (void __user *)p;
+
+	switch (cmd) {
+	case XFS_IOC_HEALTH_MONITOR:
+		return xfs_healthmon_reconfigure(file, cmd, arg);
+	default:
+		break;
+	}
+
+	return -ENOTTY;
+}
+
 static const struct file_operations xfs_healthmon_fops = {
 	.owner		= THIS_MODULE,
 	.show_fdinfo	= xfs_healthmon_show_fdinfo,
 	.read_iter	= xfs_healthmon_read_iter,
 	.poll		= xfs_healthmon_poll,
 	.release	= xfs_healthmon_release,
+	.unlocked_ioctl	= xfs_healthmon_ioctl,
 };
 
 /*

