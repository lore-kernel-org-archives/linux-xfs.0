Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEC6368D74
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 12:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782734575; cv=none; b=XDd8207etoVbKin4UrQTju+fwyIekqSX/ZzlH+rC/ZhVe3935eIVi+JaeC+Z1qYILzsgR/lKxYE1GNq1qvcCQ+0lXApmAummHdJ2kf/XNsiMutnq5pIE2LuCM5usdqhdxoTZcy/h978I7jWutp7fp8MgmKN0+Lk9ZRZrXemZpcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782734575; c=relaxed/simple;
	bh=eSn09ORLtR9pPMIh60I+fA8JValGtMdHtOOhy/UbYZo=;
	h=In-Reply-To:Content-Type:References:To:Cc:Subject:Mime-Version:
	 From:Date:Message-Id; b=Ut1Pb4U5qE+3Qd39OSwfr+HWVmsSC82/w/DgqF4OLnXlYIfkuwv+ONJNB0njexdOHmarMi2wdK5RwBdxaHUDEojwAydG8hjfnNQuFTU2Fqm/BH11BJKVjB2nNxiIMB5giKE3jHM6ufTnJlja+qcuq65QD3ZMexwpStc2qPsS7eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=j7UrBZTa; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="j7UrBZTa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782734570; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=kwFXVEMoBdj/GwtyMfnE3FbckxkaASVw/8rrswM6esM=;
 b=j7UrBZTaauOLYAQFknpi5hjKiHTkrqZiUu5+ryF21yPJXYLnHMX1HwMJz0bycJTlnaEuRW
 VPPnNIaN1lw4CTbFmVW0FTMdzM11D3bdwQL3oIsf4DKkht/hZF5P+rE6r1YoS5Fu7DO6eB
 hK8tm8HTCEPpQgj5l6STENm8sV7cFpZvXUaMMO1ushSdYQtcXigCpZkXI6WwnrB9CHUDss
 axVPnRUalTYr6BNGI26GhmGaLX3zn3+fSOLzKvk9Qb0CXTDDMd7cJmcTf+GnsG0B6Ac2nL
 zVHNxr/NmELtkVg6tThaxFWPxFKk/+PfclmJhJedTHT4HoNX5uGI99EH7aUt/w==
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
In-Reply-To: <20260629120124.25223-1-changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+26a425ee8+19bcd3+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
References: <20260629120124.25223-1-changfengnan@bytedance.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, 
	<pankaj.raghav@linux.dev>
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Subject: [PATCH v5 3/4] iomap: pass error code to should_report_dio_fserror directly
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 7bit
From: "Fengnan Chang" <changfengnan@bytedance.com>
Date: Mon, 29 Jun 2026 20:01:23 +0800
Message-Id: <20260629120124.25223-4-changfengnan@bytedance.com>

Change should_report_dio_fserror() to take an error code instead of the
full struct iomap_dio, decoupling it for reuse by the upcoming simple
direct I/O path.

No functional change.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/iomap/direct-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index c40350cdf3b14..4db79ddc1ddd4 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -88,9 +88,9 @@ static inline enum fserror_type iomap_dio_err_type(const struct iomap_dio *dio)
 	return FSERR_DIRECTIO_READ;
 }
 
-static inline bool should_report_dio_fserror(const struct iomap_dio *dio)
+static inline bool should_report_dio_fserror(int error)
 {
-	switch (dio->error) {
+	switch (error) {
 	case 0:
 	case -EAGAIN:
 	case -ENOTBLK:
@@ -110,7 +110,7 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
 
 	if (dops && dops->end_io)
 		ret = dops->end_io(iocb, dio->size, ret, dio->flags);
-	if (should_report_dio_fserror(dio))
+	if (should_report_dio_fserror(dio->error))
 		fserror_report_io(file_inode(iocb->ki_filp),
 				  iomap_dio_err_type(dio), offset, dio->size,
 				  dio->error, GFP_NOFS);
-- 
2.39.5 (Apple Git-154)
