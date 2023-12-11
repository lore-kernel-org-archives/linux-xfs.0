Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Or+XcTsi"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BFD98
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Yzt4HVdEamECD5CAzHmdxx1JMRCwlbFZDVQoedV306Y=; b=Or+XcTsiHJcNNozxP+lI/BZB85
	8OghT+++qq5Esy2zocMQmwasa+q2Gbkn6l57pqh+Szj2iZuoYj2FS6KgTXTidS5YHxmy5Audsk3pL
	iEbTLWFXZP55LYtSC9+BJSdDFibWY0mv2Dp7BZcxYzOaikcXS8vf0maH1CLjZE8jLYn35O8+5MZhz
	7J5TpOR2kvsKRPQIkllIPMqaEqWvPSrDCNUf6vUGHMaIQIt+Jgidv/0LuFNYOgc0U5MGemT9x22Q3
	O1UJr6eOZ96w8o947qRXIl/KiREWDXcKEeQGxgatOo0CXW69XsbkaMpJFc77wp89PuTPGjJn+gugG
	JjepFTVg==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjHt-005sp8-17;
	Mon, 11 Dec 2023 16:37:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: improve libxfs device handling
Date: Mon, 11 Dec 2023 17:37:19 +0100
Message-Id: <20231211163742.837427-1-hch@lst.de>
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

this series how libxfs deals with the data, log and rt devices.
A lot of it is just tidying up cruft old code, but it then introduces
a libxfs_dev structure that describes a single device to further
simplify the code.

Diffstat:
 copy/xfs_copy.c     |   19 --
 db/crc.c            |    2 
 db/fuzz.c           |    2 
 db/info.c           |    2 
 db/init.c           |   29 +--
 db/init.h           |    3 
 db/metadump.c       |    4 
 db/output.c         |    2 
 db/sb.c             |   18 +-
 db/write.c          |    2 
 growfs/xfs_growfs.c |   24 +--
 include/libxfs.h    |   87 +++++------
 include/libxlog.h   |    7 
 include/xfs_mount.h |    3 
 libfrog/linux.c     |   39 +----
 libfrog/platform.h  |    6 
 libxfs/init.c       |  398 +++++++++++++++-------------------------------------
 libxfs/libxfs_io.h  |    5 
 libxfs/rdwr.c       |   16 --
 libxfs/topology.c   |   23 +--
 libxfs/topology.h   |    4 
 libxlog/util.c      |   49 +++---
 logprint/logprint.c |   79 ++++------
 mkfs/xfs_mkfs.c     |  249 +++++++++++++-------------------
 repair/globals.h    |    2 
 repair/init.c       |   40 ++---
 repair/phase2.c     |   27 ---
 repair/prefetch.c   |    2 
 repair/protos.h     |    2 
 repair/sb.c         |   18 +-
 repair/xfs_repair.c |   15 -
 31 files changed, 453 insertions(+), 725 deletions(-)
