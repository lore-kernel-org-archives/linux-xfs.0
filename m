Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542452D8798
	for <linux-xfs@vger.kernel.org>; Wed,  4 Feb 2026 15:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217619; cv=none; b=Xfx4qImgJj4w0+5c4UVRjxF/Xr8rFLtK5/A3C4gjv/7IlU1zrYMXj78Pv/bkiVzthF3BuxBXedpra+gxTBt75DwgjGxBL0OSNVZtDOsZOcmdbO8nPzNgihSRrJTt/+5SL1778lHg8+BEI+lES4ZEG+H4Zz1Wzfq44/VzZn3MzBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217619; c=relaxed/simple;
	bh=t0G+a2dKa4grzUem09KWk8DSZ7i+VJxicdTDdT5dzME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwLqs+1XEO7D8ueIHKh/zfD4e5DMEOtDMR/EqiTGV4Ic64uXyfdnb8HfC+EhEjgW09/saTcNm9RltA93CP2nz7Baz0kBtBzq4OFarsSrMte/Ba6jL28PttTnrBiDjBhQk8irAQh3IHfpT2DfTzhrDm6vr2SwrkYhJI/wy+tAcKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kKpCik08; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kKpCik08"
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-81ed3e6b8e3so3718059b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 04 Feb 2026 07:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770217619; x=1770822419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XNkjJ8gmK3FUww8LJ6aCdhVMjugi2I6fp4ZmZEMSrg0=;
        b=kKpCik08Ui/NsV7zIO0/PhTjbnNmCw7k+w6Dcm1wCUctYTOLcE90DeCINg5F0hKN4O
         vAISWiFdl9KekQ/qTdJumjzI8Dw3Nhp9W8NdmRS9WS4I3akGIUTjh8Ocb59nm0/eaKDn
         k0tDyES18G7PzmCWi4giZJlBGishi7eAYfS1zN6RTliEV1ITMhj2l4YL08mu9dC4NwsD
         F29x+4bQ4DIY69ZmKhsY9QS5fZ55ISHns4xQFfcWh4NsNDeZcszQMTZ1j5AgFyaHazSO
         GgING9AEL3wZQhftLA7OwI1jObTntSvScM7t2re5KffNYP7JbukqpW6eFDenlylS+B1D
         f4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770217619; x=1770822419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XNkjJ8gmK3FUww8LJ6aCdhVMjugi2I6fp4ZmZEMSrg0=;
        b=b1CPPV6qwotRDTS3PBRm5zAe52Uun3GdU9fjP11zmogPCN5QVoeOiTXR/werN98yRF
         RzZxrlxQMFjhIUQ9gYvoJjt+7iAaFnl75E+o/UFmsDgEFAXTTcjdJvbZJg/fPh5wpnkS
         hzS7JPXwzK7NqbvQ3Aq/KbAlgkfiGgo5lik132EzvitQwGMP/A+4Wchn9q+q4sAk+hTQ
         L0XHSskTvAqLIT0dof+wlQjiZKJEWBQeJT1LwBD8T3l62vfNwc5QChVnbqMKy34LdC7A
         H6pOJN3WP9On03j8paTKPzWFoqEih0G6aVvsRZT5vGM9wHUujazPlbhnLVLAA7yTXSy+
         Cgrg==
X-Gm-Message-State: AOJu0YxoVAgL8qA1Rdh5O61SLdZcusaq6bahzmPS64rqIUPMoAYp3txp
	VLqS1pBbOpcl0QS7e+S8bncXZ6II34aL+9gQykFGDeEeGG2Eq8eqXZlW
X-Gm-Gg: AZuq6aLX9N/HlxIpuGoSvfcsDSfCj0m5j/rCDQBnQO2Z1TwTmQnUQ+VntfqWTdNuVbH
	jwyRMvlZCfya4fBMFcCkV727uhgh/mzMTL/fSxOB/1UinJ84cOKGQtuFT/QfbLzCwAa3LY/RqRA
	kkpgUXjd9TCEaK7qmpodCR+gS2SaNwAB6cTZHxN3k9VvbbiUb4hdlUcnChKPVaksaytbXq1ezqF
	/6gpxCq9i5GbNjENatwx9K+k+LW3TZAtdBAnW29j4bub5vcfvVBXFP2vW04yHon5jrrnEvmdqqC
	PJ4I4OOK+0A/2ZWjaBpw5cbly6NqoQeK1H90V5B0DBtjFdN0KFh/U2qz2lSriCo7Mcxa60BJBtU
	IIT5s6nzmyzTMgTy11gN0h/d1iF6laUEUYT5aOniNFPctYocQYi3a/nIzhyPoesZJjZroQGc07z
	7c1fu7WiSkvTtPKi7prLodIddXd0J67sXphCct5zClYA2pkPp2bMzCCiPg5ERzM5Znjprt7w==
X-Received: by 2002:a05:6a21:6b02:b0:38c:792:56b0 with SMTP id adf61e73a8af0-3937242396cmr3119031637.38.1770217618582;
        Wed, 04 Feb 2026 07:06:58 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6c84d67f2fsm2495276a12.17.2026.02.04.07.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 07:06:58 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [patch v4 1/2] xfs: Replace ASSERT with XFS_IS_CORRUPT in xfs_rtcopy_summary()
Date: Wed,  4 Feb 2026 20:36:26 +0530
Message-ID: <4b37c139595fdb9af280496f599f6bb43ae5a9b3.1770133949.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace ASSERT(sum > 0) with an XFS_IS_CORRUPT() and place it just
after the call to xfs_rtget_summary() so that we don't end up using
an illegal value of sum.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_rtalloc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a12ffed12391..3035e4a7e817 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -112,6 +112,10 @@ xfs_rtcopy_summary(
 			error = xfs_rtget_summary(oargs, log, bbno, &sum);
 			if (error)
 				goto out;
+			if (XFS_IS_CORRUPT(oargs->mp, sum < 0)) {
+				error = -EFSCORRUPTED;
+				goto out;
+			}
 			if (sum == 0)
 				continue;
 			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
@@ -120,7 +124,6 @@ xfs_rtcopy_summary(
 			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
 			if (error)
 				goto out;
-			ASSERT(sum > 0);
 		}
 	}
 	error = 0;
-- 
2.43.5

