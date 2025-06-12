Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41821C7008;
	Thu, 12 Jun 2025 17:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749750673; cv=none; b=g6+Su+7kP5pnYUNHJgBncDz5crmr8y+CpF1Lp69MCqJd8iMo8fAEvwhY4O+82Se6Cm6XN8940+vhiS0KkUvBH+4kwEs4VeABHS4cEpazRAkfeoCWP7WQaIQZKoXruc3Ts/wk/SxejZzTCNKWZN14uZzis6n2eClUZWr+BgLKsPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749750673; c=relaxed/simple;
	bh=V3c1unqnqI8l18bwVX76Lsao0IpH1o6MVwYWj1BtwiU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AYu7nN4qOj3uEx+TsLLtd8EDcArBuLIQhkXNNVp5yQIV6nt2/zvl4GTQG6nBl9egG36hYjpe274qP1RRAAwjyYaHh7c7jJSfHTKRvEgRYzBrJkm5VKdX+WrcjsP9TtF2kAsItk66AIiKG+wkYXOchXQvY8NVcQmoueB3cW4fhmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MbGa5kpo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MbGa5kpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93033C4CEEA;
	Thu, 12 Jun 2025 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749750672;
	bh=V3c1unqnqI8l18bwVX76Lsao0IpH1o6MVwYWj1BtwiU=;
	h=Date:From:To:Cc:Subject:From;
	b=MbGa5kpozpFS1YyptmKJJJllOKt1yufHXAeAFBmdJy1ognUfFaAmUMIutG/5ACkn2
	 jepm4id1RutGfoD1e0ey8gWFGxt5T271mCTy4tt2zEGThgyTbc3qAA7W0dF8vzRt53
	 bO72vMDvYkPEduOXCD0tHNDJ0fR2ejZgB7HOokb2M6b0gpv7A64U/obqIxBfcIgNnL
	 koHbHzEWvGKWi+fD1nmOmT2xYPLMNY7pPoVKLVhstLgylnClHH2epdr+K16FHWuL4A
	 DcJwgHEg9EoQ5CGKJ4e/Rad2mEW+YwYbpaaDnvNSZvyQIotqbgCPNdfjiZrrFSuhuX
	 bNPMciUwcqolw==
Date: Thu, 12 Jun 2025 10:51:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: actually use the xfs_growfs_check_rtgeom tracepoint
Message-ID: <20250612175111.GP6156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

We created a new tracepoint but forgot to put it in.  Fix that.

Cc: rostedt@goodmis.org
Cc: <stable@vger.kernel.org> # v6.14
Fixes: 59a57acbce282d ("xfs: check that the rtrmapbt maxlevels doesn't increase when growing fs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6484c596eceaf2..736eb0924573d3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1259,6 +1259,8 @@ xfs_growfs_check_rtgeom(
 
 	kfree(nmp);
 
+	trace_xfs_growfs_check_rtgeom(mp, min_logfsbs);
+
 	if (min_logfsbs > mp->m_sb.sb_logblocks)
 		return -EINVAL;
 
