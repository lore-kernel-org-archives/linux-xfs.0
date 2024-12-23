Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2398B13FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992016; cv=none; b=UBRNHSvU6BzA1vIh/kz8GVDstM5XMlELLCY5VZKf80ZMtlZQAee+yRJiGRT3R0Zjl6OORlUk3kDdftQquKpfyrTCE8y0ONhGIng8KhJTP9EnFVup2oFcuQGuR9KstLQX1XL3GrIfqDshkprZevSivyweXwJEPKvo8XPPzZ7F+/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992016; c=relaxed/simple;
	bh=faYR7M7Xkr7kwRHvK5D8V1oe6/skkTmgh9FKgsTRgZY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qjsTvUXuOjBvwmU1VBEAkzbsSED/3QFNglV/hxq9UrfLt3mPOAav5de7PW9a8pMS7F6AWtXc5gkkNZfzLfqBSsx1NesvAcwyavTdyQ7m6ry6+jIbUuoabBeF4uQrZu9fynDm7wGREBJHVuuLuYqSeZjl96El3ognGQaa8VXiCSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IGPKb3VH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IGPKb3VH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E20C4CED3;
	Mon, 23 Dec 2024 22:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992016;
	bh=faYR7M7Xkr7kwRHvK5D8V1oe6/skkTmgh9FKgsTRgZY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IGPKb3VHQKMEQz/S5lYsd8QpjSbNECFUeu1G7g5z08Nf9LVFcR/j6YNbda8/a9uwf
	 sHWhnwt4qU94rwXIHz6LhdLdiBUadClkOe7QkhiaxDEeRtkkoxnmRnyvqTK4qHpdj8
	 KXRORkrRjhDl/OQ5lIk3N/wPPfe/I0tNXwlZJbE0hqMHXy2g1he0Bi8AlGBxnE01yV
	 yGznbwLSSNeItz94+L8YtVRZEiy0vHSLeWMBMUNCNosErLEzrXqh1ljBSRg1CLN3YD
	 UkSpb+AMl6ez/82W4noxhSJtECaXoY2YmNdXMxPN54zqnmlYxk34Pkqe+D0nbYY7rL
	 58T6HS0fL36dw==
Date: Mon, 23 Dec 2024 14:13:35 -0800
Subject: [PATCH 07/51] man: document rgextents geom field
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943910.2297565.13089929670979744869.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Document the new rgextent geom field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man2/ioctl_xfs_fsgeometry.2 |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index c808ad5b8b9190..502054f391e9b5 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -49,7 +49,8 @@ .SH DESCRIPTION
 
 	__u32         sick;
 	__u32         checked;
-	__u64         reserved[17];
+	__u64         rgextents;
+	__u64         reserved[16];
 };
 .fi
 .in
@@ -139,6 +140,9 @@ .SH DESCRIPTION
 .B XFS METADATA HEALTH REPORTING
 for more details.
 .PP
+.I rgextents
+Is the number of RT extents in each rtgroup.
+.PP
 .I reserved
 is set to zero.
 .SH FILESYSTEM FEATURE FLAGS

