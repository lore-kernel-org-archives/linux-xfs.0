Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D341E3DCF
	for <linux-xfs@vger.kernel.org>; Wed,  1 Oct 2025 08:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759307994; cv=none; b=bUfQHHxDhkjTrVX8a633pSJwn0B4DP/FvaRaIbSPmUtkrja/ok0WKkHcvroSIq9oEC9GWVXQBEGqm9muA+Wqmv3j3oAJ2M6iFzpEBlYtcBN/gYPP5yf1bUnkFWvdiq+tnljpEjiJrFq7pHdEfuxKcz0jT4/rHon7JaiZ8UdIlB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759307994; c=relaxed/simple;
	bh=VyoVY4Q4GDe6RMQi5QGg4ffoiIPwM6SwqIJ2pC+aeyo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q48Tevezy4rLFEiQyjap3bH+kQP/13KKTUtSs6pofogwdc5p/MSGWx7OFXJ1vk5hPD1Vps1KDjSIzbM8zYqEPLjDmQ0yXksI4b2BkgQ+6T69Vrr0YHmgSAkjItvL5Dvoqx59yN7mBcB4xZSz/J/m6qf9BJwYno2PmOsWdknHJ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g3yM1iOb; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g3yM1iOb"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-28e7cd34047so11753235ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 01 Oct 2025 01:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759307992; x=1759912792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D4FfG++OYH0UQ2cb2chNsj++JT4lH4Ovdjh6P4PE8Qc=;
        b=g3yM1iObHwRxcTDwKEb4hPnaH5qID9F2qO/PBYntzF0jaxWD7P+SV/5VQ3KFwxtu+N
         sqPq26lmHKC7XiFRj/qXOcn5oWzLr4zv7pz03nIbJLgx5WPgXFsjd63aFesxxJ67qDMw
         ySFCbPyH9sByfJZKjYIRhfgt+F+MlqRw6dR5Mq/Y+4eY/VCylI/JtiiixVWnB81wts1K
         nXaBmrPSdIzOSFzO0Y6VHjWYbWmiU7VsCkjrIAhLda5k70ObaAkrUz1VUMv7qdRPvaNq
         M17uu9Xqwq1kawq9QDiLIgyiISmLgK5rjESsQKWzCPNPzJ9zX1HxaZ8gmOsatG7VRrrL
         YsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759307992; x=1759912792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D4FfG++OYH0UQ2cb2chNsj++JT4lH4Ovdjh6P4PE8Qc=;
        b=cRrydp2CsEZRQn1BK3F1ai7VEaMrWbi6svI7uh7UJmy8hgoMrFELGyTMibqmJNY2gE
         VADUuus1hgrq4anVHw8HZ3q/khyj2jN+tK6IITFdC1VVZo8oSBTHil8BMQxk3ZPgmJbp
         8LeGVK+ka3oAMQguOw55R5Gj9a76b0tmbp5FOYiv0UVTdbAR4BzD3ZJPGrhg5rEcyxSq
         MgPSau7CCLI0ThLyscPUoXAPxzQztyBcBRVgIsXWfDisYpbHZKc/84JXMK8e99T3Nbue
         NNonOOo4GR67RfiFJ+j210PulnihwaEHMOhR4XfdwcZXz3LJBBDBLy2UodWnB0Fy4HmB
         kZRg==
X-Forwarded-Encrypted: i=1; AJvYcCWBze8CtR1ORup3g2Z20jbYNsVjRpf8S24hj8Sx5UuiF+GU8C+kDE1nnjzWmxXbvopdM1vs3pk/GoU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxKV2nspVaapQybhcWbE1cxuO2aWn0R+CiKGclPQ8XrYYX6UMB
	ERV9nzZlleG6xQdvuabgOq/p77jHVOUzlk1XQ8O1tDjIXBEtQp4X5e2K
X-Gm-Gg: ASbGnctjuJzw0V+R2ij0K7DZAd78q+2gczVf7vk3zEyb/UhQ4q2bh0qM99uq3hwIFXs
	Y7Z4pQkntK/xj3ym5bYHPLnpPFAti61+l2l33rxEJOLPHtGCfibl3HhtJADXbcdk3HxUOW/VIrI
	Wrq6lEkp1cNu1aMu5UEemr92FgyeV029o9opuOZgzEvU9KxNfV8cL+oqBfh6e55ue/qyLSDjVL0
	C/8tv+VczlafdfHxliH9nH9q43T/lBkhB+XSGcuV7OAh/Dp7XQLHS8VIaRRMuaw/4zh9voNFT9a
	DVPNq629DeKK9sWByD/37WjogqQRutmrXBDRJNC/kV21rFHC8iUyBo1PITQzuemSqbXK19AtuRH
	pFENCaMRMB4rB0QPEK98wE4LDHCNtvO8QB3K1luI/hZPiWCNloYpAEHP6KAixA3yzRiyTMwwVxg
	==
X-Google-Smtp-Source: AGHT+IGDAA5bS+9IItYzYTvHt755RN1Ht/RXQRCnt03we0AczFtZuNBaAi5b7oWoS/mnvJ+e//+JYg==
X-Received: by 2002:a17:903:11c7:b0:269:8407:5ae3 with SMTP id d9443c01a7336-28e7f4b6843mr37492805ad.54.1759307991850;
        Wed, 01 Oct 2025 01:39:51 -0700 (PDT)
Received: from ti-am64x-sdk.. ([157.50.93.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6ad1d45sm179473835ad.141.2025.10.01.01.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 01:39:51 -0700 (PDT)
From: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Carlos Maiolino <cem@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>,
	linux-bcachefs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Cc: linux-kernel-mentees@lists.linuxfoundation.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com
Subject: [PATCH] fs: doc: Fix typos
Date: Wed,  1 Oct 2025 14:09:31 +0530
Message-Id: <20251001083931.44528-1-bhanuseshukumar@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in doc comments

Signed-off-by: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
---
 Note: No change in functionality intended.

 Documentation/filesystems/bcachefs/future/idle_work.rst  | 6 +++---
 Documentation/filesystems/xfs/xfs-online-fsck-design.rst | 2 +-
 fs/netfs/buffered_read.c                                 | 2 +-
 fs/xfs/xfs_linux.h                                       | 2 +-
 include/linux/fs.h                                       | 4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/bcachefs/future/idle_work.rst b/Documentation/filesystems/bcachefs/future/idle_work.rst
index 59a332509dcd..f1202113dde0 100644
--- a/Documentation/filesystems/bcachefs/future/idle_work.rst
+++ b/Documentation/filesystems/bcachefs/future/idle_work.rst
@@ -11,10 +11,10 @@ idle" so the system can go to sleep. We don't want to be dribbling out
 background work while the system should be idle.
 
 The complicating factor is that there are a number of background tasks, which
-form a heirarchy (or a digraph, depending on how you divide it up) - one
+form a hierarchy (or a digraph, depending on how you divide it up) - one
 background task may generate work for another.
 
-Thus proper idle detection needs to model this heirarchy.
+Thus proper idle detection needs to model this hierarchy.
 
 - Foreground writes
 - Page cache writeback
@@ -51,7 +51,7 @@ IDLE REGIME
 When the system becomes idle, we should start flushing our pending work
 quicker so the system can go to sleep.
 
-Note that the definition of "idle" depends on where in the heirarchy a task
+Note that the definition of "idle" depends on where in the hierarchy a task
 is - a task should start flushing work more quickly when the task above it has
 stopped generating new work.
 
diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index e231d127cd40..e872d480691b 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -4179,7 +4179,7 @@ When the exchange is initiated, the sequence of operations is as follows:
    This will be discussed in more detail in subsequent sections.
 
 If the filesystem goes down in the middle of an operation, log recovery will
-find the most recent unfinished maping exchange log intent item and restart
+find the most recent unfinished mapping exchange log intent item and restart
 from there.
 This is how atomic file mapping exchanges guarantees that an outside observer
 will either see the old broken structure or the new one, and never a mismash of
diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 37ab6f28b5ad..c81be6390309 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -329,7 +329,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
  * the netfs if not.  Space beyond the EOF is zero-filled.  Multiple I/O
  * requests from different sources will get munged together.  If necessary, the
  * readahead window can be expanded in either direction to a more convenient
- * alighment for RPC efficiency or to make storage in the cache feasible.
+ * alignment for RPC efficiency or to make storage in the cache feasible.
  *
  * The calling netfs must initialise a netfs context contiguous to the vfs
  * inode before calling this.
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 9a2221b4aa21..fdf3cd8c4d19 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -145,7 +145,7 @@ static inline void delay(long ticks)
 /*
  * XFS wrapper structure for sysfs support. It depends on external data
  * structures and is embedded in various internal data structures to implement
- * the XFS sysfs object heirarchy. Define it here for broad access throughout
+ * the XFS sysfs object hierarchy. Define it here for broad access throughout
  * the codebase.
  */
 struct xfs_kobj {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 601d036a6c78..72e82a4a0bbc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1040,7 +1040,7 @@ struct fown_struct {
  * struct file_ra_state - Track a file's readahead state.
  * @start: Where the most recent readahead started.
  * @size: Number of pages read in the most recent readahead.
- * @async_size: Numer of pages that were/are not needed immediately
+ * @async_size: Number of pages that were/are not needed immediately
  *      and so were/are genuinely "ahead".  Start next readahead when
  *      the first of these pages is accessed.
  * @ra_pages: Maximum size of a readahead request, copied from the bdi.
@@ -3149,7 +3149,7 @@ static inline void kiocb_start_write(struct kiocb *iocb)
 
 /**
  * kiocb_end_write - drop write access to a superblock after async file io
- * @iocb: the io context we sumbitted the write with
+ * @iocb: the io context we submitted the write with
  *
  * Should be matched with a call to kiocb_start_write().
  */
-- 
2.34.1

