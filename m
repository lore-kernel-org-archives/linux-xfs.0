Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505E21F5413
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 10:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752748349; cv=none; b=FX5hNuLnAp3pfOChYlg0Z5vipvy7mG8Uu8LHzlEXRg8eQnAcDy254/hAVN22binCUi+yuS4b171NBZ6ZE5dCCkQZdNjgz+e/i7Gub5SXWJ3U3mR1dHAqY79SalSbQ025xwqMMbfrFP1xPXHHo8McppMX6TJBE2yCKAGQi36LVLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752748349; c=relaxed/simple;
	bh=BNHTKzuMp9A49VkRmkfDNRJajKu9K5RvETmW/XvOilg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZOXhZ7PxNMkqvTO62yELLOklH7mZYwuqbiXWB+RIZ10Ow3N1UC8e0fe3uciZQv0CW+SLyXAaivm1khOVEtkXopQFBNAVQGZJdzEDuu0gB9XZ/xyxr1+3+tHLloPzcslCN4DCU8naK3oPb3UZRacyhIU/CBjMpmWsueCqYdrGBoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bM8q3pwd; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bM8q3pwd"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3138b2f0249so693088a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 03:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752748347; x=1753353147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Uk8CAARJSXbthFFgKScGupXUcZQ1c1qVXu7NJ5gsYHE=;
        b=bM8q3pwd0vvWKPLQEIWkrRfYDHCrLCvwI3Zh0P9JLfmBMX2tvyk4bQg8IFzbjiYv0s
         mbBquv3oJ0BR48qhx5WdixlCRiJiXYZhxA6pTheFbIGcBm80/i9W6JKdbj5fTPPY/4tr
         37OjImPBubFQvJkSVNbJn0vuzhE8on7gFSwge1IEUiB8WgFG5RNZOqbgZKfwnsUwLcTi
         e5snyV7NxwcT9l9PHdB+76GDJP71f7PgIcw3G+jCC3T8UYhbOsv9roFG5WoiQZrL238T
         siJ/pOdGMj+jJ0AdD3koP1GvIaDVSjIx6LdXkKcN6mPxbsy3QstY4tMTWXeCB+iXmm9f
         KNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752748347; x=1753353147;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uk8CAARJSXbthFFgKScGupXUcZQ1c1qVXu7NJ5gsYHE=;
        b=vgRKsxnR4M1/VEdTEf3NyuHVgEjsiceQdmURZ8ebM74V3SIXVPg/5vL0hLfkX0J+Jx
         OqBxXvWrcvonndwNM4fIju1TJS+30UcoaZjo9CZz2QTAqtrfSHAGJYx6VMQBzXLd1rYL
         UHChZQef9bKKYxle+chY7LY2iv+3VjOCbn9lWVBXFegEzRtI3JGssUV4GokZIZxURNQi
         6nQwBKBd/8a5QeoIeOnTLKXZVykUHgdtvZ8uYq+M4km9InJRg7ur9eWXtbw0nxbHtY8r
         xZqddAD7a4bimcu4iewEQku4tF7Cs++wrGD0C8rdscmShep2FWOBobtNcKbusTX073Dk
         hKBw==
X-Gm-Message-State: AOJu0YyikD8uc+BF20wzQGd027UxlzCB7XuvzXDgXHz+kXSCobzbdsCL
	RGfmePJkYJhVcqE1Zf8vcICfg7J8ls+tka50MHbK2RTwh4Bmtl6IWJgsMKTcIg==
X-Gm-Gg: ASbGncv1WbrmFOP1uSg/vBx8XvLuJ95EDtYEEKvOgwq/wCtI2Q6B1QlEd/AMc8SBtVE
	0RdaL1OJEBiOlN6FAi55EOHl2msm1e+Z0HpjMNRYvhtKX6JF7oE3BpIRyc9QndDsBgf5G1WbF2v
	OHQi+eSGDr+u0H4N8HbkmvWDSqZZ1WZzySGye8bPzUEIGNvFEkKobY/B6GItfJGkmQGnOG2peJX
	4cYm+IIt5Kd7rvfr0HWJbg4OPRKF7JeyHDwEI7+Kpn2HTRCMB8NNT5rD00uGadnQMJnCTh4B9sl
	OtroiWJ3PXS1UOcnDMajkshwOLgEXCfl/ALepRsbz7B3fW8fpnl0uO87Sch7z8YkpBXaMLAeR79
	A9EnexCEjPIMQ3EO29rtu0bqQlMGlhsLF4gTRggwgHHqNPyDz/o+K4vB+hE+ofVaxIN6kOLhON5
	QY
X-Google-Smtp-Source: AGHT+IGPxuIux51TWHjKn4nBNjNZeirhjZ3xPaiU8MutydUyEESIYjaooWtJ3K4V5gGNg/+pl/Ec9A==
X-Received: by 2002:a17:90b:52cf:b0:311:b3e7:fb3c with SMTP id 98e67ed59e1d1-31c9e799c85mr9238592a91.31.1752748346965;
        Thu, 17 Jul 2025 03:32:26 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.in.ibm.com ([129.41.58.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31caf805069sm1275145a91.32.2025.07.17.03.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 03:32:26 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	bfoster@redhat.com,
	david@fromorbit.com,
	nirjhar.roy.lists@gmail.com,
	hsiangkao@linux.alibaba.com
Subject: [RFC 0/3] xfs: Add support to shrink multiple empty AGs
Date: Thu, 17 Jul 2025 16:00:42 +0530
Message-ID: <cover.1752746805.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This work is based on a previous RFC[1] by Gao Xiang and various ideas
proposed by Dave Chinner in the RFC[1].

Currently the functionality of shrink is limited to shrinking the last
AG partially but not beyond that. This patch extends the functionality
to support shrinking beyond 1 AG. However the AGs that we will be remove
have to empty in order to prevent any loss of data.

The patch begins with the re-introduction of some of the data
structures that were removed, some code refactoring, then
introduction of some helper functions and finally the patch
that implements the multi AG shrink design. The final patch has
all the details including the definition of the terminologies
and the overall design.

We will have the tests soon.

[1] https://lore.kernel.org/all/20210414195240.1802221-1-hsiangkao@redhat.com/

Nirjhar Roy (IBM) (3):
  xfs: Re-introduce xg_active_wq field in struct xfs_group
  xfs: Refactoring the nagcount and delta calculation
  xfs: Add support to shrink multiple empty AGs

 fs/xfs/libxfs/xfs_ag.c        | 160 ++++++++++++++++++++-
 fs/xfs/libxfs/xfs_ag.h        |  13 ++
 fs/xfs/libxfs/xfs_alloc.c     |   9 +-
 fs/xfs/libxfs/xfs_group.c     |   4 +-
 fs/xfs/libxfs/xfs_group.h     |   1 +
 fs/xfs/xfs_buf.c              |  76 ++++++++++
 fs/xfs/xfs_buf.h              |   1 +
 fs/xfs/xfs_buf_item_recover.c |  37 +++--
 fs/xfs/xfs_extent_busy.c      |  28 ++++
 fs/xfs/xfs_extent_busy.h      |   2 +
 fs/xfs/xfs_fsops.c            | 258 ++++++++++++++++++++++++++++++----
 fs/xfs/xfs_trans.c            |   1 -
 12 files changed, 536 insertions(+), 54 deletions(-)

--
2.43.5

