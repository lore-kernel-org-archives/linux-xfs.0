Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F29D3C484;
	Fri, 19 Jan 2024 09:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705656477; cv=none; b=nmId13tqq9tcqKSWlmdJTTgng8bCbrkzeSAwSeMGulmbIkuLemQi05GzClfxQSL7AhhD4TiVoho2FPMXtYOOKvD3sIMOXFIgA/ECYpB2NcEG5Cg9d4F9zvEm+QbqEwYhxA/Vu4FypSNJmiueBxhqSSxgiR2nPEiQwzrByORLQLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705656477; c=relaxed/simple;
	bh=yYNiybOGuoCJPkWJq8aedeJcqBhB7zDPXgVOd7o6YWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mv2vqM2R6D51QHB+57rEHTTpsCGkgNt0GrknxcUn5ESYwrSoCO641OuG1mnZD4gsRcqPPjDgAKaje1Zutn8CD3Fblv+fHLl8A90nXBLgt74j8wBOP8Z8dkkTmcSvpMHZqmbz3lXRgBanMNbRM1d67qFcLa2aVbADSRpy1xI3mR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O3eLHgbN; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3eLHgbN"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5cedfc32250so409148a12.0;
        Fri, 19 Jan 2024 01:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705656474; x=1706261274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PmQXQNgPDNcw0Q7OyNyYioq0dzZz7gCYMv1cL8DlPTg=;
        b=O3eLHgbNI77bR/3iTKZNt4pgrocNzLB5jC1Spwj+rWq8YbuxiglX5XC6f5a5C1hIYd
         ng6mUbARy7Df6PnKF+x/mdEH2KoYjW6kqxLxWXHxOxoDzmD3jV2o3rYBd8DWm5Z7aYuI
         qe+lURdT+kIBzL2qLb0OvcR3OZh5Y6+/TE5voXQ9bq535GNEFKf3VJEg42J7BZqLcA9X
         uE1hzaPKBksLCPekaBRSyywvhRu2BZ8xsIY46CP1x4f6WVFg9Y82sDiznD3kHAwDxSfj
         60boGGCe5oTs7qMptlzG9uR0lSp3w81p14dgLpUCZWOR/iKmEjL9ywmsYAwIrNas0fuv
         N97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705656474; x=1706261274;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PmQXQNgPDNcw0Q7OyNyYioq0dzZz7gCYMv1cL8DlPTg=;
        b=IBIMYDRRJu5n5//OvYZ1khAl8Ri5VrhrBRa79OdIlXg8bXBq+RTl02PEIcO2Y8lG6m
         /Ge9F1byUKpDM0/1aG7bS2n7+TQcaIHaKZbfJ1PiuyGze5H36kttLbpY8sJ+dFVuOZTd
         5Iw/GKs9PaBagAHcJN6lFPR9e+Dg4km/d4+kKetOri4DCErgN8xXeMLdej+KNlaCM5k6
         djw+gvaujBdJS24dMEInL1vAukUmN1+Nq4vwjM3CX9LARVlbKAnmXrW2jfoQIUjBRCfa
         VdX8nWegMoq6hlmZYB8YI3mwI4pDs3iB+/xRCjk641FIlU/2kU0Q6/d6cp9/bosbXlaT
         uivQ==
X-Gm-Message-State: AOJu0YzVidjTMZ8HgR2SQJ+z068b5rg0saBu4Lmi+2KsH31cCiuH9jt0
	yDIfco91iGRPfqW+sSWcD5b8Va/JddQJyrLSwpVDxz5uCQsZy7SuqUWc4bMY
X-Google-Smtp-Source: AGHT+IEIg2vovnExzjcq2lnhztK/PmzZKNEPFJndO2FDhcFra+xKQZTL+BsefzdQj5u2ExOnQme5Gw==
X-Received: by 2002:a05:6a20:20c8:b0:19a:2432:e487 with SMTP id t8-20020a056a2020c800b0019a2432e487mr1237369pza.121.1705656474520;
        Fri, 19 Jan 2024 01:27:54 -0800 (PST)
Received: from dw-tp.ihost.com ([171.76.81.10])
        by smtp.gmail.com with ESMTPSA id sv13-20020a17090b538d00b0028d8fa0171asm3407636pjb.35.2024.01.19.01.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jan 2024 01:27:53 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH] xfs/604: Make test as _notrun for higher blocksizes filesystem
Date: Fri, 19 Jan 2024 14:57:45 +0530
Message-ID: <070f1491c25c37d2a9e01a40aebe87f3404a4b69.1705656364.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we have filesystem with blocksize = 64k, then the falloc value will
be huge which makes fallocate fail hence causing the test to fail.
Instead make the testcase "_notrun" if the fallocate itself fails.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 tests/xfs/604 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/604 b/tests/xfs/604
index bb6db797..40596a28 100755
--- a/tests/xfs/604
+++ b/tests/xfs/604
@@ -35,7 +35,8 @@ allocbt_node_maxrecs=$(((dbsize - alloc_block_len) / 12))
 # Create a big file with a size such that the punches below create the exact
 # free extents we want.
 num_holes=$((allocbt_leaf_maxrecs * allocbt_node_maxrecs - 1))
-$XFS_IO_PROG -c "falloc 0 $((9 * dbsize + num_holes * dbsize * 2))" -f "$SCRATCH_MNT/big"
+$XFS_IO_PROG -c "falloc 0 $((9 * dbsize + num_holes * dbsize * 2))" -f "$SCRATCH_MNT/big" ||
+				_notrun "Not enough space on device for bs=$dbsize"
 
 # Fill in any small free extents in AG 0. After this, there should be only one,
 # large free extent.
-- 
2.43.0

