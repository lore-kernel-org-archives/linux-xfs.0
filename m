Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793550490;
	b=dlyq6BSd8I5qmgu0p1Jcx51tE3gS2gviaHHQwHCg31iQODBGpWtS9PppvpS6u11qDgxO
	 FQFNgB1Dku1OWIPJAXJfRjrdvtOZMahNFMHQxueVAsgOYwoKc6kkhkNaB2Oiwib7eVj7I
	 XZuBqLDhJEr+MWsNCfpbkCZBwY2trfXK/ls+U7SKWnrjBkcxxDeiAbEIkNXQdYfS0CNL/
	 JItBZIyGjwz437fqMbmFC9PYrBcYLXGEPNcKEuAQnmvHbPhW27tohNesx4JGU/PdNiMZV
	 WssVh2xPtOIc9qqmNcqxKAiMGm5hZ2SQX5i3VOInWI9+TpTsFMcljsFzBfqLXw8XxCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793550490;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ahnoiNiHaHh4VWZbcJN/Bu/ObYjmY8MFVijxGEIKsyY=;
	b=miLC0dWxSdL0fZisgf7sBtGEc7J39YyCxh0VhGXxQS0qrgyrlpBhmHQyr4s2ex9Qfd3+
	 Esx8hV1Hsd3P+2eO01t0GfWat7u2YI4qxyX5+uOuyNcd820wttA8OucfxmrLfnEKAjBPb
	 qLl0BHjeKgCJezNBdNy8Y63rO2feCne+Ykv+d/9SzKOcWKElC2u3vZez2A1b4b7/W+A6L
	 YrSnuyyxVsgQeGksgSYglCFrVAZvIk7MeZ4i06BjBAYMBJSGsFhl2B0llxcVlU0cusOwP
	 gZQoAqjUgMQNjQA4jjWqoyAwkHCUxlNON1f53f2ONcKPHqQaiQSseg9l24pK00uKSEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RsyLOSfF;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCA5606A32E
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 16:28:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FCA5606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RsyLOSfF
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a208d93758so23876375e9.3
        for <linux-xfs@vger.kernel.org>; Sun, 01 Nov 2026 08:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793550489; x=1794155289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ahnoiNiHaHh4VWZbcJN/Bu/ObYjmY8MFVijxGEIKsyY=;
        b=RsyLOSfFCQ8eY5qaUYgf2qrHbG9XtwKyd0Y6zKbdqSN43in7A3GeGxy2vVEEi/Zgw9
         0YqLMp8bVzY+qNNDbkS5jucoTj/KMZRkdIqNbtHlygKGU68seGZZ20zbmyws/pTeYQFr
         EFMK8TWXA1KApHJFzrKBnTF43K4Hc8vFBKc1Wd54AVMeaVU6GRS8se1Niql7ysYaLY8b
         AF0v+66OHqjA7QARZZmTZiHNkKKZUIwjYo8gG7qdcYwR3e9lE7giQPlhdbX5Rwn+VghO
         rsDogApjWRKFynMJabrYYNJ+L0Na0IVw8wrnkjPpi0WxwFsli1Xm4lYQRxqDwBTxoUhW
         qzBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793550489; x=1794155289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ahnoiNiHaHh4VWZbcJN/Bu/ObYjmY8MFVijxGEIKsyY=;
        b=vFpgFmqLFJgauHvB1byaZQE+XeifiFvxylBO64E3WT248EQ30Ryoh75nRm0ZF8mZYn
         kJ3RCUmuDUwC7bkqh44yZA5jsFfSHeA6WRhVtRE/aV/dHVfcBbO7HR/iVFKJ1CustEZQ
         4N9OUITQgTVvRA9j9EOFQ/R5UE2o71/e+Uw99cUV4KVdOfVkGL6DKgqS0o2hwDHZD3KQ
         cc2pEiBMLWfn1DM7qzO9l3gQ2XRzdgf577wIBIXkQ9QWDlyowSN+F18+0+HEBR15Sz63
         L07UrCSl/esXnBIFu3pezqGmcWvbfqFnhVEZ/WCFBDsYKihL2UBEi0Pm/0Ola0IcCVs5
         U1qw==
X-Gm-Message-State: AFq9FYL35J5GeGVFLovwK5VVxJJB/SLch1SvinKad+KFbbWZ7aAkGS7q
	4GcbKARVnlslUXhvlTGs4GaMnUGogSGBMvV7nmUGoAkGFsrV6VErD/B15VOJ
X-Gm-Gg: AYBFou26JhTGyAIp+V7wji5DxCDU4U2KOpkJAQYZ/xz4ablpcKCUsQyDgDzkyTyHIu3
	1JOdblnxeAk5HyZCvRlpXSo3A7DfKRi/ZJXCVZSiThCwa9fOSPA1ZWBNxZDbEMSEjEJZ9lYFqSO
	TUcHkTIjW41erVj3LctiFaNp/oRMlpUsmTyrHBBlsiVBVjpJtHX3aa5BrBy+Kloumq8vrdUwgiJ
	FHFyosLat7/E/rG5xJx+af9zHd4tnNieGH5BEECwnnEeQo7x/26a/bV7ITuyEpyCnr77rTZjdMS
	NUfX+JbU7OLWe8nYVogpY2AXJx18sPByBbF1dsBPaGeyF27uLObp98IFYu8qb1OmD4T53pThvwG
	bakbhsDZt4VFU8uZTSoHqSFIA2hHUzDQsEQ6GUokjzZQeHKLekyS4X8ldhjWhAAYvLDlY9Nbsd/
	zORWRjYwV6ngcLycT56ehNZ0FPpp6vO3BKjcg38Ce15ZFDBR9tqEv+qjCY8rZgdhTixkq7/gNGJ
	g+HEDVHTUAbAoSWKbWyAub9MuVc85IDRn1qPMsnEbRnXOuDpgqXOF0LTPonQzGcSBkiSqgx0P1I
	ra819i3vJqQ=
X-Received: by 2002:a05:600c:1990:b0:4a7:462c:6b9e with SMTP id 5b1f17b1804b1-4ac1923581cmr173893625e9.32.1793550488817;
        Sun, 01 Nov 2026 08:28:08 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf0b36853sm192023245e9.0.2026.11.01.08.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 08:28:08 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	djwong@kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH xfsprogs 4/5] db: validate symlink target length in rdump_symlink
Date: Sun,  1 Nov 2026 16:28:02 +0000
Message-ID: <20261101162804.1444159-5-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101162804.1444159-1-tristan@talencesecurity.com>
References: <20261101162804.1444159-1-tristan@talencesecurity.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rdump_symlink() reads i_disk_size directly from the on-disk inode
and uses it as the copy length into a 1025-byte stack buffer
(XFS_SYMLINK_MAXLEN + 1) without checking bounds.  For both the
local (memcpy) and remote (libxfs_symlink_remote_read) paths, a
corrupt inode with an oversized di_size overflows the stack buffer.

Add a check against XFS_SYMLINK_MAXLEN before the copy, consistent
with the validation in repair/dinode.c which already checks di_size
for symlink inodes.

Found by code audit.

Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 db/rdump.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/db/rdump.c b/db/rdump.c
index a0177e5b..1884b2ff 100644
--- a/db/rdump.c
+++ b/db/rdump.c
@@ -766,6 +766,12 @@ rdump_symlink(
 	unsigned int		targetlen = ip->i_disk_size;
 	int			ret;

+	if (targetlen > XFS_SYMLINK_MAXLEN) {
+		dbprintf(_("%s: symlink target length %u exceeds maximum %u\n"),
+				pbuf->path, targetlen, XFS_SYMLINK_MAXLEN);
+		return strict_errors ? 1 : 0;
+	}
+
 	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
 		memcpy(target, ifp->if_data, targetlen);
 	} else {
--
2.53.0

