Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB661F3D3D
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528973; cv=none; b=AV8IGnXZK/L4De1PttDzHuhLFY87XI3Bg30fsoPLL8NP0iAALg8JscFqZhHPz5KK6kGdPQud30jamnhHw312Qpp0hlLAhlt3bdcEGIpUlAqh3zHAJr8HkrNcc/W4ULYFFYbnPA3DG/YyHKRQEqpz+rB4fNzsAs/2xhwWsoEoz+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528973; c=relaxed/simple;
	bh=iuKl/3CjufyNKITfEDm3GAUHkpTx33gzvTcgl4n/drs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JYdBs4rT6lQ1cYNv8TMTk9F3af7b7CcZuyHjyPo0KLbGUz87LivWZmyw91vq2+hyWgw5UKJclQiUOhx8mCeYOYD0k8TVgg/DuGoz37rddvH5alr3eCLm7k6CMSWY/e7R/3G5p/LZorn5H6LUGQfQ1fMAqW5noRmBT8sq8U6O9/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L/XBtLAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/XBtLAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65325C4CED1;
	Fri,  6 Dec 2024 23:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528973;
	bh=iuKl/3CjufyNKITfEDm3GAUHkpTx33gzvTcgl4n/drs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L/XBtLAmHu013DMM/X5rpi0g0yi6P5xVlPp0zu3ek22OXLkxo+jJ8nMFLut8eRJpd
	 la/T/6ewLSJm0o0hEPD7SPkIxPUsx3r9DcasO+Xgzi0qgs2Mgf3FiwE7Ed3l+nb6Jl
	 0V8b3ywm3en+MH1qqNXuAP33oijzYJAp7f8Bksii2mFnxuek/AMFYML7zfMDTqy1N4
	 LwKt3lr4qKHKv9syihDjiL7UfXnixS/CCN56FWccprK+VXlWQ5fj+1CR8DETBzaC+i
	 6LVeH5ij7TTYz7ZbIcJgfYB/rk+X2PupoQrrx33K9EFc/gx4MIETM+lcQIEeRiAEs0
	 qXeffK3qigMpQ==
Date: Fri, 06 Dec 2024 15:49:32 -0800
Subject: [PATCH 38/41] xfs_repair: do not count metadata directory files when
 doing quotacheck
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748816.122992.7674899898311669166.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Previously, we stated that files in the metadata directory tree are not
counted in the dquot information.  Fix the offline quotacheck code in
xfs_repair and xfs_check to reflect this.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/quotacheck.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index d9e08059927f80..11e2d64eb34791 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -217,6 +217,10 @@ quotacheck_adjust(
 		return;
 	}
 
+	/* Metadata directory files aren't counted in quota. */
+	if (xfs_is_metadir_inode(ip))
+		goto out_rele;
+
 	/* Count the file's blocks. */
 	if (XFS_IS_REALTIME_INODE(ip))
 		rtblks = qc_count_rtblocks(ip);
@@ -229,6 +233,7 @@ quotacheck_adjust(
 	if (proj_dquots)
 		qc_adjust(proj_dquots, ip->i_projid, blocks, rtblks);
 
+out_rele:
 	libxfs_irele(ip);
 }
 

