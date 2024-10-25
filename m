Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0183D18C935
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838246; cv=none; b=EpSc3UmYsRwX1Hnc66tf41e2Lsr8wB+PGNkjqCJJ3VHneQ558qqIOA4NWCxQk4MmVRAcF5rwCttPl6v/+3C8jcvfXgq4NtMGrU25gA7GGZCTH3LV/V/oixM6PCOUa42xO3Lsn1KKh2D+uCJBokW0KGMLFr/ILM4ax9uoRsk/WnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838246; c=relaxed/simple;
	bh=UjNpHV+k9RorUDh45wvtXOvZiBxlhSv06rMjJTZC6RA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fl2rIdMiGsJddAcdgz7yLzgG2ybcIRbX/m9yPmoxVjkVoHtke6i3+iqqS6h6TF3wvnVu/yE1DMHW4a0L5r+wzt3bI0W4m+DIwcCFtKfKUkfJbHOhr6fhXKL9JoRZP9CbG19nYlaPP8YChAT6qDuia7g+8HWccnQqD6iEOHal6OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gzmLX1hL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gzmLX1hL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DD1C4CEC3;
	Fri, 25 Oct 2024 06:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838245;
	bh=UjNpHV+k9RorUDh45wvtXOvZiBxlhSv06rMjJTZC6RA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gzmLX1hLCOmg0bLvA4srh5aw7l6lueh/FBIqTtclybgJArDeyEf0OfdjG66qJgbqZ
	 Bw2gaRXNl0s7gpQhvaEEx6KfDujP/XxrLEe79L4zZrdmOn4pzG3j+/IDo6ePVK1+6T
	 LDLrsM6azvRgql8j78tNv5x5HyISTyOoLeyNGYQtZ/x6KlS9viykgcR1FUWMG3Dzce
	 hkRJ7AavBWR1Xeuxs6H0klKyJE4kgAMNuGBjrWaiajvcNdU8MRTth8MTnCixCnUEZg
	 mLoaa9oNIFYvPfEMdOBTyEZ9E78glHMmSJ9qpTcm75nvy2yoH1FvOHb9yF6adGuEsK
	 6oU5IXoGHI3Iw==
Date: Thu, 24 Oct 2024 23:37:25 -0700
Subject: [PATCH 3/6] mkfs: remove a pointless rtfreesp_init forward
 declaration
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983774485.3041643.1809910276287170254.stgit@frogsfrogsfrogs>
In-Reply-To: <172983774433.3041643.7410184047224484972.stgit@frogsfrogsfrogs>
References: <172983774433.3041643.7410184047224484972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |    1 -
 1 file changed, 1 deletion(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 06010980c5b313..9d21f027c0b174 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -18,7 +18,6 @@ static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
 static char *newregfile(char **pp, int *len);
 static void rtinit(xfs_mount_t *mp);
-static void rtfreesp_init(struct xfs_mount *mp);
 static long filesize(int fd);
 static int slashes_are_spaces;
 

