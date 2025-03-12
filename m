Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA32E2BD04;
	Wed, 12 Mar 2025 06:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761978; cv=none; b=MG1GmEcfaFRJQnZLDADnNDLzEzKaiX2JGLm+avtRJl5s1uObCkUVtQ1uuhKd4/APdXCJSv1NTuhpAfhpEYesBzXJgHMV6D1Y0sGv+7Tue1DfH5PxYlWbX+uNB4WT648Wl/wflXYluQ9vUKiKPOe0v3a1GQhPYHElx0vDj4fLums=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761978; c=relaxed/simple;
	bh=mST0+OMiKJS3fvOBvJpZTUNJNNWGVJLWhpKVqKVZyqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyAN5kEbC44iEBq0rVW5T+zSt5SHhqNj/EETDxfhpdr6XOmb9dSr7/Re/8jlSLzagli3bA4S/Dtw7Iz66OrSGc9tolMvByUQlh1j1ppGSfTdxKLFDxzJCpauwRlV67QBrzO7WnGXio3vswO55jGzeHL3rNxu7GVN05OaUT5wJiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EgjWsrKk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EgjWsrKk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=E+UWIYZFw1uPodkdbF9/zV+7/kxfhAmXUP4hN9C5c5Q=; b=EgjWsrKkiaFgMfK0dPLzX3xmJ5
	Kwanj825IaqGRQmXK12jdQrAHAS2ecB/IOSiwpqtwjD2OXPHaoQ1QwjAMSbgm3hkQVdWJbeD+BZTW
	Pi6XGC/6X68pCtNa2t9HbQpvmbJntsmgOJTJu5gV9BIrBoBsxOyLLK1MISwZETB25InF/kbh5ZFgA
	yRTVe7EeZVhlcaoSc7OI4UbZj3Fo/ho1Q3wA+mur5I0Wi5pVCVE0UwlRQlT/lcspPwiG+TRQRwpJJ
	KGE3Pu/enAmgCjqz4bjmlPTRwbbKDpnVFYYxIhunCTUVVnLs57M5dilUXxqni3O7PbBjTZKYvXY0H
	e/6d97JA==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFr6-00000007csh-0EPQ;
	Wed, 12 Mar 2025 06:46:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/17] xfs: no quota support with internal rtdev
Date: Wed, 12 Mar 2025 07:45:04 +0100
Message-ID: <20250312064541.664334-13-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250312064541.664334-1-hch@lst.de>
References: <20250312064541.664334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Same as regular zoned, but the previous check didn't work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/common/xfs b/common/xfs
index a18b721eb5cf..3f9119d5ef65 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2210,7 +2210,10 @@ _xfs_scratch_supports_rtquota() {
 # can check that quickly, and we make the bold assumption that the same will
 # apply to any scratch fs that might be created.
 _require_xfs_rtquota_if_rtdev() {
-	test "$USE_EXTERNAL" = "yes" || return
+	if [ "$USE_EXTERNAL" != "yes" ]; then
+		xfs_info "$TEST_DIR" | grep -q 'realtime.*internal' &&
+			_notrun "Quota on internal rt device not supported"
+	fi
 
 	if [ -n "$TEST_RTDEV$SCRATCH_RTDEV" ]; then
 		_xfs_kmod_supports_rtquota || \
-- 
2.45.2

