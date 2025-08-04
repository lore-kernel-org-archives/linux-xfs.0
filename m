Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F622046A9
	for <linux-xfs@vger.kernel.org>; Mon,  4 Aug 2025 12:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309316; cv=none; b=gijF6qN5QPh1xDhRKMsp+mnQ+gsI4Ghw8EXS3h3txc4p8ZpmmtaptlkV2AJS3IAxJ01Jish8Xgtq9ID2ERhqnsZzgMj7X7NSFg6MB0M0piN4dfkJmdTEF/qy97wn9FwMvLZqgDqGKDd0HDinMCyw85qBQ5nGLNO5ov5YwtU+hmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309316; c=relaxed/simple;
	bh=zGUR9DpansGJXstIciFJ6TgR/4+TAzouRHMrN3dVYD8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=VGKuqZwM6U/usIILB3KcwMNJSqVGNFj8hlxo9P1ASCzJZIM38m18NY24hNkINrxviB4tk2n9V6IwIvyUbs/LDljjmJD2nFkcGuIaqiUwi5/OUobrYJSMDFCMvn21rImzCo9/clxk/eUWzDhiPYlteMD2ACLNxqp+22AsDuIqn5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gJaQ5msh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJaQ5msh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754309314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+juhKJLRasyryJIZ07BPSgVKdQPnC3B3zRrA0jMHHXQ=;
	b=gJaQ5mshACeThB0fm5FT+5nTVsNxyDLD9+fY5mOr6xpKRTKsQEHspXQDOJohf3ad05pMtB
	huzguw8MHTjn3CT5dWhRsj/EX42Dra+0wxBHJx47bAlMQWfdybN2BGE5eSiZvnf/f9es6k
	tcQAEYd+KYx+DvsYoihSOfc9Gwpqd3c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-sB6H9rA9OQu46YgTyoUk3w-1; Mon, 04 Aug 2025 08:08:31 -0400
X-MC-Unique: sB6H9rA9OQu46YgTyoUk3w-1
X-Mimecast-MFC-AGG-ID: sB6H9rA9OQu46YgTyoUk3w_1754309310
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459de0d5fb1so3345915e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Aug 2025 05:08:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754309310; x=1754914110;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+juhKJLRasyryJIZ07BPSgVKdQPnC3B3zRrA0jMHHXQ=;
        b=aFdjAZ4k6bCvdzT4wDEwFVNVZ1LFWIS5y+LWeYOF54SjUkyC2dRdQFEYq6zyJy4H7+
         FbwgkTVs2pUFtIw1rbyeDNSD/wkLzqabtMA9bS+ZoNLjT/kznWdZPAC0higL5t0rcJIX
         LstBmubmK7Xq3JGZJ1r97dyRZa0oc3R6pzsnviPEAQwvA7Hw3xYrhHatNzG77PMIx91z
         Oz42Z6J+bMI17aFYRW+3XjqzPB1qZ3xfd2FnU37orYjor2rlZr/sbkt9DtMQAADpHeZJ
         dN2klRuvf0Rv9VSpa60+8it4rdTdliJSul1L7Nn2/mH50sgJvFjiMEVgriq7lOWRehjM
         B7vw==
X-Forwarded-Encrypted: i=1; AJvYcCXsVNnJ83nGDvqmrcruERlmCmgMeD9LG2shIUWXvUxGSpYDVe0KqR7HAp4wooNNld+yfIyS7+4+6to=@vger.kernel.org
X-Gm-Message-State: AOJu0YydG1650swzrQJSvQiLvNulrp7HyL2RxYr1kgvEzuXbwWVg/m2+
	kYD4UqKyUuMxq3EmdrtzhktnOe2vjDpXyoXYayZ6bYXfuUf+epXxlNSc80LKKv9hW03JdG/WaRu
	sig1/Ja+czd64502+qWgJa8Co8VAyIfjZNBmSlaSYbinyB/3XJCAJQhyvUkjX
X-Gm-Gg: ASbGncu5/SgdUuyW2WBp9GVoDEWss7cvhuwdbS16+bn4FR1RdSpReFsOFf2MsUSU6vR
	1PTSFYrCOh7yyqxi/Plog1sSM5L8veXZPldDoKloFcVOaH8NGXJbyRXFs8rGY4SMpvrStP4Js2R
	23tLQ5pdE2Nrteeeu2B5M4IuR6kvHU4/yl1PLEAo+PADunJiAS+0vXqtNiXhFfI7la7m3OyyUSv
	Hly7moPcs5+d/o1U9pDyFA2NDpJ6Oj5/IBi8i3YlVAmr0CdiL0DWkGONlM8S+Npw8jCy4yUzCaa
	6egwmW5tQWj/8Pd3FtAmI13imEeaeZIhTSJ8b7wZzilHKw==
X-Received: by 2002:a05:600c:1382:b0:455:f59e:fdaa with SMTP id 5b1f17b1804b1-458b6b3066amr69030515e9.21.1754309310356;
        Mon, 04 Aug 2025 05:08:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXxMwtOO5ml8lNLq1//EbF/khCCFiDqjX91sgHh5BBDJ+MFnHs5f8sHA3NRR4Yj4PvxWM/Qw==
X-Received: by 2002:a05:600c:1382:b0:455:f59e:fdaa with SMTP id 5b1f17b1804b1-458b6b3066amr69030235e9.21.1754309309873;
        Mon, 04 Aug 2025 05:08:29 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589ee4f239sm163962675e9.21.2025.08.04.05.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 05:08:29 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v2 0/3] Use new syscalls to set filesystem file attributes
 on any inode
Date: Mon, 04 Aug 2025 14:08:13 +0200
Message-Id: <20250804-xfs-xattrat-v2-0-71b4ead9a83e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAK2ikGgC/1XMQQ6CMBCF4auQWVtTpjalrryHYVFkCo0GyLQhG
 NK7W3Hl8n/J+3aIxIEiXKsdmNYQwzyVwFMFj9FNA4nQlwaUqKVCKTYfxeZSYpdEp2pnvaYemwu
 Ux8Lkw3Zo97b0GGKa+X3ga/1df45B++estZDCdMoiESndmNuTeKLXeeYB2pzzB5NNMS2nAAAA
X-Change-ID: 20250320-xfs-xattrat-b31a9f5ed284
To: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1077; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=zGUR9DpansGJXstIciFJ6TgR/4+TAzouRHMrN3dVYD8=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMiYs2hvMy1Lf98u4UvAAU7do3/5VPiZXDs/te3Rl3
 wS/hfzK1QYdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJiIfzcjwMvQkw7+DEoIR
 k6p/3nr4lf3hk6rZm1yLHl+L4mz7oP9/LsP/gm5NdTfBO+ky3zdtO9O+99G8Vb+5Klev1tVe3PS
 Ov/U1AwB060sI
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

With addition of new syscalls file_getattr/file_setattr allow changing
filesystem file attributes on special files. Fix project ID inheritance
for special files in renames.

Cc: linux-xfs@vger.kernel.org

---
Changes in v2:
- Swapped patch 2 and 3 as it make more sense to add callback and then
  allow calling them
- Replace "file extended attributes"/"inode attributes" with "file
  attributes"
- Link to v1: https://lore.kernel.org/r/20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org

---
Andrey Albershteyn (3):
      xfs: allow renames of project-less inodes
      xfs: add .fileattr_set and fileattr_get callbacks for symlinks
      xfs: allow setting file attributes on special files

 fs/xfs/xfs_inode.c | 64 +++++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_ioctl.c |  6 -----
 fs/xfs/xfs_iops.c  |  2 ++
 3 files changed, 36 insertions(+), 36 deletions(-)
---
base-commit: 86aa721820952b793a12fc6e5a01734186c0c238
change-id: 20250320-xfs-xattrat-b31a9f5ed284

Best regards,
-- 
Andrey Albershteyn <aalbersh@kernel.org>

