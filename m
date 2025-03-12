Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275DB1BDCF;
	Wed, 12 Mar 2025 06:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761946; cv=none; b=jp0tnWieoeBq2hR6Cn3X6/qZ3dxf15/k6yq/+PWWJv3/kuK0y70vNrssTb7bk3X4qPAbbU5m9aW6ZHrH2Qj9xEEse7rVq35oml+TpInqKAxuXGh4IuCTP2dQc3wOgjIkygBGKQYSO2dnn76tJ9AVyDjc3uf9fh71i0/+oBYkbjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761946; c=relaxed/simple;
	bh=ktZZpWGID8+5iu7+Kvr4T2J/182CjhXNzYHW8i1TnBw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=royoXl77WIrnK76L19pdlFZOYgp9NzcnSapB3+YwZuYGjlgPUrDKri6Fd1BmXKIRjk+FEvNCXUApvNCsXjyFtOQjwljGw6J6cdLJJt97VvDfgWloPrSiqwDWgpiACrP1oRy+xsFJSRdEyfJU5FO0ZyvKUz9kMmQsyzx8kn5kT6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oY4Z8cos; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oY4Z8cos"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7czvv/uLwtwno3fKxFZjajVUdv80MOAEIAgUKd5k8pU=; b=oY4Z8cosUXhBdzXukBEX864B3z
	bHyZsbql2EKzeIzrAeokLkgEnkohw2+hFElZYIW42RvASoP0gOcV3UxoK+1eHQaU1Yk6sPUEVn0tv
	xl1Y+8eVTDS6kH6nu7WylYmoaR9ylt4E3bAf941wXUYXBOGNswcbmoZuulOvsTP+BE81MLzD/x86x
	XAASSngEaToH/I+5okBGLB8Xgu2vMOrfHtglzC7isUd+TFzegKJjIdVcX1ccGjMzSgNKCHg5On5T7
	JzPgCLKdGJIput/BWuvTwxw6nfrw5sg3Y+TpLcndZG++wiepw6wPC97xKTHVnmA0N7joDc17fAY1R
	rj9QUrbg==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFqa-00000007cit-18Qd;
	Wed, 12 Mar 2025 06:45:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: initial xfstests support for zoned XFS
Date: Wed, 12 Mar 2025 07:44:52 +0100
Message-ID: <20250312064541.664334-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series adds initial support for the zoned XFS code merge into
the xfs tree to xfstests.  It does not include several newly developed
test cases which will be sent separately.

