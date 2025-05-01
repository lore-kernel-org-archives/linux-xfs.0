Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2DA18024
	for <linux-xfs@vger.kernel.org>; Thu,  1 May 2025 08:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746087372; cv=none; b=VY+YYhcWSV+VTLAFIrgO6zS9AzF84qqwMm74DzWQ/Eb6uAJHgYrIJ/SfY35rS1hv2zZdroYVglTgaOzEhrt7Zx6a0vUMGeIn9v9t/NYCjiVOEYmYQSlLVXOOp5efi6qpgtpg/0HXA5Cb6RhEwvVqIVp0VusxlZWtm9/WurKS5vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746087372; c=relaxed/simple;
	bh=x2oKUJGgAKn1cM9Ab+46+WCM4E/fkU4UKZswt6PrdR0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m7LbVsN7FP2Llm0hTa4dElMC7QPcdmhxU2i2AciJHxCwpEAX+s/HK5+H5rtt0zjuEGUCnzKWxNDVdrDikeFIj1o7WcssoKpfNWtnemX2qTZy8CaGf8yiBraWBIUSlqmw+c959HZX57OY0pEtn3wRUT5YNPgFxnT46gCULgalXGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q25uisMk; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q25uisMk"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5e6f4b3ebe5so1318891a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 01 May 2025 01:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746087369; x=1746692169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PNtfDFhuj1BBq9YY5FIWce+HLvnKZCEJ7ViKFWTJJ7k=;
        b=Q25uisMkRdScKryEh216vz2gWsHxeNyP5y7QW77Ze4pp3jJfnVTGpJk/rHGPKWees6
         lNL2fn2kJapzy6ROPAah5bx7CEwGQjjy0L1rFxAcuK6Z7AVAzP+DG6GNo+IuTjgEDf5/
         OThOnSFN7EqTrXeQlSv5shS70tGwvBXYGx5R436Dt9vPjWWmXx2P4C9eiE9DnIz2snlB
         mNm1LcBG/FL2KE10pZ77ApWFJ6kOIB680DgUxYi1rsSDbsobi2diMtF3OZN24oSvinVI
         tdQJZ0BjGCnRGyFcktlrii5uIlhQnik1oRtYn0pwra0DJB0SWN40oAjJUQCK8Fiju0+4
         laeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746087369; x=1746692169;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PNtfDFhuj1BBq9YY5FIWce+HLvnKZCEJ7ViKFWTJJ7k=;
        b=mO/XiAHKj7G1Rogo50wDsW3uYV4sYGjBzeBErYiQlGhJK3/Aou9deLQdvIuDmo14TU
         OgU7OIMYC5WS8L/IUVsD0Hz4XCusg4RVu3c63fVser4xeOJC1y8tlH0bdg9IqmLDn7cY
         1sjQHg1KJp/+nu+lxlfWGRMP8YjDTzPD3FUt0uEoIQkh9LsT8+7vXPOHvdn7DFgeiQh3
         820VrAGp2b8YlazceXlGs4JkOkBJR8AuDHH5RdHJOgP/ZpX15gyyJyoB5MiF+KMKms90
         MuUCxdUhsb9uSIJuvHUc3gtduMxMh0X+VPdeqYDCrtcHEeSF/ikj4+G0NxxHvUoiZtrZ
         OC/g==
X-Gm-Message-State: AOJu0Yzb/uRhNmZm5KTXJ8/Dw1O+C3q5B/ljHNpNjlrRMzwZzO/YSNEi
	VbfYKdDgz9t8e+mVb++Y1rWMkamYFHn8T1DEnVr5VfgQxgZgVdwOzHlUuA==
X-Gm-Gg: ASbGnct4Y1t2A9hyNxKYb5mOvq1kk5M7P2zcH1rdMYTz3ee+7SgI/T1xlWkpK19o7Xi
	G8mMGJfPZX6EcspZj62OcKscnyjc+g9IbcdGvW+/SYAqkfWQRzK2AqYMVlLFMFKOuWIW6Or4Vjv
	MQx7J0pQpy9A+T/w8sUQ+NrV96X3RT8tkVUbPRTaUjT1sje6JUe3XMwXOzpB+TR7RiSmQi9FeBQ
	JMl7sc4F0G/yJ36GM8sK/mIhR8SiW7O2jn3bT/inlehTtLh3IZ6j1Ars43w41sXw2TnakQ6xSgN
	btww1h/GqMAHeRrOss/w
X-Google-Smtp-Source: AGHT+IFZRhD1XcvvOcfUp8CeNAzdhop8P/dTai9Jo3rcd4b/1hsZBvH+Zr+1tE2ruhD4KGx10kT8fw==
X-Received: by 2002:a05:6402:40d6:b0:5eb:cc22:aa00 with SMTP id 4fb4d7f45d1cf-5f9127e38f8mr1992852a12.19.1746087368310;
        Thu, 01 May 2025 01:16:08 -0700 (PDT)
Received: from localhost.localdomain ([78.210.34.211])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f92fc86545sm109708a12.10.2025.05.01.01.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 01:16:07 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v8 0/2] mkfs: add ability to populate filesystem from directory
Date: Thu,  1 May 2025 10:15:50 +0200
Message-ID: <20250501081552.1328703-1-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the only way to pre populate an XFS partition is via the
prototype file. While it works it has some limitations like:
  - not allowed spaces in file names
  - not preserving timestamps of original inodes

This series adds a new -P option to mkfs.xfs that allows users to
populate a newly created filesystem directly from an existing directory.
While similar to the prototype functionality, this doesn't require
writing a prototype file.
The implementation preserves file and directory attributes (ownership,
permissions, timestamps) from the source directory when copying content
to the new filesystem.

[v1] -> [v2]
  remove changes to protofile spec
  ensure backward compatibility
[v2] -> [v3]
  use inode_set_[acm]time() as suggested
  avoid copying atime and ctime
  they are often problematic for reproducibility, and
  mtime is the important information to preserve anyway
[v3] -> [v4]
  rewrite functionality to populate directly from an input directory
  this is similar to mkfs.ext4 option.
[v4] -> [v5]
  reorder patch to make it easier to review
  reflow to keep code below 80 chars
  use _() macro in prints
add SPDX headers to new files
  fix comment styling
  move from typedef to structs
  move direntry handling to own function
[v5] -> [v6]
  rebase on 6.14
[v6] -> [v7]
  move functionality to common -p flag
  add noatime flag to skip atime copy and set to current time
  set ctime/crtime to current time
  preserve hardlinks
  preserve extended attributes for all file/dir types
  add fsxattr to copied files/dirs
[v7] -> [v8]
  changed directory source validation to use stat() instead of open()
  changed hardlink tracker to store inode numbers instead of inode pointers
  fixed path buffer handling for directory traversal
  handle blocking FIFOs filetypes
  handle hardlinks of symlinks
  improve setup_proto and parse proto using structured xfs_proto_source type
  renamed noatime to preserve_atime with inverted logic
  specify EBADF fgetxattr() and flistxattr() fallback for O_PATH fds
  switch to calloc() to initialize hardlinks_tracker
  switch to reallocarray() for hardlinks_tracker resize

Luca Di Maio (2):
  proto: add ability to populate a filesystem from a directory
  mkfs: modify -p flag to populate a filesystem from a directory

 man/man8/mkfs.xfs.8.in |  41 ++-
 mkfs/proto.c           | 754 ++++++++++++++++++++++++++++++++++++++++-
 mkfs/proto.h           |  18 +-
 mkfs/xfs_mkfs.c        |  23 +-
 4 files changed, 804 insertions(+), 32 deletions(-)

--
2.49.0
