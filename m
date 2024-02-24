Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4355B4C69;
	Sat, 24 Feb 2024 01:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737569; cv=none; b=KeW31CycrsMMe3+M0jHtAaiuU3jZO7QK9k1Gp+xro60hqCBJMIDPJTKBnSdAGT6pv1B3F9tEVP7VCQBmjF+zZe21i9Sp6v6gyZTNtt1aPtY4RQsoBt/dlMWH8wKA5gUkPLoVut7fP8EXKKIOuhdwbz35r+V3v5hr00qtHZc/sWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737569; c=relaxed/simple;
	bh=oDh1Ts+hn3lgKzDs3Z2UQdgZ7XQaqh9T+RxuUGk1AxM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FYTsYedjzurJ3yaKSFaNojvXN63W6SS5hXrLP/9DdqqgRP8RsmRiqYfD6uQ1GzRlqVhw8BVjVmBopu+ECnTwiByPYrTnxE9I5rAQV2Zr53jQCa4+fJiTXx7Mr753/C9bIyPNHH9ZymZ5L3cNQXCJ1mqxlL+FiZrqz+gFJu9qK8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rtfDDtmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rtfDDtmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C802BC433C7;
	Sat, 24 Feb 2024 01:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737568;
	bh=oDh1Ts+hn3lgKzDs3Z2UQdgZ7XQaqh9T+RxuUGk1AxM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rtfDDtmuINlGtSvEIqxW0nJgqBxOrxvl2lgYUM20UK8+FvUm4XE8AFAFVCgW3vm/U
	 Nr2eHh2742RMf1cVJxMjSlQKvndAQn8J97uOMokc/Kz3+lmagzEdIZeZaAT4aRl8DO
	 X1RongFHgMQN9Ogv1If1KgISoiqqVLs0OH42oiMAJ/eAM8KkhwlKVNQi5f+QD0B1c7
	 NzURU5Ga3y3SxDhqltS6A44411c6dUz7NV8lhbzpMSMA8Y4vnixd3NY4faAizOPmSj
	 /XdAuHyCyyNjWfb+fjAn1/1aGbDx0ooQoojPz7stC3F4NESo/AUBlUk/JZMHqLtJPz
	 zjS/LZIpYMedQ==
Date: Fri, 23 Feb 2024 17:19:28 -0800
Subject: [PATCH 7/8] xfs: allow reconfiguration of the health monitoring
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873669980.1861872.14772003328438659934.stgit@frogsfrogsfrogs>
In-Reply-To: <170873669843.1861872.1241932246549132485.stgit@frogsfrogsfrogs>
References: <170873669843.1861872.1241932246549132485.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_healthmon.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 34efc5b5d85e3..27cfca98164eb 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -22,6 +22,8 @@
 #include "xfs_health.h"
 #include "xfs_healthmon.h"
 #include "xfs_notify_failure.h"
+#include "xfs_fs.h"
+#include "xfs_ioctl.h"
 
 /*
  * Live Health Monitoring
@@ -995,9 +997,36 @@ xfs_healthmon_validate(
 	return true;
 }
 
+/* Handle ioctls for the health monitoring thread. */
+STATIC long
+xfs_healthmon_ioctl(
+	struct thread_with_stdio	*thr,
+	unsigned int			cmd,
+	unsigned long			p)
+{
+	struct xfs_health_monitor	hmo;
+	struct xfs_healthmon		*hm = to_healthmon(thr);
+	void			__user *arg = (void __user *)p;
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
 static const struct thread_with_stdio_ops xfs_healthmon_ops = {
 	.exit		= xfs_healthmon_exit,
 	.fn		= xfs_healthmon_run,
+	.unlocked_ioctl	= xfs_healthmon_ioctl,
 };
 
 /*

