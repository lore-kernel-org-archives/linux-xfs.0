Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00799F9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440896; cv=none; b=AyDzJeUh6KQ3RJXmg9ZbEfQOgVfxGqKxhf3q+PBTu/IN+h18957fDTwVQYmxAfu3clssU0q/TU5MWgv/+jfmCeJUlQIRybNVLFFbZ+BfOAHOyt3wn7hisy/j6MU9bOevrVfW4O5/1ds088PxcqHL10r5QFIwB68GrIPfQfkU5WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440896; c=relaxed/simple;
	bh=OqoVdbUH21aB4HjU4RGqIh2C49UUd+uBw1wczrkU3CQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M5ERhDNS2PpYXtKHCcivEnoiMtCXgo171u4LTn8BBXvAOmsahYTbekw4SR2X6OkibgJnyu4nCy/eNbFgOmjLjwH6EUfwowmd+Rdd7KNfuozpK6fG8ONY/nQosrvBsrKmx2zaxaY4842PFwlkykwlKo5TPQ/k/R7+UryGhB36ch8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VEM8dCcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VEM8dCcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC451C2BD10;
	Mon,  3 Jun 2024 18:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440895;
	bh=OqoVdbUH21aB4HjU4RGqIh2C49UUd+uBw1wczrkU3CQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VEM8dCcsQaSiT0ttxlEAI5xRfz6VL/AaJGEWzZsQlZj4Nwqjr7yZ2QePjsas8YaVE
	 pOo7WOHY1Vh37T7ycg/4dvRE06w26jtLwVt9AKukgONp8Pdk7Y5F0HZ2J831W4ALP0
	 zQHaqP1f1+cmDU6yRzLFbjas0kF+wvXYCke6kzREtXO2DSFDNEDWi259IfcgJ5B0P5
	 U3zAbRjmln8bZZUUuZU3r9Elp+D5sj/36vE5LqF5++6AWk2VYsmVGV7fnoZmjsoVjt
	 B9jnQmXV2QVgvA7ncsBzMVEd2xY8N+sJoc774cwhn7S3oNxKeBx1NeiJFcRZSd+hCs
	 C7OkwIJdkq7tA==
Date: Mon, 03 Jun 2024 11:54:55 -0700
Subject: [PATCH 011/111] xfs: create a macro for decoding ftypes in
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039532.1443973.228310183231592802.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3c79e6a87221e063064e3680946a8b4bcd9fe78d

Create the XFS_DIR3_FTYPE_STR macro so that we can report ftype as
strings instead of numbers in tracepoints.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_da_format.h |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 24f9d1461..060e5c96b 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -159,6 +159,17 @@ struct xfs_da3_intnode {
 
 #define XFS_DIR3_FT_MAX			9
 
+#define XFS_DIR3_FTYPE_STR \
+	{ XFS_DIR3_FT_UNKNOWN,	"unknown" }, \
+	{ XFS_DIR3_FT_REG_FILE,	"file" }, \
+	{ XFS_DIR3_FT_DIR,	"directory" }, \
+	{ XFS_DIR3_FT_CHRDEV,	"char" }, \
+	{ XFS_DIR3_FT_BLKDEV,	"block" }, \
+	{ XFS_DIR3_FT_FIFO,	"fifo" }, \
+	{ XFS_DIR3_FT_SOCK,	"sock" }, \
+	{ XFS_DIR3_FT_SYMLINK,	"symlink" }, \
+	{ XFS_DIR3_FT_WHT,	"whiteout" }
+
 /*
  * Byte offset in data block and shortform entry.
  */

