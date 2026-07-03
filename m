Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DC2433E84
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 03:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783049599; cv=none; b=jHly5ntTOJ1MMgJHZ+ZTbxNFIXPYeQtnPB4SQS1nEvMYymyBcJYtpWcElLKMnPG/WugrAplXahjG1+reV3GCX+QUk0JPydiP11iV2dVHxOC39L8tPy0r1gvAKWCqx2VFfyNKszyZjLeBEigaT4N1h0o+j95vpEnTxV1hdsC2PDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783049599; c=relaxed/simple;
	bh=tponrRQ90TMozf+MyLB3cGGztbGISkGwaMEp6546Ar0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqMRiSvTGlL9PtAV6/Wjed4ajh0dvGPGpLxZMABo+9biz6Lu1ajYqnOV+sfifB3418k1/N2/mMMcx5aln4kNLvjNhRnzMsVkfGhHkwiodm0FaQ4rTr4lPVXiTpEd+W4OvgYrrewBx4a20jWE0rURKOL7Cwy3914XrZgSU9NzGE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hjb6qlEq; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hjb6qlEq"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-37f816d01e3so130552a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 20:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783049589; x=1783654389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OScgIk3HVtXhi2nQlNSKs27hube3U3/KXs6uU1PNyuU=;
        b=Hjb6qlEqVGsN3564YLAMORGaeqhIxvL9Mf6RhqjSGFJFJfYgcnd3BqgmpZHOkRwx50
         lG53auwQHL4f6p9t4yMt9LivFtNxz9HkUzEd+G7RILgDMB2TZ2i3EYdXmYWg4iOhdBTz
         yBfvhxXYK6JkNr+u5eHeyxXll22ACSYqlr8+lQ2TSHwv08nzHb+z+wIZ9SP+TPx7XMSz
         Tyv582rofMGNNQj1Si+KomKO04+65bR1ANAM9h729ZZTp5TRz+KdIyX2ilwHmUNE/WOZ
         sKjFJ+xdER5U1DSyQD7ananBptgRlcnRHyQq6sPRVpeuJuMXKgYD7XoTUCNdV3z8Qanp
         pTWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783049589; x=1783654389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OScgIk3HVtXhi2nQlNSKs27hube3U3/KXs6uU1PNyuU=;
        b=macUqHwhhKojjHE2t5sKCOnxZaHSByncdGhHtH+iRxAqBWPgCm2goQtqnP6XfDFJad
         gDKqdO3A5nFoCczio/TFmIFmDGSBsD4RL5QATbRHGymKSD69UIi6yRG6Xq6Bf0wR8G5J
         m2vAs7UfKWnypGhuO6wOfBOLpmny291Nz411b3fFuvq+xl8pl/R1dd7biPYvz/9AVA3s
         zTORJw3cPbNyVL6CpbrOr9Wpw/TBg2/keioC5yGWqztGbxRI07ysFeXK8FbKqdiCcqRl
         x1SQO1ORR1hnvVIvK0OF/rE1Ml/H2ovQKPH+qzGuqXepKK4LOE7y4rSpIqYasyKQJaAE
         uLyw==
X-Forwarded-Encrypted: i=1; AHgh+RqeiYFp4w8WIJknj21TLq91juMXS8KItqF8WEOSn7QzI9OnU982npJYx37v/sSLsY4RP6oWE7EbIp8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxthqdM0phiIrc6uu+b3lEpF7TRKfhW6DRhhPtDZ485WglFnrUB
	cwbUjjm2L5f/7yNFY74n0vdf6IJ+b2n2yjHfu+tM+lq36bKVXJioKKIQ
X-Gm-Gg: AfdE7clw+JE4E4tt7zxiKLM9HTWHUHeMnuQ8X77L+8IT6z0nUWxa+mxjL4SeroSqW/Z
	SugTM8oqdXN9objcMhQ8TJHa3NluQRs4XTmJWq9ClWLDtQX7s7px4uU2tWE1H4iuoELhkVtncbF
	1RamrPQcwdwcFowHzeBLzD83hdPDv5G2qtAhSFb2G7gjkHyHvYv2bI2wZSy4+OMUMLXUb1G+ugn
	Q8/JNNDNNXrvG4HytpCx5bILZV0+C4jsrkfUSvEARmbl/vPXq5ZdZJ9ltkhhdggG2B3jJZ2SakN
	gxKWnwbWziYTbCDFPudh/oz9sfzhpA7mHzdrS5GpH/T2d3FlU/DhmL3L/Q1rS6VtrNVCj3qVBO7
	hJXbzBtXZ8u3cM6ULj0wo4R6Aj+6qZINLZhy9qiSG6n3efLm4xbJ5QV29sDz4PK5LYuGhceGqGw
	USxK6iQawAWxW02u33kLaffEo9
X-Received: by 2002:a17:90b:3b52:b0:37f:9ce3:ca93 with SMTP id 98e67ed59e1d1-380aa1d7714mr10460052a91.28.1783049589379;
        Thu, 02 Jul 2026 20:33:09 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bbd223esm15398453eec.21.2026.07.02.20.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 20:33:08 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: djwong@kernel.org
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	cem@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use xfs_csn_t for xlog_cil_push_now() push_seq parameter
Date: Fri,  3 Jul 2026 11:33:07 +0800
Message-ID: <20260703033307.3829704-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260702155305.GD9392@frogsfrogsfrogs>
References: <20260702155305.GD9392@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jul 02, 2026 at 08:53:05AM -0700, Darrick J. Wong wrote:
> I wonder, did you find with some tool?  And would it be useful to add
> __bitwise to the typedef so that static checkers will find the places
> where we screw this up?

No tool -- I stumbled on it while reading the log code for an unrelated
xfs issue, and noticed xlog_cil_push_now() was taking its CIL sequence
argument as xfs_lsn_t.

I did try the __bitwise idea and measured it: on a clean tree "make C=2
fs/xfs/" reports 0 sparse warnings, and adding __bitwise to both
xfs_lsn_t and xfs_csn_t produces 286 new ones across 26 files. Only 11
of them involve xfs_csn_t (all in xfs_log_cil.c); the other 275 are
xfs_lsn_t.

Almost none are real bugs -- they're legitimate uses that __bitwise
disallows: sequence numbers being compared/incremented ("degrades to
integer"), the cycle/block splitting in _lsn_cmp()/CYCLE_LSN()/
BLOCK_LSN() (xfs_log.h alone accounts for 120), and every trace event
that prints an lsn/csn (~49 in xfs_trace.h).

Clearing those would need a fair number of __force casts plus rework of
the LSN helper macros, and spreading __force that widely tends to hide
the very mistakes we'd want to catch. So my own preference would be to
not add __bitwise: the churn and the pervasive __force casts outweigh
the benefit of catching this fairly rare class of mistake. That said,
I'm happy to revisit if you think a more targeted approach (e.g.
wrapping the sequence comparisons in typed helpers) would be worthwhile.

> Regardless, this is correct so
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks for the review!

Jinliang Zheng
