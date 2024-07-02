Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37948D50F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881641; cv=none; b=ba2mL7kzh/ZmyReBD+mStW1K19QJIuZHt8DaNkq2QgIvpv4BKlfkEJB9RlBBo9w1K8WQFN8OfelqgwtzI9LSvYa4ePFONnue8fR7Sa78t8rPSRreFjQwbe8cwPZ2AJI+CA4P7RMymjJ97y1BQr0zIos/nK7sPqeK+I33NgtA0RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881641; c=relaxed/simple;
	bh=Xt9/MDLb/ODLkAhoKWy3KEAz+FLpPn9xyp9Ae1tccc4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DORIQzl5EFiJflJf80VgnSQVv2o7KwkSwY4QzebZ6ppkN6JKEy+OTu2ftgNaUNpWqrcMdVFkv56kKyeMu0686TVw7hZOHNgHukAMEuESzk0z8ZayUyHShLkfBJCU0i24sQI5/cJT9NN2vqz1PEDBWsLYNokUDET/z8cRcdUcREI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cExTIcCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cExTIcCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2636C116B1;
	Tue,  2 Jul 2024 00:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881640;
	bh=Xt9/MDLb/ODLkAhoKWy3KEAz+FLpPn9xyp9Ae1tccc4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cExTIcCi4FIVjjHETYz+am2w/+DtFHyUXWSAIuCL5RZxiyxDidusvycHApbNElO3u
	 uUFNIVyUkfQrLalzjzrn8dOx0QBUTtr/hykhvumW2tZGB02TeuKce+39eMBAo+81NZ
	 dSXMscziGciM6QnNrCZRmvRp63Nz9cB0iCa2MLT9a35IOoDt6EvHOgUEe3pC0S4+D0
	 3TfVu5Blx+XPFAU+kJDy7oIDC0BYEmHqHwu4tahI3bUcm31CXs9MInVEl4L6YueMep
	 vT1GuXjBz3e1/D93Lrm4Mvp7PI5bB0V0ksaXreiy1JNJPv/TeOom3N3EoBjw4cbu/H
	 LdUsx2JJrvqXw==
Date: Mon, 01 Jul 2024 17:54:00 -0700
Subject: [PATCH 02/12] man: document XFS_FSOP_GEOM_FLAGS_EXCHRANGE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988116741.2006519.5093845148682277814.stgit@frogsfrogsfrogs>
In-Reply-To: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
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

Document this new feature flag in the fs geometry ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index f59a6e8a6a20..54fd89390883 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -211,6 +211,9 @@ Filesystem stores reverse mappings of blocks to owners.
 .TP
 .B XFS_FSOP_GEOM_FLAGS_REFLINK
 Filesystem supports sharing blocks between files.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_EXCHRANGE
+Filesystem can exchange file contents atomically via XFS_IOC_EXCHANGE_RANGE.
 .RE
 .SH XFS METADATA HEALTH REPORTING
 .PP

