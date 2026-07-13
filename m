Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C533655FD
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 06:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783923523; cv=none; b=g3sw0I7LcZHgcJhxO6FCsGsp0A9JEF3d1tbbPgs2AbtN/8498v3SRHzkhu2JqaidrxCB/W5xE/mcXkxFooYDzUy5/AmqEDp2Il2S9zPAqMcxS1Huc5cGOeiyCc7zvDtJW9GYoXp973wXk/KuYYFxDVR0Uz1Fn9qEJL8rFMFw//k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783923523; c=relaxed/simple;
	bh=+MrWXRIfwc0Zv78dZOd2Eyfpm6bFVinB6uiwmCQIHu0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kKELLuI+W2b71EfCe7FYWtDE6CCbvCESM50a44wfEiNl6TQ69H/3GiUnMXjoN73oDa3ITsjc5a2nmj9LW7wGyxFsoAhqP0i/PRjQ+d4b2w6w7EThjJa8zIcodxYvnlDfuvKKOU+Do+vpBWSlFIYJvuBtLJlf3AUktdi9eYtqTks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P1JHr3Y6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kSrOpCVP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P1JHr3Y6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kSrOpCVP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783923521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8LSB2dymbFEEsJzcflJNoLJ+AlzGMYHxA3bqXgSK7oU=;
	b=P1JHr3Y6AKmYEpASNOMJN7cR7ieX/yUzGQQ3U/k71L+fD1WkLrjImyVRxXHoRA3x1oQ170
	t2QAS/VDJRLUg0jQVCyJXxb1ZI/AX62Kt1AGMEoqMKm7SVPY3T8X9amknva12tMK0yaW8W
	OOmK5lL9n/nybRf6m7q1MCGFjnzii4s=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-2pogujIFOaeQXUkrK6EVxw-1; Mon, 13 Jul 2026 02:18:39 -0400
X-MC-Unique: 2pogujIFOaeQXUkrK6EVxw-1
X-Mimecast-MFC-AGG-ID: 2pogujIFOaeQXUkrK6EVxw_1783923518
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-37d4f23eb37so4685514a91.0
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 23:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783923518; x=1784528318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8LSB2dymbFEEsJzcflJNoLJ+AlzGMYHxA3bqXgSK7oU=;
        b=kSrOpCVPxpEJGrBZ4tKjv4GJpBYQFnNy2DP8fCYLo/OHERVkWezoiPe1A2EX8w49qq
         mzU0JcQDP/3E0v1RQYL1ULKenvSeJcU1/gQAnRqqOqPqQ4ngyH113HfR5IrcU3UQn8Jm
         mj3p/dd6hON2nr9stgiZW7vUdbQk5SaALswbUNFx1AZKp5Y1gKp8QyMF3HhKqaIyTGC9
         P1a59+z3apwFgDrOH1CX7DU5ZjAg52ANq7hBo/Kf8jEHVQYyOTvQH2Ezh5LO5slPgu7M
         Nro2RJiynLONl9s3MyNWdcX/CGs0esoDvyKU3SCpq7UAGWpuvcbNP5ZkUziHuXLIhIVY
         FqlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783923518; x=1784528318;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8LSB2dymbFEEsJzcflJNoLJ+AlzGMYHxA3bqXgSK7oU=;
        b=rEDrbjxrul2v3BZkZjTOon6JFmsx02scgSD3W/bZEsEizOBjFqvqH9GJTj6L5P6+NC
         lpuORrhB4J87qv3izAKbEjuPoXm0j0MByJwC8Q/UFMdy6J6BeaKfGXsl3DJEsL8XxLqQ
         wInTx7pvM5Hbl3wLjZosUjwe5bfCj5sb0e6Nz79x6oA5oiX714fs5ZdAAaXwCMuCGgve
         iaPm7i1HLbc/7Tn+2KSMYw9ffJvMbyLthiLWzRUdbIewYcC6rplOWv2MgCG41HclOTtJ
         ZlpmPUUfcAOidIepEA61wjHH8b/DukUz3itlEj9v/3rlzDZDZ/mIOxR9JyAQ7GMIKlFU
         jpVA==
X-Gm-Message-State: AOJu0YzOhCFMgHkfXEy/iDj6zWoL8RAblMq9BEFeMenhu2G5GfABoOSc
	M1jsZkM/BUxaGOyu1QpVzv/YzwES2Lg/T99seGpCT6V8GR/T/ozviOfr2zd8kD5P9mojTjQftIF
	a+sY2p6Cpwy8VmEDQ3B2qo8+ipMil1AfYdgL+DESH3F/99eCSj55lb2d2FDQfz/lxbbJMz00W/O
	v2BZ55O1ru+0iLDfN7BSlgW2+44PIXW0nklOT5PgmRLFxXkg==
X-Gm-Gg: AfdE7clVPw9UkbxoTXrRDbT0nOdZkD5NrCxCEN4ebnV6w7sYYoWdgc2Z9/9txRWU6XZ
	yjJHVe4uqn7WUwOisKv/P64Lfa1399v+Y3dtJrFZ1iFbQNcsTVRrBsOblTn8QJ/GksnyninOWzI
	8YfnTN7ahRWaAX865arTB+AY4V1/qEeZKU3yceOC2Cm1ikTitXjXMgHMOuHpu/0NFujKUheEs5O
	Y5ngC3nw07cngA3wSoQr5KDu6TYBYeEdcYDq6drQLdcuSx19tEBLVB5jDHlqpPjjXzZ4W27l0Bq
	VMIxdBn9L8mcG9g7FEbxGLqDKR82KVW9lqaZ5/YxCJw2q+g9v1cSGsfbWiJ8a+uTnsxQAnRlV5G
	lZmD/cpTv1WHYiZNsjSJ43qxm0Yeo5BFtTdRGXurPB/kDWbQ=
X-Received: by 2002:a17:90b:5384:b0:389:8f6c:4d58 with SMTP id 98e67ed59e1d1-38dc777c40cmr8000161a91.34.1783923518352;
        Sun, 12 Jul 2026 23:18:38 -0700 (PDT)
X-Received: by 2002:a17:90b:5384:b0:389:8f6c:4d58 with SMTP id 98e67ed59e1d1-38dc777c40cmr8000124a91.34.1783923517772;
        Sun, 12 Jul 2026 23:18:37 -0700 (PDT)
Received: from msinguru-thinkpadp1gen4i.bengluru.csb ([115.110.236.142])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-313b4cbafa1sm44943800eec.6.2026.07.12.23.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 23:18:37 -0700 (PDT)
From: Manognya Singuru <msinguru@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@redhat.com,
	Manognya Singuru <msinguru@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2] mdrestore: fix extent length overflow in v2 restore path
Date: Mon, 13 Jul 2026 11:48:08 +0530
Message-ID: <20260713061808.22518-1-msinguru@redhat.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Aisle Research reported that a crafted metadump v2 extent
length can overflow the signed int used for length,
leading to incorrect size calculations and a
potential heap buffer over-read in restore_meta_extent().

Change the length type to uint64_t and ensure all size
arithmetic in 64-bit before converting to size_t for I/O
calls.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Manognya Singuru <msinguru@redhat.com>
---
Changes since v1:
- Fixed indentation

 mdrestore/xfs_mdrestore.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index f10c4bef..3368a005 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -395,11 +395,9 @@ restore_meta_extent(
 	char		*device,
 	void		*buf,
 	uint64_t	offset,
-	int		len)
+	uint64_t	len)
 {
-	int		io_size;
-
-	io_size = min(len, MDR_IO_BUF_SIZE);
+	size_t io_size = min(len, MDR_IO_BUF_SIZE);
 
 	do {
 		if (fread(buf, io_size, 1, md_fp) != 1)
@@ -428,7 +426,7 @@ restore_v2(
 	int64_t			mb_read = 0;
 	int64_t			bytes_read;
 	uint64_t		offset;
-	int			len;
+	uint64_t		len;
 
 	block_buffer = malloc(MDR_IO_BUF_SIZE);
 	if (block_buffer == NULL)
@@ -442,7 +440,7 @@ restore_v2(
 			XME_ADDR_DATA_DEVICE)
 		fatal("Invalid superblock disk address/length\n");
 
-	len = BBTOB(be32_to_cpu(xme.xme_len));
+	len = BBTOB((uint64_t)be32_to_cpu(xme.xme_len));
 
 	if (fread(block_buffer, len, 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
@@ -503,7 +501,7 @@ restore_v2(
 			break;
 		}
 
-		len = BBTOB(be32_to_cpu(xme.xme_len));
+		len = BBTOB((uint64_t)be32_to_cpu(xme.xme_len));
 
 		restore_meta_extent(md_fp, fd, device, block_buffer, offset,
 				len);
-- 
2.54.0

