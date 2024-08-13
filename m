Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC0F77102
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 07:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534798; cv=none; b=NoITjHl6jruDJ4TIKR+RHYY3nfJjNvAHl4qM8MjcBEAm+FTKkBSjSK6SFeAPEd3nY24BPV/absFesAo9cU142D2BZGS55mhAScDyvB4lYRYw8HtkxmDW3vYegyi+Z0xqjVftjf9r7gI12L08cwuFbKiSoftIqfvniSgoeq6Un7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534798; c=relaxed/simple;
	bh=ZE6temzcEdfCRFvt/z4/TcMxzYLsg3gi78nNeqjitVY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jg3TqER7iJrWD+dH8p3xn2EceUlCAGpSoeCox9eOCKBzkew7PhMPyURe/J0pNNv/xm8T4Q63oBQef1jPJA+LG8gajWLd7wjOXDMdx364VcsQh55SbXufFKFlz/zNLf+WpjkbmEjn7QgpYIb0NbxZyUVhQuoYcLrtLhWX3SJOkeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TunVEMDh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TunVEMDh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=wNLVWyWDnp2q4IUApViQt9+jK7HOOYFJ0pZDAX7DLqU=; b=TunVEMDh9Wt+ncupa1kx9f2GWu
	YTGWawUJx5/AJgnVW6oVB1Ik2cf4EnsOMKejRAP94DhQtq/qmqcl7ryxKuetqv9KdO+kXz88hAcUC
	MXhRXCRYIKlXvEuWmfFH/+wWoie+oBqS3LM3zZRqWB6QUtlQne/99bqM0q2lE45XkEVBoC+qgSNiI
	ZKDUNp9zA/31ueELxp0Vao+/m74WTQ8iCOFwxoix1c5a57ZXfXeolRmooXCXV8ea7SScoeBJVitzu
	ZxDomShBOIOENabkjQ3eQesl1hDV8eWHSW/1l8AQ60zNQammcZqGphPgTBmjcXNBEaM18QBcU5Hfa
	aIZQg9OA==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm8J-00000002l7d-1UkT;
	Tue, 13 Aug 2024 07:39:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: post-EOF block handling revamp v3
Date: Tue, 13 Aug 2024 09:39:33 +0200
Message-ID: <20240813073952.81360-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series reworks handling of post-EOF blocks, primarily in ->release.
This takes over the work originally started by Dave in:

    https://marc.info/?l=linux-xfs&m=154951612101291&w=2
 
and lingering in Darricks's tree:

    https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=reduce-eofblocks-gc-on-close

for years to ensure ->release doesn't too eagerly kill post-EOF block
speculative preallocation and then goes on to not let preallocation
on inodes with the append only flag set linger forever.
 
Note that this does not include any of the suggested improvements for
i_flags_lock contention - that's left for a follow-on series.

Changes since v2:
 - fix another typo
 - use test and set semantics for XFS_EOFBLOCKS_RELEASED

Changes since v1:
 - fix a few commit log and comment typos

Diffstat:
 xfs_bmap_util.c |   34 ++++++++---------------
 xfs_file.c      |   72 +++++++++++++++++++++++++++++++++++++++++++++++--
 xfs_icache.c    |    2 -
 xfs_inode.c     |   82 --------------------------------------------------------
 xfs_inode.h     |    5 +--
 5 files changed, 84 insertions(+), 111 deletions(-)
