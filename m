Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A84D1B0425
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688894; cv=none; b=dqy4pL6OAUo5+P/GZNwdOTT9uF/8adrgBn3mrjDVX3B+qYlRCOxRL0bRv1pWzMOp/3pTt0VL/HJtwYphcneMJ17gVbaJVcf44thDXwG5qcnROO5SffSdLnySbtpusgu0ipJbABh8XJhGAaT/rfDXh1WEPoB6O3M858qGABVS1EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688894; c=relaxed/simple;
	bh=3o5tLxECcPqexA+7liD5fuzVzTkCbj75UANvONLluJ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Og5lpDGlN6tQ/U7UNhIW1r1P8ibA1unIud2OoxrLjjz05cx2CZmGP5nT540jA7gexXrKOnzV9rMcwgc+ECebz2vAXZcln8rc10yiSbFKRWO2hZp89nz4HVkfpPgrq+jy+lUS8y8mFZ0fXTv5Wf/AWUCwoKHiHi1BLOEy6B9JOvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NnFl39w3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NnFl39w3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DC5C4CED2;
	Tue, 31 Dec 2024 23:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688894;
	bh=3o5tLxECcPqexA+7liD5fuzVzTkCbj75UANvONLluJ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NnFl39w3mUSQawgRFthXMcXgSSYq43/RpAjmYt7umuLPZXhZb+SwKrZTm2QSiJ00V
	 P4jpVgsnPZMHAhTExSG2Ee6BfpxZ/7C3COh6xk3WXM5b+OvlRfhaG+hMQgPQ/VxIME
	 /n5mZO+k1m+fw8S8ZOhG1BEhYpxWMlP5fs+HeZ26ARufyyiOTvziZ4ZPpfZWLGkCKA
	 gzlhq4t01qYCGTAYhxX5dRapMWunBRw5fxIBpuJoub+s8rgCq6cTV+rPnT0j99eiJC
	 1VDiAXBdHdzbEP95yKgnzv09+d5B7oGoMXrfwOq+cho2hK+jEd/oo/xbwDynDHbZVT
	 v+WhWbWt5Wp5g==
Date: Tue, 31 Dec 2024 15:48:13 -0800
Subject: [PATCH 02/21] xfs: create a special file to pass filesystem health to
 userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778490.2710211.13224859037235411069.stgit@frogsfrogsfrogs>
In-Reply-To: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
References: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
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
index f4128dbdf3b9a2..d1a81b02a1a3f3 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1100,6 +1100,13 @@ struct xfs_map_freesp {
 	__u64	pad;		/* must be zero */
 };
 
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
@@ -1141,6 +1148,7 @@ struct xfs_map_freesp {
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 65, struct xfs_rtgroup_geometry)
 #define XFS_IOC_GETFSREFCOUNTS	_IOWR('X', 66, struct xfs_getfsrefs_head)
 #define XFS_IOC_MAP_FREESP	_IOW ('X', 67, struct xfs_map_freesp)
+#define XFS_IOC_HEALTH_MONITOR	_IOW ('X', 68, struct xfs_health_monitor)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s

