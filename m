Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE723CF69B
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 12:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779885587; cv=none; b=C1KjfArNKucOx8Q0fadXMCL7UlcFsQuVMUaIWjuhTqg/ZmXzJWVFKr4647h9/9LgjmXw3aR/EDhnaEgJIYJl31KmUCu7z5T7k3UL6kxWNaYkUAW4sHcJ36Jf2XcND5jRfVmw3P5MbbfuTRWFcQjM6oPTRdrpRFKS8MEh6WZM624=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779885587; c=relaxed/simple;
	bh=fGYvVt9T6Jxc+ze6dlz24kEsXF2/1gbystuAOEztloo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QJa0B7CZBU67nU6rfwiX0xujzY6oz6tN6U2ODvTHUZi8sZ/zTs92KnVKUTUtM9FvHDimeT2A6NlAZtrySrCDh9d0YU46CaKLH6sj81iN2L+yJL30ZqpikH4G9f7NE2pRk7rMovNlULpFxSeM8mWX1493gDW12KJc3bWfH+4kyOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dXEGDHvX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dXEGDHvX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Ghn9WVleVcMMP3PQq5XEUC+RdjJP97G5fYhZccsNZKg=; b=dXEGDHvXOYF7s0QaSrYgVmisGo
	kYGlrkCv3RVbKCIJzyo0GK9mvH0g8qJpZNzemZha8tTYoC7J2S5WxSr/04C6bqxjOFmSfYsU/39aE
	VgZzBXTDQV72nd1JH5CeRF34iYGMaw+7QntY+XawdstNTs/jiUcFLGlYjzB+G5VKsckXYLyVj82Jx
	RLqJsePSxDXIhHBPX+QbcMbDOHlIr2QCkmqP3fejpDvX9L80l9xcfGY6B9t57JyvCHjT1TlDnDv0X
	+fj1qA8qfU65vATaJo6fV5THG5si9NE6ZwaOPFnRbzj6DoRAZrTjk8yZpMc14OzBaUdx0HNWh6Vrk
	Lzl7i7Jw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSDY0-000000047Be-2pku;
	Wed, 27 May 2026 12:39:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: zoned xfs updates
Date: Wed, 27 May 2026 14:39:27 +0200
Message-ID: <20260527123941.2319377-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Carlos,

this series has a fix for an hamrless issue in a recent commit,
a cleanup, and then drops the experimental tag for the zoned
allocator now that it has been in an upstream release for a year.

Diffstat:
 xfs_ioctl.c   |   47 +++++++++++++++++++++++++++--------------------
 xfs_message.c |    4 ----
 xfs_message.h |    1 -
 xfs_mount.h   |    2 --
 xfs_super.c   |    1 -
 5 files changed, 27 insertions(+), 28 deletions(-)
