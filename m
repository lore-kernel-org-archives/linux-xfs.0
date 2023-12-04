Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xp0ZdHR0"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA0CCE
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 12:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=9FDJMA2KnZI9IyEwBJFEN9tXWgo46RF7e3uxGjgE/PU=; b=Xp0ZdHR0z1K80GokxS5ai2BU4l
	HVq5Q6rkroNbthGPK57gYba77lteNTuKosUTN9Dbgy0QEv7Ue8VKtIJUtikrTudGe1KQHwXOdPZm7
	zDhnMtURcggiE8X/X0YYJuiFvS9lxNDncyfR6elxh5y7LSmDTkcdKLwjhDGSUMjphIw+nLHQlYCO9
	e08e9/j6eq+omXOi3I36ocRt2K/Caq+FwZaVpQaIyw8+Kqa0FKWP7eeFFjUwbvDI7nuv1WhlIle1z
	Xxv+N9yqEuo/NOE+B5Pe/y45wu1vvvbJJIJQoqqctnmJGCk1bIL5sx0FtaLksqBHxiGdgQgkkMGur
	8wq2zvnw==;
Received: from [2001:4bb8:191:e7ca:e426:5a32:22a9:9ec0] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rAFDv-005W8z-1Y;
	Mon, 04 Dec 2023 20:07:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: share xfs_ondisk.h with userspace
Date: Mon,  4 Dec 2023 21:07:17 +0100
Message-Id: <20231204200719.15139-1-hch@lst.de>
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

this series switches xfs_ondisk.h to use static_assert instead of the
kernel-specific BUILD_BUG_ON_MSG and then moves it to libxfs so that
userspace can share the same struct sanity checks.

Diffstat:
 xfs_ondisk.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
