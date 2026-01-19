Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6433009D2
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 15:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768836724; cv=none; b=PCbDc1y/h37Td3lJZK5nqGg1IZhfrF88Oqts3ccg62DGACvxwcnIcWlTU1iRworzi/iq9vSFl7GEwhQOj3Tfo+usAWkIYeZxKpvSZLAbXFf/Sv1yKbGtzO1j/PHQ3r+JeRgWIBeo/xfDbT23EwEDMGfExi/yd6FPtnp97snX15k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768836724; c=relaxed/simple;
	bh=2ZSWy/6pDXHulqzTSwctZbKjboTz9Suh/FlsMs/C0pI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j7yaV1zlvncREYtQtlQCCF5ez3PhvuWDycbspk70tkLxpp8TyUFbzanCnvXx7zw/zYDk6qC93NxOFhfna0xCr36C5/enaxMeWRRcUlzwSSUI8/M2wMA3d6Xx+NDvPM0Gx6iWsR8YA0EKHV4y7/PBPzdUf+g+/Lwt+FEZ95LNhLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=225pj3J+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="225pj3J+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Zbk5lX/cJAabmFC5vQJb42DBn1eQv6aLLtt4vYQ/gSY=; b=225pj3J+FAoJI6ZSWAWP0ZA8BL
	M4XwB1BmQbXs9QFOMxtczJY5+9srDTujGwpJcr1K2TjzPsqDdhgtDzGkcCAS2tliMJfgS97fMFZJP
	RlyzY4VRGRfTUVGSujCoUQxnmMdpByzakDqdlV2c6HOwznePgYcaJms59cyi+gWm8xOOrts7emwRK
	PDO5H9PL82xerQDobM8zmzLkorlGnTkkNNWtPwSlP1YubkA6PxBhm5xR+E6ftZazTQm/SqJMM4+K0
	vYKGyBmW+/4Abr2aHw+tw2D6+IXPo5GwvAri7MjnGLKIji2IQaGxp7nEt1x65n0R9N3JAbY9zbt0y
	i8V35VYA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhrEW-00000002M2V-0NR1;
	Mon, 19 Jan 2026 15:32:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: buffer cache simplification
Date: Mon, 19 Jan 2026 16:31:34 +0100
Message-ID: <20260119153156.4088290-1-hch@lst.de>
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

this series has a few old patches that simplify the LRU handling, and
moves back to only having a per-buftarg hash now that the buffer hash
is using the scalable rhashtable.  While some of this looks like
performance work, performance and scalability is unchanged even on the
80 core dual socket system I test this on.  Besides cleaning up the
code nice, it also happens to fix a syzcaller reported use after free
during buffer shutdown, which happened incidentally because of how the
tear down of the buftarg vs the perag structures is handled.

Diffstat:
 libxfs/xfs_ag.c |   13 ---
 libxfs/xfs_ag.h |    2 
 xfs_buf.c       |  234 ++++++++++++++++++--------------------------------------
 xfs_buf.h       |   20 ----
 xfs_buf_mem.c   |   11 --
 xfs_trace.h     |   10 +-
 6 files changed, 91 insertions(+), 199 deletions(-)
