Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD1430FC12
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 05:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750436; cv=none; b=WX8AUi6PTx5luhp5Kh09lrQjkL0ow5UWv+QITTdKofqyENrfo67lzkiSV4Tvd+FFVMYdWGawAh6humbSdRABfytJk8z4w7rWMxPb5OmRq43KOMXZTpajecyEWwteYTgSY6p7Tj/ZCXjfhzvRUNoCzMIL83NS7dQDohxjZHD8OdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750436; c=relaxed/simple;
	bh=6GkMIEOIYcG/bJXKm6NvbaLARq7Or29O8PGkSbFsgNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6yDY2SRdy+V1bfUxE2oYMyIWGeY2ch6L5frh1EkuRMScsGu+nXUxsATx1vR/i24vk4ZvewaiExinn46oV7QyR964RaTW2NQc3aG2ej3BI4YhR+JNZ6gtqqKwuK6hRJJMbNm1rPW3O9H5lhzUgxgBZKE0L10xeh9cDA7I+4ei1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rhLLUCvl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rhLLUCvl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H/bAyKrefJ7JeWfDf8c4Y3Vfr+NfwWSqxC85hoinmOI=; b=rhLLUCvlTFKeg9DlrKRPRKTlwo
	T81Ji6ksdtjRMQKf7QFQML4KmKTDuJ6zgu55QxRUnoV2bjqlgVYHlawoFQaZTnoMeAZbZAc8He4bO
	Kteb+3lZgBz/dnqtFlCqUwHJG5ND+S56eIO+W6lmBKmmTfO1iI/N3TQ112zaK09BsWbc58+mwOuPq
	X5t7e4jgXpcvJmpHv0J0r6tHaTwKoC/c6EgJsA5dmzYj/rrxG/KaT6qYKdKFJZaghixtuKTSx/TAV
	0ViXe+WS2RaWyNHd+3KKowLHiFtvmbPZzxAv4MlQIzxYN7MxvtstcHQc0YCpXTFyYTsv6zJzp6yBn
	SKtvSyQw==;
Received: from [185.190.48.89] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlgvq-000000013IO-1dDX;
	Fri, 30 Jan 2026 05:20:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 05/11] xfs: use WRITE_ONCE/READ_ONCE for m_errortag
Date: Fri, 30 Jan 2026 06:19:20 +0100
Message-ID: <20260130052012.171568-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130052012.171568-1-hch@lst.de>
References: <20260130052012.171568-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There is no synchronization for updating m_errortag, which is fine as
it's just a debug tool.  It would still be nice to fully avoid the
theoretical case of torn values, so use WRITE_ONCE and READ_ONCE to
access the members.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_error.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index a6f160a4d0e9..53704f1ed791 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -50,17 +50,18 @@ xfs_errortag_attr_store(
 {
 	struct xfs_mount	*mp = to_mp(kobject);
 	unsigned int		error_tag = to_attr(attr)->tag;
+	unsigned int		val;
 	int			ret;
 
 	if (strcmp(buf, "default") == 0) {
-		mp->m_errortag[error_tag] =
-			xfs_errortag_random_default[error_tag];
+		val = xfs_errortag_random_default[error_tag];
 	} else {
-		ret = kstrtouint(buf, 0, &mp->m_errortag[error_tag]);
+		ret = kstrtouint(buf, 0, &val);
 		if (ret)
 			return ret;
 	}
 
+	WRITE_ONCE(mp->m_errortag[error_tag], val);
 	return count;
 }
 
@@ -71,9 +72,9 @@ xfs_errortag_attr_show(
 	char			*buf)
 {
 	struct xfs_mount	*mp = to_mp(kobject);
-	unsigned int		error_tag = to_attr(attr)->tag;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", mp->m_errortag[error_tag]);
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			READ_ONCE(mp->m_errortag[to_attr(attr)->tag]));
 }
 
 static const struct sysfs_ops xfs_errortag_sysfs_ops = {
@@ -134,7 +135,7 @@ xfs_errortag_test(
 {
 	unsigned int		randfactor;
 
-	randfactor = mp->m_errortag[error_tag];
+	randfactor = READ_ONCE(mp->m_errortag[error_tag]);
 	if (!randfactor || get_random_u32_below(randfactor))
 		return false;
 
@@ -151,7 +152,7 @@ xfs_errortag_delay(
 	int			line,
 	unsigned int		error_tag)
 {
-	unsigned int		delay = mp->m_errortag[error_tag];
+	unsigned int		delay = READ_ONCE(mp->m_errortag[error_tag]);
 
 	might_sleep();
 
@@ -183,7 +184,8 @@ xfs_errortag_add(
 		break;
 	}
 
-	mp->m_errortag[error_tag] = xfs_errortag_random_default[error_tag];
+	WRITE_ONCE(mp->m_errortag[error_tag],
+		   xfs_errortag_random_default[error_tag]);
 	return 0;
 }
 
@@ -191,7 +193,10 @@ int
 xfs_errortag_clearall(
 	struct xfs_mount	*mp)
 {
-	memset(mp->m_errortag, 0, sizeof(unsigned int) * XFS_ERRTAG_MAX);
+	unsigned int		i;
+
+	for (i = 0; i < XFS_ERRTAG_MAX; i++)
+		WRITE_ONCE(mp->m_errortag[i], 0);
 	return 0;
 }
 #endif /* DEBUG */
-- 
2.47.3

