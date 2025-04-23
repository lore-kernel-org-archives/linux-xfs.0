Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEC8269B18
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 08:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396595; cv=none; b=dug6NjMpS7l7XeBtgJHaL1UtqVEWJKB5plxmglvXnd4NXZDpCI9qMLhqbGi0i2srgavgWN/A/6rOT4kTtYRJqtK5yPR93yZ6q3wWKv5eTjU/Be4fBanCHoYxcag4fI9GcUBbMWKu0Tbp02NbH+8yqnglMggfSK4xRJjeVDKj08I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396595; c=relaxed/simple;
	bh=9mCDpu3PTcE2v7m3rOZ0THZoCIavdabOsp4eL6qQKZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fJkySjX/nIfw0ln5enVuR/0xNM9e7uBCT2GAECan7QStuRopJCsSHB/88okRCnV31Uf2WslsnoJCKQqzqj5Ut3Kj+CtO7jmSdzRlZT/L89kUS/rfuiCl0vXHjDGFju9uaDSaje/8G4R7I6XlJUoX8CIEn+cb7v4qCWuKSqb7NFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aJvQDM8d; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJvQDM8d"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3914bc3e01aso3727221f8f.2
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 01:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745396592; x=1746001392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DLAq6Lekm4rXea8nnJVoOY/u6a3uNd8PMN95ZOq3dgc=;
        b=aJvQDM8d4pk4+0JUHXEh4mJNe4WvfdM81s9vwUTjEmed4SZuboFwGM4Q7KAli3TDWk
         RSA+L6Dawb5FyLWBSDKR72XNHABjlNh1S21Hvo4CiUQjgRiYqSOQorhArsZd6sfwwL7L
         t3bPDGrG77N6vtgvUWhNVhaDXrRIHDKtLjJc6tDJ1e1nTq0cfD7prscDpxQHkCXOYgY2
         QS7jVbPxRwb4FBicUliAUSA3n/JZVpF1YvgX4+1+gbxcC18qOfBLJmso3q1pS/LRoQZl
         yiPicS+J2tzWp0hIgepMHPt4VOy4mxssb34f6LP77mjWtaidgOXG+WhRgp+EsmRpGMyh
         PZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745396592; x=1746001392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DLAq6Lekm4rXea8nnJVoOY/u6a3uNd8PMN95ZOq3dgc=;
        b=gj/HyG/0Tqm2gGJeVI55nL014epAGNRUmS348EnINyF+J6HimJ4zesn0bf+t6owrLP
         sHQtvErlBdIrhWUdVp1SbQ+VsNR9TUGz4wEWnfMrobkGLHTj05tbRMQff5nBwKXJcA6y
         jZV5pj9o3+Zo2+fDwclk/iZoJR21CqDtNJBKEHNIRJD6ieUARwWY6KUzfwK7R/Ht1xxi
         BWpfuHBZKfWoK6O2pMM93OoJIYnPtqq/TNQnavG5Ow/qV5RK12w5b9xs6so+X4LRB84M
         wGduvXtME+sA7EYZg2jKY0jq5oZ260F9p4uuvDFmdYBPL8d77sKcPc7KD/ZWv6vw8BcQ
         iXdg==
X-Gm-Message-State: AOJu0YzoWRL/oSQMAUnUW5ihYc0twNlTeqQGxhwjj3SeNKt9aglovy/d
	9UrhAFrJq4DtSjP69AVQaZRC/O8V5ZUh//ydS2ZjTedUAVwVc8jshDCZFQ==
X-Gm-Gg: ASbGncv2Bl4UDYOs2SwDpSEP6ALqWJ7XoD+9umpC0JhrXEHxVck8yFdD4kmHBqcZwXp
	tC3lY5n7vWF/3GyBcDYtjMrNvKFbPznzKabGppTRm1DA8gWpGdw6iknD83OkSzXJGNcV/lbaw/o
	B7fTHeCpfYPvEGLTrIuuJbj/h3cR9Qt4pqIzTHrug1y+81MBxi9wK7yXb49B0dK7+OMYI+ItjPN
	gBVGXFwVajP1EP3yqEEf0lAtU/83QWpNHl1y8+3pCAATAmjJiG4CbF4oyFki4i06T+P9DioZeoy
	UQiOwRZcRw2cF4x3KpH8xxoTygKZ55M=
X-Google-Smtp-Source: AGHT+IEYhzLMHXTguVyiVeI5jTGoqIb/+MyiI1BtqAbbeEPC60AzKR520rqHffaExDHFINuX0kHBJg==
X-Received: by 2002:a5d:64ef:0:b0:399:7f2d:5d23 with SMTP id ffacd0b85a97d-39efba3cbc6mr13985186f8f.14.1745396590998;
        Wed, 23 Apr 2025 01:23:10 -0700 (PDT)
Received: from localhost.localdomain ([78.208.91.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4a4c37sm18345313f8f.98.2025.04.23.01.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 01:23:10 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org
Subject: [PATCH v4 0/4] mkfs: add ability to populate filesystem from directory
Date: Wed, 23 Apr 2025 10:22:42 +0200
Message-ID: <20250423082246.572483-1-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the only way to pre populate an XFS partition is via the prototype
file. While it works it has some limitations like:
  - not allowed spaces in file names
  - not preserving timestamps of original inodes

This series adds a new -P option to mkfs.xfs that allows users to
populate a newly created filesystem directly from an existing directory.
While similar to the prototype functionality, this doesn't require writing
a prototype file.
The implementation preserves file and directory attributes (ownership,
permissions, timestamps) from the source directory when copying content to
the new filesystem.

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

Luca Di Maio (4):
  proto: expose more functions from proto
  mkfs: add -P flag to populate a filesystem from a directory
  man: document -P flag to populate a filesystem from a directory
  populate: add ability to populate a filesystem from a directory

 man/man8/mkfs.xfs.8.in |   7 +
 mkfs/Makefile          |   2 +-
 mkfs/populate.c        | 287 +++++++++++++++++++++++++++++++++++++++++
 mkfs/populate.h        |   4 +
 mkfs/proto.c           |  33 ++---
 mkfs/proto.h           |  22 ++++
 mkfs/xfs_mkfs.c        |  22 +++-
 7 files changed, 352 insertions(+), 25 deletions(-)
 create mode 100644 mkfs/populate.c
 create mode 100644 mkfs/populate.h

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>

--
2.49.0
