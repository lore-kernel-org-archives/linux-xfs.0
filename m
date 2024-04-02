Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A8A15E80C
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 22:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712095895; cv=none; b=F89ZEEwbwGlHFEvpmsrt5kzIkU5EJTI6e7jrbr+S72SKGu6bd9NznXeaK1qoNIFp9t5YiFAkI9sV40JnqeB9b9Oa9BrLj1+8pKzX3/y3wkfx87fQxx9C1936fZqdzRyjjk9a29+HNoAVyPMGSEN+DtTFaQAXjFoQfsSGEZ+xQMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712095895; c=relaxed/simple;
	bh=xn+oTNDH/WzVR3FJqoy+C9vcPNbTs7GhI9Bgwm0uvYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+s+sW0vVzTXt3hS5zytINe+b8ZWJ7O5kbCyuuI70NIuXnKCFmMHWoue19ndfWCmRUBIYR3vUepxliYKbxMF4o+kuZdebKF6j6NMWFBaKYonv+m4lBowIehSH7tHgJfHdS1rugObAXEMy77B/48KX+aeMQyx0fTK6zp/yYCS7d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rtven9yv; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rtven9yv"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1e0878b76f3so2936635ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 15:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712095893; x=1712700693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YwBiuU1vbtwyp06BnjtnbYmBHFnX0UcMvJRm7jqM20Y=;
        b=rtven9yv4TgUxSD1kWyUv715eLWwHtp6O+c/dog4nBEWbDCizjcBnPKVf754hS4qts
         hp52XO0VkKDaZYvnJBefMRupEcXtjTq6PQRA/meLsv0cOabX+jAyIQQmEZfbQ9zNs2xY
         ar5415avwPX2WC8CJ+h0P5YSaoi1Mewv4yaoCOI6Uf79TI4VWsJK2SRZGLTMDlsy8sBA
         b0VS2qBoFwSv1x2lJafE+B33WKDXHbOBbPMhBMPGY1v+/wYLT83xHriVvjUDNu1lGPBG
         z1A4CvbG5DwOAmXErycilWtHnFIKg7xssdzsHanWDOLnQA3ACcSfq9xveLR6LOYPMlKg
         1VPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712095893; x=1712700693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YwBiuU1vbtwyp06BnjtnbYmBHFnX0UcMvJRm7jqM20Y=;
        b=NdbDEM/Snmccgx5ppTXTj9Fczq5upVRXg/KfJhBrqN9wUSRxS//bAxjKyuuQkikih5
         lHuUUXlCKQlHFaxdnOQJ/FMuftTnJmri3nE/LXD8Z9YpsCZtTTL639H1TiuKhbpsAdWw
         DJdH0jV5Nvg3E7RP6+KK7ds75uNrpPkzmEObFhM8WZb5sAqlfs4guAwxqjUMmtnZl3P7
         DUsZN9UI73O5+OHT2/NxCEzcgpf62ObytFYx1QX8pageQJ7PYw2bcNFScM1edWhOuvS6
         TckUnOe1rQT/a+6b69DrI9bt8Na4OHrq5smA+JufOyeV7jttQcOWP/HkhXGjNVUeFEv0
         bI9Q==
X-Gm-Message-State: AOJu0YxOiHLBJRX8KcGYAtByLwbyYh6crc/vw/3pcx3bUaupbIf07PpI
	XpCk6NoEdJFd8clWykWINmYdXNMxnKUpX2Z7c6kQAu2sYK3WGyaj76nmpC39el7PLOmncrvtMVM
	K
X-Google-Smtp-Source: AGHT+IFrLJ5UtbYuK39D5QR3+h6jyfYpq6j1Xve0EWLdUCHLufpSdz9kjDyPn/RjWIbJGpdFejaGCQ==
X-Received: by 2002:a17:902:fa84:b0:1e0:a2cf:62e8 with SMTP id lc4-20020a170902fa8400b001e0a2cf62e8mr814090plb.10.1712095892666;
        Tue, 02 Apr 2024 15:11:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090341ca00b001e21ddacb20sm11162160ple.297.2024.04.02.15.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 15:11:31 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrmLq-001osS-0E;
	Wed, 03 Apr 2024 09:11:29 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrmLp-000000052r4-2Xau;
	Wed, 03 Apr 2024 09:11:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org
Subject: [PATCH 4/4] xfs: validate block count for XFS_IOC_SET_RESBLKS
Date: Wed,  3 Apr 2024 08:38:19 +1100
Message-ID: <20240402221127.1200501-5-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402221127.1200501-1-david@fromorbit.com>
References: <20240402221127.1200501-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Userspace can pass anything it wants in the reserved block count
and we simply pass that to the reservation code. If a value that is
far too large is passed, we can overflow the free space counter
and df reports things like:

Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0       14M  -27Z   27Z    - /home/dave/bugs/file0

As reserving space requires CAP_SYS_ADMIN, this is not a problem
that will ever been seen in production systems. However, fuzzers are
running with CAP_SYS_ADMIN, and so they able to run filesystem code
with out-of-band free space accounting.

Stop the fuzzers ifrom being able to do this by validating that the
count is within the bounds of the filesystem size and reject
anything outside those bounds as invalid.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d0e2cec6210d..18a225d884dd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1892,6 +1892,9 @@ xfs_ioctl_getset_resblocks(
 		if (copy_from_user(&fsop, arg, sizeof(fsop)))
 			return -EFAULT;
 
+		if (fsop.resblks >= mp->m_sb.sb_dblocks)
+			return -EINVAL;
+
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-- 
2.43.0

