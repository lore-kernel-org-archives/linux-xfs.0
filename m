Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423EB3ADBA2;
	Mon, 31 Aug 2026 06:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158427; cv=none; b=Hc6bwD6JZ7IWN7lJn3WzfSDQMlyw4flwy1mmYCSIPcuq3FMr7Abr4SyAxCSIpnKPUMLAb89sEoMEMX0vKzVb/GT+/MkltmxapCvDvKb7JhIivVeeQH/kpYl7sa78Yunq2OKVjL/l4fy26qX7lV9QsjBG9QNFERlSUavhTlMMlIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158427; c=relaxed/simple;
	bh=khvyDwrxmguwUdvH8t87d3fMdkvfcS84MF3e9wxpffo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pjxoL0c3csiL8UlmcmPd3uV7jymIBKmatcwlBEyovJZctPxDghWBJv5aojIrNmxlFIOhlno+cxBU61wbWlUyt4rQcLk4nQ0WxXb1g0tO9kqgOlr0JRkCFd829ZExVpzwNGTpGnMF5k03A2612ILqEsI+zDOvgTiiSqAB0lYqL4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wl3oaBK4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wl3oaBK4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=BEs0+VEayJBZdJhNvVB+4R2X5XA5wGb/x6k8Eq0o4JQ=; b=wl3oaBK4XuJeamTGSjgQfskZuE
	A5kxZQ2nZU+vyqI8fJZCiSpEv9/dGnQ72dqrOUyWfURnZ3U9XQ2/LJMcKGzOgWE0pnGoBeOZUbF7s
	aNYN5kZS1xXYvonrnbRAK+QvT7qRLmta+Uu+3UQBQPkjv2yOFqv8XvrZ1xkn1MPvp+TbJF+gmcgUc
	N9bGIk9Y9U5DMg1wWAEsUFVW6yYvmKQmbCxurlAhEtjNLZqneIeOjliwGyWKAwGIzHZx0oxlUzkJu
	Fg6Nt9R2cQnmVvH1IpvQwTP3GbOYd6PFKwMeCP8nJOlSQxCE3zxpVTYrdNi130M7eM6MaQ3gmrjtm
	SWirfuQQ==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vgm-00000008crH-2UVp;
	Mon, 31 Aug 2026 06:40:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: lazy bounce buffering for checksummed reads V2
Date: Mon, 31 Aug 2026 09:39:48 +0300
Message-ID: <20260831064010.2574896-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series improves performance and resource usage for reads from
devices that require stable pages due to checksumming on XFS.

Currently XFS unconditionally bounce buffers reads on such devices to
prevent user modifications to the buffer from corrupting the data,
leading to checksum failures.

This uses DRAM bandwidth and CPU cycles for copies that are not needed
most of the time, and due to the use of a bio_vec for the bounce
buffer to smaller than wanted and unaligned I/O sizes when using 4k
user pages (i.e. 1MB-4k I/O).

This series addresses this by reading without the bounce buffer first,
and then only allocating a buffer and reading into that again on an
initial checksum failure.  To accommodate for rare (or hypothetical?)
applications that have legitimate needs to frequently modify in-flight
buffers, a sysfs know is provided to revert to the old behavior.

The baseline of this series is the xfs for-next branch that Carlos
just a pull request for.  The patches are split over 3 subsystems,
and I'd love to hear from the maintainers what a good test strategy
is.

A git tree is available to help with the review here:

    git://git.infradead.org/users/hch/misc.git lazy-bounce

Gitweb:

    https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/lazy-bounce

Changes since v1:
 - rebase on 7.3rc-1 and xfs for-next, which has the bio complete in
   task support merged
 - remove the now unused IOMAP_DIO_BOUNCE support for reads
 - fix compilation with integrity disabled
 - make I/O size limitation actually work
 - clear REQ_POLLED when bounce buffering
 - use sysfs string match helpers to allow non -n echo
