Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C2739ACC
	for <linux-xfs@vger.kernel.org>; Sat, 26 Apr 2025 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745675758; cv=none; b=tTLLhRk9iK00gF7I/WPY7G6XVod73PwGFyUH9WksWm6wcyTCYFeRwaGSBIK32Sh7LrusOShAUF0LYBJ30iJlAyCpACis0+bdtVwZBAL77qQtWb14TskifICtBTMHVVnZZuIGG+HSI8z58DU2NpUlBHmfV/PTHl6Iiv1zrCXIICk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745675758; c=relaxed/simple;
	bh=PASWKcfpo6/WKSksN0SMglNi2bcVdqar54CvuWpCBfI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I/v4K/jwRrc26roWWYYgP6rFqcVtd0i5MXiUUfcVhM06AV6JyGNmS51kgUkXrs/1SbkPIpB7yIlgXwU/T23mesaOO1DN+a5FjHOIwVAigonZiw7ozUgQC57cf6C9cq83Bdpa7RSbhyd1I2qZDMMgakvZt+N1PRqoDpPe4Fo2dUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bVoPPxJW; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bVoPPxJW"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-acb5ec407b1so534427566b.1
        for <linux-xfs@vger.kernel.org>; Sat, 26 Apr 2025 06:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745675754; x=1746280554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AHXob5CpiRgiGi8lrX5AIZh88VJ9Y9ino+4aCq9VFuw=;
        b=bVoPPxJW8EQTwrv4bgOf3ibct+oABqzwzyTCsD4jhdZLx+kdg4bBNE1X6n/LeJjlIA
         5DMhcNxc2e6kK/opmqPdJ7ozYXhGEJ07p8Si2PhAQtMLDOvH438NgAydcsgRJCKbPruS
         Ldnz5BiDKRrEHLhnE5O1v0BF3b5vfqGFQhcsZktL0eSxfeSyqtmoyzeyg44lqhFheN73
         INvrnWrbTsOsUKO2Ni7umfu/D7fEaJ/EDJruoQ+z27OHaLx1gEYVLoElA8VPYW8dppp9
         Ayw7EX6eF49qHblccaetq8nDdmJFlYaQUk2JuEw3/iNeJ6vUg1FPJrKKHY2tGgswfYR/
         4aCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745675754; x=1746280554;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AHXob5CpiRgiGi8lrX5AIZh88VJ9Y9ino+4aCq9VFuw=;
        b=IPi0qeNPfdVyHBo1UcZJqJQnfg/tvOtriTB4CgobMN3ybd3Hv4CnGWosB6zX+PfG4y
         xpgUKCl6Z/nBCB8FZCQCvu/HzUH9VueT+wzvLkv1SuDiRUSbefSOmbRtnjsDDOU3xBZI
         eNVqok8hUd9Q91Q6SSiw2r+O5+vySoiMj32h4fZMZXJT38cJvT6zDbQ8Q8GEYMXBnBT1
         c1EkaQSOCcpqdWA2UFMUnUBQEVLMfVWYptk+u0Jq9y/5eTHyBtjNqXCPrIDEW9//Hztd
         AnHZH/YiMqh0xXNW2hdcOAORDklc7BGJ3kYzeomqDeeLMjSpcRTbOAas0ixIFkTpcidR
         rqzQ==
X-Gm-Message-State: AOJu0Yyj5I/LEkYJBETwmHaj7Pbo7gP678nDqTYRfrfNU2nWVmedbb+u
	vbGodSo+cGaWz0aaArqcMPYQC8eUOc/jjOoV60Bufs6BZ1+sBHBaiDMp8w==
X-Gm-Gg: ASbGncuLHJ91I9SjiY6+XX3A/oSblxIKDWHj6bx0O8InXQl82S8Bv52gAXDGZI+TGBa
	zsZozPL0npndIwhcjMN98bHlLkMWHgpghpZfw6jY3cfM++6/Dn7QpSweVJI29VkhqfSpH2L1REa
	KQRAemGLOjlFBnUo35TN7x+LeCLcI2yq0eKNb2uWkEZV5KMVs+N/fmMSCvKe7P5lH1XbX5bOx/R
	kSM1aPL5hwkfiALouqqDQPEFFZ391XhvC2987QMADNelKSGcjlcFJSDmOOjXuhZ9uNcolpWWAOJ
	+uiFCnfbNPd8QxQ41Bs0eQ==
X-Google-Smtp-Source: AGHT+IHxhBCt0Gp/67cplXE00Rwp0DCVIXZq/uXCd4YoLWAvl5lF821zyNUd9yCxiIVOO/Brr5cxxQ==
X-Received: by 2002:a17:907:3f1f:b0:abf:6aa4:924c with SMTP id a640c23a62f3a-ace848f77f7mr271065166b.17.1745675754315;
        Sat, 26 Apr 2025 06:55:54 -0700 (PDT)
Received: from localhost.localdomain ([37.161.219.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e4e7a41sm298700866b.55.2025.04.26.06.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 06:55:53 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v7 0/2] mkfs: add ability to populate filesystem from directory
Date: Sat, 26 Apr 2025 15:55:33 +0200
Message-ID: <20250426135535.1904972-1-luca.dimaio1@gmail.com>
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


Luca Di Maio (2):
  proto: add ability to populate a filesystem from a directory
  mkfs: modify -p flag to populate a filesystem from a directory

 man/man8/mkfs.xfs.8.in |  41 ++-
 mkfs/proto.c           | 643 ++++++++++++++++++++++++++++++++++++++++-
 mkfs/proto.h           |   2 +-
 mkfs/xfs_mkfs.c        |  19 +-
 4 files changed, 682 insertions(+), 23 deletions(-)

--
2.49.0
