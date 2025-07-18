Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FF714F9D6
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 14:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752847701; cv=none; b=sDs9amPB/0zuAF1JLXgYdhgsr+TeibiVJaThOeaGtk906+66qyUojBzk9gm1AU+6dG0PMh40hkcKqM/2vBnEuxrv1NQNViKbFbOd70gx3aXZtedWKn2sXPZdD+C/d+NPnXqP8XNeX2OEB6SUCI6chy5x3YYJaWykgSEqpN69SLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752847701; c=relaxed/simple;
	bh=HPQJbRy98+HWhqVE/lpiEuZWSFNmzvuLc4onxgWZfwY=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TpzUSSMdNXlhhcHe4Sg+t+XLHIgRQiHOAcpBdkCdU2CDZB+lVfLofbOt3OFti8WWBN3vewahJGmn78rERK73xn3ht4FmFKof4S0YsKn9cSyhyJfU/7y6zrkH8V167x/Mh2VG1xyzXCQUnbRBrbwHJszMJWqlAhtCc0SU5HKLnA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UP3Bw8uE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UP3Bw8uE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752847698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=CwKT+DOwFaJvUIHnIX6x08B78hqljTJT008Xra442Yw=;
	b=UP3Bw8uE9gfMgmmiGKuKy536O8dQCPhher+3XEs6lgooOSn7LGh3YkOqVG19fWvs1XGanJ
	bvYoUTjnNLIRjd8ZkkZPOxpRm9bF4oOosbu8qJ0WmCUJE3dBvJrJLyUIgJNGgo7ferEQ7u
	ads46F99bzpcuvoFu8/nT0aUiYen6pc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-HCw9rwSqOxKwRrpiMmqC0Q-1; Fri, 18 Jul 2025 10:08:17 -0400
X-MC-Unique: HCw9rwSqOxKwRrpiMmqC0Q-1
X-Mimecast-MFC-AGG-ID: HCw9rwSqOxKwRrpiMmqC0Q_1752847696
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ae70ebad856so197469866b.2
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 07:08:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752847696; x=1753452496;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CwKT+DOwFaJvUIHnIX6x08B78hqljTJT008Xra442Yw=;
        b=jOsJ3U0lXlAVFjh3HhQNLBdwWGz2hLdDItAI698AH4r5Z8u2UFXR28e0IJtfwJPlRM
         8wkh3uj3RnFc2fm2OBTgwgMM+T4QSS7j3o7AmMoGoHoIusyOT1gcMVrP0aOGAMihBvJK
         Aq1OcSykIeWMqtdzmZ4eYerse5KC3yBsGuYNS62aw6qP31OEopFOT9/E6lFrW2O6JaKj
         RcHWGTC8zC9FvS+lk7cgA31Gwq/ugIGoRYA9UsF5Gudx6VBZPRKNjJTT6RmPMPyDVm6w
         UPcbH31b4K24rFL+Q17X1UWIy4CE78VMRvdT2/wE4UkjsRpHPTvwUCL+B1swBMPE8zDo
         QLGw==
X-Gm-Message-State: AOJu0YxYlNSyj87e12ZkKoDbw09vOYlmBY/xdRT8EddiLWzoEbyYKrvT
	ZfwNQm9IBBaT1JTantnt27R19Q5ws6zpsVPwwrgFxRui1CMEKwGhAH3RKSKyT9Od5Xfc9eJU6vf
	unxBeEQuNbVOmNCrZnxJg1KPbhmQldOIlhW0P5Xau/1z38byUTY6jyY15NU19khlKBxU98E8uSa
	VVz6qKR+DXYI3mGrtEpuv4zRcj6TDdln5AlWSa8aJg7gNv
X-Gm-Gg: ASbGncs3kGuizOfJhfcNdE5EKZOVBv3ShnWYZqgOe4H5AVjgmFfLvFSnMYZG1PWD1fD
	XZjgjQ7XgZvX36tmMPxuke+QbfaAlJvd4WK+E9tksgsnRXfnJ68DHs2ViHxvDSo/FY1aQMyhnsS
	4IEf+CNQaMh5KIypTE6bbYNcFgLa9SQIh0WYmap5CnOoe1bMNEOFPIr+KaMA5LzNt6oxxsL1dfk
	bG0slDZGxzbXlrlv14cbgZ2/5EzFyLOygNVw9w0yQopRIPU3N2hC8Mnc+2d6bMKzZORR3RUpQGk
	N6WA8fy7sYDEpMFhbQDwT4ielvX1S21YwZivmH6XgOr3djqNxaLFVIEivlo=
X-Received: by 2002:a17:906:9f85:b0:ae6:f15e:88c4 with SMTP id a640c23a62f3a-ae9cdda86e5mr1155475566b.10.1752847695925;
        Fri, 18 Jul 2025 07:08:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUJ+NlEtxkwOy4RtgyaY2n8TKgohAGN8si54n5krBdtqYnwfXhhlmJc6qdUq4KMtLfHi0H0w==
X-Received: by 2002:a17:906:9f85:b0:ae6:f15e:88c4 with SMTP id a640c23a62f3a-ae9cdda86e5mr1155454266b.10.1752847693782;
        Fri, 18 Jul 2025 07:08:13 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6ca310e2sm128484466b.79.2025.07.18.07.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 07:08:13 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 18 Jul 2025 16:08:12 +0200
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, djwong@kernel.org, hch@lst.de, 
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 854665693e67
Message-ID: <6bq2774tjncygzlgn4qg4akexkyl6khy5r4rjh7t3fx2e5i35a@coylq7yhv7qn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

854665693e6770c0730c1354871f08d01be6a333

New commits:

Darrick J. Wong (11):
      [1705e1fabf77] xfs: add helpers to compute transaction reservation for finishing intent items
      [4c6a63fdb9d4] libxfs: add helpers to compute log item overhead
      [1ba98d1f4fd9] xfs: allow sysadmins to specify a maximum atomic write limit at mount time
      [fe8cfecb916f] libfrog: move statx.h from io/ to libfrog/
      [b5b477a38244] xfs_db: create an untorn_max subcommand
      [55b28badd9c1] xfs_io: dump new atomic_write_unit_max_opt statx field
      [875e57e81ce4] mkfs: don't complain about overly large auto-detected log stripe units
      [5015906cf669] mkfs: autodetect log stripe unit for external log devices
      [b245cf325293] mkfs: try to align AG size based on atomic write capabilities
      [3423827c2ed3] mkfs: allow users to configure the desired maximum atomic write size
      [854665693e67] xfs_scrub: remove EXPERIMENTAL warnings

John Garry (3):
      [5049ea2e832a] xfs: allow block allocator to take an alignment hint
      [8ccf3002f5f7] xfs: commit CoW-based atomic writes atomically
      [9ae045b77d88] xfs: add xfs_calc_atomic_write_unit_max()

Code Diffstat:

 db/logformat.c           | 129 ++++++++++++++++++
 include/bitops.h         |  12 ++
 include/libxfs.h         |   1 +
 include/platform_defs.h  |  14 ++
 include/xfs_trace.h      |   3 +
 io/stat.c                |  21 +--
 libfrog/Makefile         |   1 +
 {io => libfrog}/statx.h  |  23 +++-
 libxfs/defer_item.c      |  51 +++++++
 libxfs/defer_item.h      |  14 ++
 libxfs/libxfs_api_defs.h |   5 +
 libxfs/topology.c        |  36 +++++
 libxfs/topology.h        |   6 +-
 libxfs/xfs_bmap.c        |   5 +
 libxfs/xfs_bmap.h        |   6 +-
 libxfs/xfs_log_rlimit.c  |   4 +
 libxfs/xfs_trans_resv.c  | 339 ++++++++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_trans_resv.h  |  25 ++++
 m4/package_libcdev.m4    |   2 +-
 man/man8/mkfs.xfs.8.in   |   7 +
 man/man8/xfs_db.8        |  10 ++
 man/man8/xfs_scrub.8     |   6 -
 mkfs/xfs_mkfs.c          | 251 +++++++++++++++++++++++++++++++++--
 scrub/xfs_scrub.c        |   3 -
 24 files changed, 903 insertions(+), 71 deletions(-)
 rename {io => libfrog}/statx.h (94%)

-- 
- Andrey

