Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DB427FD5D
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307788; cv=none; b=R+l+JK+JngAuHAq2BTSa5cC9i6eiLrDZu47CC8oUoH3wB25diPo5Zhv9kYe5W0MMaQckvLKuj57VjcReIRJgfwReLsMF4ElRyGRTDuYbhjDMipOcfHskCzUCojhupOCtboxR1gDwsToEuwRJtUKZrjjVCbGumx+G5usByFTHnjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307788; c=relaxed/simple;
	bh=PPr77puRvCeAT40UGuOX5WZ1/o6gVvC8AT6qc5GzuQg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 In-Reply-To:To:Cc; b=XyJvtFZmpp04eFzDs6LfnU/+J2J1JlzCM/TY8zLZ+FIheMSmrNmXvvvivMgpcPCYdYj0rfJk7ASEhvukkU/XutBpivbUEd5HRUKHStlbTSzm5KhP2xE7lnEeZIUpxdhSQW3U4d0XSOOrFNiA3ol4fm/BYsvG+tWZwmk82CuLlsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gzQFWnoc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzQFWnoc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756307785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
	bh=GoGNdT1TeINSx3pJcevvIE4J9/n+UyYLAaBs2NvW64U=;
	b=gzQFWnoc4CbY7dNgYiDE4jN4ayKXq7RiS0sxm1Jh1s4/IEbveIikjWrTR8IlzkJydk4ZhB
	2viWgsUrY06+vO3tgRrlhH0u3OLNY6HL7TNFPJYMd7rGMOOUhpSwnJj3uTmiMW0MFk99OW
	TaXHLyMHrfk7LVwKFVUgHCHy+/FCiQs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-tZQY_Mm0N8GMrzJ-tzqM-A-1; Wed, 27 Aug 2025 11:16:23 -0400
X-MC-Unique: tZQY_Mm0N8GMrzJ-tzqM-A-1
X-Mimecast-MFC-AGG-ID: tZQY_Mm0N8GMrzJ-tzqM-A_1756307780
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b629ed73bso20732775e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 08:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756307779; x=1756912579;
        h=cc:to:in-reply-to:content-transfer-encoding:mime-version:message-id
         :date:subject:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GoGNdT1TeINSx3pJcevvIE4J9/n+UyYLAaBs2NvW64U=;
        b=h03yHuq59zPv+vfE9o+wCBBVsCvaR/UI9raJiUFSjRzfZCoDu71+9LOuxSVQuNi97l
         xVLxKe3i7taaiFaTNIxyQY9LAtlxOJ2kJxI+2v/rENoz77Xtk5T3v+Xaw4lDLtmlmeNE
         YufA+iMvRWc9RcdOU16v1GcMhECcIdrFL/u9Nhj5nWLq+P2pUzaroBeJstm11ym3jqdF
         0BZKd3/zTPdZ6Zfuvn6Zgp+U7uVDQk23+oLLf5gjjy5uJv2Ns9ymRtSVkVQK9g9TwRCC
         l3HfI3krc6YDP1/l97FqU5EnaRqqdk8I0XwNIXQm50RTWzpdNHYHddYby824g2pSHKbr
         GS+A==
X-Forwarded-Encrypted: i=1; AJvYcCWAb2r4FefU3WSl/E3L77he+43LgtdxgdmST6k5KKRLcTOeGQb3ZIfnO08woss3kbMo0I4XyDou02Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCfAhbHX4TkJv0kYK/A5za6oD9fPVxq6nL2KS91sGDvm34ZGiE
	Ewm/2iIhgf7anTWdA7WeLSf7jHvGXZVKXNeIgSqCnyZ4TJ/odUAlDg9yY60LTPt3900UPIof/H8
	i4RYH2iCT+d+DFyOllQNMy8qS+/5Sh+hO72qrpBW4BTbz+5MhOqTxSeaFgKCd
X-Gm-Gg: ASbGncsghYF/gyQspqnH+6XzjYzL9ZeJds0CUI1DxbBHCF58fz1eDu/kFVNXdOglKsy
	y+zvOV7dXkEIdeoDeGv1CiFDZjDAxYIjU/lPPql/3VsKBhn0cdYqi0eBQ7g/KgDqI24ZpvutkqV
	z8j1BwU881LR7d5ICqUsYyK+yy+/oGdSJ7aLm2HUhGK4OqKCp6syI3PC1Xtdn9THQUPXeOrvo18
	jrDNMmANfRG44Hk1QVVcRwkc2T2i+deD35jkp0wbuQ+XxvJ8ATfqXeKp/Fm5Fw8tDoBLvDIyiLw
	NAlngrBsqaPFBaconQ==
X-Received: by 2002:a05:600c:1f83:b0:456:1c4a:82b2 with SMTP id 5b1f17b1804b1-45b517ad803mr174421015e9.10.1756307779461;
        Wed, 27 Aug 2025 08:16:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSshh7UA0Q1tQ+3feB1Bg+Sb2OMUJ7cAMX5l3HHqsQhNcKfVCBQkB/C/cHAyfVwt7bELFVww==
X-Received: by 2002:a05:600c:1f83:b0:456:1c4a:82b2 with SMTP id 5b1f17b1804b1-45b517ad803mr174420705e9.10.1756307778992;
        Wed, 27 Aug 2025 08:16:18 -0700 (PDT)
Received: from [127.0.0.2] ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6dc1sm35019145e9.1.2025.08.27.08.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 08:16:18 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v2 0/3] Test file_getattr and file_setattr syscalls
Date: Wed, 27 Aug 2025 17:16:14 +0200
Message-Id: <20250827-xattrat-syscall-v2-0-ba489b5bc17a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD4hr2gC/2WNwQ6DIBAFf8XsuTSAVWlP/Y/GA8FFSYmahRCN4
 d9L7bHHmeTNOyAgOQzwqA4gTC64ZS4gLxWYSc8jMjcUBsllw2vRsU3HSDqysAejvWeIyjYohxa
 FgrJaCa3bzuKrLzy5EBfaz4MkvvbXUlz9tZJgnLWa383N1p0V/PlGmtFfFxqhzzl/AAsF82evA
 AAA
X-Change-ID: 20250317-xattrat-syscall-ee8f5e2d6e18
In-Reply-To: <dvht4j3ipg74c2inz33n6azo65sebhhag5odh7535hfssamxfa@6wr2m4niilye>
To: fstests@vger.kernel.org
Cc: zlang@redhat.com, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>, 
 Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1760; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=PPr77puRvCeAT40UGuOX5WZ1/o6gVvC8AT6qc5GzuQg=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtYrOp7b0lEhvrvvh/Ljp3xCofUxbawCiksZlq6t6
 F7dKTvl08GOUhYGMS4GWTFFlnXSWlOTiqTyjxjUyMPMYWUCGcLAxSkAE9nZyfC/oP2OrKljSqlD
 8+duHbN0q8zLWV7s6+Xr0q6q7cuya1vEyPB2RfflhKaFmt1265S3mz++HfBg4T7veRJH1sp85Qy
 1ns8KAJ2MRdE=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add a test to check basic functionallity of file_getattr() and
file_setattr() syscalls. These syscalls are used to get/set filesystem
inode attributes (think of FS_IOC_SETFSXATTR ioctl()). The difference
from ioctl() is that these syscalls use *at() semantics and can be
called on any file without opening it, including special ones.

For XFS, with the use of these syscalls, xfs_quota now can
manipulate quota on special files such as sockets. Add a test to
check that special files are counted, which wasn't true before.

To: fstests@vger.kernel.org
Cc: zlang@redhat.com
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
Changes in v2:
- Improve help message for file_attr
- Refactor file_attr.c
- Drop _wants_*_commit
- Link to v1: https://lore.kernel.org/r/20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org

---
Andrey Albershteyn (3):
      file_attr: introduce program to set/get fsxattr
      generic: introduce test to test file_getattr/file_setattr syscalls
      xfs: test quota's project ID on special files

 .gitignore             |   1 +
 configure.ac           |   1 +
 include/builddefs.in   |   1 +
 m4/package_libcdev.m4  |  16 +++
 src/Makefile           |   5 +
 src/file_attr.c        | 268 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/2000     | 109 ++++++++++++++++++++
 tests/generic/2000.out |  37 +++++++
 tests/xfs/2000         |  73 ++++++++++++++
 tests/xfs/2000.out     |  15 +++
 10 files changed, 526 insertions(+)
---
base-commit: 3d57f543ae0c149eb460574dcfb8d688aeadbfff
change-id: 20250317-xattrat-syscall-ee8f5e2d6e18

Best regards,
-- 
Andrey Albershteyn <aalbersh@kernel.org>

