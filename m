Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195263ACA59
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353436; cv=none; b=u9S6sQSk0KjZbBdoGpUCycpM6xCZlO/91BnOrYND7pprislCUoxSxYNR6En1fSGhandbwqhrac2ViRUBHKntfsaw7YKtEm2UB5uKWQueHPipKLpVfPQoaddCdUywvqb8zEf/3b44tmuTQrUAa2fYWxMqQD2YRsDkQwdWjgwTJO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353436; c=relaxed/simple;
	bh=bAIl0EYJtqhiY+G9Xwxws/qkXqkeERtNBUa0GVKm6tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsbrPciLtev+jJfubwnwDJM1DBygIShAF3sXA7jWOWI3ARBJme9eNbTCeDB7OZjYxFS6xRp7L3Dj03nKE5Bw/P1cEwgEg2B7KX0gKmEvdfsdSsmy6PYeYi7auJKDMQQYuEJ/8GW7lKyuKzv/voXAwvHHWb2bqPkAzk8ZtEcyZkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FJbF8JiN; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJbF8JiN"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ce98cb8165so444845ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353430; x=1785958230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N2JkSd7oYJPFcviDB7E5uYmo6tGTEnQPMBBxrAZJVXw=;
        b=FJbF8JiN53OlaZjmgIxbxDQKFi4NzFEzQsFYwDBLYMm8hBKnpMLGx23+AALliOnRDm
         y/7i5If7yUrRtE+hurlTKtxreO4AV2I46ngn4eidmkJq0QRbNOvaMa0hzZbUQ5B1fiWn
         9b5dM6pB2gcs2jEDs0oB1QUWXwO/4JWFnHwu+8nfiQKRJrAHrcs2n7g1BwB8Jp2cvE7p
         DhpsdhvT9gqxFngHaxUQtY83csf814enHyTGclw6BX/xO/B7sfoKAJ9vNR/pcwuk/LHS
         A2CAG7JxiJKnDlHWfrCM0DpVAJl30YPPOWhO/m/g176f4ss07KoDWFUtSj7qTa1JECFH
         ynlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353430; x=1785958230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N2JkSd7oYJPFcviDB7E5uYmo6tGTEnQPMBBxrAZJVXw=;
        b=Kph6dRx4AFc0WRMvIK5Hnr6s2UkwZzNWJYqkcItjBF1J/7Dsx2lXs6S4jQjlEdRqF1
         kyhbP2E0wU/I94DqQrLIS/YQbQsrxCpKWdl4LrC0AI4zBTFt0NIqghNADi4qrFYPmrQs
         sS5EwsQcb6zDhrfw7Pu4CT+HdI4XLqkJmHItqMhhO9H7Ds9/oFCdlAhemclfEsNqEPi7
         +MxNdvXyR1qr2Ah7BXsWs/I4yvfQZaRmH6i+5ms02/ETSt2kOaWqRuOxIxWEUClMlPaK
         LPEX/l7JKdTY7XnhUi9ensPPLAgugIsz0lqi1OBUIRAJlRCSf2OSpn9ddUVwo+UizYQQ
         nTZg==
X-Forwarded-Encrypted: i=1; AHgh+Ro5SZ1bEVALGQdA0emNIoe73CsIoasrNrLNkaU1zjivaCNJVpgWxB2HoWvN5hWUexBBDDA+Aaiz/5E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4Xkox6QK5ZRdRdyilabDAi9lgiRiPSYvD2QD3dJr4aNgDAVa4
	g7sBxOB9h+4Fyt+mkPh22Ue0E1XKM5rKGwoxQ7xKGQ9RLEJkD59lP64o
X-Gm-Gg: AR+sD12dUhqwt2FBkXBEcORVKfUgMf84L2hj1ksw/c9nIEPonH8yhF8KTpy6uS+OJV2
	enI6PoQyVG1Q8aHYOVgbXL8bo+E8t2jos3WiGeRMrxXWgOAYMlmE06vi5uL9czCpb/nl/fZiGX8
	fQLinSNoEaVRakmzRRu7on+fAXKBEX2YlfAzIVOx92tmX/2hJlx6hLToVD5IFMPq+KA0ZlWrA+l
	kga4xeWPl8FMw7qe5RDUvZ+rz+n0mal0Q+5vyL9jG/BiuiRixAAUpgxfkn5Yb9waSCwT/q3J5K1
	Iqbqf2q7Js6pi81nUu+ED30CFIGbbBTjDxk/Aem1LJh1pSawwXYqiFXo3SXYXYnE7AHvbQ3Sm8Y
	0Y2jqB8SBIaFHpeiEQXt67TWMydFHq7qaX6U2krmmfK06qyZCBp0FvO+lOsugi4C/eJNCHhkAol
	tfVZiVfi0ie82ATK75qT/tyifU0z5EaegHvfmKpB/Hr2VkQ5l2/NTasP4LnMgXqhA3GzufbqEPY
	Jqm0zpR+pb8Mvf5wsqTDqJBwcmHMTuThIaeUN4x
X-Received: by 2002:a17:902:ffcf:b0:2c9:e846:a589 with SMTP id d9443c01a7336-2d0266f9cedmr39156595ad.13.1785353429695;
        Wed, 29 Jul 2026 12:30:29 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a4af04sm16305135ad.31.2026.07.29.12.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:29 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v5 17/22] hpfs: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:32 -0700
Message-ID: <20260729192737.3190206-18-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert hpfs iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/hpfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 29e876705369..6a629ab956fc 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -156,8 +156,10 @@ static int hpfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(hpfs_iomap_next, hpfs_iomap_begin);
+
 static const struct iomap_ops hpfs_iomap_ops = {
-	.iomap_begin		= hpfs_iomap_begin,
+	.iomap_next		= hpfs_iomap_next,
 };
 
 static int hpfs_read_folio(struct file *file, struct folio *folio)
-- 
2.52.0

