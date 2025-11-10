Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D566D30FF1D
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781024; cv=none; b=XjX3sDnjb660ao5yNrtMZiMRORrvt1QcTKwWJXTmxsC+5oEppv0+wv/sCaCyu78W3UcARo62yaS9dQJwPD1orlfb2776dricYMz2UY+V3knevm22PSg1ZkwKqGTdcEXeftbhFOTy3pUMcljTCrZVDnJrFJF/1YOqsGCVj4sjB5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781024; c=relaxed/simple;
	bh=fAlQEAHZkk6xblQMvxttf2dg84+p5Z+PnuHkv4fbohQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Uiynxk+QUohXVLvBZWfVZjahQv27LKl2/2bj7l0pEtFHOvTUwzdx+rEva6ewnwHb3O9aZg8JKGBeuVoLD/g0l67mSgFrPvqIcz24wwvURyzmFs0AAW+XPn83v16fPY+7YRem6a4jLHCGimfeLf7fS9pf0TAmCoRVY2TVKqpP1K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HfIi6luK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HfIi6luK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WfWuI1Vb0ROKkjVcmfMatWlRZH70OYO2Vhl8AiH8LD0=; b=HfIi6luKarSTwno4dleXt/egyD
	VV4n+NmuiiM30FVtZidWyISkOI2UMnGnvDSW6RZQqHY03/IaoekN7zc8+I6B0znAYjmr9j9CHvfQG
	P0AfCk2DGevecmZJYC/mOk710Zb1QCE27CQ3sNu+0KO5queq7/aVMMqoeZlHRMcXaBam8vhKYTVnv
	krZQYbJLhUYL9MXrtWrQP7ya4N7fnKAulR6NWEsAHJnWMRrnGBve4tUHUUNlHNbOV5eMxoo0SzMtN
	82oHHkJnITzBECbEF9hKmuWiF6UG7Lve9vW6+UClpwC+pteTHZu/W15wkseAaVaFXIdWvktE+24c+
	m+a1EYzQ==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRrv-00000005URp-1PRC;
	Mon, 10 Nov 2025 13:23:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: cleanup quota locking v2
Date: Mon, 10 Nov 2025 14:22:52 +0100
Message-ID: <20251110132335.409466-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series cleans up the xfs quota locking, but splitting the
synchronization of the quota refcount from the protection of the data
in the object, and then leveraging that to push down the content locking
only into the places that need it.

Changes since v1:
 - use min instead of the incorrect max for s_incoredqs
 - add a patch to fix a pre-existing leak identified by the build bot
 - fix a new locking issue identified by the buildbot
 - reorder patches a bit to avoid inconsistent intermediate states
 - add a patch to not retry non-EEXIST errors from radix_tree_insert

Diffstat:
 libxfs/xfs_quota_defs.h   |    4 -
 scrub/quota.c             |    8 --
 scrub/quota_repair.c      |   18 ++---
 scrub/quotacheck.c        |   11 +--
 scrub/quotacheck_repair.c |   21 +-----
 xfs_dquot.c               |  143 +++++++++++++++++-------------------------
 xfs_dquot.h               |   22 ------
 xfs_dquot_item.c          |    6 -
 xfs_qm.c                  |  154 ++++++++++++----------------------------------
 xfs_qm.h                  |    2 
 xfs_qm_bhv.c              |    4 -
 xfs_qm_syscalls.c         |   10 +-
 xfs_quotaops.c            |    2 
 xfs_trace.h               |    6 -
 xfs_trans_dquot.c         |   18 ++---
 15 files changed, 148 insertions(+), 281 deletions(-)
