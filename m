Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3DE146A6C
	for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 22:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727217707; cv=none; b=etG29wUCIHKWgL2M/4DtluMwA0AM2U8WRFrMhJH39ZZ++IOpUkd5ylMl2dlFaKEaiX3wsP2mpAGG4bk8mG1tCzPdyqhLxf6xKv4oPuADoiBBmX+e/wXIctGmrk1xrVGiaXIccWjqg7KsghRTLQ4+whn+LBlzOsUipYq2FDZmQRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727217707; c=relaxed/simple;
	bh=mPXnF7hMkUm99VEerNDvKssi7GoYEqx+nCfJxCNI5gE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aejDBUsVNbKmZumzdTAZIRcgE+/4V6vQ+oxItEpdpngZgXX7UieVIPGRw3BaSuiQ+FenDAe2GcgCboefa+TGzcFj5XVOyWD/aaFAbTSldn5BS76kTZw36WSXjCnebv0ZTs3VzDhgnsZg8dMRQHsagcU37GtZDDGF6/Qe4KbJfpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=goqHFmrA; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="goqHFmrA"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7a7f8b0b7d0so303147385a.2
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 15:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1727217704; x=1727822504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l0a+dC7bPkvRCPdf1FziTYWIZO6MVoEFRBy8NHKXmB8=;
        b=goqHFmrATnV2YSdXvgE8xfdQPfP3hbgRrTHi6qbTIxLayVRc7RkN5GZbQFl4vwpKE+
         esv9xu3IipjrzGUOsWCRIz9gv7BQFw3kgIhvU4KcstS+n0qd0B25Za1OXTYmfONVRvPX
         m34jJLQLazIG7Jk7Q1ZzeCaO3gB2jK4G3/ouc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727217704; x=1727822504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l0a+dC7bPkvRCPdf1FziTYWIZO6MVoEFRBy8NHKXmB8=;
        b=rDnFj18P5YKXJpfndwtiFkzbCM4berCwhWaqmlPElSGD864EAMlRImatyhhx07dXam
         v8uknxXpDUd0ya2kyXvsY9bQiXynPzlJpHBnn2bsimYLRb5kTUR59wvZJt8KVJquYn3R
         mQEFUVR0Q5nYrDycUJXk4PyNL6bhQwpMqLv2U+PxReej9wMAtx1cjKDHxjoVfMHeICLu
         VLHxKHErfZ4BzXOH5qsLVrcWnqFZ1NeHMxhyPI3LDWfBqWM/28czCGuxBszokyRIyids
         8HxVfWmhjkD7/3xF/ShlTBuz9t7FE8C+WRN65P38c4H/ajNve5fWl3P4vyx/lwiTSvq2
         ARnA==
X-Forwarded-Encrypted: i=1; AJvYcCXhfi+yXJSPyRv5qV/lOJLDNUjFKBFVXnMzIQoqY1Nwz+G9qq1+belaMbAIXui0WfvKIXMx78Ua5R4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxlmUERgyE1CYrGLgr2eRhFjyZwJ4PdnrOVXFhXoG46oHJUBSB
	v7ovjfEkHnWXt63UMNN/XR9kwnC1Zm5TCeB0tDrFoHUlI8gr1HTG7skIt8G6TQ==
X-Google-Smtp-Source: AGHT+IE39ZVbpC2igbn16XZ30Di4nIf8N6wS8SaYUKMQBPWPMPJvDmLuOfL87RMesCOfEKAa+FbXJQ==
X-Received: by 2002:a05:620a:2454:b0:7ac:d663:f454 with SMTP id af79cd13be357-7ace741486fmr124086485a.36.1727217704498;
        Tue, 24 Sep 2024 15:41:44 -0700 (PDT)
Received: from ubuntu-vm.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7acde53d6d3sm114843285a.42.2024.09.24.15.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 15:41:43 -0700 (PDT)
From: Kuntal Nayak <kuntal.nayak@broadcom.com>
To: leah.rumancik@gmail.com,
	jwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vasavi.sirnapalli@broadcom.com,
	lei lu <llfamsec@gmail.com>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Kuntal Nayak <kuntal.nayak@broadcom.com>
Subject: [PATCH v5.10] xfs: add bounds checking to xlog_recover_process_data
Date: Tue, 24 Sep 2024 15:39:56 -0700
Message-Id: <20240924223958.347475-1-kuntal.nayak@broadcom.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: lei lu <llfamsec@gmail.com>

[ Upstream commit fb63435b7c7dc112b1ae1baea5486e0a6e27b196 ]

There is a lack of verification of the space occupied by fixed members
of xlog_op_header in the xlog_recover_process_data.

We can create a crafted image to trigger an out of bounds read by
following these steps:
    1) Mount an image of xfs, and do some file operations to leave records
    2) Before umounting, copy the image for subsequent steps to simulate
       abnormal exit. Because umount will ensure that tail_blk and
       head_blk are the same, which will result in the inability to enter
       xlog_recover_process_data
    3) Write a tool to parse and modify the copied image in step 2
    4) Make the end of the xlog_op_header entries only 1 byte away from
       xlog_rec_header->h_size
    5) xlog_rec_header->h_num_logops++
    6) Modify xlog_rec_header->h_crc

Fix:
Add a check to make sure there is sufficient space to access fixed members
of xlog_op_header.

Signed-off-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Kuntal Nayak <kuntal.nayak@broadcom.com>
---
 fs/xfs/xfs_log_recover.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e61f28ce3..eafe76f30 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2419,7 +2419,10 @@ xlog_recover_process_data(
 
 		ohead = (struct xlog_op_header *)dp;
 		dp += sizeof(*ohead);
-		ASSERT(dp <= end);
+		if (dp > end) {
+			xfs_warn(log->l_mp, "%s: op header overrun", __func__);
+			return -EFSCORRUPTED;
+		}
 
 		/* errors will abort recovery */
 		error = xlog_recover_process_ophdr(log, rhash, rhead, ohead,
-- 
2.39.3

