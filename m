Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0207275864;
	Fri, 14 Nov 2025 05:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763099578; cv=none; b=ml0SVG3ODqgZTCW/CpVNLdV/eE0Z8u+zZmiDjO8jlwnJh8CCtkOCL9D6fG1/xJm5bYVK8q/YCpU5wrE226BgXsxbcfYdwDgps9yRrekfjW8LNMKYEV8TbC8IlwTCjy4eI76XbZW81auuwYFv4w1f92gfdk81BfHhmWJAgdQq/xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763099578; c=relaxed/simple;
	bh=0LkBK2Xvnt2ZuZ/2D/xuME3Qx9teLzVBPhVnFYQ2fyk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ii/p+muzkxduN8Hrd+ngy/mrD5pj5gAro1h1GN/Y+BOUra488fLsrzOOOP54ZNTpAtQmAW8CylB0+yI8aQrrVo6Ub5IfAahzmWNE8JjgmIoYUCDlBsqmJplrvti9C89e2XOxIgB8ZccYcUV3v+4mn7NVGlBIm0ghGHFOLiR/ays=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q/7VIjHK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q/7VIjHK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=CL39ZOuMW3CgdvA0XIMB8sUuMWXDAcy6tVxpDRMlLoQ=; b=q/7VIjHK38Rd5IXW7qNcwE0r0I
	V1uc7UUnrBjIUvc8/E2lOY+HWFncbKVzHCyWdBfh53qcbFVpc6sFBBxh29IPOS2w6OQ49zfDASyh3
	YhU0I6XHTkkeTJU/DLpEfUwQSoZOQfMa3pZZ0A3WvxcL4EKz0fudkPqtRGFiIsg/B9NpmQGT15aG8
	LCSWQreAZwpSx2JIaj5B1VI3KY34Hqi0UVfNALRXnn6dxEp7Zci7kgH4lkCx5x6NGa2QTt5yhFSpa
	2V9+lRMrSgf4PiXnBCn785BunuSL7C78YuAeaoWj1Om65+CwByaElfoFndLx8NJy2Vh+tHmQxOSVZ
	13u2SIHw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJmju-0000000Bc1t-1CsY;
	Fri, 14 Nov 2025 05:52:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Luc Van Oostenryck" <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	linux-sparse@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: make xfs sparse-warning free
Date: Fri, 14 Nov 2025 06:52:22 +0100
Message-ID: <20251114055249.1517520-1-hch@lst.de>
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

this series isn't really a series, but a collection of two very different
patches toward the result of having no sparse warnings for fs/xfs/.

Patch 1 adds a cond_lock annotation to the lockref code.  This also fixes
warnings (but resurfaces new ones) in erofs and gfs2.

Patch 2 moves some XFS code around to help the lock context tracking. 
I actually think this improves the code, so I think this should go into
the XFS tree.

Patch 3 duplicates some XFS code to work around the lock context tracking,
but I think it is pretty silly.  Maybe it's a good example to help improve
this code in sparse?  It would not be horrible to apply given how little
code it duplicates, but a fix in sparse would be much nicer.

The kernel MAINTAINERS still list Luc as sparse maintainer, but sparse
itself lists Chris again.  Do we need to update the kernel MAINTAINERS
file, or are those separate roles?
