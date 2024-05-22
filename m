Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A38C58210
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346095; cv=none; b=h4X55ppT31wc3H4BeTqG2zxQd42zA2WhFsjIUG81c98XpZ4Uf8Kqmyb4V04TA4ICyMJynaL+G7Y3MLjJZmxpbhkeUN7QSaI3lV0Rd/4KxT7PNZkOju+vY5hGH39MNk25l6zKZzjFcua6b0cOQRV2DQ8VhPnpxm6B1S3RApFhAXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346095; c=relaxed/simple;
	bh=WWwIT5M/tzs+Feo4cLV5B7sbQMJZeJfo1czDP3f5HjA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lMpEG7GWSntyAYMw/v/1+tGhItYeysXlWntzdRkCHUv11DPfXiJFdF24ICqf6v1ezB55amn/bCF2BhJr/917I0a6g+pB+QJWv+UnS4CEMHTa3gnJB9qnm6WGvBe21a4lGfke1JMaFtWRRow2tDyDrwmJs9m+s+YFmtFNZJOr/kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTrQRZhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTrQRZhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22454C2BD11;
	Wed, 22 May 2024 02:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346095;
	bh=WWwIT5M/tzs+Feo4cLV5B7sbQMJZeJfo1czDP3f5HjA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TTrQRZhU0c2bwCBjgv/5iNrNv6MpKO8LzJzgBmBP1aVy89NUIJtDex3idhRWfUYeT
	 Gyo/gH/3c3Ih8phc9WKcLxKiMo8zXk5DFbji0wemUyMdSMsEs67jZmqdr+U6PsL7FG
	 yh0Eth+tjHw6ZrFRw2//r9Qj0k1HMlfZWlMQzP2Z7RuBjVX8AxuZChP2rD8OS87Vm2
	 ZyyQcM0tQmxQdR0uJDqOt2opirYuJQLXZ0JNBKorv6ivWR5+r74VCNXOV3hPMnjUp8
	 7gbrkvoReuDHM0OOJZRVywab3hxIinMUzO9vMarvfdM4IQHAwcYEegOIFjbY+SYjAE
	 OSI1PI6Ow6GoA==
Date: Tue, 21 May 2024 19:48:14 -0700
Subject: [PATCH 1/3] libxfs: actually set m_fsname
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531156.2478774.2478899438270350659.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531139.2478774.17043099852261356412.stgit@frogsfrogsfrogs>
References: <171634531139.2478774.17043099852261356412.stgit@frogsfrogsfrogs>
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

Set the name of the filesystem before we actually start using it for
creating xfiles.  This leads to nice(r) output from /proc/maps such as:

7fcd0a44f000-7fcd0a450000 rw-s 021f6000 00:01 3612684 /memfd:xfs_repair (/dev/sda): AG 0 rmap records (deleted)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/libxfs/init.c b/libxfs/init.c
index 6ac9d6824..c9c61ac18 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -643,6 +643,11 @@ libxfs_mount(
 		xfs_set_reporting_corruption(mp);
 	libxfs_buftarg_init(mp, xi);
 
+	if (xi->data.name)
+		mp->m_fsname = strdup(xi->data.name);
+	else
+		mp->m_fsname = NULL;
+
 	mp->m_finobt_nores = true;
 	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
@@ -903,6 +908,9 @@ libxfs_umount(
 	kmem_free(mp->m_attr_geo);
 	kmem_free(mp->m_dir_geo);
 
+	free(mp->m_fsname);
+	mp->m_fsname = NULL;
+
 	kmem_free(mp->m_rtdev_targp);
 	if (mp->m_logdev_targp != mp->m_ddev_targp)
 		kmem_free(mp->m_logdev_targp);

