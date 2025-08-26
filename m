Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22976368093
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222896; cv=none; b=DX5CHgmlArqq1Ytx71YyFKmhERMZtJlAIdvPoNLZnJr68HYef1xL4N6zm/kCRkTxR7rh0TYAiKE8nbOT7RF2PCO0NoFClnEMpQeqj+N8Cgn/P2k169FHWOXVLXWEUh7vz5sY3Sd6mF2rHsI3nylEXqiG1SI/eJB3XHHDrKgHPhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222896; c=relaxed/simple;
	bh=Ek+K7HnIxIEopRMdqMnNty91y2VWEE+x+hrrKpFJIDU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2uiNFl497tr9BwWTzZwzSfysjN+DfPhTfooHktXm0keaO/hLnv28r1f/r4rhFanxrBhFuTRN4cFVPtKnNJh3+4IRD63LW9j+xdopsiOy8V2FbnWBY9uenvOCEafLeqr06G7yUYU7zp6SnXmI/DA2ZLnlChVWsJlzMWeJiBr+wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=VX3rg/1n; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="VX3rg/1n"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e931cad1fd8so4824567276.1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222894; x=1756827694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y3TpSvoC8LjQ68sRQOMNnuf57RQxDl2e4bAAk/7JVig=;
        b=VX3rg/1nwaBPBki8rHZ8UMExRSuThguHtxx0flJqoSvOXhaKgDjDtKIA9EExV3qk5T
         Lqz10q8Di5PI1oODeVYRbgF9u76OCf+emIJobOksU8NQXOzWMc+5V4S5R+zwW24dLhrr
         o3mbJQQhDm/K2PBw/cD36W1RjN4n7mW+rT/mHqT/KCDwiXwhmLiHqBvUZ2+V7kv5Nnj/
         LU7Uft/YyWnrh5UMWE6VaGIZ1Y89oBRVuzQ8LFofIdzNVuSH1+CeQVbKI6gfxtBxnXY9
         9POUaUX+9zt9GdgGY1QctZaiKg/jBZ7hGSx/DUmlX9hLHYgsZeIPLwZouW/pYPC8fZCt
         RC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222894; x=1756827694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y3TpSvoC8LjQ68sRQOMNnuf57RQxDl2e4bAAk/7JVig=;
        b=nbUo1VMQSO+lqQq5FSBRiutafv6ulKNjp/HtLqj3OiZeh/1D74IEC1fq7gNiT3N2u9
         zPVfIUhla1pgz56xtO8jYbhOyBqLO9FMVIjQoZTXKKyNkBmLknpHqvOLbBqh3lX+u2Ww
         cHlTCv784MmUVzLBUb6e8i37y0wHbrHak3+nF4vO5I8bZxYb1KwpK5cYavANOWZyGcec
         iV+tKmX2ghMBAYIKOgWboihtL9mqtBWCY6XZk1W178oEZSpxuzyp2tqeytKFC4hJWXlx
         6HyjyP3phXaF/yav/7mCoVNRhi7yrs0731VZG8yevDpIuP/x16/+UkFMHyDxhhI+phFS
         HStA==
X-Forwarded-Encrypted: i=1; AJvYcCXIdTbngR6+oqgFGW4ldkEd/Y47hQGZm10PPHEpMsqggmvP5YMTbIctxGoDlT6kuGfSeZIkBjplfYI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkB1pQJJ/Jqdl/pN0t2C+zLVsbBTUgAvUnjq5BYM1KUo9mMxe3
	m60CVQB4p8NiqwkwWV2lG3+2fpnWSVULIUElHWVbS0LnQttJQRwQe9AWc6oe5hCLCzw=
X-Gm-Gg: ASbGncvnEnLMvys78NviqedSPLtq6Wa6EFTMg4cF5H6NhwqBjDdlEwv0triPLbEfA62
	Hx3DvWloY4P5aH/d9baDJqOHo/EIjZ6cQP3y3Awm5aJbc44QDU7flb/a9Pam5+I1vbvHwSaqJKQ
	wngzmvR3y5pxmBmL9vBatN2a0a/lLYJ7mt1CeBckssuy1hxXogULVOAkrGklSdtgraasskWifX3
	bYowwY9HMuxecuVzbRf7eTupj4VYnsLJtiDwOVgzXDW9NrwfCRvhiWc0T6qXA0dy9f3pRf+vVdM
	ddBzQg/B11yvBfWgujX00mQHzqqdt6AqMLhED4RY1oRQNEmJ8gXs3xEqXuX3WXKH8BgWaSyoCvA
	EH/PyT82JTWn0vpxvDh253z4R+aZx+YyEs2CgGNLAC8NBgFJe13iKL1ZVJF0=
X-Google-Smtp-Source: AGHT+IGsMpG/UCDruSz3Wvi7CzZlKIL5xzEKlg+zB+8+jIE4udBR1skQ5tPNMiXAg2ctT0vtiUJNQg==
X-Received: by 2002:a05:6902:c11:b0:e95:25c2:e800 with SMTP id 3f1490d57ef6-e9525c2f090mr16314789276.44.1756222893943;
        Tue, 26 Aug 2025 08:41:33 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e96dbdb8453sm850314276.20.2025.08.26.08.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:33 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 31/54] block: use igrab in sync_bdevs
Date: Tue, 26 Aug 2025 11:39:31 -0400
Message-ID: <83700637bec18af1ca85a2d232a11c0fa85dca34.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of checking I_WILL_FREE or I_FREEING simply grab a reference to
the inode, as it will only succeed if the inode is live.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 block/bdev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index b77ddd12dc06..94ffc0b5a68c 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1265,13 +1265,15 @@ void sync_bdevs(bool wait)
 		struct block_device *bdev;
 
 		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW) ||
-		    mapping->nrpages == 0) {
+		if (inode->i_state & I_NEW || mapping->nrpages == 0) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		__iget(inode);
 		spin_unlock(&inode->i_lock);
+
+		if (!igrab(inode))
+			continue;
+
 		spin_unlock(&blockdev_superblock->s_inode_list_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have been
-- 
2.49.0

