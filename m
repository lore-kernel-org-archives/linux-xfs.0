Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA161426D0B
	for <linux-xfs@vger.kernel.org>; Wed,  4 Feb 2026 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217604; cv=none; b=IA2vGA+3cz8WegISsFo6ggXfC7Zx5Mk6kgD5vJNgbEVgi+1pjkBpVAgFn4/DPoqS98aEZRJpSfl34A4BNFMngajgwYPqS86lNID0P/3OZY2JjmPaFCB9MeSI99GGRgLpegeMfAU//najPgQSFPwjDm/DdLkrLHgxlofKEZ08uEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217604; c=relaxed/simple;
	bh=zLq0tAhfUD0g1dF88GeskxnLxS5o+c/blwS4NJsVz1M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XFl/6UdGjtBpiV+hhA2kUYm7zlojktDlk1K0Pqg71OhO7Jdtz88P7VsrCj6Ytw45PSj/gLsvBiW7EynKayA8Nxz/+bsc14cFTSdelef4V9jLE67Ori1OuofTwUr2rb5F8vfNIvyTm9Ovg1bII+VYQ6usf8Vknt/NySHZEVqueyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a42b5mGu; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a42b5mGu"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-81f5381d168so7170996b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 04 Feb 2026 07:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770217603; x=1770822403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YsHKzh3cvyvYMzwO8Ak1uYH6+VbCyXout9kraJcE7xA=;
        b=a42b5mGusxW4f5+O4lFoV+tY0N2G/DZkhDhC+cuSB88MoIVtWvUturJfSva+60YsvZ
         yyMuYWFT9jCT9kzc4jlgdL3jhR/v49gMC3GzjRGXCWg7gxZeAUR2S9EenYGOeLsFNZtU
         XfrjWZjnS3/+kaUP+DignJuvEXG+WKg8sZo9reoFgMRH8ePq8LX04M52ZClHFPP0d9Fy
         eCSStmaNIekj1q7ReHPWPn9FnNz3IXHkRl4BaVCNOOmmaFg2E69Eb36g0iyGuO8q1ZGH
         uE6ibR+9M2LwFsP3BXik/aocY0qkTjb5YKDmanHgDzPpiujSU3MQkyYXFZBu4ij8pFwA
         wRgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770217603; x=1770822403;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YsHKzh3cvyvYMzwO8Ak1uYH6+VbCyXout9kraJcE7xA=;
        b=avPLJVZBZpSP7Zp3pVujyA3h803NKR6i0hAeyBFWWWW5nyVCY1sUvinzn5O66R2Bg4
         oZ2zKTmwe7XBJJIiHb2Sr7VCLd5vPkWjbE+GDQzAvDy5Yw9Tv/ySIMKcyBc7kvztSbwJ
         53FsTos7ISIX/b2eey4lzpfqqfuW5AtZN9o145eSmWNha2zoI+PD2umaBnAVudxkmNT6
         dW53cMtxSEHreWpz4tPxN4qvLWz6FuusVHfOx2oevaXUQObI7ct4FOcOD1e88SdcOADe
         yP0TCHujkmGGysscHk2GzaPj2gbcNPkDoU7REMHB5MIhLgLALJhZ5iKN5YOG/UitWzdY
         Q5GQ==
X-Gm-Message-State: AOJu0YxXgdwKQ5CK5aYhDUmh2tVrBfkfUtk2rbnsOos62ODFhVSRMCDL
	HHzGebAVOgUWn6CYwFu1u0asjLfFxM4M3RtIbq5rKUnOSKqaiuI69zn1
X-Gm-Gg: AZuq6aJq2P2X20jajQEK6OkjJAsQ24vvIklw5WUtoJzoFMgMf8ypzr9YLpJd1Te/yjL
	O5WMn9xdwKVAP8W0gpMBWJTGjNVlo+KOc0uiKTrRO68dA3idh9GS+67gAut7PbcrLkWa9pwxQbn
	Ezw7z30z8XlqpRLM3DgN228Ry04rTefN+virNMccDOC/XAKryKPuYXYwRQZ3F43VrMpuehQGB16
	zeAJJZ6irGNUfxcFCgNtfV/KynwneaPD3qtimFjq0sy8nl1KeZrlkmF5yMAgW/tFqJ+0RFTyw21
	GIDxVVsmuGmm7Ja+qD7S6jFbk3AjDIfmIIS7VvM9WUGThJPC7jrsHWplRdrnVMg5+b/CeLC76t5
	EDxnf4MfPSYapflkgGzQSlAzTUWPYMF+DvdyoREDs0EvHKf9qUBivJPo3qyn/gCzz6Exc37gHOC
	KhpkpmFSixShNj/nACW3djpsmrlJQ/XfBTpRluqeqDwm+alIkdstonZ3aSlDw6mPoVWWO1ng==
X-Received: by 2002:a05:6a00:1949:b0:81e:ef16:b26e with SMTP id d2e1a72fcca58-8241c64c756mr2938060b3a.56.1770217603234;
        Wed, 04 Feb 2026 07:06:43 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6c84d67f2fsm2495276a12.17.2026.02.04.07.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 07:06:42 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [patch v4 0/2] Misc fixes in XFS realtime
Date: Wed,  4 Feb 2026 20:36:25 +0530
Message-ID: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
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

[v3] -> v4

1.Patch 1/2 -> Replaced the ASSERT with an XFS_IS_CORRUPT
2.Patch 2/2 -> Removed an extra line between tags


[v2] -> [v3]

1. Patch 1/2 -> Changed ASSERT(sum >= 0); to ASSERT(0);
   (as discussed in [3]) and removed RB from Darrick 
   since the code was slightly changed after the RB was given.
2. Patch 2/2 -> Added RB from Carlos.


[v1] --> [v2]

1. Added RB from Darrick in patch 1/2.
2. Added Cc, Fixes tag and RB from Darrck in patch 2/2.

[3] - https://lore.kernel.org/all/20260202185348.GI7712@frogsfrogsfrogs/
[v3]- https://lore.kernel.org/all/cover.1770121544.git.nirjhar.roy.lists@gmail.com/
[v2]- https://lore.kernel.org/all/cover.1769625536.git.nirjhar.roy.lists@gmail.com/
[v1]- https://lore.kernel.org/all/cover.1769613182.git.nirjhar.roy.lists@gmail.com/

Nirjhar Roy (IBM) (2):
  xfs: Replace ASSERT with XFS_IS_CORRUPT in xfs_rtcopy_summary()
  xfs: Fix in xfs_rtalloc_query_range()

 fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
 fs/xfs/xfs_rtalloc.c         | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.43.5

