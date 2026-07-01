Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16FA356755
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 03:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782876886; cv=none; b=uiPTsp75KB6XyqGnefDX6Bx3+xSFMRAdoVXnOiWk74qNspJKybdZPa/gEUKQrKWGm8JlNzV3cKzHHs4+qzjx91RNIVfA+a2oXHeOm+bd5vXk6vzMesUgRqPFDlDGDR2Gj02msnriZXmfZeivmmzi2on3a2AZpNxioCnH73cMj7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782876886; c=relaxed/simple;
	bh=CpStEfVycwYFCyVJJkq3ZX28N16LXa6OqcGuP5iwgJ0=;
	h=Date:Subject:References:In-Reply-To:Cc:From:To:Message-Id:
	 Mime-Version:Content-Type; b=cd2OjXFpJQh7WPgx7aAVuOs+ULf0apAykB99Qg1C2CSRbo0wp+Rb9ZCI37Vlqgwx6SxdPf51+v877TtBIUWmT+qBCrwJbEI/919u9qCaeVcvN8R/plWfBtJq5vc20gixwj4KsuI7I8cXtwlX7dM7Qj5k7/60RtJra5II4ABcxNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=lk6p9TWp; arc=none smtp.client-ip=209.127.230.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="lk6p9TWp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782876880; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=DuoDJvFrD5o8qBqneUEj4nYk1bIrBwyyKAkb/ybG8cY=;
 b=lk6p9TWpIO8LQT+v89ugErjL0aTAOccmR9wMaKxjOmtdoC5rTNsTbc/0N43VU6KnCQDnMX
 bNehusKpMBvcagHYqNo07uBo7rk2mENCpuaNFDdpMXnRjoqz1YceyfdKyS279bA9buxjJq
 sZOd7wWKKAVEHcBTVDVXCVFfJOgBb4tzThYK4WL/OnYhg3/KU9aayADp85QVKO3G4L5Hdr
 NX7kYgpVoeUjtJeyaldHoph1KcxzIAsBgYOtMuvDxS6A7hHeWhFfo/MAp75lJJj6o4zWTg
 ZHf+Qrp4eiQ3a9F8b8Enb0JGv0uUGsY7uFLLNOohttSwN0vY6B6N3tMT/w9zNw==
Date: Wed,  1 Jul 2026 11:32:52 +0800
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH v6 2/3] iomap: pass error code to should_report_dio_fserror directly
References: <20260701033253.46420-1-changfengnan@bytedance.com>
In-Reply-To: <20260701033253.46420-1-changfengnan@bytedance.com>
Cc: "Fengnan Chang" <changfengnan@bytedance.com>, 
	"Christoph Hellwig" <hch@lst.de>
From: "Fengnan Chang" <changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+26a448ace+896563+vger.kernel.org+changfengnan@bytedance.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, 
	<pankaj.raghav@linux.dev>
Message-Id: <20260701033253.46420-3-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8

Change should_report_dio_fserror() to take an error code instead of the
full struct iomap_dio, decoupling it for reuse by the upcoming simple
direct I/O path.

No functional change.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 487c4763f3fde..1b9abdd831d0b 100644
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
