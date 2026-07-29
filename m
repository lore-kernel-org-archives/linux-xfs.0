Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EBF47ACE9;
	Wed, 29 Jul 2026 12:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330002; cv=none; b=K8bzPAM1sf06/279i4vMmxA3eZaIZiRwEWi94iM1zYKrgzMTsX8LNCc29hZThs1qxP3TooUqo/8QLzorWKSBJUDi0xzx8b6c2Kw40+S3PCJiVygfE/IAkz5JZDVhpL3T8OYHwC5pYVSizx3E86xAtmjHATMPkKvJnT9HCIN5+o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330002; c=relaxed/simple;
	bh=/PzP6JGaPydfWNUraZYBJo6tpdlWALHrb5m+kgD4kiY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uX0M4EhiytwbLYMNtsCgSVfJ81YtQdMIuI/i1zMtnOMo1QNGY4BKkfCcxSFXeVV5Cw1qO/nnAFl96mW0YCDoojVjoJLovcUTuA68zbxDkX+EGJxUDl+p91/WHwx45AwmQMUDmaNYlqlGz1OWiS0GdAX7kuWU3xSOIT3GIttOCQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=olLFogHE; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="olLFogHE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=CvDfiUhj0/rbRz/sFU2oR+wTKJag6K5qy+m30gW7YyM=; b=olLFogHEsLuQrFn3Yi5l4jeIZB
	CfhWkGowiOYLkUie4UaYaxejybsTAPqAHTXu+MYECzpxGRkWDSnyvN8QPRufMG7/xbiGPuIKM6fu7
	X+v9m+O0Z3n56/8shn4+mNGRhdT8+vX7jMvDOZPA9MjLVXOFnFb3HndYzR3oDdFUD6SBN3LMTyTXo
	FCflOY4mVF7kdejxfA5TolRcx8jLxaDCj551G/qGusIVWof/Qp9Bkf2EcdhGa1jQK3Myipcmd8MSx
	noTY/LSg0/gIxbNyTSeBPnJ09kva+O+w4a5X2+pxGCkYJaU2s/nPeyoNx7vtS8a7HBFYXhOG8edGj
	wSEXvyyg==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3t7-00000004PId-3Cq4;
	Wed, 29 Jul 2026 12:59:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs/507: use mount -t xfs
Date: Wed, 29 Jul 2026 14:59:55 +0200
Message-ID: <20260729125955.2281762-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Sometimes mount wants to try every other file system but XFS when
mounting the loop image, making this test fail.  Force mounting as XFS
to make it reliably pass.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/507 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/507 b/tests/xfs/507
index e1450f4f8f94..a9eb8646680b 100755
--- a/tests/xfs/507
+++ b/tests/xfs/507
@@ -86,7 +86,7 @@ loop_dev=$(_create_loop_device $loop_file)
 
 _mkfs_dev -d cowextsize=$MAXEXTLEN -l size=256m $loop_dev >> $seqres.full
 mkdir $loop_mount
-_mount $loop_dev $loop_mount
+_mount -t xfs $loop_dev $loop_mount
 
 echo "Create crazy huge file"
 huge_file="$loop_mount/a"
-- 
2.53.0

