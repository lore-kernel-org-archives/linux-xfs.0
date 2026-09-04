Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088E34908BA
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 12:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788525423; cv=none; b=r6XLc90Xu7xJXdbCuZsfaGlE3KkNbzCNVj/y6em3t6Nw3hGhe1UM9qW3JluyVQIN+0zV7h1JA+yeqZPBRY7nQDnvDaCCweGZv+E1Ma2ej40w30VTKP77NclMgoi+86n/Y4r9BeaiRnGJr5TIygZRWVUEjMP9dx6aPnPTp9HwNG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788525423; c=relaxed/simple;
	bh=ZcsYmzObhoBHTNNPxAvGqe+roZExk0LXIokEa/TA6Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WZYusNDpc6lDGycPyDHFUnfheGzwe0X8ptamqCmo29KgUIzVODARDMaEoKbIqKsUDYc1PLrOzOHoqouAb71SbFFOhQY46yo8m39+WX60I5i98KdYC2P9iSz/ylx73RhWn8N0laoc9MqdVG51dzCtLdpWqRIlBhjn+GZFye4Jy/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lodhtimT; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lodhtimT"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7f6617c7536so522760a34.1
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2026 05:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788525418; x=1789130218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VPjqeXAhECP/NeKzLhAoGYW0KJpn2e3tAGUkNRRmt4k=;
        b=lodhtimT8tqPkYGOkCF5l6lp+i8CONSr6KfDgkGnsEsg+GfgIBsiK9G/8LgzcfcXcs
         wJ8T0R+ECQFDqeDqDh3mPWQNF8BIg8NJdBSDvWl1zrksT5KU7x/hrn9u3VH7qaHLJry9
         g0WzOqCsu3pP/gCo18JjLwIm55Zqzr/y8o1/zqg5CuQ2c4eJyuOoq1407CkmAnaBGRPH
         oTqwIUm2wp/ELA+NvGkL65g8bedb85Vt/A3YcLKVXYswpuGdrzfwprOrS9hccRYcu2GH
         nZlAspB4jr/qKqQ228LTXCaKoeVvRuGplSQqNo1R7RjBO0ZUDJL+O0lPG/yMfuZHWKHC
         GJrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788525418; x=1789130218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VPjqeXAhECP/NeKzLhAoGYW0KJpn2e3tAGUkNRRmt4k=;
        b=cvb2aivLpBbRlhcnq/DFUt4tz+SinLBFYS/G7FmD4XA7lHTX90TSQg2WXDx062bg3T
         9UVrBcdA5X4NHvmiojuxZzi3GQ3ThIo47MczUXe5mP7yTCkCAKl6L59YCeuQKoolmtfL
         jSNDWZFRc+SJ2eXknxHMygGH+l0I7JAXrKVmhdEALF2MIh5m48vOo1Blo/jITzd+ARLL
         OQNGDaPiCw+biD1v3gZEgozSDtmVdJNqFW4740NDzJtpzTx49k86B2sQmUUrutoO14jp
         /Wk6LP3C5oDZ/a3PiGNr+RXctQ8sJNaKzc4bRuI03v9ofgFw3sWFbNQWpQf2Oh7LzaoU
         9msA==
X-Gm-Message-State: AFuF++kZ/HygKWaNyy+apgLrEFoSdiEx4RamZROynX5If0ldwB9Rbg6+
	wF3vvFpVUaHE7+nczDqN87zqe5i6M3bVC4WSUVbBLp+qJSWvxmUNgyQ=
X-Gm-Gg: AYBFou20h8KZQ+k0WMoF4YGgcPTbLHjjQyE6iY8dtiRbC6J5i0+FGRqx66p23rJdTIl
	TXnDbF3JbqNwnTKYSaka7obq9IWO79e9IZaitj2j7od6K3BcveIr/dbNwOfwi/Q0G4wNffmZz4R
	D1iTeNf7zru1oRsJXGTPhBmox/7yKV24VavrGkP+F9tTAV/l/VdHhnzcM8qrorirA74Ryc5X9/j
	Ond2D0pt1xULD3lmxjgE8Hciv4QlCr8/+0+CZwLwAGWeqOb7zffiOH9LK4egDHe721CyD2+Fm2r
	zNblz79RBktHk+JCa5Jzb+zQcKokO3sEF168V2YSUWcZDsd4YWOjI3pigO/ArUBEx+GLdNIPmhP
	uRrgqeq24ogPIs3l+fZfhwRd5498w7Sey68np5RFHwBbqKUE4+8MPIDZzpfcEBEfcBsh7tk6G/j
	NOOliSYdpDSzQQhLBar3HOOuvtWqS6wqNmL0UoaDRKB/SghC/ta9E8aJfqMwjB+WTN9WqHIIARq
	cFzF+cD0HrUiDigG8zNEGj+CppXbA==
X-Received: by 2002:a05:6820:561c:b0:6b7:46e9:9713 with SMTP id 006d021491bc7-6b746e9a381mr1437857eaf.67.1788525418491;
        Fri, 04 Sep 2026 05:36:58 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:f76b:f0cd:302:7fec:2f27])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339bbebf2fsm6944495eec.25.2026.09.04.05.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:36:57 -0700 (PDT)
From: Anuj Gupta <anuj1072538@gmail.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH] xfs: remove unused xfs_reflink_remap_range declaration
Date: Fri,  4 Sep 2026 18:06:41 +0530
Message-ID: <20260904123641.3028007-1-anuj1072538@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Anuj Gupta <anuj20.g@samsung.com>

The implementation was inlined into xfs_file_remap_range() by commit
3fc9f5e40931 ("xfs: remove xfs_reflink_remap_range"), leaving this
declaration orphaned.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_reflink.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 9d1ed9bb0bee..683c1841e640 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -48,9 +48,6 @@ extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 int xfs_reflink_end_atomic_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
-extern loff_t xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
-		struct file *file_out, loff_t pos_out, loff_t len,
-		unsigned int remap_flags);
 extern int xfs_reflink_inode_has_shared_extents(struct xfs_trans *tp,
 		struct xfs_inode *ip, bool *has_shared);
 extern int xfs_reflink_clear_inode_flag(struct xfs_inode *ip,
-- 
2.43.0

