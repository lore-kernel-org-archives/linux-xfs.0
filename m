Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1445B5BA;
	Fri, 12 Jan 2024 05:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Co5Bh6O4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=/97IITkX1uge/xBJYpyWdpHrfNqs9qvFvvBlkk59PfU=; b=Co5Bh6O4DitNSYN6NxusnBuqu/
	kItc4zX7oxHlARMRs0t7M51SPGQcoaVtObvDLclx2Hs3d0zUGjn8Mzo3vzwklqXWR+RZlWqcl1ZjG
	U69gm0AZ1qATPFNsgUEaXDEadFqN5gprIvpH04D24ltzPCL3skQ03gFkHnQ2a+6I5KQiN2Yg0C//Z
	EMAPghlt3yDK4VpfTeS2w4OC5756ylQGsAYA0zhIv/+UiePkhdFfc+7Zio+XnyJN619CUendtMG7I
	KHLq/xYqIKCq6sQNkQNT82wnN7GclfSJKpNUhLRIah14UfUi3o/F+CrQ/6QfFCYW9GJ9X8YEVi4CN
	3Ys7d6CQ==;
Received: from [2001:4bb8:191:2f6b:85c6:d242:5819:3c29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rO9mV-001uja-2T;
	Fri, 12 Jan 2024 05:08:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@redhat.com
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: _supports_xfs_scrub cleanups v2
Date: Fri, 12 Jan 2024 06:08:29 +0100
Message-Id: <20240112050833.2255899-1-hch@lst.de>
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

this series adds a missing scrub support fix to xfs/262 and cleans
up a few bits around this.

Changes since v1: 
 - use _fail
 - also annotate xfs/506
