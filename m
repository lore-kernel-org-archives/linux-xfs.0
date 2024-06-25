Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C4C17C211;
	Tue, 25 Jun 2024 18:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340130; cv=none; b=gLgh+qnxZKurNMvtT3w1gDP6nKy+H67WHh4iKN+/MRq5Mwnr+CQXozazicSapIWKU4ERq4jlRitNwcXJYmf8bKNIL9MG1Dl0c5VASJo19j/LQaUjbESuQyu0+BLW+rvzyee9/o3FTFWzkghPIsue0pOR49uCKkEME9L6nI/KHPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340130; c=relaxed/simple;
	bh=CM2iH9mXGomSC7nlHDF14QKGppezrhMjXLfegpwPYcA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gfh15X39l3UcGuQTu5EWBHpfbkOKYyzkWxmDONtXLXva5929d7Ou+lvKtvM8A++0W9KkmWioaKO2qKc+LueI12t53V0X8UNI0BMfYCR2Dz6JBMGNxNx8XEmWXCnEFFp66J+NNZzn/TliItaJvxwpCVQ91DT6B/ClmSp3spGQ4iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H49UZXM4; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H49UZXM4"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1f480624d0fso46069865ad.1;
        Tue, 25 Jun 2024 11:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719340128; x=1719944928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tpX0xeSIQSy3UCzH7IXtPcZMZx7uLWqIqcJDea4EQY4=;
        b=H49UZXM4dbVcZW/KQVi8PSZN72YykKxC9zAtzU3Mep/xKnk+rNhfmieobamFZkXPAQ
         9/2Y6czyIE04xriRvkmMlN+PZowttt8EDu7rKXRvXwS5jrqrs1DvCqc6/VVy9AA4luBH
         S6a9NKGVOJwU99jbkMBmGMjde0I0XA8ycGtceUP5gmf6nGYq42u7PhNwiSfk2xDp3jJj
         NQlS0t3MGe/eAinrBH5laKt0x0vbamdXbTA4AyEvenJBT3HaHPo+Mi/vrYlZ2xMJG/GD
         gTAWPi7trb+hIY5zmzu+RhqcmRgdIKLX1QtZw/Ut0zUq0T2ZqWc6JRqGc6vnJtmk3YJc
         i+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719340128; x=1719944928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tpX0xeSIQSy3UCzH7IXtPcZMZx7uLWqIqcJDea4EQY4=;
        b=cnXftbaOVawNuwGJmImDzyRcGmBg5+KqAnSZlngq0f60f//JpLgk88cEQb3uBeIAm1
         eevmQSrP+qd/eASEQnWxx6vTANlyjv4DyUT6aDGUS+UYn9fYiVV4WmkOGJ4DyTnIzn6N
         k+CsOsJqggvSyGPKplKsWxgd92XlrkohHhHKc8YGrzuIBONQezHm3PytXzSG1gN+DaBZ
         vLPyD1tjTnyA1z1ym/jQxG3aHqaF0g+ifyJUE5owLe/dHhTrVYlOgOgHxJv+5iTlLqdx
         Fmfpq1YKk/yGfQLtgLPYI3kh+8bH7JlqJtxLTdWhtGrd0AD+acfKvu5pLwJTs5X11Oke
         ZfuA==
X-Forwarded-Encrypted: i=1; AJvYcCVv8DpAP9NI0IRmzQZ6vp5ZBQxVT/YMvbgOqvBYtL0Ozu+s6A8AQ9sGGZSyGK9Fzp2f1xb930Frpggeck1rITn+2sIMCvfopqmnUjPzthyU4wCtrDp/mJoPFyysHrbb75T/Mpj49Mbq
X-Gm-Message-State: AOJu0Yz2LhKTXHlN1z4hdz6Lk58l/3kktkQxWxHg87Sgsc9wNsj9qgif
	pmFUKvLCnLiixeDOBYWS3gl1YL+61Gv7BA5eCKz7FY5iMiLrbdU3
X-Google-Smtp-Source: AGHT+IGbt7eIbNjWmgynrWAQBgrmJkThoBEKR8VXrWEhtnxue8mTrGlS0G+cMHKM/5HXDCsvxEL8GA==
X-Received: by 2002:a17:902:c943:b0:1fa:2210:4562 with SMTP id d9443c01a7336-1fa23fd8a00mr98999775ad.29.1719340127998;
        Tue, 25 Jun 2024 11:28:47 -0700 (PDT)
Received: from localhost.localdomain ([43.135.72.207])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb320917sm84690555ad.75.2024.06.25.11.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 11:28:47 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: david@fromorbit.com,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	alexjlzheng@tencent.com
Subject: [PATCH xfs v2 0/2] Separate xfs_log_vec/iovec to save memory
Date: Wed, 26 Jun 2024 02:28:40 +0800
Message-ID: <20240625182842.1038809-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

xfs_log_iovec dominates the memory usage of the
xfs_log_vec/xfs_log_iovec combination, and it is no longer useful after
the data is flushed to the iclog. This patchset separates xfs_log_iovec
from xfs_log_vec and releases them early to save memory.

Changelog:
V1:
- https://lore.kernel.org/linux-xfs/20240623123119.3562031-1-alexjlzheng@tencent.com/

V2:
- add kmem_cache for small object xfs_log_vec
- reduce redundant free and allocation of xfs_log_vec

Jinliang Zheng (2):
  xfs: add xfs_log_vec_cache for separate xfs_log_vec/xfs_log_iovec
  xfs: make xfs_log_iovec independent from xfs_log_vec and free it early

 fs/xfs/xfs_log.c     |  3 +++
 fs/xfs/xfs_log.h     | 10 ++++++++--
 fs/xfs/xfs_log_cil.c | 33 ++++++++++++++++++++-------------
 fs/xfs/xfs_super.c   |  9 +++++++++
 4 files changed, 40 insertions(+), 15 deletions(-)

-- 
2.39.3

