Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB5330F819
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 05:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765346100; cv=none; b=W8L9YN/tuPqY6t3g2wdFbfM+Y1lFh8RUP6hhGZ0JldZZqpOpkO4yne2UT4BwnxKvC5be+FbXfk7KaTFCnd78rqwZleeMK7kQTisgMJP3SyDNHus4DtZs0pQ3qYKH55E4n1TkxydxRtlufRPxz5KL1b/uq6ofgRLTxUBdoujI/Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765346100; c=relaxed/simple;
	bh=7HuJNDrn8GbmApfnGYyeRluRVaaTNmj1qeB0c27KjZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TmdSEUWtRoWDTqDhlbZ/XDZAcVMKgCAbFfuG2Yt5CZN7ce2adG/GwK2u8U39Ld311xshoKSh7dtoS+8jx48aHWILKnN4JiNzjcZIk6J/HRLVJjddLzd4BgtksneJqT20+oFkKSiWDeX2lkO+jkb3QDOdnKOS4PwP3ohcYygXFJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rz0Rqr6t; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rz0Rqr6t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=t7PA+wK1LFohkp2y90E7TU/d64qpL5qirNYYuQVyo/g=; b=rz0Rqr6t+Ek1CUA2XyI9gs4kXv
	syTRhblZ5M9y5HxBNhq6/rSd5cZdR7cS9B6tnhUxSn0ZP9VPxxhSvTXBiMdyy9vczghzN2GaFlCUB
	xp8pEb6+R6IE+ZSGArOVQOWEmaPIUUf3BJ1tAPjPcZDHlncuIkgk53T8uasD7P05w/QTM5MaqN5az
	aHuuBFwaCmp9M1yU6XsFbKXlHytG1a/jciaYlHllU+IjKsrFqueeOUIRhqkut4hnbA2oCB/8no9j/
	HHxv4G3HEwgLEWlfkQdl8Gb48HSOtmmKZsPq00v7HAlZHmcZlv2ANpHEKrcSYs9ExNMY02tslVwEi
	LnNSDnxg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTDAA-0000000F9O8-0TJO;
	Wed, 10 Dec 2025 05:54:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: repair tidyups for metadir handling v3
Date: Wed, 10 Dec 2025 06:54:37 +0100
Message-ID: <20251210055455.3479288-1-hch@lst.de>
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

I recently played with adding another metafile type, and of course
messed up my first attempt.  This series enhances the metadir
repair code a bit based on things I found while debugging that,
and in the last patch changes repair to warn about unexpected
metafile types.

Changes since v2:
 - more gettext!

Changes since v1:
 - add N_() annotations for gettext
 - add a build-time size assert for the inode type names
 - fix a comment typo
