Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A874F894
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 09:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715074628; cv=none; b=pgm/xVRWogs/rvG3BGkAVH0OY5w47Wh1oS5q+uvmi2Sd8P2nsJsv/5FUzE6lVX05+CCz/dABkxuO9dRJb1vj9OfL29AFgrSHqrXooI0ACjQ2V+R4cW+uOPcRFEMfNTBbtBMQFm69a+re4CoUtPj9nrxojg8lkICkWn1ZltKnbZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715074628; c=relaxed/simple;
	bh=R/d/EKQorfmzIM6ZoXzD3ZxFmxSt0AEbdw5mTTc5Jfc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IVeRHcaDwmZV0KbtiU/OvVVl0Sp7aGWb9phPrCC7mlDH+Ln7pPBtjPvnk9NgpW9LTuOYw1ZMF4oZFghNudt1Hhex+HmyCFxa2hjnuaku0WssLwTnjHihKOzGVP04ZhXhTUSmlZ8ZOtrXYTvv3zT1AMu7nmmxUxWC17NznNZC2Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b2sxbz8M; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b2sxbz8M"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1eb0e08bfd2so15756065ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2024 02:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715074626; x=1715679426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g7YZkln0TQ+95t0ldSuzZG4eDqPMf9KDUuMruVx6FAA=;
        b=b2sxbz8Myrol5Tm+77YssVfpYhinJuQbQqUrc2SRxtH0pPvkIbh6Caid/moI3fUFBa
         0tWd/zl+zNRNMhYymOm6dNCO/B67IYY1gZUVJIjfYdAh+cEcf9Uyf5rFbcKzCIX58oe8
         sB6P9+O99cUhVbJgb9fc4ZXivrTFudnsBGGYklQk1ZUuWNCUVLKh/sVP3TqNIMln5OBk
         Fd4WO5Byz4BfZpqvDttg7m72Asodg8igyZNnB4LUQExDskRgt+QHuUDj052BTzMw4UxI
         dLwhV4cPcSm4gl1JEWvO8wX8dyT9k1jcJdKyvo4mH0/VDI+ze7ia5WAF8f9LLGgLEbSy
         D7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715074626; x=1715679426;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g7YZkln0TQ+95t0ldSuzZG4eDqPMf9KDUuMruVx6FAA=;
        b=EREeXEZqsrRqmgV82VXP7CG9op94lcy/CqaKcqM6OZ+gZlZPnhbWfP2FT4bin0ccVM
         f8j4zLzKaO4Uab5NJlmWuxnrpXz3gRfm79n3DQL5DnWOBmLu/yC7+ireZOITeFnwqpIQ
         VrNJLtgsh3+rAawH+eOoG6pGpt12103P0W0peipNiTnKLGorzbFW029RMfjTNkt3O4Ju
         3ks7mCQE8uGVML6OACoR7vg76XGwNVDjhcI3nORRO3wQYlTKHgF7VFXLzCTX+X6TJANq
         txNHx8yuSn93xba1LsPUTzXHuaDYa0IqCV1L3amhnedXPQ479sAV9uy0+YxSEqYc6fO0
         vz8g==
X-Gm-Message-State: AOJu0YzsLpnpP3hme/IbDlRtiZ+2DTIsAJmz9MqfJpmVE+p4azJtQmTA
	ve/wCeHBmr4wnbNW8n8FCktRPB/4MAkEclPITVGEXVbGTZFy0DcNfRwE9iOn
X-Google-Smtp-Source: AGHT+IETk1HuY5wfM+azXK3hhzTmG8dUq70gen9uc1FCQenzJMSJ5THgaYR+PeBUmAsLsoS1vz3xsg==
X-Received: by 2002:a17:902:e890:b0:1e5:5bd7:87b4 with SMTP id w16-20020a170902e89000b001e55bd787b4mr13321926plg.18.1715074625826;
        Tue, 07 May 2024 02:37:05 -0700 (PDT)
Received: from dw-tp.ibmuc.com ([171.76.81.176])
        by smtp.gmail.com with ESMTPSA id j1-20020a17090276c100b001e49428f327sm9639129plt.176.2024.05.07.02.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 02:37:05 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCHv4 0/1] xfs: soft lockups in unmapping and reflink remapping path
Date: Tue,  7 May 2024 15:06:54 +0530
Message-ID: <cover.1715073983.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

In one of the testcases, parallel async dio writes to a file generates
large no. of extents (upto 2M or more), and then this file is cleaned up for
running other I/O tests. In the process of deleting this file, soft lockup
messages are observed. We believe this is happening due to kernel being busy
in unmapping/freeing those extents as part of the transaction processing.
This is similar observation with the same call stack which was also reported
here [1]. I also tried the qemu-img bench testcase shared in [1], and I was
able to reproduce the soft lockup with that on Power.

Similarly another instance was reported where xfs reflink remapping path also
saw a similar softlockup problem while iterating over a million extent entries.

So as I understood from that discussion [1], that kernel is moving towards a new
preemption model, but IIUC, it is still an ongoing work.
Also IMHO, this is still a problem in upstream and in older stable kernels
which we still do support and such a fix might still be necessary for them.

This patch adds the cond_resched() to both xfs_bunmapi_range() and
xfs_reflink_remap_blocks() functions.

v3 -> v4:
Remove cond_resched() from defer finish and add it to both the unmap range and
reflink remap functions individually.

v2 -> v3:
Move cond_resched within xfs_defer_finish_noroll() loop

Ritesh Harjani (IBM) (1):
  xfs: Add cond_resched to block unmap range and reflink remap path

 fs/xfs/libxfs/xfs_bmap.c | 1 +
 fs/xfs/xfs_reflink.c     | 1 +
 2 files changed, 2 insertions(+)

--
2.44.0

