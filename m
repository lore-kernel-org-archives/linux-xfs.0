Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D8F212FAD
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527801; cv=none; b=AQ0SVjpbxcyHfRktK3shQMZV3ACfWy+c9ZGB8wvAkTzzli0VGOPWy84H2yg86zZSLle+Cms9GPWbbAGC62aLTpDhlLp2JHfHxzk7wZsyNBB2dY9S9UsUWDbQNUEs1uBzxtIO+uaJrLJoMFnqIybnq2MRkSmA23CpaZb2iRO5Jis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527801; c=relaxed/simple;
	bh=r4LRIVltITO21AbPivmzhRo80jBA8npW90ONb+XUkYY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HcJqayrLC5Py7Lq7BvX4zuEL5Z3tW4LX+6ivr18F1dpPyRTf0YI4EIZ6dmAZeXaPjbv5RVADNuKRlysmeFOLfZk5AwWeGtbY5kNeNUuAO+aOqxitD6Hwc4Q+CZ5ScLKSDPYBVOlA4KIjlP9TYT+KcroD19DfDhA/1FnvKgMk1MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHIKCg2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHIKCg2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D338C4CED1;
	Fri,  6 Dec 2024 23:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527801;
	bh=r4LRIVltITO21AbPivmzhRo80jBA8npW90ONb+XUkYY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UHIKCg2LfNcUkreauaIkNrcJmrZjbqJZmOQyjVJ/Gq01IXL9IvAiRVrm43h39ORPP
	 wKYOxg1u72PYAXVDto99TxmcQB4ZIMhv4VLMVYU2JlMf12SW4pQBY6REj/p24mcQ5K
	 56f+OT8sQ9ff9NjoKaW7VxGMA3tQk+6MCMxtjbvH0bJUwZaKHgBOTsS35aVp2vZWHx
	 T2hvOJG9qAzCZidugF5F2BWUhpBgmHxIg28T3VXQ7Zt/utozlv7e9s2iKKyynws7M7
	 iB6Mnh6FH5KMLrIW+yRof+0Pzb9hbXbgXVzkd653gf3ATxyseNGVQhEwSPENGnFrN6
	 5DliOuB3xqarA==
Date: Fri, 06 Dec 2024 15:30:00 -0800
Subject: [PATCH 1/2] man: fix ioctl_xfs_commit_range man page install
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: jpalus@fastmail.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352746316.121646.2193613203383089524.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746299.121646.10555086770297720030.stgit@frogsfrogsfrogs>
References: <173352746299.121646.10555086770297720030.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Jan Palus <jpalus@fastmail.com>

INSTALL_MAN uses first symbol in .SH NAME section for both source and
destination filename hence it needs to match current filename. since
ioctl_xfs_commit_range.2 documents both ioctl_xfs_start_commit as well
as ioctl_xfs_commit_range ensure they are listed in order INSTALL_MAN
expects.

Signed-off-by: Jan Palus <jpalus@fastmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man2/ioctl_xfs_commit_range.2 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/man/man2/ioctl_xfs_commit_range.2 b/man/man2/ioctl_xfs_commit_range.2
index 3244e52c3e0946..4cd074ed00c6f2 100644
--- a/man/man2/ioctl_xfs_commit_range.2
+++ b/man/man2/ioctl_xfs_commit_range.2
@@ -22,8 +22,8 @@
 .\" %%%LICENSE_END
 .TH IOCTL-XFS-COMMIT-RANGE 2  2024-02-18 "XFS"
 .SH NAME
-ioctl_xfs_start_commit \- prepare to exchange the contents of two files
 ioctl_xfs_commit_range \- conditionally exchange the contents of parts of two files
+ioctl_xfs_start_commit \- prepare to exchange the contents of two files
 .SH SYNOPSIS
 .br
 .B #include <sys/ioctl.h>

