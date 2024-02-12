Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3217A3D97F
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757222; cv=none; b=idVZXBa5GDbwQtgvv8VGDD1LwouehSd7EvILshzSnjcNOB+cfLhVehNeyDUV0T54FpPxGp5A/2eDRsX/9Hi52x86fpGE6yqBbqEsKb9w5ycGYdHYSf0Y1Szm1t+a+H7eLUEvCE83WAYVsWDeuNYnSssB4m5Q157Nw4DMmjJB5pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757222; c=relaxed/simple;
	bh=uRpqcFHztW6mv8ys9x1B06hDBwaQZHF8LlWlh4KeXNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s7ooPe5GcOjSyQD/d4hXMdrSjW1Hmi77cZMAgbiD9Qltu1RJZBNt9oOOaNzkbuqmvbAx0i4mWSvAGjIR162ID52oJJAOGhdJInw6Ilnt0chSdEiTCE3S/NcQ+yd37fwNPBRm9ep6SjxS3U7L9PKFtT1PO11QBnW4WZAfbK/4hBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g102msEZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g102msEZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K4IPa0qcdOfoZGhIk7o1SuO7zkizJ6265PJwpzaMwSg=;
	b=g102msEZB4hRAdgJUPM5KNYeyuJMPKnJCkywbU54e0GjXyDzK56OUGHfH+IsmxTPZP9d/f
	AA8kL0Q6B+ngOG3NMHtHnWFhEAu3eGSELDm7h0nggF6amn4UwMq1xya13MPLLY1vzxGza4
	1NvXqWDIyd+Lp0MJJ87sCNofQFU7L7g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-VtNtiaKeMJCx1Bm16d5vaw-1; Mon, 12 Feb 2024 12:00:18 -0500
X-MC-Unique: VtNtiaKeMJCx1Bm16d5vaw-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5600db7aa23so1995983a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 09:00:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757217; x=1708362017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K4IPa0qcdOfoZGhIk7o1SuO7zkizJ6265PJwpzaMwSg=;
        b=jvpBA00ntMTHW9ny3sZJSxvN0gc+AbTYhnDM0JDgKUzfpjTKtsNtN5pHcqiTUI/ImU
         Ox0T38PlcHf3XyB7JtbhiMZ8Xm65zoTSWom/tmve/3Y5uqr8lAhh1R2AsEBE7rssjpe6
         n5uVfjyOA7J3UQupqd5I+L8MHQgzBvx1iIsbkKJD+roa/ebo5jrvmAcsO6IrfBSIyAtb
         NnLbQBdtU3DaIFI0KycE1LHlIbicWl9M5s02wIf8BoSnkx+1PZkVTVPbAUVFz/rGTBTm
         JD+xBFG8OUrhVsKlaF5lxrC6tmpE/6fWWj2YRGmO3xlq3tFN/WvliNZkQppNtfZqzivJ
         gpWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYDYlA5F9MzjdPUQAEY96/+55Q7ZZw+kBL6zPp1LW7KrywXSJVHcBNyN1w9+ptXjIAPCeJxtF236ueTov2AT0RojNnh6E050ki
X-Gm-Message-State: AOJu0Yz337eC2gREUXEdQ9BOUMjWRRHiN4+xlKNQx9AuF/IzH7oP/5hD
	axud83dqd/juCA3YZ+Dji7bBZKKbpqEipdlZRJjaO23DZpF+Zhn+XwzQqjkFTauXwcAl2zEacuP
	Q4QayABGN1fSrOhFibQmxtmSFLOK1+GvBlizwX2L7lQzdJYlLyBcmV892
X-Received: by 2002:aa7:c38d:0:b0:561:dd88:cffc with SMTP id k13-20020aa7c38d000000b00561dd88cffcmr465747edq.28.1707757217465;
        Mon, 12 Feb 2024 09:00:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHksA5ai7JOoS0uklOVKI1iGk/wOmBYywj8HWtXzARiX88G09MpjFmNbBH4phxpiPQJH/VdNw==
X-Received: by 2002:aa7:c38d:0:b0:561:dd88:cffc with SMTP id k13-20020aa7c38d000000b00561dd88cffcmr465738edq.28.1707757217252;
        Mon, 12 Feb 2024 09:00:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXR1m0bOpBoqPXPgXXYaM9xtNMBrhn4WE1Pg/SJk4bnMQdTF9h8ffsK3KWu15iaJi6Z23nltfiz5dIXnKMptfo4UjJ0x/eI7CWd4H2jF97ZLwCYDKHPNU2p2YlMAanXkf+nNaNF0xypLv5AaDh61uecKausA88SdVC6PnzrvLFKxQbUkiSyZ3hdYGSeHT4kr6p3yDrqqsiA5JLSxLyJaGGrWGufxilwbyNg
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.09.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 09:00:16 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 19/25] xfs: initialize fs-verity on file open and cleanup on inode destruction
Date: Mon, 12 Feb 2024 17:58:16 +0100
Message-Id: <20240212165821.1901300-20-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240212165821.1901300-1-aalbersh@redhat.com>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity will read and attach metadata (not the tree itself) from
a disk for those inodes which already have fs-verity enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_file.c  | 8 ++++++++
 fs/xfs/xfs_super.c | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e33e5e13b95f..ed36cd088926 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -31,6 +31,7 @@
 #include <linux/mman.h>
 #include <linux/fadvise.h>
 #include <linux/mount.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1228,10 +1229,17 @@ xfs_file_open(
 	struct inode	*inode,
 	struct file	*file)
 {
+	int		error = 0;
+
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
 			FMODE_DIO_PARALLEL_WRITE | FMODE_CAN_ODIRECT;
+
+	error = fsverity_file_open(inode, file);
+	if (error)
+		return error;
+
 	return generic_file_open(inode, file);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b2b6c1f24c42..4737101edab9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -48,6 +48,7 @@
 #include <linux/magic.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/fsverity.h>
 
 static const struct super_operations xfs_super_operations;
 
@@ -672,6 +673,7 @@ xfs_fs_destroy_inode(
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
+	fsverity_cleanup_inode(inode);
 	xfs_inode_mark_reclaimable(ip);
 }
 
-- 
2.42.0

