Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842A32EAE5;
	Thu,  1 May 2025 13:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106746; cv=none; b=ghvxMVQWyUkWQFSrazsBPXFfDEpi5+I5zPVVA4qCAaUFLot3p1azjUR/x6Pb4ThWfwjM2LVAm5UDlNYIzSkpeOKVqEBAIpLSOwYLxN18dtLFnZ5Q25+6FPMsKXbVLJUdb7YNeFar4i5PCW/dqDiNU6shAB6CrDX3Hr0MR/+R+wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106746; c=relaxed/simple;
	bh=RnYwYwK6rTuOlDPLEUKas0+OrddFaFwKRKjBr5X+m0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1Y6dDwP/hAZDdHbV8l2/C7/3DdXH6x8NR1Vf5kGUoN20/5OMYJsTHAL3i0FVs5NOOaDuN/Q3p8nMbUTempoR1itpDrq7CK+pCdXBcf9XIan/VyJcQuHdeJqEBta3IR+7rEMjyfjfukdlWR60VprT3HRpafQZkuMyZpnFDC7ESc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2ktMdeuh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2ktMdeuh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5Gn63vL/wQuXjVASv/q6r+2AqubMUZ4nKvH59OAI3e8=; b=2ktMdeuhC1usuCmEd1xJMqvS68
	VpDvyKYWiDKTEO0yk4NOuYuiTUnuNkjJ4vQ9GZJ4ad7KSi3TQD+xhhO4ZSorFYyKfeSEdPvVGWgJq
	ptMIlmk8N3lOowjWtYA6J8tDaNT+8cwOGedtzeeKLZztuPZjZUIzSoNwaAzR6qOUaxR8rHP1SlfyO
	XXWyAT9wlUCNqEaTCIaUKHGxCFI96REn99rKHQtTw/WVZRR47U1dtSzkDu2hXqQp8zkpzBBfso7n8
	VWYnn3oTHPuvuDI87/ptS2ieG/mNKJzr1+Yx4vrJxi/jVVuqqk9pCMieiA9NXbNIiewbEMdd99qYu
	cTJDsnJA==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAU81-0000000FqfF-0e6R;
	Thu, 01 May 2025 13:39:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] common: support internal RT devices in scratch_mkfs_sized
Date: Thu,  1 May 2025 08:38:58 -0500
Message-ID: <20250501133900.2880958-5-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501133900.2880958-1-hch@lst.de>
References: <20250501133900.2880958-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/common/rc b/common/rc
index b174d77a75da..6176859a8db8 100644
--- a/common/rc
+++ b/common/rc
@@ -1267,6 +1267,7 @@ _try_scratch_mkfs_sized()
 	case $FSTYP in
 	xfs)
 		local rt_ops
+		local zone_type=`_zone_type $SCRATCH_DEV`
 
 		if [ -b "$SCRATCH_RTDEV" ]; then
 			local rtdevsize=`blockdev --getsize64 $SCRATCH_RTDEV`
@@ -1274,6 +1275,12 @@ _try_scratch_mkfs_sized()
 				_notrun "Scratch rt device too small"
 			fi
 			rt_ops="-r size=$fssize"
+		elif [ "${zone_type}" != "none" ] ||
+		     [[ $MKFS_OPTIONS =~ "zoned=1" ]]; then
+			# Maybe also add back the size check, but it'll require
+			# somewhat complicated arithmetics for the size of the
+			# conventional zones
+			rt_ops="-r size=$fssize"
 		fi
 
 		# don't override MKFS_OPTIONS that set a block size.
-- 
2.47.2

