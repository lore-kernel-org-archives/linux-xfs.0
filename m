Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F228DF76
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761177967; cv=none; b=XcpLrjb2HIe3kqyi7PotOQg4HqVUbfO991uNk0kk88yPrS9biVQyxTCnTdx+SGJCc6SBuhsr+FKegK/5ReBMTOC9Q79V6I1yYB2ha0WYc7ejSuy7YuCtp8DaBwNC2sPSzF6K/r0nKWGWMGAV2pmeJ5bGpYWB8hzm24fTpuXrGaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761177967; c=relaxed/simple;
	bh=tepbJCxGA5lI+LlLAgs+6xUxW+TEp0bN22U56Ayg2w8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UJVcX4OODkMCMgQ/bwAOt3zsFaq3t/BaVHCmiqRXgpe5etaf9Z/SiLWANLI75RdA1e0jK1CwpR1JgTnXIw4NSCf3h/sJhqqmSNePBKNMBEpESzZhiF2IowQ8BKYvIbnuL+Q1bh+ZW4ej66drLicbHeq9SLH1Uu0pbgrHweEzL4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ipaxn/o+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ipaxn/o+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46C2C4CEF5;
	Thu, 23 Oct 2025 00:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761177965;
	bh=tepbJCxGA5lI+LlLAgs+6xUxW+TEp0bN22U56Ayg2w8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ipaxn/o+cxkfRImEYlrw/nzezhTvZ3+6AqZQTHlSiSYwJ0Bc5h50yK9eWagsHFswt
	 cP9JEthNj/SQyufQJC1FKOrSIz3oRW6yUEDLKFKf+/4AfNKTK2EqjQQ/BOraovQgqK
	 TZdD154mGavnaIBBoQOv/fGuG7OEOh3LieMS6nsfsHzb+3hSiJ+Dk/o7ND60YgB1We
	 /OmuSD/grxH8xS8o27sF9RBqNZPklp4+kp7ZamnxMyK/Ud0HYP/7lgVT3sCondcfGD
	 UsSoTQ/Moi0hAvSMQfbL1M3x27fjTVwLHFQGAtnFvTuR8I32ZJDdgBG0VdcuvJflGx
	 0/PQ3Cs/4iQ0Q==
Date: Wed, 22 Oct 2025 17:06:05 -0700
Subject: [PATCH 02/26] xfs: create a special file to pass filesystem health to
 userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747505.1028044.17908733628001095158.stgit@frogsfrogsfrogs>
In-Reply-To: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
References: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create an ioctl that installs a file descriptor backed by an anon_inode
file that will convey filesystem health events to userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_fs.h |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 12463ba766da05..dba7896f716092 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1003,6 +1003,13 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
 #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
 
+struct xfs_health_monitor {
+	__u64	flags;		/* flags */
+	__u8	format;		/* output format */
+	__u8	pad1[7];	/* zeroes */
+	__u64	pad2[2];	/* zeroes */
+};
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1042,6 +1049,7 @@ struct xfs_rtgroup_geometry {
 #define XFS_IOC_GETPARENTS_BY_HANDLE _IOWR('X', 63, struct xfs_getparents_by_handle)
 #define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 64, struct xfs_scrub_vec_head)
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 65, struct xfs_rtgroup_geometry)
+#define XFS_IOC_HEALTH_MONITOR	_IOW ('X', 68, struct xfs_health_monitor)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s

