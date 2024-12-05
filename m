Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B11215F5C
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 10:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733393054; cv=none; b=Vo2VwFKkGQ8LAu4QgF2pix/Xm2zUfoY4rXnqrfEDkwOy610Mskwwl4Eqixlhqih4QLeCEAFAI7IETBDSknYRBbU2TSz8ZpUCR1Ee7d0Tw9hS9MnzfCzJL54+dWkQaYi2JmWboQayJBkXycBemC5LsqL+ErBnN9DanVKRNJsMuj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733393054; c=relaxed/simple;
	bh=TE2uEgZC6nvfFxaC1BDDg5Qia/idhm+M6acr64uUi44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ElVKqA9oHV0iGZj3OdADZdsHHNrX5o7Xg8DVml1/4tuoMisEPro9cI1kAnQ4kmEoXlTdLyLFDlFi2jBMKBZJqrHlDVuh/P/5dgCZNdSPXA38JLDHOfmo+Nc8uEeXb+u8sM9p4nOCDgUrfy8ZgFlMT2p6/2CS4K2ocMheqZ/0CIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=O1WJZ+QN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=uTZwysAN; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="O1WJZ+QN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="uTZwysAN"
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 48E0E254024E;
	Thu,  5 Dec 2024 05:04:11 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 05 Dec 2024 05:04:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1733393051; x=1733479451; bh=ymQWH+NC3mwLBpXJmVyFX
	eNqIeGfERpeG8TdAJE3YRM=; b=O1WJZ+QNmtPFHz8n3VDiTsRdaitJkYamiDce1
	yDwf2ZL14meT23mJtDBL/iCeMSck+3U/yijxot+ZRISTUs0h+UbBn5MtbXDFeYg7
	tV9JK6xP888EnpLP/ba9KF9ojhdqyOMEzuZsDbaKyJkpiOffo0SDzcF11RJTLnxV
	Cd84VfykKf98XVES39tUO2J+wmgK7vDRpYEF7wkEjmh/W6DXXyFZi79+6oFht+SI
	D8oog12CJOgksloYlpWMEMgcf+twEbNnwaobdQ69xo4t9ay1PcLZBw5KeNLl+Krd
	r+bTl9AGY4+HQ0ZMMWgmV/i2btq/G4grH63HuudxZWrsFbPuw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1733393051; x=1733479451; bh=ymQWH+NC3mwLBpXJmVyFXeNqIeGfERpeG8T
	dAJE3YRM=; b=uTZwysANhJTT5Bi99Veri76Osgy/ZN25UfHf2Bck3bf0NlXHmO/
	h7XunlqehsmO7hj/FB25WUY8V6n6IPpRi+knFIdsoIkJlTZT7mys78UuNgfJOVd+
	8zqYOeziVyl2R1dSpqEvEMYIDpMDSCCYyRdnrBHZRiUSILB5EPtTnP4WEB3MY8xI
	Lxlm25y6kR5DmwE6BYybXj59844CjY0HKYa0IGVmqTpMwhGcdl7iep6N6KO1Essx
	FCsKTvwn7fpdePH8HNZDCH2Xli0/Mv2TnY60K/Z+cO4eYh4vuSUORkUZsXnmLGAP
	KLJkpPaq7SMQxIUNf2kB9R/9c9hQBy83CKA==
X-ME-Sender: <xms:mnpRZ6kKc3V2EVi4J0FYLo8JxqDwtziqPe4b02Q4z6i1iFNjBkrPBA>
    <xme:mnpRZx18UQfgFNiMMyugyLf90vcbm0P4B3uV5rrvkEeCHTbo0f4rvQem37ZtaTm_P
    KPvIS05pl7QslNLWA>
X-ME-Received: <xmr:mnpRZ4o-UNuxIigGTpyxdTPqB4nLyK5-3i4dVcMGLvefrn6lgMt0yfuzeZ0KZtONEt_30eqpT5HE0vIj481LGLVDNkHWfKM4jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieejgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecunecujfgurhephffvvefuff
    fkofgggfestdekredtredttdenucfhrhhomheplfgrnhcurfgrlhhushcuoehjphgrlhhu
    shesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpefhkedvvdegkefhje
    duieevueeihfdukeehjefhleehudfhhfelgefgtedtteeutdenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjphgrlhhushesfhgrshhtmhgrih
    hlrdgtohhmpdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epjhhprghluhhssehfrghsthhmrghilhdrtghomh
X-ME-Proxy: <xmx:m3pRZ-kIdhEQziC9LioOF6u0RtVfI_z8d4_OSqX5pmsvgr9izNVOfw>
    <xmx:m3pRZ43lUvyU39dMJFrQRG3XRBHDNr4HkGYS26fOlZX-tFuC_1EZww>
    <xmx:m3pRZ1sHa04f95-rnUq_a0WnkGZlRhDiGSKtNgse3eqsKJ6qej7Lgg>
    <xmx:m3pRZ0V1r7CI5zhTKsJDGS5ck-9Yr90A113-8JcEo0CvUhVhcbCykQ>
    <xmx:m3pRZ2A3boDOoT7ff2K9uD7f496prr6Ip4eVqWSH8TgJCiN8EWHiMa9E>
Feedback-ID: i01894241:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Dec 2024 05:04:10 -0500 (EST)
From: Jan Palus <jpalus@fastmail.com>
To: linux-xfs@vger.kernel.org
Cc: Jan Palus <jpalus@fastmail.com>
Subject: [PATCH] man: fix ioctl_xfs_commit_range man page install
Date: Thu,  5 Dec 2024 11:04:01 +0100
Message-ID: <20241205100401.17308-1-jpalus@fastmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

INSTALL_MAN uses first symbol in .SH NAME section for both source and
destination filename hence it needs to match current filename. since
ioctl_xfs_commit_range.2 documents both ioctl_xfs_start_commit as well
as ioctl_xfs_commit_range ensure they are listed in order INSTALL_MAN
expects.

Signed-off-by: Jan Palus <jpalus@fastmail.com>
---
 man/man2/ioctl_xfs_commit_range.2 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man2/ioctl_xfs_commit_range.2 b/man/man2/ioctl_xfs_commit_range.2
index 3244e52c..4cd074ed 100644
--- a/man/man2/ioctl_xfs_commit_range.2
+++ b/man/man2/ioctl_xfs_commit_range.2
@@ -22,8 +22,8 @@
 .\" %%%LICENSE_END
 .TH IOCTL-XFS-COMMIT-RANGE 2  2024-02-18 "XFS"
 .SH NAME
-ioctl_xfs_start_commit \- prepare to exchange the contents of two files
 ioctl_xfs_commit_range \- conditionally exchange the contents of parts of two files
+ioctl_xfs_start_commit \- prepare to exchange the contents of two files
 .SH SYNOPSIS
 .br
 .B #include <sys/ioctl.h>
-- 
2.47.1

