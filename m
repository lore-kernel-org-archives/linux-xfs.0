Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D46716132E;
	Mon,  4 Nov 2024 01:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730684694; cv=none; b=jrNGYJ0Fekh9Jb8zbMQDdSEe7SaCtzDKNJx38bZab5VWq0iF/FxXbiBDygwRFtkg2yt/b2IgGVFZpqoUZZiIjLEzZrxAcABYW0zwR9hmelpw4SGzyuqxazMHdurLcAFsTQoeffX5S7VuLm3Iikh3ZwI7j9EvKmEnDZjGxQoXk2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730684694; c=relaxed/simple;
	bh=tC4PqQJJYcdMyZvQ+5LwuLep63laWjsCpdNbGMW0fbE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YDDvq7oXcyBxBL4PN7LrVv7TMXLJQQGXFlBDn7Sg1x8xZVD6uv8iC+scQD72wSFEma2TFd5es0X2tSUxYE68Cj9USWuvZcDXuhPmH3bZS/0SAP4kFAJnxWL4cN+mX1Za6K1uuY3DcZRbJc2+59xqeMUMdlgMGjANElexp1GApkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TZWjBYzN; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TZWjBYzN"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-720d5ada03cso2338961b3a.1;
        Sun, 03 Nov 2024 17:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730684692; x=1731289492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I6lIXV9swQCB9hiaNbT3cZZ02Y4/nQybP/TZFkA0ruQ=;
        b=TZWjBYzNHC9nm4xhq59SBEBZzt7Jc4s/EzsiZYa2Y2KD5fCaYg8b6b7ij9daluaTmq
         9ILA8L62YTeLvmC2dHxZECIn6SjXK2Zl699iOX8Ujr743Aekn5T4a+MSW2eGeBeeQZCC
         kcauhkouYTFp0K4IHmOXTJxeXL9PHae/gPEolO5V9thKqyXH/5gdLpcAbdm0yAMA74UG
         zoHRYLBJSodUzzVqH7FIuXax81CND7rF69rkJi1aumA0Fczy4XXBPF7unt8jLLJlGagJ
         57n36/iurGngR3865ugfNZesxz58E6JMz7QSLOVlz5HkZP2ONzxlVUJnGdT2NjDjPOLl
         AeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730684692; x=1731289492;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I6lIXV9swQCB9hiaNbT3cZZ02Y4/nQybP/TZFkA0ruQ=;
        b=bTWLqUh9tRAR21lx5GHG0awPRGTx+X00Hru70rn1wJYEiPuRQ4vWt21ZRLPrZG7IuM
         B3MT3a6neQ4uxGqCkln+4SIfQs3+95tpfxufivkdC9+J14zOwYFNa3JANoxQGUcoC5Oc
         aM7HUGwMmqmBzuVWvRDz0y4US5h5Rq1tMBSKSxJtdswOC/kJqbNtKCpw6cx6IX+cznfz
         KWNzhmm9UVRcIJhbHdjOikhJF7VtQbPCwsuZyhYptoDsq+IB8CHrjTsLGbRYUJKDp6bk
         0f7L4OMMaI6Ixvk75By9xe+j9TcFFYW1Md8Om60RUtA5lnwH/Sq20Iu+EcTDoc1rMdkT
         4Exg==
X-Forwarded-Encrypted: i=1; AJvYcCWCVmzzR1+KMuurajv4NQ2XvYr8jIgOYYjJg0lJO08UIM+8pT4BqXQZjhn6qbF8/PJU8/5Z5gx6xTLOpl0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8j6Dc9NgYSk0zSHxHweNrOTv9a0lIUFCWqxqNuabum1sBsyiH
	wJdJfYfaYqhvf3137dfxBvAs/prj/qO//Z5ooJnUoPEtsY0oOmIl
X-Google-Smtp-Source: AGHT+IHk4SnOh645pBIqDhO3u5LbiG0tUTbR3Tv8H9J272pjfh24DygmWBnY5QVFRDM5MdFcf5e13g==
X-Received: by 2002:a05:6a21:2d8b:b0:1d9:28f8:f27d with SMTP id adf61e73a8af0-1db91e533camr21755195637.38.1730684692392;
        Sun, 03 Nov 2024 17:44:52 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:105:216:3cff:fef7:9bc7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1eb3a7sm6360030b3a.81.2024.11.03.17.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 17:44:52 -0800 (PST)
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
Date: Mon,  4 Nov 2024 09:44:34 +0800
Message-Id: <20241104014439.3786609-1-zhangshida@kylinos.cn>
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

