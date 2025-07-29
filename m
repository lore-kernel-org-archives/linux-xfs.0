Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDE92882C3
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 11:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753786883; cv=none; b=S5r1tO2hy9sTXpzXyMR2HCp/5TZ2PdKGvz+1oM4FpRUxbqnlAsxLX7aipEKAY4YwYYH2PRsK4yOy6Js+oTXcMS7vinbpeEz7+FWFfeg3QAHIuVWZN6Xpdw4jPiTm3qlwAJp5lTXw6oMlG0Iz6DmZetfsrkLyyINC/4kaxidNCt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753786883; c=relaxed/simple;
	bh=+wYrsl1m7MENer8R5W77QZjqfI/e/Urh0hMixYaxerQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y5MP3T4gQ2MoTlrUURJz2YTDqn4B7JThhHtm8+qZvaVI5sspj8tRNDyBYdqQaBEygZEtamoa/2CyJEyKwD5o7wBXowH4aq0pQaj7C7CvD03pIgGct8mPV9SnxxRzx2A/yGouiCZSz7KB3bHH59BtAerKGi4LRbojGBREcnkxZqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OWDbDnH/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OWDbDnH/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753786881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GYA7LUl8keH/ltX8mHT4MdGVQqQRp7+pu6mrc/v+FH0=;
	b=OWDbDnH/KaGEid9FO0n44e2MSZDiVznJ6FOTnhyJG21h+nfSqcth71icv4ECu/gRLTBexJ
	GHEXTBhQWS4JPzCc1b0NCWvLC3pQe0EiLkJmVjUV9wPsjGhd5PrQrYAdDMdsYRGkD0yVnG
	DeTFVhaj5tPE3m9SIXM7tR5BASzUxt8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-D3bIJXINO-6QhhI_2Sjx8g-1; Tue, 29 Jul 2025 07:01:20 -0400
X-MC-Unique: D3bIJXINO-6QhhI_2Sjx8g-1
X-Mimecast-MFC-AGG-ID: D3bIJXINO-6QhhI_2Sjx8g_1753786879
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-612e67cee87so4415923a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 04:01:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753786878; x=1754391678;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GYA7LUl8keH/ltX8mHT4MdGVQqQRp7+pu6mrc/v+FH0=;
        b=b9gLHX0w+/Wl7sVwoaXTt202nbkNU7s3rTj0lo0Sa5TpQTGivfBlmfrDpIw21xlmTZ
         0OrXWJLFnZm3hRw+OeQqgNGYENDMpKgyfIk1TxhTxZg+myH3UEs0C6OtdXZ8gVuIaLzK
         qv/iulVe083bd1ts3aG9cFnQuOMXZbl2OL3ZP7XAumw9Pk2Hn57crn1Qh/gRqrBL/tTm
         5LGiylAhQj5DAap4m4DO5qYUJL6rSsSQ+C52DgqGUXfUu+aSaMM7byaLT2bX3+NkhDVK
         zjW8nat7on034STJmhCnbqkVpqUYGFRQE4iXt2yBHSeS1htJIqB2AL6cCZNcXUd5PT8e
         Lbhg==
X-Forwarded-Encrypted: i=1; AJvYcCVizp0/gLfh1nnGGGJXm70I6kB3FFCnSIwOlKB1C17koxHZSkvNtWayKwgS3uR7VDuwEly5UxS0KOA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5rNM+zfq+nFt+9bqWA2r3uTPSZmML+GYi65XGc+lGF1ANN6/m
	wQei39tVOVQiUH9CSm/UQku8K1FBFSMrzdzdDaxdSElHoMccjOiOrZWcnZaDsOcFldrDLvZ+4Jp
	bp3SpjrAb730y1Zp46KhjKgMsmVMjb+Pi3LtROnPXr78sJhaUYJdPHuA5dOlTDg4bB3A/
X-Gm-Gg: ASbGnctcsBXou5Nbwn4kdqAU142hsQd9QoUG6rP7Io2pWt2ZTMsAxtoGPQnKXuXgB5y
	sGD5pBNCTnl514zoLJmsOSjMUd8WtSw0n6xI/sqWMHUfpdOGBlSxzYIg3OTKvsZfc+mdTSnWfZp
	PyvG/nN/KB17XjObAmy+MNLq00kSXE6Bt79ZZu0QDpo7d4x+zw42fafjXNLRxmgFKzuW1Nl4y87
	r+P/HtUkdVcbjssG04kGuZ2rSiQroT2YNmsyJ6l8YxY7cjRCyyTLDNi52vBXoi0TV2Jn1oHpmaI
	vYoTbczI3aIu6ILbTXwk2w2S/al7w3pKL+IwbfNxOaP6ng==
X-Received: by 2002:a05:6402:4412:b0:614:f5ae:61b8 with SMTP id 4fb4d7f45d1cf-614f5ae7748mr13464793a12.34.1753786878420;
        Tue, 29 Jul 2025 04:01:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgnjHwM0gOxerwKKl4L9hLajeki/xz7hW8tkZNNb3tBJgA4DSR+EKsPGCxeKQD0vI9RUHapw==
X-Received: by 2002:a05:6402:4412:b0:614:f5ae:61b8 with SMTP id 4fb4d7f45d1cf-614f5ae7748mr13464753a12.34.1753786877923;
        Tue, 29 Jul 2025 04:01:17 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61563b3edd8sm1083884a12.47.2025.07.29.04.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 04:01:17 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 29 Jul 2025 13:00:37 +0200
Subject: [PATCH 3/3] xfs: add .fileattr_set and fileattr_get callbacks for
 symlinks
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250729-xfs-xattrat-v1-3-7b392eee3587@kernel.org>
References: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>
In-Reply-To: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>
To: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=976; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=+Lxyt4pb2Z8hR2sPagBTuDL7znviXoPTowE2dopI/ac=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMjpW/lpjY785XnB21drSE2uqtTo+1K7ONnn46bW62
 G4BPa8PFsEdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJuK9iOF/lY6YhE7ezm4m
 zbQyvd7wModrbzPSp5Xz/13BosjnzfOfkWHS9dUCFw6UrmYTaXI4ovJxVvZfPUbpHSqPo8NnfHu
 eeo0LAEAmRlM=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

As there are now file_getattr() and file_setattr(), xfs_quota will
call them on special files. These new syscalls call ->fileattr_get/set.

Symlink inodes don't have callbacks to set extended attributes. This
patch adds them. The attribute value combinations are checked in
fileattr_set_prepare().

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 149b5460fbfd..c1234aad11e9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1334,6 +1334,8 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.setattr		= xfs_vn_setattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.fileattr_get		= xfs_fileattr_get,
+	.fileattr_set		= xfs_fileattr_set,
 };
 
 /* Figure out if this file actually supports DAX. */

-- 
2.49.0

