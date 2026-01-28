Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C00728C2BF
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 18:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769625900; cv=none; b=u3q5hX8uOWN0cJn709FAjtV3i11g99ANxlOAJio7dYimDqOipkXq2zTewFvJW7uWfU7LeK1fJsceogDTa5w57sGhcyC7ICIP4o2giIsbRssCGAiV1E8KM8TBse4rPtrbPSbU1mx5mYeSVyNHkmz7NjZoLkbZzURMWGIqtI4TmYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769625900; c=relaxed/simple;
	bh=KFRroCDeeeSlrtdNIHrufozUA8SCZA+04ja0bbxAKJU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tLyAUl1ETHlSVE52S0kTqJC2mqWSLKJ/I1t1wJJ8LQe8GLBWYy3BBsUCi6l0+OWidBYzZcl/l1xIVjbWvzF55HkUYEHK+BwX/HUl877Q49zggklcA93xu+NhWtEGK/33/TaCBXwd+2UGzxVLy5GN/k347kzIqd8QWVLqu7tD3gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FwARXBq2; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FwARXBq2"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a0ac29fca1so624895ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 10:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769625898; x=1770230698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uvizxo0ZR/y39z+4Qr44f6pon3Z8/QGSJDBfp0YdiQU=;
        b=FwARXBq2IHzEeRdMUEmfaG8DmU/xhHKKZmw3mkfbHCtyGRLzKByVTGzYKeV/JZnRPt
         2qhpGFJiyqloU2yR98zv493DMnj9C+qVHwBVuY3UkqgFKRAa4m8fvw3MHtgtWjVmST3E
         J57wHtwPg8LPYb4zA1E7tHIEl5FH28k9of227D/sq4AggGX96ChmvVnnXaSNKXqpdD1h
         7jVKM+7wOHaLi+Dp9mlNrYwx/nAuhBF2hl+gJ6jS7nQfKgzxtwWkBROgOKmpFgdPRYa3
         ALKbNKrGIFvAwG6OUojazt1T7pRCelCgTzsSKX9UWwQHPJYN8ZglCM9OVZFD6wNQCPjm
         5/nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769625898; x=1770230698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvizxo0ZR/y39z+4Qr44f6pon3Z8/QGSJDBfp0YdiQU=;
        b=fKoVAILfofZ/LWFzb6UsLihbFO4Dz1uhsJsZYsHp28AVhjYBo3TWspLooU/ge4upIx
         CZ2Apdu4M2BK8PHj45o/ldMoyMeqQoaKyv1cXfYrRlrslrnF2lHP7k9H2bSSJC8LKEe4
         IV77EzNZS7SSsgNhTTxiMN/+9+xrBlFKyUY9/rqk4BB4nVNLo/yfYBVbrb6nxcUqD4P5
         axFTLRIJEvRf5zHiRL706ncM++qKAgSnIoOwJ0x6cfW3qlYVjid/Dviv1/cI8liHeUNk
         lfRgkd9SMLu004UHd/3xTOmus+v96WN+vhLX0VunND4tTDgapWwpMOlBycw0o/j456hw
         57QQ==
X-Gm-Message-State: AOJu0YzsgF1Tkzqe6lS/CLSuAaT3AmTB5/osUzLqjoHkJ1Ho4gJBggJS
	MX/BUbcbboE7rPmefrJ2Pro2y7rrc+YQ6CLkm5jdBfKyWLD8ynbHclfZcuuXBg==
X-Gm-Gg: AZuq6aL4Pg+zaazZiInmilorpILio062ShW+cDF9l5ccBuTJLMe44Ul4J8qW8uWS08L
	Eccia4FlLecHkjpNPI3XmRv2P5l4t1E6Vjw9IyX8ne8qO32cCpDituO7KEtC3sDp7Vo8qqJhEZ2
	DDb767ZAf7ZeHb24eDnLUKxh5JLlJkZqczgocuKGGZYvPTt126XOxdZwfbAKVBLEhFIXHs7SztM
	Yf4p94XNzcpcs5b4EBM5qlepXpReRS8S/0C0NJEz3L5kzUh1ij3ecElarPAnP+5MaLSxWNoOOO/
	iy3JHODOFAaxoysN2/G3PAxXAVPC3WaILtHkkJMBY9FWestvfyEyAoiVxi80H0WTLz8hV29IH7/
	Ds9ECAdqRD6B9GhPYUAOSmi+Cu2LFKJRczd8FY+j32rtuV9byMFV3SdMcrt4BBajn03luGhgwzZ
	eovahvYz9mHzwKSUM3yNnfC/K1luGyTYuzVZ7hkRKhnLev4Pa41VdFhqfpfmP5d3yn
X-Received: by 2002:a17:903:1b10:b0:2a0:d05c:7dde with SMTP id d9443c01a7336-2a870dde886mr64719215ad.44.1769625898163;
        Wed, 28 Jan 2026 10:44:58 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c3dd4sm29068745ad.65.2026.01.28.10.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 10:44:57 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v2 0/2] Misc fixes in XFS realtime
Date: Thu, 29 Jan 2026 00:14:40 +0530
Message-ID: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset has 2 fixes in some XFS realtime code. Details are
in the commit messages.

[v1] --> v2

1. Added RB from Darrick in patch 1/2.
2. Added Cc, Fixes tag and RB from Darrck in patch 2/2.

[v1]- https://lore.kernel.org/all/cover.1769613182.git.nirjhar.roy.lists@gmail.com/

Nirjhar Roy (IBM) (2):
  xfs: Move ASSERTion location in xfs_rtcopy_summary()
  xfs: Fix in xfs_rtalloc_query_range()

 fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
 fs/xfs/xfs_rtalloc.c         | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.43.5

