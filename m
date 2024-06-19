Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4F4143C43;
	Wed, 19 Jun 2024 13:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802538; cv=none; b=lUtpv8xTZ2LEQ+omSH7JOAujwtDvTcva1hpvufhxipQVUDP90wzLc/E/SoOQAlt4lNrRohILbQ+L0s9zVyj5I3PDNx5Z50/+dupNCFZgILSxshubSRS7VaILROWjOg8QBQm/IdIDwTjxYxVQ9cZ+aJ57VT4jlm9UbwffH5uGYfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802538; c=relaxed/simple;
	bh=+i3xmw1fxIXjonzeByqElusHwXKYJ+n/NZG16LpuME8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJ/G3eE+Yx+vvZ/BEWPi022ooY372n65GwuQEhjcA1MQvYyFTUkRpKl8kigFvnDEDd7UfNTW4jFs+Au3cQ7R7yOl9DWqjNrWyJrZUpZeZzO1JRGZY2H8IlCVNtnChlD1BEny4xx1SQUi8qDaMhwPo67uYYD+4G3m5K7hYfIXTyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDAfOiHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDAfOiHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BE2C4AF1D;
	Wed, 19 Jun 2024 13:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802538;
	bh=+i3xmw1fxIXjonzeByqElusHwXKYJ+n/NZG16LpuME8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDAfOiHDOawUh6ncTom0TbOAXEkqOkbBbVkdOxrazeG2tRN4WFGe6yDtkPJVf1mlx
	 gVTyQXryQzG3jahL3EhmydrfynmMcS2h3bzMoaIcJ8YX/EXO8om+ledKjyO2NVPxTX
	 UQRFMQIqMCPA5kICyO+FiDxJ4+EA4MZbhW/gVf40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 231/267] xfs: fix scrub stats file permissions
Date: Wed, 19 Jun 2024 14:56:22 +0200
Message-ID: <20240619125615.191534523@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit e610e856b938a1fc86e7ee83ad2f39716082bca7 upstream.

When the kernel is in lockdown mode, debugfs will only show files that
are world-readable and cannot be written, mmaped, or used with ioctl.
That more or less describes the scrub stats file, except that the
permissions are wrong -- they should be 0444, not 0644.  You can't write
the stats file, so the 0200 makes no sense.

Meanwhile, the clear_stats file is only writable, but it got mode 0400
instead of 0200, which would make more sense.

Fix both files so that they make sense.

Fixes: d7a74cad8f451 ("xfs: track usage statistics of online fsck")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/stats.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -329,9 +329,9 @@ xchk_stats_register(
 	if (!cs->cs_debugfs)
 		return;
 
-	debugfs_create_file("stats", 0644, cs->cs_debugfs, cs,
+	debugfs_create_file("stats", 0444, cs->cs_debugfs, cs,
 			&scrub_stats_fops);
-	debugfs_create_file("clear_stats", 0400, cs->cs_debugfs, cs,
+	debugfs_create_file("clear_stats", 0200, cs->cs_debugfs, cs,
 			&clear_scrub_stats_fops);
 }
 


