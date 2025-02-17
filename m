Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6BE2153C7
	for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 09:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739784732; cv=none; b=nkslqaTYNr0EIm/4+Yor5TSrQd3zjQmO8Mqvl4VXEneiH54NLU8kGX6KTE7i20Kd8RAdJAcOjBY05bOEYvAiBahkCFRzLCBZzfEeEq4MZ1fTEAU8Kr/UlqaWQO+EQm3Hen+wf5PDqgnwID5ExjdcpUwVCmvustoTFJtwvEieQAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739784732; c=relaxed/simple;
	bh=4ak9lKpWU3R4Sj3CZXCBfojkbLc0eZGX8u+NhQS+xlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cnEbayEQRArhHX+PI+HE78a1JS/uUW8ytoXZJLAyaHpUsVo8dzLsYjYeFFi4fbF90qtcmVmdkEAANcyxBQxU4kG+Ww50KpZObWank1qp/kOnnq1cYt4tguK75fGPCO8RzrV58+Wq2CAGUrakT/ng2myDFi9+g4w9bPVwF1f/osw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1Vob/mry; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1Vob/mry"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=VHN2XCxALhDyUsF2edjV6hQZnk8BfxU5fiCyKvqH4SI=; b=1Vob/mry/cNkRAGtl3tqvpTGRe
	MqVv3sD0B9/4Dx65DvYp1f1kVBbYVTF/4RYia7c4LCQXacqIWxdFbUjR6Gl29P6oLY+YFF+jro3Hb
	DWF5xZLwjZelA7L9WU0/PlEg/wJK7EdL40uOM5qCAx5rmGrGifP0njtV5jfl74Jj817g/RK5d5qDW
	boapdui0jF11013nMOPVJhdo1a05d3RLPdXPYSstRweggOJbGAizHh/Hpy35DZynzSzsK1rHlK+Zk
	pZTG65LxaxK3sfsObQ/DBZz61FecvYSH0GOptta+yr3YmPz4olRQYl2daVeSEAEvgpwpytpkok5qw
	l9wU7iMA==;
Received: from 2a02-8389-2341-5b80-a8df-74d2-0b85-4db2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:a8df:74d2:b85:4db2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tjxU2-00000003wGA-0EJ0;
	Mon, 17 Feb 2025 09:32:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: buffer cache simplifications
Date: Mon, 17 Feb 2025 10:31:25 +0100
Message-ID: <20250217093207.3769550-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series reduces some superlfous work done in the buffer cache.  Most
notable an extra workqueue context switch for synchronous I/O, and
tracking of in-flight I/O for buffers where that is not needed.

Diffstat:
 xfs_buf.c         |  181 ++++++++++++++++++------------------------------------
 xfs_buf.h         |    7 --
 xfs_buf_mem.c     |    2 
 xfs_log_recover.c |    2 
 xfs_mount.c       |    7 --
 xfs_rtalloc.c     |    2 
 xfs_trace.h       |    1 
 7 files changed, 70 insertions(+), 132 deletions(-)
