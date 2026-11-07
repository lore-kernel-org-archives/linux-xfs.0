Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=71.18.227.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794081024;
	b=h93XwJk1k7sGqbLLMqtmDABWaylV6SInZUtiGUqklqe/+J7/uByNesprhKRqpf/oA1b0
	 m5NCzJp3gTa5GnUF09xGqaVScXk/X4vE4LMYdbz/4GIH7WS2P8eYYxs1cSu7uNGGzp9Yw
	 EboDPuAnvVtQMWDtyqBgdmQ33iBe02h8YGgIYRlcRvfnD1sE+w/0LNVQRumFBxYnrGa5F
	 aomsKBhUVXruaWFlW+WHbekGX7PsApkgEIgh54pLGPGLAU2aAHJ7bdo3F/mswFe9dUa2P
	 DKzNTWKo0J6ea+dmPYT8kj5YpAqNT52ujRVBqyJbhrRBaGg6+K0gFX/tP6iZpKmGu2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794081024;
	h=DMARC-Filter:DKIM-Signature:X-Change-Id:To:Cc:Subject:Mime-Version:
	 X-B4-Tracking:X-Mailer:Content-Type:From:Content-Transfer-Encoding:
	 X-Lms-Return-Path:Date:Message-Id:X-Original-From:Received;
	bh=K1F94lpgRjwfdExX3+hXbcyK+LhehLvQceSbB/nuEyM=;
	b=D0sClH39oV+hnNr7q5Wt/vFbq4ksmefYZbZiOfjbjL8EZklf4DwlveVWG+zVYVEycMAw
	 OMgz1BFoU0qA8gLIHSqLpzbteITQBeVW3qOp1DEtI14F7IX8+qiSAs8JvGtzI/HBrLm3/
	 z6ymx0bJoeujhpX3qX8rR32Dma8av5oT1t+g/qkpSfyoJHJIKZitaUdzfbW4tBlai7q/U
	 pKgLzLMAnInszUOF7cIg3IZ3sFEbmDYKbx2ASOmqcPGMiMIwITTpDdzdlU64cHcSWjMal
	 ZYlxcbaF00XvKmD0Ofz5b+QVPtCmIxBIJ3Knk60hnrtFSloT/r7pthffqk+DDr7rdwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cherr.cc;
	spf=pass smtp.mailfrom=cherr.cc;
	dkim=pass header.d=cherr.cc header.i=@cherr.cc header.a=rsa-sha256 header.s=feishu2604220257 header.b=wGQ07F5y;
	arc=none smtp.remote-ip=71.18.227.5
Received: from sg-2-5.ptr.blmpb.com (sg-2-5.ptr.blmpb.com [71.18.227.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F31606A32E
	for <linux-xfs@vger.kernel.org>; Sat,  7 Nov 2026 19:50:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4F31606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cherr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cherr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cherr.cc header.i=@cherr.cc header.a=rsa-sha256 header.s=feishu2604220257 header.b=wGQ07F5y
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2604220257; d=cherr.cc; t=1794081011; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=K1F94lpgRjwfdExX3+hXbcyK+LhehLvQceSbB/nuEyM=;
 b=wGQ07F5yPwFP2lUcYc5hmRoZQJYtqKvgEgaqAOHabzrbTOva4UzlSqscPKJTQtv3VdwUUy
 RWwfeSZg4AAUqUn8Ggml6tYF8fyWCjFFtUtBi4cs7cpH0wOCQQKJ1eorpXZn7ZEWFEAKUW
 cYLVbNwvlYkp9VczVP55U7he64wgpsL13uGo3HNAu12Foh5egwAdYu9oxVY5eondZoagVW
 M2JeKNZlSPeVBwCXcrgbiknMu/E8BRFXokURqeMLJdv2xbS0iVAVx2x9LL0ia4DXzIhTkW
 yCGJAe544nzAx6XjL4DQlVLIOH1hVrtLq3VlKuLa2PaqToTuyFlU8ultVuz39A==
X-Change-Id: 20261106-twin-20261106-fs-xfs-da-node-e319621e1c48
To: "Carlos Maiolino" <cem@kernel.org>, "Long Li" <leo.lilong@huawei.com>, 
	"Darrick J. Wong" <djwong@kernel.org>
Cc: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Shengzhuo Wei" <me@cherr.cc>, <stable@vger.kernel.org>
Subject: [PATCH 0/3] xfs: bound da-node entry counts
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAOWA72oC/z3MQQ6CMBBG4auQWTMJU00jXMWwwPZHx0UxHVASw t2tmrh4i2/zNjJkhVFXbZTxVNMpFUhdUbgN6QrWWEyucV6k8Ty/NPFfo/FaigOnKYJxkNY7gYT jicrikTHq+t2f+59tudwR5s+T9v0NLO3uO4AAAAA=
X-Mailer: b4 0.16.0
Content-Type: text/plain; charset=UTF-8
From: "Shengzhuo Wei" <me@cherr.cc>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26aef80f1+0d34c3+vger.kernel.org+me@cherr.cc>
Date: Sun, 08 Nov 2026 03:49:57 +0800
Message-Id: <20261108-twin-20261106-fs-xfs-da-node-v1-0-0d4bd47938ba@cherr.cc>
X-Original-From: Shengzhuo Wei <me@cherr.cc>
Received: from [127.0.1.1] ([111.40.58.155]) by smtp.feishu.cn with ESMTPS; Sun, 08 Nov 2026 03:50:08 +0800

The da-node verifier cannot distinguish directory and attribute geometry.
With multi-block directories it accepts an attribute node count that is
valid for a directory but larger than the attribute buffer.  These
patches add fork-specific bounds in xfs_da3_path_shift(),
xfs_attr3_node_inactive(), and xfs_attr_node_list_lookup(), preventing
out-of-bounds reads and the inactivation write.

Signed-off-by: Shengzhuo Wei <me@cherr.cc>
---
Shengzhuo Wei (3):
      xfs: bound node entries on path shifts
      xfs: bound attr node entries on inactivation
      xfs: bound attr node entries in listxattr

 fs/xfs/libxfs/xfs_da_btree.c | 5 +++++
 fs/xfs/xfs_attr_inactive.c   | 8 ++++++++
 fs/xfs/xfs_attr_list.c       | 3 +++
 3 files changed, 16 insertions(+)
---
base-commit: d68ce4e71248e1ff5af9654b407541d9260b3ba5
change-id: 20261106-twin-20261106-fs-xfs-da-node-e319621e1c48

Best regards,
--  
Shengzhuo Wei <me@cherr.cc>
