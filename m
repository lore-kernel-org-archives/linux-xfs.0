Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF515EEDE
	for <linux-xfs@vger.kernel.org>; Wed, 23 Jul 2025 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753273217; cv=none; b=hKA5mgyYXj87fhmFS8Nmuqtwfr3yvyDwt1HAISv2BN3JIOVoigqUjzHCEg1L3ohNlYo38pCLRnfF8TZ3vUZe1T/0z41kvDoxvBQyBd+or6Evvax5OrfhkyPkOk7Wnu8shf0WiDBXTu1tn5/+UXs07/+Ul4/rW29g2lwlIBlLuu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753273217; c=relaxed/simple;
	bh=QdAKrIoCPsxJ8DMHDVO+if5eFfR/vpDpn7kS+BYLiLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vo6/IsoFmD+XDbOoW5CsQ3u41wTCAZLT4nUfRAMHcBDrvYSIQZFq3DdhVcjeo2Uu44DB4WykyVyID3fxyOtwvQ6f1CbnxtshYdYrBwiZouCeyUhFH1TXUCNoyOVjUmMdbBkuGLcjESJimGKdNB1rBNiqEvO7XJpJLIfVelW4DfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eD7oXQ8E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eD7oXQ8E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=OhvUUUWY0tCUo1vn/G10TDlt9nD9BzvvwGRsBqtlBXU=; b=eD7oXQ8EjqiiduydACZ+uaDByj
	Oas0TpiyLCGeEjM4MxbyiWn1cGu7f20y+yrD79ZqiPWnL647lEqcGR3/tGgRaiuOcBNNvkl7k7wLE
	+oABM/3qXHnqedrY56LhpR2uV/aWozAayxn7abFsgXfK/vblCPvXxR4cLULB+1S/TU+mO0a4IsKdP
	Hze09Gxy6666+6FnnJg2t5li1O9RhtsFsOmdDcJnYernv4CBY7I09cXdqUq7/I2ssEJMtlmA23ZSs
	aCsCZa+Jmpl0nltplMDHMoQyVI0Zsh30xrwpw7DjxMVUR27snkwYuS+enpoTYC+xJkZz0/cqX1IGD
	vLgUBuvA==;
Received: from [2001:67c:1232:144:a1d2:d12d:cb2d:5181] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ueYSD-00000004tVN-2bj4;
	Wed, 23 Jul 2025 12:20:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: cen zhang <zzzccc427@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: fix XFS_IBULK_* vs XFS_IWALK_* confusion
Date: Wed, 23 Jul 2025 14:19:43 +0200
Message-ID: <20250723122011.3178474-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this fixes a syzcall triggered assert due to the somewhat sloppy split
between the XFS_IBULK and XFS_IWALK flags.  The first is the minimal
fix for the reported problem, and the second one cleans up the
interface to avoid problems like this in the future.

Diffstat:
 xfs_ioctl.c  |    2 +-
 xfs_itable.c |    8 ++------
 xfs_itable.h |   10 ++++------
 3 files changed, 7 insertions(+), 13 deletions(-)
