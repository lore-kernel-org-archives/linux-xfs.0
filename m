Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCFB2F1FC3
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 00:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773361654; cv=none; b=rz37uZpateIIbbLoBzJ/g02hu6tUBHD5omokyqG31aI18NxhPWpEVjBonAzyTfQrqbXfCVZvdLS5g8xB/PR/YEn4/s5g/GDXDFCPw6sg6GlDrg0nuEXX/bTdLHk2K8AKyyW5Wv1BlBSQZhqAlARVsDapy1fBD3+sWUOMMBVDkAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773361654; c=relaxed/simple;
	bh=6YVSYSzKSOCTanxPeRmWZDu1w+987eq1hBwRLX4Rups=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E45iDb27wHpiPuLjt10EtpSg2putzLTKsrWN4jDldVZggwtuLIOrQpxBCo9KlDhOBDuabg4wMgewJiEl810T9C9X1xDWzq1/+e1zc/jlVgAIZit7cJxYo00DqhjJkRTqPASxTTNuxJlIhkgCoRnrkzslAnz140TkdoodieQrMU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fNNN5ZLn; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fNNN5ZLn"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35a0b413684so1043487a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 17:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773361651; x=1773966451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21nuVdkxQLyr762+P1jdQsUEx8qjng2p1inLryalZNs=;
        b=fNNN5ZLnutLs4QpiFzShbkPgrAI2Xkxt0nCzita1lVxbyrcvdtwoMhuoArCNSSL9oA
         vd7qW0AxkmFTBi0ww2Kd6SGTWQvrhMp4cS9AamSbqYofNpdp6d6KSfz5vR0B7BUfR1Gy
         t8GiaGLjsP0DsyNbp+qriOLZeOwBJicym4xcBkjkfUJg4ktwrR/4YdUQzHOmJ3h7/9dp
         L9BiadnkEmZZCXCKf5t3ntISJV4fNy3V+v6qMU+7Td4ia369oWwlHOewJMV1xEEzYKK3
         jr2ZceZ81rNfa2vFlLgqmphk2oDRrFfL033toc6fPlDEM/xwux5D8xz5+w3z7zIQLa61
         809A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773361651; x=1773966451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=21nuVdkxQLyr762+P1jdQsUEx8qjng2p1inLryalZNs=;
        b=EbRVfKha4tZpAjsxtUqTsWRQqHHBz3w3D3o7r+iZ5rTFwFTElKPv71kZ9Ti18Kgilo
         +ehh7KCJgWiDhxAdih97n5e/qMPv6drLCFHBktv91S95KsvPxEoawoQ2dxFjmONzh8ro
         JQGGQ26NSFYm/KmKghjsTSNTEMaIUZjJpCBQfdPwrztMvVX3mKi8p3AyRn3VuA+u4EYB
         Uxh/j+x4MEb8rzq6aZhhftuqwIG/7sM4JjOEu2h2W/f6o02K8CGWv+blH0AZrezvx6Wj
         tghdHyJSxNHUijbuIHGYGeiyNkCYHSZMJW+OrbyChWzgD30Toi4ZAqugJbT2EHStM0VW
         9/wQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQ33ez1kL/TKvpzeaNju+8ifpCsBkSeyCbH3XC8eQPLkPiR4qZIp6OyWPnUCm4F8aRBSVgoyX+biA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7X6SiVNcLXsGUxO+4ly/syAHYKsoRXRZijA+LeVs6M5xvx1mK
	H5NBT0WInW95c7OOW1snUB5zYnpQWigsVXUPqcuSCLonSK5v/0vUpJEb
X-Gm-Gg: ATEYQzw8FdEbW1gDoNjfIgvZY72Wn8+wrrG3Y0OQ5e6uM/iBVgs+ykI833Uh35MtC5M
	LYCvZJsGsP/PRvLz4KGcp96M7IlXkbMFKVQZSK6NnnUvi+3u7pYMJBaoZu+5pX5apMarqz8QBpX
	tQYAx1cqBdO0UflE4T8hlraD5zUlGV3pnZpMIgYk4EcM/SqNOnCMfuU7KalHolsR8A2zbTrS+az
	sHfCsCNjE7BbwkspfPclPquHMQZOEE999iDA6wiKTqyGGoBjD34sKf2T9BrlImE0WcB/aCIkKds
	mQTUAx8Q8ms9pWmw9HDbAmeUlNzAf45ofhikqOz/hDmtB4avQnh3QP4LUSjMitytu3M6nuzuQxm
	c5pso1VB2UjgIYYf9bbjKWOSmE2Q9M0tK/Pjj6eWmE69eVarzOABdwkAGRStUPGZQ9Li2hWE+Tk
	xon4LDg6PD2MTB+sKO9eiuFKWrDdWGl9DPokoVFjrECtapXCiOkpfkDajyRwvd
X-Received: by 2002:a17:90b:5348:b0:33b:be31:8194 with SMTP id 98e67ed59e1d1-35a220aceeamr1079558a91.34.1773361651216;
        Thu, 12 Mar 2026 17:27:31 -0700 (PDT)
Received: from zenbook ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a02ba23adsm6528427a91.0.2026.03.12.17.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 17:27:31 -0700 (PDT)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Cc: Alistair Francis <alistair.francis@wdc.com>,
	Damien Le'Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH 3/3] xfs_io: report rg_writepointer in report rg_info()
Date: Fri, 13 Mar 2026 10:24:56 +1000
Message-ID: <20260313002456.3823811-3-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260313002456.3823811-1-wilfred.opensource@gmail.com>
References: <20260313002456.3823811-1-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

If the XFS_RTGROUP_GEOM_WRITEPOINTER field is set, then print the
writepointer in struct xfs_rtgroup_geometry.

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
---
 io/aginfo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io/aginfo.c b/io/aginfo.c
index f81986f0d..978f0f3b8 100644
--- a/io/aginfo.c
+++ b/io/aginfo.c
@@ -132,6 +132,9 @@ report_rginfo(
 	printf(_("Checked: 0x%x\n"),	rgeo.rg_checked);
 	printf(_("Flags: 0x%x\n"),	rgeo.rg_flags);
 
+	if (rgeo.rg_flags & XFS_RTGROUP_GEOM_WRITEPOINTER)
+		printf(_("Writepointer: 0x%u\n"), rgeo.rg_writepointer);
+
 	return 0;
 }
 
-- 
2.53.0

