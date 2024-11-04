Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4646FD5;
	Mon,  4 Nov 2024 01:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730684467; cv=none; b=M84g2e03nET1DJGTejXOpt8YtIgHlCa6vQePb7f96Y//fMOQXqcbJqtZTb30p/BaifG2tfMqP4uQexCvMjXpV/ohk3TfeWHx482G7yIcaa+VJczDhO6Ku92p0lnURSBPPtjgL2n4Hd5wy+2VRb/+bppAkKebwPUeXa93FAh2KyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730684467; c=relaxed/simple;
	bh=tC4PqQJJYcdMyZvQ+5LwuLep63laWjsCpdNbGMW0fbE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gm+nE4+uP2sWwvkx+sxKQkO+wX1z9PwNUQbquYZOSOVczjyOs/gt5KTf8wZXriicEKlc52bwN38Dj9WhYZ2SE7vLnc6jAr0/u0fuJccmig9m14aY3Gzp70vFIprFMt+FIVZN6+3tYim97QJdzaspjAb8fAgnj6u2qecZW3//YvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eMY5SUM7; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMY5SUM7"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-71e7086c231so3072560b3a.0;
        Sun, 03 Nov 2024 17:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730684465; x=1731289265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I6lIXV9swQCB9hiaNbT3cZZ02Y4/nQybP/TZFkA0ruQ=;
        b=eMY5SUM7qhj0VMgR09cTivyXIyQG3kL8ZgbuBgZB5oCDJYOGCpk9ik2bD0TeQYaW9S
         oXGmepFYwnhdTiiSpCBHngxLSw92v1+vAsB7t4okLGsL+Ipogk+LYojQ/mTi3qhFnClK
         96X6rG4Lfin0rIi7Sjjyi3oO1WuFflD9f/d9W6Xu0gaFK4jm9Byl+MokMccerBjaffUU
         RBIAYW8pE4LJWS8pfnF5QkmqouE+KDcxNZauBd/+Y/rAjgszFzr9/a4wGfvZllPLWkM4
         JiYQj3inoj3xNNcqL667+NkGuBNxHNDNW8HAN/klkKuWSa93YYYpxmA/8JgY0rbbUEv4
         +bJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730684465; x=1731289265;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I6lIXV9swQCB9hiaNbT3cZZ02Y4/nQybP/TZFkA0ruQ=;
        b=KZj/yGt3BLtgqc5GMHL6nOcbwLqXVLBYnDGZXv58hhBD4r/j3ySCKOWZmXB5jKHPIx
         1Iity6B+LHEFxvnX2xk0MWd75ZF8a2uolFyMEKvQk+97p0pUDsl0kjB1EC923FsVcQ5v
         5JM6NbTlLDi6N2EdiEJ3oNgrhSy5ioG/qzXCDiAvkgl0kdALjaOzEV5OUNiRvDEpJBvF
         xoHWgTA809CEyC9up5Qp/dkx2hH5+mXIkgPLFGFlSPzpjUB2yOk5apy3nzRhvDMHb4oK
         l9b9Enz/Byu2MsWK8FBnAYx1wgv9tx4z8jUNxbfZ4rTa7BMfdIvZEJwS00/gXOiiCjdq
         shvw==
X-Forwarded-Encrypted: i=1; AJvYcCXThPCSREuhVw2NP484RcjDEq33obO74llYiqpHJCgpWEg1sw/B5Ccw9NW466tt2Jq0bZGv5Do0r6nRn9w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKDQsJ5+uIW7VUUt+M/Vn6J5YPwY+99M9MCy6lFX2VJH1lv+PK
	0qtnPX1NcogSNJXzUqQRrZI0PSdpZVBkkpjNiaNf0c0D6HfylcRK
X-Google-Smtp-Source: AGHT+IEleneOzPh8AcU0YpyHeBsvSXiWFO8A4OagbGaaN0pkrKH4OXemu5YZHxUMCuxXv/PDznx3Pw==
X-Received: by 2002:a05:6a21:4d8b:b0:1d0:2531:b2b9 with SMTP id adf61e73a8af0-1d9a851ef40mr39255164637.36.1730684465021;
        Sun, 03 Nov 2024 17:41:05 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:105:216:3cff:fef7:9bc7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1e5995sm6238815b3a.70.2024.11.03.17.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 17:41:04 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: djwong@kernel.org,
	dchinner@redhat.com,
	leo.lilong@huawei.com,
	wozizhi@huawei.com,
	osandov@fb.com,
	xiang@kernel.org,
	zhangjiachen.jaycee@bytedance.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH 0/5] *** Introduce new space allocation algorithm ***
Date: Mon,  4 Nov 2024 09:40:41 +0800
Message-Id: <20241104014046.3783425-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Hi all,

Recently, we've been encounter xfs problems from our two
major users continuously.
They are all manifested as the same phonomenon: a xfs 
filesystem can't touch new file when there are nearly
half of the available space even with sparse inode enabled.

It turns out that the filesystem is too fragmented to have
enough continuous free space to create a new file.

Life still has to goes on. 
But from our users' perspective, worse than the situation
that xfs is hard to use is that xfs is non-able to use, 
since even one single file can't be created now. 

So we try to introduce a new space allocation algorithm to
solve this.

To achieve that, we try to propose a new concept:
   Allocation Fields, where its name is borrowed from the 
mathmatical concepts(Groups,Rings,Fields), will be 
abbrivated as AF in the rest of the article. 

what is a AF?
An one-pic-to-say-it-all version of explaination:

|<--------+ af 0 +-------->|<--+ af 1 +-->| af 2|
|------------------------------------------------+
| ag 0 | ag 1 | ag 2 | ag 3| ag 4 | ag 5 | ag 6 |
+------------------------------------------------+

A text-based definition of AF:
1.An AF is a incore-only concept comparing with the on-disk
  AG concept.
2.An AF is consisted of a continuous series of AGs. 
3.Lower AFs will NEVER go to higher AFs for allocation if 
  it can complete it in the current AF.

Rule 3 can serve as a barrier between the AF to slow down
the over-speed extending of fragmented pieces. 

With these patches applied, the code logic will be exactly
the same as the original code logic, unless you run with the
extra mount opiton. For example:
   mount -o af1=1 $dev $mnt

That will change the default AF layout:

|<--------+ af 0 +--------->| 
|----------------------------
| ag 0 | ag 1 | ag 2 | ag 3 |
+----------------------------

to :

|<-----+ af 0 +----->|<af 1>| 
|----------------------------
| ag 0 | ag 1 | ag 2 | ag 3 |
+----------------------------

So the 'af1=1' here means the start agno is one ag away from
the m_sb.agcount.

We did some tests verify it. You can verify it yourself
by running the following the command:

1. Create an 1g sized img file and formated it as xfs:
  dd if=/dev/zero of=test.img bs=1M count=1024
  mkfs.xfs -f test.img
  sync
2. Make a mount directory:
  mkdir mnt
3. Run the auto_frag.sh script, which will call another scripts
  frag.sh. These scripts will be attached in the mail. 
  To enable the AF, run:
    ./auto_frag.sh 1
  To disable the AF, run:
    ./auto_frag.sh 0

Please feel free to communicate with us if you have any thoughts
about these problems.

Cheers,
Shida


Shida Zhang (5):
  xfs: add two wrappers for iterating ags in a AF
  xfs: add two mp member to record the alloction field layout
  xfs: add mount options as a way to change the AF layout
  xfs: add infrastructure to support AF allocation algorithm
  xfs: modify the logic to comply with AF rules

 fs/xfs/libxfs/xfs_ag.h         | 17 ++++++++++++
 fs/xfs/libxfs/xfs_alloc.c      | 20 ++++++++++++++-
 fs/xfs/libxfs/xfs_alloc.h      |  2 ++
 fs/xfs/libxfs/xfs_bmap.c       | 47 ++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_bmap_btree.c |  2 ++
 fs/xfs/xfs_mount.h             |  3 +++
 fs/xfs/xfs_super.c             | 12 ++++++++-
 7 files changed, 99 insertions(+), 4 deletions(-)

-- 
2.33.0

