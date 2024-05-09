Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE41B80C14;
	Thu,  9 May 2024 20:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715285864; cv=none; b=GoBVRZnDw67HfTZLcMfP9IcEu/5AFzcfnZbJojlSGc2kA2qVev/sfdzb8elX5pOTYXradhOpdLcWOeIFp0XsTq/Carjiq2+quOyLoWMeKrAmVNbXrbBpFDrfb6m0avRskLqp4ALJVWjVDq29tUAO+xLzZC6p6HqooF0ruZskDsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715285864; c=relaxed/simple;
	bh=S/CCO5/QNpzI4OvPJp6a7Mb30fILCCIdG1WRMmNcaz0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HvjYiQG/RqH4RbmFtLGUBSsWAWvWCemZI6/tWzPQs1U9DiF9PEu66td3j/6EONB+gOS15m9nIY1sPg4v+J9zbpsx8sSf9Q8N3Phxvio6eb27tMjSpbXH/EO6wD4TsNI2kQc5IqPEwM7uh/BZdcbz1NjdN8TPn/ht6wUZn2jcVG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OTYGzRy8; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OTYGzRy8"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2b620677a4fso1043774a91.1;
        Thu, 09 May 2024 13:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715285862; x=1715890662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sEo1k9QjNoaPjKHYXsGQt2oIR44fE7x4tGAc9RVTBi8=;
        b=OTYGzRy8RHveYVx0VTArmtlvI8z9qmM5msdyxLP4ShUhoJ0mSsDgxcxrfm+MBlylG6
         +4nOfRIE2oLF34n9+FSzM7EfBtdRXu5XyB38CVui7g33rhUY6TGsjINNoXzeghnwU30j
         duH58WpuLwZ0ramWM2h4Nbq1lo+v1fvWqtC+x/6+V/Bg5wcGzVXxWvIU91bb4dFXWcSd
         QYV+69/5lBAcEuAhNMRGX9cjCmuE7Fy6Le8WCqXU6rPaxHpeg86PtGCCscTm5dUuqGLE
         TOdFsFS3tpfU17kAWiIECqftL1kVRVGqPqzgefU8/gGPDYJTrtr3fTIoJpvLGoW5l5Ce
         8tsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715285862; x=1715890662;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sEo1k9QjNoaPjKHYXsGQt2oIR44fE7x4tGAc9RVTBi8=;
        b=T7Lottw1TjjdalTRG3TUW9a90fH7kXNBHmuuKDzVWeJlAsp2pfxzpkyzRxBK1fEYye
         2S5iVuN8XHtOCHQQ18cdk3s7wGXyVioL8j0XPssKn/B9BQxnwYSnkTDEkjBvF+sgjdFH
         yq4bNbzH15qx/LZgebOO/KDfJnrotWTpm8ZI7yPhjvXbeyo9bTj8uUOn3Vp1HLbEvnsR
         Q5MF1XKmzkmMErFJ5EM7I3vWusPPwC2TRyuxyRQZa8OGPQNRDnKa6Uk1IQfPc4wOkSdg
         8VNhzdPg8DKIwdEbIh2l0679TdXVlnLFvDC6CAJukJyGqaPl016uUBdvfZxkm7NAhrmV
         u82w==
X-Gm-Message-State: AOJu0Yx/sKzQ9ajX53Ago8vs2MgDcHOZVXbgtbp0WirDXoAWLXxSjDnI
	qLpfMYIuD1ug9ptILP/1iEXy/Ora4xrdJsR+XN+BUO2G99V76SnH1Pp4Pw==
X-Google-Smtp-Source: AGHT+IH7zGvvDn2cSpwGXt27l+n1EYkk5xq05P2G7mbOWeU6CB4xhj6nO1eQpPQKL7bTjRfZjlzENA==
X-Received: by 2002:a17:90b:ec7:b0:2b4:3679:183e with SMTP id 98e67ed59e1d1-2b6cc879ac3mr617885a91.21.1715285862008;
        Thu, 09 May 2024 13:17:42 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:b32e:d59f:76f1:7402])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b67178301esm1870174a91.49.2024.05.09.13.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 13:17:41 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	Leah Rumancik <leah.rumancik@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 6.1] MAINTAINERS: add leah to 6.1 MAINTAINERS file
Date: Thu,  9 May 2024 13:17:35 -0700
Message-ID: <20240509201735.2208865-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I've been trying to get backports rolling to 6.1.y. Update MAINTAINERS
file so backports requests / questions can get routed appropriately.

Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ecf4d0c8f446..4b19dfb5d2fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22557,6 +22557,7 @@ F:	include/xen/swiotlb-xen.h
 
 XFS FILESYSTEM
 C:	irc://irc.oftc.net/xfs
+M:	Leah Rumancik <leah.rumancik@gmail.com>
 M:	Darrick J. Wong <djwong@kernel.org>
 L:	linux-xfs@vger.kernel.org
 S:	Supported
-- 
2.45.0.118.g7fe29c98d7-goog

