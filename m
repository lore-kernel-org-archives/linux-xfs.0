Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F45367F5D
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 15:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769613312; cv=none; b=sHgOb+IHUw29/nS9gaLekfwRWxVzju+L6OPquASNnoTRYFp9u+Vq0Jo7jXPRbpauQnCZRYj4vrTlMlz18oa70ox8Ozd8JIt1SQTR6H/nFR2z1oHl6QEsezHnkp0yZ87L/E7nBnUOvNe86Fp6DvMY9bcV7WPqe2r7JbNn4f/rPhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769613312; c=relaxed/simple;
	bh=FfXRST5TAIleJQV2ElnXMH4I0Ocp4+5OxIeXbRGXJ7M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JyPyayQBmuf7jqlS0lLRFXhroL15NPmuEbYG8DrAlK3zs6fsggwUjexHA29xYelo2awnjZygvtmnG76t0joaBJHn/jnY0ZSSRZEYg+Tl8nF4sPUs4oP082e4+NcI2FF1keph3aUcss9iGDUQ/v1LnHCpUv5RrPOeOW3n4X8Xu5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fyydkiQz; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fyydkiQz"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3530715386cso5829332a91.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 07:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769613307; x=1770218107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NQavHcov3zyWrX+HB/pgu1TA69a661EIAp2ehZc5V3o=;
        b=fyydkiQzkLqkQVE3N9GXqIlDmt2uPoqabV+zCKaTgD7lEToVNxt4EOVRO29tVw+BJH
         56b30z5LIPC86bE+SH/5WJtMIi94zD5YkRcglOg4pwexcMnzHpev6Yv2+03sSMcsaJPN
         pDKnvPcYXLgDsrXduC8bhULFBsWvkPQtyV11AAbqxkYZ44TeFI3252dwAQa/BMWfS1kV
         AUUtJqHWODpU7yaUsOIbx/A9mqyVzoNNXSIGbMbUbzbKhuDPyFtMuDv9x+il8f0VgNo1
         SJnjAW7s5FEWJlGJ5w9uMNapLkqkfLqL4WZ3vRTBdmXlYdFHr7mezWu2nM/aDdE4622M
         JDNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769613307; x=1770218107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NQavHcov3zyWrX+HB/pgu1TA69a661EIAp2ehZc5V3o=;
        b=a3oYGIB7dtog+hhSH2YBD1reoLbh+Nt00oZ8IAzPpAUSuSAwWgzYIDn3ulYJyI5P8w
         jSgF4hwp7+KlauE5f+tP4Ekk+rJQDJp/a4hcgHct/Wa8DZ4OlSmzU0s1Ngxtepq7G391
         a9VdH5DyWee0lZmc6DwYyD0IFzl3Ot0XOIg7foZ5CKtXKjTO3583aYzBk2Kyo0pAWkkE
         gKprZetzARL+f3a5zwCoj9jIS10R4TaiPSGgzMOSXZMt9t+X5sdSkiOacLW9lue8HUqI
         9oA1PBO04zltiN6qcci9ao2iUJRgdG2cgME1Mjo7OWwOdE9O/hOvwmrySV7CsrPoua6x
         HnTQ==
X-Gm-Message-State: AOJu0YzcsGrzeLeUySOUjVsN7p2XntkuE5Au17BBuIlI1iceXf0qE4rq
	hrDMP/sV5q29c5oH/E2Umm0cV7aHzXKrf6hrad3EtR2StwHfuy82PWiBSGbJXQ==
X-Gm-Gg: AZuq6aJGlsyOBNOAq/sm7WK7QnPQddVsjymwURqvF0h9df5nkLE9PVitrsK6MLnu+Wm
	NMk+wHsWpas24Fwwvgwtwk0gQ5biIq1OgZvG3k3OSkKiIx84nhb8rvNcDxbEo4eVwANy3BRtVIt
	aG+AgMm8xj9pfAyTA6w1hAXYHEbPQ4wT5BuDnp7t/7RXzsgYqjGL+hNzdSv0yXMrrETXO7IUrEc
	GJgzmA+HEGkEArckTIby/jdHauhUhO5la70a1wu/ku6JhsOMTzZ16R6dc8meqi8H+5WIS/RRwnD
	G1oNcmMMaUhHRszbx/2M3YJmu6KiJjnGYDBlhY23tG8sN1q2vdjRar7EQeYI+Pq8ymxzYTaqmA+
	Utb72SjicZG9zsAIelvwGcM4cXFhAJuZxxWaCFAb3wSnXa/eU7T4JGEAxxxy3N7r4JaQ9JlGii7
	ZqjfFaooCV5Fvi6KE5FrN71Nj25RRpL0pciz584U4oYnjBQESLY6epxVKM/xFwELk3
X-Received: by 2002:a17:90a:c88c:b0:338:3d07:5174 with SMTP id 98e67ed59e1d1-353fecbacbdmr4678362a91.5.1769613306546;
        Wed, 28 Jan 2026 07:15:06 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f2f0283sm3286080a91.5.2026.01.28.07.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 07:15:06 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1 0/2] Misc fixes in XFS realtime
Date: Wed, 28 Jan 2026 20:44:33 +0530
Message-ID: <cover.1769613182.git.nirjhar.roy.lists@gmail.com>
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

PLEASE NOTE that patch 1/2 in this patchset is actually a V2 of [1].

[1] https://lore.kernel.org/all/20260122181148.GE5945@frogsfrogsfrogs/

Nirjhar Roy (IBM) (2):
  xfs: Move ASSERTion location in xfs_rtcopy_summary()
  xfs: Fix in xfs_rtalloc_query_range()

 fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
 fs/xfs/xfs_rtalloc.c         | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.43.5

