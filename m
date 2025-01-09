Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32825259495
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 00:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736384043; cv=none; b=amJXqLJ7/SsOlxDQiJ6p17nBxIMVhikN43V/hGn+Tz2cPXsrvia20B/r2p97qVMAmt6DSg8a/PEdSsRzXLgDbB7DfSkDFL5dG6jDuiMKWbHwQVw9E4kyPqLwtaJae8Wm0hACKWA9bpgI32rJ3TlLV8WMRgd6JotjiAgTtH9siV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736384043; c=relaxed/simple;
	bh=cAUQ5HvYwNq6J9IAD1C45TKfB1W/JwNpEKZlcdYxg7A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cKIXzNl+8g5ttxIRSz4M6qhW/srlRH5MVUVLHbhTegy80jEKYu7q9Uf8OV+7WDwrvIf6veyF6hcbW3mmv0cu459+pF0e9wwFWqqmNWwywgctX23XaUI64nerKRGCGKPyIUfFUnq52mkLfxiKLwHd8NCNuxl4bIlNi/MZe3aHdeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aaj5go9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aaj5go9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A911DC4CED3;
	Thu,  9 Jan 2025 00:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736384042;
	bh=cAUQ5HvYwNq6J9IAD1C45TKfB1W/JwNpEKZlcdYxg7A=;
	h=Date:From:To:Cc:Subject:From;
	b=aaj5go9sM9TYC7b49jQ0fQNjm0DTnZt3Igz6M+SZYXuuS0B2DnTvj+FKTAlKY0uyy
	 HZD1oQC4dLr6JQpIliZciDgYRgS2Lm2aLfEc7C2rNEue5pBg+flJA6YnlAVzIXPtcd
	 p66C6dZZ0ENI1MNAkDdMoCTEuV0EfxKuFK40VWNh4/5LnxIhaamv7mx77PiPBdT9Ah
	 0ni2kGZ4cDcJgdMLQm6NLM38C4j7dKJh03RfbTqNIv3rU7ZzAOiF5yQW8sKW09N2Ei
	 Znws9UjfOTjW5XJcnV087ubamZrPIOvYeBaMFjbFZzLMqhlEoCVyksn/yLERECulaL
	 1hJHDMSPYbTPA==
Date: Wed, 8 Jan 2025 16:54:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: lock dquot buffer before detaching dquot from b_li_list
Message-ID: <20250109005402.GH1387004@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

We have to lock the buffer before we can delete the dquot log item from
the buffer's log item list.

Cc: <stable@vger.kernel.org> # v6.13-rc3
Fixes: acc8f8628c3737 ("xfs: attach dquot buffer to dquot log item buffer")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 576b7755b1f1fc..84b69f686ba82e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -87,8 +87,9 @@ xfs_dquot_detach_buf(
 	}
 	spin_unlock(&qlip->qli_lock);
 	if (bp) {
+		xfs_buf_lock(bp);
 		list_del_init(&qlip->qli_item.li_bio_list);
-		xfs_buf_rele(bp);
+		xfs_buf_relse(bp);
 	}
 }
 
