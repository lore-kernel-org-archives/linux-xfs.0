Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b4kWb51G"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB39E5
	for <linux-xfs@vger.kernel.org>; Sun, 26 Nov 2023 05:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=VIP9BDaIKqm4f+tccjbMAJQEKtUSoBQGG41ja8mfEUg=; b=b4kWb51GzzFRed7gDqWwNF3+8M
	Tm0zahcOUNAfde3fsEE0pJNVHjG/TWCI6D3RYHyr+LEHGuyVLnVha5woW0zGBsovTo5zOcy80UJqK
	38DIE8WqM+F/FURkQU57adaFUIcLbw8jE/DOOERxm9I09bilYjItQfzcksOywv/xCqiJHuhv+Nkx9
	io3MNcemU0VrDuY82mubsxdAGWc40wvSUWGi9oErOOiIoo41kD+QVQfiEql2za+WX7KJ1iS26DH/T
	ym8UAJv+7XrW33DNh71/N8ecHapL8g3P+mrmYgUYLW9FT02nJXHAIol9vYvvTBUDKLhYLyOieH8Gl
	ItbUqywQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r7ElK-00BGgI-1q;
	Sun, 26 Nov 2023 13:01:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: misc cleanups to the resblks interfaces
Date: Sun, 26 Nov 2023 14:01:20 +0100
Message-Id: <20231126130124.1251467-1-hch@lst.de>
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

this series has small cosmetics to the get/set reslks and fscounts
interface.

Diffstat:
 xfs_fsops.c |   50 +-------------------------
 xfs_fsops.h |   14 +++----
 xfs_ioctl.c |  115 ++++++++++++++++++++++++++++++++----------------------------
 xfs_mount.c |    8 +---
 xfs_super.c |    6 +--
 5 files changed, 75 insertions(+), 118 deletions(-)
