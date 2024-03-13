Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A30FC122
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296221; cv=none; b=OS8LW4jRSCsbKLXc4lY06ojSWttRvRmicMsw3CpQHuSxcewe9BylnOMTg/g5ESFqxrq5uqc37vlCJg1dUC2yBiNR1sYS0Vvz470Ll4gLXutAs21kqwH+Kqshsr200jNSbN1X+OQmH12/GFVS7FY7+T3GGA2EOkxa6B3uXurTK9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296221; c=relaxed/simple;
	bh=eg0DpmayDb2KZT9A36X4aHSIn3DK16fdTdF6DddoUD8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HPkEyVjnqYX+4l3rkkUJ0+1gDKqHeluiTQj2EhwLKrkO0u93TBNxGP8/1IeE27HSFcgoD35v4PZnPtnLfY19ZL0+ZK5z7jmm7ZutSsCiQ1aM3PQJbyQHzGE4QCf+HLStKE6r8vtQo2KqcimPhr3a+xkGh6W8ppXA3Fr78ApFWuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hALvl/14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hALvl/14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60883C433F1;
	Wed, 13 Mar 2024 02:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710296221;
	bh=eg0DpmayDb2KZT9A36X4aHSIn3DK16fdTdF6DddoUD8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hALvl/14DOHcTJ4cZ1O19RnPi6FSRqRa2Me5gohroNnhPgDrUMR3w5HuescDmy9Mm
	 8afPPKgm5e5e/pQEwjl+pkQH9IWpiQY3pPH5MzQpHJs+9lgVtajyG7jm82dhR+rSM1
	 tOFHR1pVjH3Yh/gW9niuijf8evM8Hu1Nx9WJJy2Ry38wh4WNldk2xPCbPN/AE+TViT
	 wvWVMcCqiSid4NDVPQ0bq5AqjdV1UogMcgLDAvbPB8SZ3F+78XfP4QbL5QnvM49a01
	 lGTAamYELnQ2PjmWwuKdBAQuZtDWMqsItrE7BKIg0CLwfs1A465mTlY0nZxlBltHSH
	 ypwYVsAU2xSzA==
Date: Tue, 12 Mar 2024 19:17:00 -0700
Subject: [PATCH 1/3] libxfs: actually set m_fsname
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029435189.2066071.4364534770813261790.stgit@frogsfrogsfrogs>
In-Reply-To: <171029435171.2066071.3261378354922412284.stgit@frogsfrogsfrogs>
References: <171029435171.2066071.3261378354922412284.stgit@frogsfrogsfrogs>
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
---
 libxfs/init.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/libxfs/init.c b/libxfs/init.c
index 1e035c48f57f..c8d776e3ed50 100644
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

