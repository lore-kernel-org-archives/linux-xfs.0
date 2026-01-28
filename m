Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91928C8CE
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 04:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769574808; cv=none; b=GqL+gUSswrHJnamdmEcOY6xlt6KQx/Dip8dpS9VNi5RGniFsaBLqwZMOrSMth3dFqm4vSTaQlZirvQKTpax6U0KSVCBo/o/Em4BgdCSImy5iwdIRgCKqZAmLk83HiHSUpdPwOI11hlL3LioF3wneYZY3nXiEi3wMxJTp778uLG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769574808; c=relaxed/simple;
	bh=CtcYMpCIEgo4q1rWHcez0dqMkLYHGWe2A3pL+hLcF1w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GQd47ApycEWffu2skdgD774vqqifRGhHRg5Oh9LvNu4NuZPdlYE9wLcNDeSQ7v8uM7cNJKb9S8geQUGwWVCPAUNmLM6xNzcm2drozpHJkJfALZzbD0feMQPvDDklvtdIgacjHpbGoUDhcZ8RFSa0zdjBWTbFnb+9DX4g6eNtybc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ka/+pP2T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ka/+pP2T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=BXr7VM0AdRqSDWxSo7OLOLgfQ2WdUnRXocaSW9sVbIo=; b=ka/+pP2TiBpuoameG1Ze865/Ru
	fSI6nJSqp1JYBHiFk70BsFUisB5Net+zT4i/y8hUmH75gClZ4ItmK9lkULQ28AdCcnrjMbL1OdSRg
	PEhoege6vw4SDthDIvl9h8DcJ6LnspWSf67e/njlC6b7WdbGJaKNMF+ULgmbcbeXcMgn69veGOryZ
	wnNUiLwP/TsyFvBxoIqhR1K7QobYOWdrsny4a/PeVgSujiHiXG+noc+GPK0qVDwMiPOH9VRavNHfU
	ITQVZAt+yd5786egh5SdkmBvroVNqO0GFfoH1/F59JXol16ICpeeL3MXVEAhggS65MtSQEXz/y8f4
	9lyt0VuA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkxF4-0000000FQab-2SjI;
	Wed, 28 Jan 2026 04:33:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: enable cached zone report v5
Date: Wed, 28 Jan 2026 05:32:54 +0100
Message-ID: <20260128043318.522432-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Enable cached zone report to speed up mkfs and repair on a zoned block
device (e.g. an SMR disk). Cached zone report support was introduced in
the kernel with version 6.19-rc1.

Note: I've taken this series over from Damien as he's busy and it need
it as a base for further work.

Changes from v4:
 - include blkzoned.h from platform_defs.h and add the missing bits
   there to avoid problems with newer kernel headers

Changes from v3:
 - reorder includes to not need the forward declaration in xfs_zones.h
 - use the libfrog/ for #include statements
 - fix the include guard in libfrog/zones.h
 - fix up i18n string mess
 - hide the new ioctl definition in libfrog/zones.c
 - don't add userspace includes to libxfs/xfs_zones.h
 - reuse the buffer for multiple report zone calls

Changes from v2:
 - Complete rework of the series to make the zone reporting code common
   in libfrog
 - Added patch 1 and 2 as small cleanups/improvements.

Changes from v1:
 - Fix erroneous handling of ioctl(BLKREPORTZONEV2) error to correctly
   fallback to the regular ioctl(BLKREPORTZONE) if the kernel does not
   support BLKREPORTZONEV2.


