Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1821EC4D9
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907432; cv=none; b=DHnxdjaEfx9uRKL3wKS0jtFKBDgPjvLUiMouvkQdmXkanGR4K1JyfCWtgGSHyqu6r677ipgAauYIthYQopt8+hlseVbNhUofEk08hESWnR1nLMZcXgPnWqpjdFqex9SknpANSONtdqSthGsHUQ2HFLXfxrs6YMQ/upH+AqNVnDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907432; c=relaxed/simple;
	bh=8clmYLfAyqVPCDq6huiKdW+hRGE3LM7MI07qupha76Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txFh/paCuHMSOjNQW9sa9fjy7tOXmKQAwkdCaKoS88Hyc+jPmfoKqbfU6oPMMWWXXBTrv9DkHZ3OznIDCLyPmjhSWJVJCVPDfRZAEsyZzPJqjhLIbjG7Y5svwIYU9N1vhBTcdsDjZ8yCdqUE07rzgq8mNjgrUlqlYXRailf/rgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rsWoeP7D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rsWoeP7D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=J6VbC9UpWE1U1XoEeoJlwWAZw/gfoClrXJZWq5ATraM=; b=rsWoeP7DQ8WozQWCFr7H+cF94N
	iqBuoWW9wOg3IocJuEpWeAAopD4T22oKEgNouYhARxCNgpkB8Sz9Mz1GfVLp04w1rsoX0aXyq2bHJ
	0LBLB93YgwHOXoWqRAJ2GkH9iv6GrI+K1oC7mwW5XKPHbY9LWV4zb82Dfqeqx0bCegWf13I/doFVY
	uXDIZ+OjZVDg5VQtXJuDXZyayYEvWlSvu/TFK31BV0GZNccBWai5qiFctw6NhMH5VyLfZ2eZXyFua
	5o9LQtOObAIEIUGuHIjp7nTSClXI+4FSodBDkfxSP+mQ3e2Fnt5jPx2idRdufEJBrxrh/DtSlld18
	GlcIYPAw==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWr-0000000EJ7g-46VA;
	Wed, 11 Dec 2024 08:57:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/43] xfs: refine the unaligned check for always COW inodes in xfs_file_dio_write
Date: Wed, 11 Dec 2024 09:54:37 +0100
Message-ID: <20241211085636.1380516-13-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

For always COW inodes we also must check the alignment of each individual
iovec segment, as they could end up with different I/Os due to the way
bio_iov_iter_get_pages works, and we'd then overwrite an already written
block.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 2b6d4c71994d..6bcfd4c34a37 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -721,7 +721,16 @@ xfs_file_dio_write(
 	/* direct I/O must be aligned to device logical sector size */
 	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
 		return -EINVAL;
-	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
+
+	/*
+	 * For always COW inodes we also must check the alignment of each
+	 * individual iovec segment, as they could end up with different
+	 * I/Os due to the way bio_iov_iter_get_pages works, and we'd
+	 * then overwrite an already written block.
+	 */
+	if (((iocb->ki_pos | count) & ip->i_mount->m_blockmask) ||
+	    (xfs_is_always_cow_inode(ip) &&
+	     (iov_iter_alignment(from) & ip->i_mount->m_blockmask)))
 		return xfs_file_dio_write_unaligned(ip, iocb, from);
 	return xfs_file_dio_write_aligned(ip, iocb, from);
 }
-- 
2.45.2

