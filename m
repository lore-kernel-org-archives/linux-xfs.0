Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BA221A04
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 07:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714635240; cv=none; b=VkQKM0SEKoYX5lqmh7/LteegAsil3/WH9uq+u+H//yiYVvUaKpVhLV+3/HWk7Yc61MRkW8HSG9hnCJtPSm1CcJ6XYeHeYoQSsk9mI8hn3iqt9+n2RoMI+OkL5wtN6STm+jgRXeO/JcGnkD8mDjqpW60YFPc5LQ6QGfsV4ziOK1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714635240; c=relaxed/simple;
	bh=0N1dx6KG3a1opKZvp59L+Lkd5wbpvoymJoCad0GmbDg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d1b9Hd80NcRBz4oJdbt5lMGDOipM7QN+q53FHSSR7qz+hwwcNnvQrJAXf0sf7vJjigeAgdW4xVoryAR6rWRGMw8XkDezXIusaXoI+28nubRQWxm90LAzreNCIImDlw5XIefqV4JFCPd3/27g09eBXSiUJLZpup8Du4Ti5w8B+nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=djW30mbI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="djW30mbI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=2LkKpLK44LJfPH2tHczZycX5Uw3i34lA+xrz1GIbf5o=; b=djW30mbIdtV2L4axGjojxvHsP6
	sVRp48tWRd2eHcmur+Q6YJEuMz6oDnUGVJ/3pdiOf9WZ7telpoVEHGrsu1YaCB/X9b9QYC+r+rKKV
	ipOR9WNMVOyBJ08s4FnSC6Fa2q0zGInMLIZNDZIH89bHuoEszBZG/vAxOWX+UwuPQaHU1kzxDzHmd
	Y475G0CqLe74RJJ1jITxi9hcPVDNdG0I/YfLzp9f2KVkf+2+IbhYIAYsjhJOMx0L4/ol9avknEUdo
	Q2Rivp9FWzf3KpubXrtUK18U/J21JVyDe6iYuW4GepUdMJHAxKSssVk4AHKsRk8rm7h8k9AwAOmh+
	mSW+Jj+w==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s2Qx4-0000000Boia-20d6;
	Thu, 02 May 2024 07:33:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: iext handling fixes and cleanup v2
Date: Thu,  2 May 2024 09:33:52 +0200
Message-Id: <20240502073355.1893587-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series fixes two unlikely to hit iext handling bugs in
xfs_reflink_end_cow and then cleanups up the iext count updgrade
handling.

It has been split from a larger series that needs more work.

Changes since v1:
 - rename xfs_iext_count_ensure to xfs_iext_count_extend

Diffstat:
 libxfs/xfs_attr.c       |    5 ----
 libxfs/xfs_bmap.c       |    5 ----
 libxfs/xfs_inode_fork.c |   57 +++++++++++++++++++++---------------------------
 libxfs/xfs_inode_fork.h |    6 +----
 xfs_bmap_item.c         |    4 ---
 xfs_bmap_util.c         |   23 ++++---------------
 xfs_dquot.c             |    5 ----
 xfs_iomap.c             |    9 +------
 xfs_reflink.c           |   23 +++++--------------
 xfs_rtalloc.c           |    5 ----
 10 files changed, 45 insertions(+), 97 deletions(-)
