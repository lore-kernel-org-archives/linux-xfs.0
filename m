Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E89C29AB11
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 02:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763953071; cv=none; b=elrjiwaBfBZBkJRUnRrGcK52xzvF5nemRx3gBJNueLuDunwBhxjCg2V2IZ6qFS54FsgPFq8nRws+chS7LKBYEgUf6xRAxS+Mkdpk25TOLA0GYmZOi4+zn+dakxlo+j0rgB3kntd2RSdXq0rJ4Vld6YHruHpUUHbp78cvtG9E9wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763953071; c=relaxed/simple;
	bh=CHhIhTF7NAlbIHo/7TRGjQSC5FGBam+nH0hmtRIrdo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jiGjHe8tpk/1959rPyJITALFddiPJPkhXickwmyXgmvMww2Tlpe5TvIgchAl7HtRvaVobWeVe6IM1BecQWsHGUR5RSplrXiLvFZikGy4OqIyw3QiGRoBMJUaYzBAf+jGy1WbbuxFTvlzjSI8GXBCx0X0uptQXNCoUgGCS0+4WuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jDz/DONC; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jDz/DONC"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2955623e6faso44397665ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Nov 2025 18:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763953067; x=1764557867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNwYZl+W2fvcXiK6f1dLRuPmVDUoM4hiP4tOVDl+CUs=;
        b=jDz/DONCcktAyNl+leNQ33o3sbS/lb4kKl56q4xXHXX/kr0HC7xVs16t0EH9RbWuaS
         0KwWYTJNfWKNSmWU5nt9F2egBjeEU8JYE1re9nCLIvyPnGYtHItQjjPCaUK6mZCk2THJ
         sQ+n3HQTej8WS68aHQrgQmnDJD8x1hPgbE3HX0CNjwhm3B3Cew6qNPGEKO70nx2kbUO4
         HNzmjNzsQNbncqfwsvqK3aQn2m/e/h8JsEbLnt2fI3sKPIeEYiRQMCoktHtqYMW013hm
         rVHp+8UVBJWmNjjEH9B1cI+gVTXO9yznDitJhkS7Py0+rjcP7etm14yoN/BI1lN1U7YS
         sbew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763953067; x=1764557867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sNwYZl+W2fvcXiK6f1dLRuPmVDUoM4hiP4tOVDl+CUs=;
        b=vbeaTHL+PnmJtq/XRrOR2X01MK8i3JLSNBGPDTdNOKj8oS7GJf12FB7PFHIIoItxXr
         AGfrKERk2BmIUbMApjGi/oGA04Bv+j4y0jcQp0XBjUK86t0nalp6gAMv8oK28v4mQdd1
         X1VU+96s+ISFMtqmi5sO72dhmNjX5RqEFxOOZtH/SGgdWlIQ4cqHP7K/IT/UwO2AqSOp
         xb+jE26lNBT4A6Jc9agtMdlioZqKPS+gqb1YgWd3bGAuG7JoFFw/SeGHqu9XOu6/8x45
         hfewXDd9LsXUX2SE+WRvCxhFRpB5ppFTD54AkpB7teNIaZp0OrSSwl4CYAys5fTEmGDM
         hxiA==
X-Forwarded-Encrypted: i=1; AJvYcCWNd79zciT7Azct0CJtxrQa8AAmnuV/MQcD8AhhFnZjII1+1IsqNBpvUqzV7eMlWkCgRLlt4+U3SWE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeHE0NHbVJcnjLpssGRYukXsMKexbHyjhJkL0jwGthHtDl3BMG
	KrLh52VDwENwIfpDshomS9ScDHuCtQgdtK0qQKksHOrpxw6HaxxI5imQ
X-Gm-Gg: ASbGncsSzqGPcVLCa7cfW75+qzTask0GcHR29TzviydbMQkx61AL1P6vlyavC4MUwPZ
	0WwAGCP0p5/VzG5s8QD6eBwXVhB3QaiY+EvelcJwpmVuVPaImTHtJh2nQhQ2AQBEUNW9FNwLYFD
	UYxMXJr9pE/2GREyQGusOPf/4CFHewbHTO8Ml0ymumAthRx6Z6csyaLHFYyg7UoS9Hz7V/9ZoSY
	j2vh5ljjeKtjEdjgPQ20RKRV81etL3/Pxc7exsDxmjpRd/MDKontXwdmWv2fEgui26tFnTVrjmR
	tYol/sfafy47+C15WZYWK3PIQTwfR7tqAQ1DhOhVknlv3A0Ql/uykTeav7hT5Krko68TduCyZ7I
	j7i9Tpiei9Ilb5T1X3pvvtiPDYQWu1XI3nchdwdRiMjggyXgqTTIerNI9h3tSYkj+CekxK63cQA
	U3Use/cecx91tFJRRkiKkf/rgaCauDDobms5oNkNJ0dHpYGoo=
X-Google-Smtp-Source: AGHT+IEZXRFduMWog8lY/WEBRyb3MZQs6kfaoxzTi2A/dpYZvd44wI5EVbBBu8fatXwqYTbLGqTaxw==
X-Received: by 2002:a05:7022:6285:b0:11b:923d:774c with SMTP id a92af1059eb24-11c9d613979mr6980540c88.4.1763953067290;
        Sun, 23 Nov 2025 18:57:47 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93de82c1sm45441687c88.3.2025.11.23.18.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 18:57:47 -0800 (PST)
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
Subject: [PATCH V2 3/5] nvmet: ignore discard return value
Date: Sun, 23 Nov 2025 18:57:35 -0800
Message-Id: <20251124025737.203571-4-ckulkarnilinux@gmail.com>
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

__blkdev_issue_discard() always returns 0, making the error checking
in nvmet_bdev_discard_range() dead code.

Kill the function nvmet_bdev_discard_range() and call
__blkdev_issue_discard() directly from nvmet_bdev_execute_discard(),
since no error handling is needed anymore for __blkdev_issue_discard()
call.

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 drivers/nvme/target/io-cmd-bdev.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 8d246b8ca604..97d868d6e01a 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -362,29 +362,14 @@ u16 nvmet_bdev_flush(struct nvmet_req *req)
 	return 0;
 }
 
-static u16 nvmet_bdev_discard_range(struct nvmet_req *req,
-		struct nvme_dsm_range *range, struct bio **bio)
-{
-	struct nvmet_ns *ns = req->ns;
-	int ret;
-
-	ret = __blkdev_issue_discard(ns->bdev,
-			nvmet_lba_to_sect(ns, range->slba),
-			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
-			GFP_KERNEL, bio);
-	if (ret && ret != -EOPNOTSUPP) {
-		req->error_slba = le64_to_cpu(range->slba);
-		return errno_to_nvme_status(req, ret);
-	}
-	return NVME_SC_SUCCESS;
-}
-
 static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 {
+	struct nvmet_ns *ns = req->ns;
 	struct nvme_dsm_range range;
 	struct bio *bio = NULL;
+	sector_t nr_sects;
 	int i;
-	u16 status;
+	u16 status = NVME_SC_SUCCESS;
 
 	for (i = 0; i <= le32_to_cpu(req->cmd->dsm.nr); i++) {
 		status = nvmet_copy_from_sgl(req, i * sizeof(range), &range,
@@ -392,9 +377,11 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 		if (status)
 			break;
 
-		status = nvmet_bdev_discard_range(req, &range, &bio);
-		if (status)
-			break;
+		nr_sects = le32_to_cpu(range.nlb) << (ns->blksize_shift - 9);
+		__blkdev_issue_discard(ns->bdev,
+				nvmet_lba_to_sect(ns, range.slba),
+				nr_sects,
+				GFP_KERNEL, &bio);
 	}
 
 	if (bio) {
-- 
2.40.0

