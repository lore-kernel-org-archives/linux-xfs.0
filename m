Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEADF220694
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 18:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744740577; cv=none; b=UbWZXfeaK3Ne2hEAQ/gRE41kWhX9wGzQPzz0cAf6uC/yJrBwZ0nGNau9mPLNxDkzmAEnzb59f+FFhzDhI4jyCvU8drqODzwArQvgxHJQbGSyom/bowPd9MTj+IEImgHLFvfLtD7dEcroeg1ogtexyDDoqkWTIciB6s+EoCCUWuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744740577; c=relaxed/simple;
	bh=hSbtMo5XKcX0vgIy0W3LFyvfT5MoNIRO8P5cDlB/8TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jdG9djKRqcveKnG+V95hsdtyDb84wky/0FZTMK9lZffq5alEQUgmEFsYQzXAs/dmUfl82rT/3ElRVnfBfHY52GFVsRwvoGC5ZJL2s0//9iKtVFRRDK/Vi1tb5E9hWLc+gVb3REu5zAVlYFg/X5/OdlUyUdxEYhPNk3J3QeNRFOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y3kVbOvB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y3kVbOvB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744740574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ix+c5NBQUpRqDHm6haeIPSrah3kLRBUin8Ce0i4YrRE=;
	b=Y3kVbOvBM1PB8zSH1x+F4VkJuv7+7iqgbOuAg5E8BO2Weydt3jLldUo/aWwla/cXNVhgos
	s4q6Nuihnq9Ht8SH014j5ns84M3YwtKo+G8nRWKONafXnc9TStFsAftAe3Pb4F+o0y5G67
	n0ONmbbMoxaXIKOeRMMvrhMCPyzY4NE=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-2Rb9TJTHNZ2xZnzXEmwdJg-1; Tue, 15 Apr 2025 14:09:33 -0400
X-MC-Unique: 2Rb9TJTHNZ2xZnzXEmwdJg-1
X-Mimecast-MFC-AGG-ID: 2Rb9TJTHNZ2xZnzXEmwdJg_1744740573
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-86195b64df7so504272839f.2
        for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 11:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744740572; x=1745345372;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ix+c5NBQUpRqDHm6haeIPSrah3kLRBUin8Ce0i4YrRE=;
        b=qTf/E33v8hgS9r1Ze/SDpMjnWhDeNaSRIiSt5U2JjFxGJCGro+ul8LZ0nlNeWoruX0
         ts9D3Raai6BY+92CF/Lsv+jGkTmFEIsE7YZNHMZKCDtuX49wcVey7BKAptQsM6sB02rg
         d18qX3m96eL4yv1O5RoiYqs/zQBVlkgdEJwqZh+Pon9WayzFttZcWAt8cWatNKtDsg21
         jTbaZTBFOcmx6y23Uts3qWqkum6w/n8czHsPPdLuq5QBSX+nzRfHq9SFDboqV+XKM9kq
         VBK8whqQCtFVwNFLvOahP7+Zcbn/HLM3Pyw/N0yLU8dsUI4nODh3hsaQNn9umFr7X7WX
         1JrA==
X-Gm-Message-State: AOJu0Yw1pHiGoio/g13Qn2D+DcIUJOUKGvSOyzPW05tUMMkaKOreE4H8
	964cuAE4HVtJo7AOpDTPbnJyd98xYbTNnVWLB1hsV1425txWreQvoHBoKgYPD8fBY/cC5EcKRoL
	YD/oqxg2GLIvFziPCjmkMk8UBhZkHp46AcoZJL4caSsL+3v/zu15GusjWVLGJaPlPjPrLgyOPtd
	nxrHl6BklQRJdDHbDxeYtPYMrmQ4utHCsM6cB1oOCYslo=
X-Gm-Gg: ASbGncvmXetHqCPwZSzMeEvUj6ylnPyit/6DwQZJeNcx5jrIP7V0E7UfBIqBBempoMu
	HzqyzE1Qu5i7ubl9Ifv1GdBSyT0b7mq41gc9YnLeWjZFe3+RrrOaLuoVDrEhsH1WU/b1O2YE06N
	bSp1h7Li0jNO9ZQ6oHYc062upb/qmOtdmoOeeXOEIPOPbTYD+N0tWu+a3Dr99xfWKtogsaBmnqq
	EFDhyuLtG4uUHpFC1YrKogRl9xcWTexw2OjrEQCJxp+TksTNYa25U1Ak20HRxcKqNphfbl1Ee2n
	6+Sz9vH7bz3A4v+U
X-Received: by 2002:a05:6e02:3605:b0:3d4:244b:db1d with SMTP id e9e14a558f8ab-3d8124d0204mr3638725ab.6.1744740572472;
        Tue, 15 Apr 2025 11:09:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTqd5hRdeQjlnee93ef8VT/aGPm8+cR1HFBN3TxYU2mrEG4RYnmN3y6AmailNv785/psAK8Q==
X-Received: by 2002:a05:6e02:3605:b0:3d4:244b:db1d with SMTP id e9e14a558f8ab-3d8124d0204mr3638115ab.6.1744740572102;
        Tue, 15 Apr 2025 11:09:32 -0700 (PDT)
Received: from big24.sandeen.net ([65.128.108.16])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505dff0c0sm3274217173.98.2025.04.15.11.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 11:09:31 -0700 (PDT)
From: "user.mail" <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	bodonnel@redhat.com,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: Bump link count if longform_dir2_rebuild yields shortform dir
Date: Tue, 15 Apr 2025 13:09:23 -0500
Message-ID: <20250415180923.264941-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Sandeen <sandeen@redhat.com>

If longform_dir2_rebuild() has so few entries in *hashtab that it results
in a short form directory, bump the link count manually as shortform
directories have no explicit "." entry.

Without this, repair will end with i.e.:

resetting inode 131 nlinks from 2 to 1

in this case, because it thinks this directory inode only has 1 link
discovered, and then a 2nd repair will fix it:

resetting inode 131 nlinks from 1 to 2

because shortform_dir2_entry_check() explicitly adds the extra ref when
the (newly-created)shortform directory is checked:

        /*
         * no '.' entry in shortform dirs, just bump up ref count by 1
         * '..' was already (or will be) accounted for and checked when
         * the directory is reached or will be taken care of when the
         * directory is moved to orphanage.
         */
        add_inode_ref(current_irec, current_ino_offset);

Avoid this by adding the extra ref if we convert from longform to
shortform.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: user.mail <sandeen@redhat.com>
---
 repair/phase6.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/repair/phase6.c b/repair/phase6.c
index dbc090a5..8804278a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1392,6 +1392,13 @@ _("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
 _("name create failed (%d) during rebuild\n"), error);
 	}
 
+	/*
+	 * If we added too few entries to retain longform, add the extra
+	 * ref for . as this is now a shortform directory.
+	 */
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		add_inode_ref(irec, ino_offset);
+
 	return;
 
 out_bmap_cancel:
-- 
2.49.0

