Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6213A20371B;
	Fri, 14 Mar 2025 17:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741974890; cv=none; b=sLvrXto76qKFbxP0Eg2aVmBLxC3MK3M3YVPBn76TtDFGf7bERb2j/6ypHtn2lCG+W5xFHviy9HIs6nEY1quHlGz4Cr1ubDfeIaZ2ezesHPcnDS+lHduVaLsYShJRWQdlBCX0x2W9JdTi9p51itih4xy4L9LUIv4M8iipLuQzJwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741974890; c=relaxed/simple;
	bh=eMn5uhKQRhhROLSyUc/9TF6dv1QMKVKhjXWXlk6v+gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GY3xoY2S53MlkxL942BD3Vs3cGozegBSyWdAMNpqREDyccTlNJ1/4Q4VbwMtoU9a5wXxhqMVViRfNiTRA2KqearzEi6Rymqu5rgG9u02oNmpNhwXOScuOp5P1DS3uPT9v28nBLXBnut6/AsTlpHqmUFxOX7ViJjpNL/zNb7P/2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h06Kk1D6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h06Kk1D6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7644C4CEE3;
	Fri, 14 Mar 2025 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741974889;
	bh=eMn5uhKQRhhROLSyUc/9TF6dv1QMKVKhjXWXlk6v+gc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h06Kk1D6uk97VJMMWcGqSPk4mdEJRqkoTQGNIvZKzedxEbnGGtWHPdVFdQgiZt+g5
	 Y4mga7mc6BE2sNWnSrokC7GWucdgQkNR6+Kt5/6jaC1tWxUDn50JRS5gKTNMfTOeOf
	 M93IwKXLihG+w87PBSXoayrT/gi1/AM+Aw/s89HxkfR5Pm4Zi9Hxzz7rrlGmro8sLA
	 hq91VaB2YvRVMA146FIhaDFLNwT41zhZvMksUY+mvobJ9YqcUVkns1Ta0jRJy6JnKR
	 HJD2y8M+rAGklsdGzm0tar2i2d+jaTvtjzVg6J+lHBVMT3JO1jSY9nwAeGVAoraNaP
	 csl7jYKye/+rg==
Date: Fri, 14 Mar 2025 10:54:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 4/3] common/populate: drop fallocate mode 0 requirement
Message-ID: <20250314175449.GL2803740@frogsfrogsfrogs>
References: <20250312230736.GS2803749@frogsfrogsfrogs>
 <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

None of the _scratch_$FSTYP_populate functions use fallocate mode 0 (aka
preallocation) to run, so drop the _require check.  This enables xfs/349
and friends to work on always-cow xfs filesystems.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/populate |    1 -
 1 file changed, 1 deletion(-)

diff --git a/common/populate b/common/populate
index a1be26d5b24adf..7352f598a0c700 100644
--- a/common/populate
+++ b/common/populate
@@ -8,7 +8,6 @@
 . ./common/quota
 
 _require_populate_commands() {
-	_require_xfs_io_command "falloc"
 	_require_xfs_io_command "fpunch"
 	_require_test_program "punch-alternating"
 	_require_test_program "popdir.pl"
