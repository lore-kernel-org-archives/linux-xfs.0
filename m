Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B8115E816
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 22:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712095895; cv=none; b=SLYizTREbTW7vUrvCj2p9YEqy9nuR5aTUtOFnew3CAsUq3sTInexHykwXJ8rtCLuJZH79zwXoSAxqilFbADmSGY6dHB8cCD/+c0qHF0LpC0oMpCXfBRgTcDHUVdY2is5EkVCLhAFgfUH7LS7fYRNfS70eeewlqaafyLevP1NX2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712095895; c=relaxed/simple;
	bh=shBkRx7pA11aQ3YnojI25UdbPvE+X+SpEt8ONzOKls8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hptcvSJ5jkL5p5xOxbuYQ78xsibmOS6Cz9vnJj6/IUizuRnuZeY6GeeS02TGfnr/QNVoHTXavf6dz9qvJ7BRXTvy3CGD6fn0jXGfo2f4m5AF52d4a3x1RRcFuYneRY8qjnozPfvwGFZOPzbzwaYmRrG4rYlKKMiED5BKWqAJzf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kjrCdPdq; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kjrCdPdq"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e7425a6714so4716547b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 15:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712095893; x=1712700693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nv9qAfAy8Ba24HZcFcvtbURJLwcQQ+oY2ruUtgCN9oo=;
        b=kjrCdPdqJ0khGZFZu2mLkX/fHpSMvCtF8sfdtKQMjmW9UOLrAFpCirc0AUZqbTLlCT
         5RNDtuq855IbmHpVD7tHqSdKjv/PMObpwJvex/aw/Ijd7eeIANvE1vCl0veiOcDqb3L5
         TK/uaBDvm0vVYmrq502VXUTX2fPGr7uPsOIqjJ5LrkgN2TTZ/+amtTQiR8mRkI8fZ6in
         aHADjtKq3RDlJpN3QvSpuR+UUmoXjhgVgcSduNzox8REwYm824jWvgqwSDS+2EWOujiU
         u5GEBcuwOU9LJYuDejcpfEMemN4Zhv2Ta+iIUKYuRb4rAQMB02iwIkKMul49vSu8v6yA
         QkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712095893; x=1712700693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nv9qAfAy8Ba24HZcFcvtbURJLwcQQ+oY2ruUtgCN9oo=;
        b=CaXCgIU4Ax2JURkFqYXhIeYf+9nXndH/YB5KH0POmw9voBt59TThLIVv6HSAoN8tXV
         XOlJdCDbh2KZSy6/YkYlrkSYTubBpLgobH0pwjd9CUFUYCLWL25IkwWu1ws5JAruKbTY
         WtXziUVpoSNHU0LlR44ZLX/dwPgMbgFQaQjx6dlvZ9I7YJm218S4GH9MrSe6wY+sHYXi
         GHWQFG7HvaMZ9z6EGBR9C5mQO2z+t0uv29haMJFVv99pAK5lZD3myNqHQU3scOCj+B88
         8icPGK5NeTW9dA8voILUo06vhLQGnAmLnioXsqugVBNaDsOkBasbo6QB7HPll9NG1WHV
         6ihg==
X-Gm-Message-State: AOJu0YxDXNgcBz1y670AosFG3zYxi0nXgitaW5/ej2SHIktVcLKp0UKl
	O8vIJVoXfJDs7qkQ8LgsbkA0+lPOzAvlj8vArjMsnFmhTGFKpanEdge4IBM/kTlhpfGNpG7N9ta
	f
X-Google-Smtp-Source: AGHT+IF9OBCoyxMr4ZgNTst9LeJ79EwBtxzwALljqrxRqqr0vHOOctdufaU69Zj0vhYxv1QuOHEUiw==
X-Received: by 2002:a05:6a00:2d1c:b0:6e5:ea19:bbcb with SMTP id fa28-20020a056a002d1c00b006e5ea19bbcbmr14698488pfb.5.1712095893165;
        Tue, 02 Apr 2024 15:11:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id w4-20020aa78584000000b006eafbf6f1e8sm6640150pfn.17.2024.04.02.15.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 15:11:31 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrmLq-001osP-0B;
	Wed, 03 Apr 2024 09:11:29 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrmLp-000000052r0-2Ooz;
	Wed, 03 Apr 2024 09:11:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org
Subject: [PATCH 3/4] xfs: handle allocation failure in xfs_dquot_disk_alloc()
Date: Wed,  3 Apr 2024 08:38:18 +1100
Message-ID: <20240402221127.1200501-4-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402221127.1200501-1-david@fromorbit.com>
References: <20240402221127.1200501-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

If free space accounting is screwed up, then dquot allocation may go
ahead when there is no space available. xfs_dquot_disk_alloc() does
not handle allocation failure - it expects that it will not get
called when there isn't space available to allocate dquots.

Because fuzzers have been screwing up the free space accounting, we
are seeing failures in dquot allocation, and they aren't being
caught on produciton kernels. Debug kernels will assert fail in this
case, so turn that assert fail into more robust error handling to
avoid these issues in future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c98cb468c357..a2652e3d5164 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -356,6 +356,23 @@ xfs_dquot_disk_alloc(
 	if (error)
 		goto err_cancel;
 
+	if (nmaps == 0) {
+		/*
+		 * Unexpected ENOSPC - the transaction reservation should have
+		 * guaranteed that this allocation will succeed. We don't know
+		 * why this happened, so just back out gracefully.
+		 *
+		 * We commit the transaction instead of cancelling it as it may
+		 * be dirty due to extent count upgrade. This avoids a potential
+		 * filesystem shutdown when this happens. We ignore any error
+		 * from the transaction commit - we always return -ENOSPC to the
+		 * caller here so we really don't care if the commit fails for
+		 * some unknown reason...
+		 */
+		xfs_trans_commit(tp);
+		return -ENOSPC;
+	}
+
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
 	ASSERT(nmaps == 1);
 	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
-- 
2.43.0

