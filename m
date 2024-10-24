Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7D7482EB
	for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 02:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738310; cv=none; b=aj9rSqrEzVnOyMc04V/TmM22xPNwWDGJwZPxWyIjfqNqvSWfBZ318y/AiEYvhzWQV5FqT8gI0WrvuETkfAGyFPMqvYbQONWwvMOt6+V3M+61yb8A6tG8NK3Z56O5TWMROgoUKox2Gli0OoEHmgxPilKdxY/6iJQX9Lp1QTnXktg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738310; c=relaxed/simple;
	bh=/7tSNmrIO5cNnugNY5mtfbWhKPrkqqMj4TY5JfdDXzw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=fzn0FYI3J0idqaI5T8cPddiepj8qYl7TDgTmvFwgmkC7Y9FKWYcOteyo8prJbPd/6wCdzund13Ghjcswr+Df1qeYzB5EWMLzcX7oVj53Zn1Ki8GhNDZFheS/svbtvDsfsL4HxXHyc50HkdIgSDWAjVik4rp/KQk5O99skjjM4o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=s8263bvZ; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="s8263bvZ"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20cbb1cf324so3193075ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 19:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729738308; x=1730343108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=KC7SgsbfWewQmYF5sxly4ivwsDZFnpAjCHK/0+wIMjo=;
        b=s8263bvZ9DMqLPyCkink3YfeD8rOhd5VUyUsq5t6KYsymCOz3AIHIMJ3DHkzQQbKPv
         eBJcOMpl2Is4am+MlDDkp/SLVXWt2SkTFKs20z5jZ9rNaR+nbHAW1PyfwQn4IhNcjh2f
         dSdiqfaO7+N2+0C6bPuvazI2VTw88iGTdfNe9Rct7Td/OGguXnR/aeJAdYRA4My+mWA3
         Lv9HbVTSliF52K2I4xyoq0viPEKrzybKWzRbl+hg64HI/aQPcCD8zIsHlgyKSaLCOSnr
         Sq278t4IVLDZsKjBRSycWfo/X9mPB1x3ty++HPbr/0z6GtTj0xZRn185dBzjxX7CbEOX
         nbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729738308; x=1730343108;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KC7SgsbfWewQmYF5sxly4ivwsDZFnpAjCHK/0+wIMjo=;
        b=XkNpoeVY92nBqc5Gajmwusdjh8yQ/cqWBLEzUAV/3usYSGcb7X3Mgmo6u/D7svQKpk
         Fnok2JpRU1+jhHoTnkB3Ha9UE3GMF+3V/TpabGb6pmzlxRi5E/DZrSUHmAl2sPS6U+rO
         NWqHia6CRlXy/nDBDmJXSyOjY5BTqiZt17HUjb3W/jor/4SrwctSLsXXG/ZwI3Q0wQLf
         KN8kr+51hYSYz00GF0EbS4f1lIxalMr8mu6jW6xb3BpumYIwlosM1bbXuTtuBuV9HM5C
         JAxX7Fe9mJvkkaZ6pVzPRbCIDdLX17vBjEghP9YTex24ygSl3brZMCC/0jfv7X8uclw9
         nK2w==
X-Gm-Message-State: AOJu0YztJbfx/s/oFCeB9fdBQleQTB7xqWm+t+bzDY2yubMJUTd+PiDh
	MOHzorUVKClZVsnHnCt5OPUbNQcNCyDORh+/jPd1bmMjQPJj5JRJOMfR7MTRbiIg/Z/JkzyclOx
	8
X-Google-Smtp-Source: AGHT+IFOVeOExio31RV4HVLsuET/QcB6cB+3qFa6Q1SMny6L/31xeMAsLspVr3x5R3VbLayzoM2M4A==
X-Received: by 2002:a17:902:c40c:b0:20c:a19d:e73e with SMTP id d9443c01a7336-20fb9a81a63mr3866005ad.57.1729738307739;
        Wed, 23 Oct 2024 19:51:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7ef0cc1fsm64026925ad.93.2024.10.23.19.51.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 19:51:46 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1t3nwt-004xNo-2Z
	for linux-xfs@vger.kernel.org;
	Thu, 24 Oct 2024 13:51:44 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1t3nwu-0000000H7zR-0t8B
	for linux-xfs@vger.kernel.org;
	Thu, 24 Oct 2024 13:51:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: sparse inodes overlap end of filesystem
Date: Thu, 24 Oct 2024 13:51:02 +1100
Message-ID: <20241024025142.4082218-1-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We have had a large number of recent reports about cloud filesystems
with "corrupt" inode records recently. They are all the same, and
feature a filesystem that has been grown from a small size to a
larger size (to 30G or 50G). In all cases, they have a very small
runt AG at the end of the filesystem.  In the case of the 30GB
filesystems, this is 1031 blocks long.

These filesystems start issuing corruption warnings when trying to
allocate an in a sparse cluster at block 1024 of the runt AG. At
this point, there shouldn't be a sparse inode cluster because there
isn't space to fit an entire inode chunk (8 blocks) at block 1024.
i.e. it is only 7 blocks from the end of the AG.

Hence the first bug is that we allowed allocation of a sparse inode
cluster in this location when it should not have occurred. The first
patch in the series addresses this.

However, there is actually nothing corrupt in the on-disk sparse
inode record or inode cluster at agbno 1024. It is a 32 inode
cluster, which means it is 4 blocks in length, so sits entirely
within the AG and every inode in the record is addressable and
accessible. The only thing we can't do is make the sparse inode
record whole - the inode allocation code cannot allocate another 4
blocks that span beyond the end of the AG. Hence this inode record
and cluster remain sparse until all the inodes in it are freed and
the cluster removed from disk.

The second bug is that we don't consider inodes beyond inode cluster
alignment at the end of an AG as being valid. When sparse inode
alignment is in use, we set the in-memory inode cluster alignment to
match the inode chunk alignment, and so the maximum valid inode
number is inode chunk aligned, not inode cluster aligned. Hence when
we have an inode cluster at the end of the AG - so the max inode
number is cluster aligned - we reject that entire cluster as being
invalid. 

As stated above, there is nothing corrupt about the sparse inode
cluster at the end of the AG, it just doesn't match an arbitrary
alignment validation restriction for inodes at the end of the AG.
Given we have production filesystems out there with sparse inode
clusters allocated with cluster alignment at the end of the AG, we
need to consider these inodes as valid and not error out with a
corruption report.  The second patch addresses this.

The third issue I found is that we never validate the
sb->sb_spino_align valid when we mount the filesystem. It could have
any value and we just blindly use it when calculating inode
allocation geometry. The third patch adds sb->sb_spino_align range
validation to the superblock verifier.

There is one question that needs to be resolved in this patchset: if
we take patch 2 to allow sparse inodes at the end of the AG, why
would we need the change in patch 1? Indeed, at this point I have to
ask why we even need the min/max agbno guidelines to the inode chunk
allocation as we end up allowing any aligned location in the AG to
be used by sparse inodes. i.e. if we take patch 2, then patch 1 is
unnecessary and now we can remove a bunch of code (min/max_agbno
constraints) from the allocator paths...

I'd prefer that we take the latter path: ignore the first patch.
This results in more flexible behaviour, allows existing filesystems
with this issue to work without needing xfs_repair to fix them, and
we get to remove complexity from the code.

Thoughts?
