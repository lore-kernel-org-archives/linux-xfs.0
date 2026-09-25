Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218114D0CCE
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349533; cv=none; b=mjm0/NVx0egpLWxFBj5CMtjfa5BdNSszgCIZF+PXuuq65UFL5NbFT4bAhWxC3HAYR3k/4ie5NNT4Fuizomz5pQ17Lj8I9zaHkR8wcoUDW3GplAtP/I+M8WSpUssvpAmMtRjG/hqhh+39vSuZivn6KqucZyOsDw+zmxXqktr9Pq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349533; c=relaxed/simple;
	bh=n0QBlzpWUMEgUibHhwQVGT+ZXOtD7/poNr2gJTrvFI0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kl5I2NbkrgEv8+eN53ku2RhsHQtzJUJWdvxDUx0SYJ6hv+ktg8x//6LLw1p0mwB9n0TnZBNg/Lxl8+9TRHq0IXicidEXsZlXhx7gChULTFpHKBmcM92ZYVQLnIvoDJa8e6D1mx1tONtenztMxD47G8cddUPExuKrPezBXw+xmaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=llrNJOu6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="llrNJOu6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=RquNs7gj2z7f6mHrS4vCj58+l4Ig4pE89lL1m33Di3g=; b=llrNJOu61uM59N04eYITTnOfdp
	18zL4/V73uFAhKQ8Gtgm1cWwQ4xjmX6U+KEKFxaAiRzxJ4kjyUdZrj+xmtQeZGx99tfklJsBC71cc
	F9MjwjBI/3vtcTLR9qYCzqOF5mLdfYypK26G0XStkNWGwsQ8aOFNey/9DYPrVF6ql7IILHglYXHL2
	4F2coIQlil50JrEec1q34qhHoP/9y5b5eo8zB5b7x7fS3avni/H/UnuvgMAD6gwBlDZDjBFEpWliG
	qhEagqBcMMH8wXBr/AEqJEfvM6Zmlwu0tBE0ixQM3TTGlZu1E7+/Hmzi08su1QqqNPFiO8VLKu2CC
	nIW+oN9g==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7hE-0000000DlDT-1Pyh;
	Fri, 25 Sep 2026 15:18:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: small cleanups to help code sharing with xfsprogs
Date: Fri, 25 Sep 2026 17:18:25 +0200
Message-ID: <20260925151841.3385994-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series has a few trivial cleanups and code moves that help
sharing more code with xfsprogs.

Diffstat:
 libxfs/xfs_attr_item.h     |    2 --
 libxfs/xfs_bmap_item.h     |    2 --
 libxfs/xfs_buf_item.h      |    2 --
 libxfs/xfs_defer.c         |    1 -
 libxfs/xfs_exchmaps_item.h |    2 --
 libxfs/xfs_extfree_item.h  |    2 --
 libxfs/xfs_inode_buf.c     |    3 ---
 libxfs/xfs_inode_item.h    |    2 --
 libxfs/xfs_inode_util.c    |    1 -
 libxfs/xfs_refcount.c      |    1 -
 libxfs/xfs_refcount_item.h |    2 --
 libxfs/xfs_rmap_item.h     |    2 --
 libxfs/xfs_rtbitmap.c      |    1 -
 libxfs/xfs_rtgroup.c       |    1 -
 libxfs/xfs_sb.c            |    1 -
 libxfs/xfs_trans.h         |    2 --
 libxfs/xfs_trans_inode.c   |    2 --
 xfs_platform.h             |    1 +
 18 files changed, 1 insertion(+), 29 deletions(-)
