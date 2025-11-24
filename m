Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A7F29B8E8
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 02:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763953072; cv=none; b=OFEa/fUZmDIlydTQNgGFXTnnp2ohP7nIO89Dj6CbXwZF1kkx3nlJ95MYGXM9o3qFMkPcFkDZWSvEwQnW0zQOdWV80haoNRsqz2915bBuNpjKEMaTztD+3AUveAKOjffFLgZELXEHnFGEeWz6ci0RMtqeJ5o5GkDo0J1Nyj5DW4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763953072; c=relaxed/simple;
	bh=1rxomFQWvF3IATN9kucOuHHGa2FB/YCgzDqnGWQM12I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eBdfwADcVzRLNaNMMdsaVwPrAoqOuO4FiKx6dHCkguCo/++aU2RVSzu0ZSeLHS0CY0OPG4gTWrPH4wn/PdxTzGfWeK91suq7MHt14hUE5I5j4eapFko30Skq75UlHjdOpMPQVYcOwhgsXKZNKSrjMHx5rTmigH6cwnG7PPPeWVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=azIjdVI3; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="azIjdVI3"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b99bfb451e5so2494338a12.2
        for <linux-xfs@vger.kernel.org>; Sun, 23 Nov 2025 18:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763953069; x=1764557869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7A/o1KMdHnERZPkaP005IU3nW52A8GrE+BEL9651kiM=;
        b=azIjdVI34KdCDfW4btCpFmAICXA7gD8DN3FA10SiAzUACJZ146vWSjuI6oEtkye28F
         zJIhsxt3btUYjxbiupNX8VLujqiH7qQ2s9iaxtoHfHD/6jlG+sirrXUWQp5LF7PFoNSR
         sIipqOcsR9kEA9S+/+D2kRyJNdccpwTsNS1UIqzy0d43FO7DQ5t8DzqkICEBy8S/obNF
         5SO3ILAiFwWwKmiBuG5py/BU0pKzvRIlDoOclvB0EEnA4YPIlUU+TfO9j755NT5OzLAA
         ofABhdoKpj3fzVuWJtdCkZkLZYFw0fy25FF3M2Gj6hcbHEdCp28wEVQ95thYDK9TSo9H
         Mp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763953069; x=1764557869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7A/o1KMdHnERZPkaP005IU3nW52A8GrE+BEL9651kiM=;
        b=wqwsKuavTIiI9hkP1XiiqpgvunHJYmNjFHZwvGeajhI31N7wrvxWsQ3eOxmZI0VQ7M
         lVk7BsTpgNTPypfjAL1ccGTmxJhK1emIJfuHzoypDHAAgsn+oBdoRGTK3dF94ezJs6S+
         EWQcBQfoEdiMN6EpCwubUSvkchErgWkL2VO8Adl9+97qIIj+Af4zCcXCRzNyQx4wmUwV
         Oz3qBw6Tst4KZUAN2LrdccWdIVIecmQKnA2k6ejgosBdEXpDCyHeyTb9XvrsvawTcZg2
         jE+GmwxpofP0V2Mf1EIOev0sBK5wBUXJQukrr6mZmpwBCsvid1/geEUtT5leUSLvM6Vv
         qkKw==
X-Forwarded-Encrypted: i=1; AJvYcCVym6xvSCER+iQq3KdZIoLdoOHV96KLtBsUj/N4WJCYw2fgn5Ba7tE9Ic4m0u2duwVJbRDnsUG9meE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeiCdziur+L4gl2slZHp3DirjCGWk5orwE5KYTPJYsSxWBv6Nq
	kXOkxW+NsSQ1lDQzjJZmmdwgWRdmejNPucwk07V9mfa4PM2GtKKoKFRY
X-Gm-Gg: ASbGncsxyfzZt6PXZUM3fyvFVN3ov2Mlacp4csaXKaR4dH40GES/fV9iTnMJYFNpxdw
	3GCs7yCuPhcZ8EcQ9iHHEQFAuDzvonT4Jedvoal82iYCOQejdUZbD8WogjzSG/Z2uy2GUilzSwK
	RZX5xaeEIcWch46r3Z5IK2BtODy6ciI6ppVfRdjxmiXoVZ7/LOWnPLLc4zl7SJ/qha2SdOKWH1f
	QQa2gmNPI0j8QkOnbqVyI+2cbiXPeo+uaG6izxMgzckYCrusZmwOZA+WASyVbRXgCRzNizMviCd
	9WMgv2kgnZVlM0sMve8te+8gx1Brtj8FvlqKnFjXl/DCXyEG4cGfJ8SqsK+habxY7KoyhKkA2dW
	p5G4kCd9bdhcfVA9lr+AB1fdBiNm0unbl1dk4H+fZ0yDRtZamRGNf9HHXsPQtBrL1+r6e8OocSS
	NFhxNrn13qZiuWqfzTIxiSFrn9AdC4eTdGUXUfVB4SFu5dmSs=
X-Google-Smtp-Source: AGHT+IEmMLANDAnmsBNCneTvCZSlRusetXy+m9HCywmHN66AM/499qf8PoyOZ4xW94y10CRf7NdkQA==
X-Received: by 2002:a05:7300:538c:b0:2a4:7cb9:b7da with SMTP id 5a478bee46e88-2a71927d85amr6563682eec.25.1763953068821;
        Sun, 23 Nov 2025 18:57:48 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a6fc3d0bb6sm67532109eec.2.2025.11.23.18.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 18:57:48 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: [PATCH V2 4/5] f2fs: ignore discard return value
Date: Sun, 23 Nov 2025 18:57:36 -0800
Message-Id: <20251124025737.203571-5-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making the error assignment
in __submit_discard_cmd() dead code.

Initialize err to 0 and remove the error assignment from the
__blkdev_issue_discard() call tp err. Move fault injection code into
already present if branch where err is set to -EIO.

This preserves the fault injection behavior while removing dead error
handling.

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 fs/f2fs/segment.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b45eace879d7..3dbcfb9067e9 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1343,15 +1343,9 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 
 		dc->di.len += len;
 
+		err = 0;
 		if (time_to_inject(sbi, FAULT_DISCARD)) {
 			err = -EIO;
-		} else {
-			err = __blkdev_issue_discard(bdev,
-					SECTOR_FROM_BLOCK(start),
-					SECTOR_FROM_BLOCK(len),
-					GFP_NOFS, &bio);
-		}
-		if (err) {
 			spin_lock_irqsave(&dc->lock, flags);
 			if (dc->state == D_PARTIAL)
 				dc->state = D_SUBMIT;
@@ -1360,6 +1354,10 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 			break;
 		}
 
+		__blkdev_issue_discard(bdev,
+				SECTOR_FROM_BLOCK(start),
+				SECTOR_FROM_BLOCK(len),
+				GFP_NOFS, &bio);
 		f2fs_bug_on(sbi, !bio);
 
 		/*
-- 
2.40.0

