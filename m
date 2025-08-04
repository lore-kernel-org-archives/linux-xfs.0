Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CB6248F7D
	for <linux-xfs@vger.kernel.org>; Mon,  4 Aug 2025 12:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309317; cv=none; b=gXBISWl0jfDoTp2dtMe8lu8sv2DiKwITlSZ+Ocz7/1dRFpQOEFGp983zXCNKaJ0kwLf5lq2cnMjjTWrQqKJCxtQ9M/9a3j1+M2Zh7J6pm5g/I/Vc5xd6I1xG/GP74e2Z41VDJqYq1pNLqWGEfjHUcwTh1Ga48QZY7QyJ5alX1dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309317; c=relaxed/simple;
	bh=iNnO15/BfgmaMPqw0h4U0UuERiRQHOSjrTOw49XBO3I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bkxI1FmcJd7GATyGNw9xvVUTlaJ6m5kIbSxnbRffqFxa/1TdiLfQ6F03MWIEPRgvxc8fYD5kq61LUVSU8HuT3gZdeH+iv5fvkvlwTZiN2g4PYtSyfWmLuregXoLaWQAdWr7JJ7oMaPOgm+FbZ3NtxyWkgnkBiuEV+l5JQd/hzHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dLA55NUr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dLA55NUr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754309315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q/FwRKBqadlCqzUW765IWOU0vfo8gDyZ/uGIP5dqCW0=;
	b=dLA55NUr9vFLiU1LWBo+KHRZtij+YXsWfHHpAd0EKlgbehkKEAb627obGjkxbHf2e1whTF
	sdJ5P86vM4QFGMEScQoS1BHTkMrx1gtG8tO27/+jbI9uto6yPqA6sOB8uetYeXu07dhMvs
	bsstJ+yLVtcmX8HggeMUJ1P5Bp/I6cI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-94bhGhpbNP-49wgcZQImzA-1; Mon, 04 Aug 2025 08:08:33 -0400
X-MC-Unique: 94bhGhpbNP-49wgcZQImzA-1
X-Mimecast-MFC-AGG-ID: 94bhGhpbNP-49wgcZQImzA_1754309312
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459d7ed90baso6938415e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 Aug 2025 05:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754309312; x=1754914112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/FwRKBqadlCqzUW765IWOU0vfo8gDyZ/uGIP5dqCW0=;
        b=RDhGOOcgdnW/TtVwJK0DLFxNgRbrAlqRrJnemOZ4IK3WPkI9BsIy0K6vGJjGEk+1Aq
         y6ylsMBRxXd7rEOZqdgJsaqL2vXzcGmO66ygoi3BpIq0SLv6iciZvpHQAIdPXSko+Sf0
         ghLkM6HzFLxdXITTgyHjBbIFDxbD553bVwbyUHcRNse+xDUABD+rchDcXvNMkcRjywvj
         nYEh5pxU7xTi3IWJQSm+iZNHDsU6WrAMcwSfvBl+S8LFGX0RCf36PXbmZl4w7axbsfEe
         m/kZCo18kkXYm+YwGj66lor3fMaX+H6+m3bU7pT/E0/Wa2t0EP5igMpUu6i4fGbyImno
         I9YQ==
X-Forwarded-Encrypted: i=1; AJvYcCWe5+2Anq4LX7bZzibyv5vvat7rP4hmWYnpIPH2RMSXeKzbSz8WNBrZhweITI7r23gPCCYWYhQOWKQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5WCWeLvz42oDpYbPbswFv8JqmurXlRPTyyEzIRPJc8IlMycYQ
	wvHAijSH8PDZYft/b+6MJadPbn+pMw1nuf23NQVifG6mtGhws35G7y7cXzhVSYWa/KWLLyhvVAS
	VullAk8475nyNiJnlVa7deBmh9UIZkIPCiwDEyuv6DRQEBw0ekLxKQYsIb7H+
X-Gm-Gg: ASbGncvqtCECzBraU2ncKSrvi4pvTmmAutF7GcM71X0gcq6Fe878fj3mr8on/ONVNXI
	sgURE6TdyyNbKKZrFJitoFj7lJLFzqEv6PESSrdWNKkUq6cw0ZYITyoonJlroqizhelje5AzB62
	AbS97e8oHnPoFnPb0/Cuce6YoHEWbiMrjZX1WS2cK6TbsBPZ+KISSgTckC++RuNK3KG8y7eb7GD
	oSzln+dYTevsC4WqhHVf0yckuG1x14P8ZpN42yRjqNBp7P/BKbooXP468+Zvhi2khg5R01jayST
	G1fCoGj8FsZREphZMk/4VgVFMd7uT8joh1e5er04iMHACQ==
X-Received: by 2002:a05:600c:1c1e:b0:459:d3ce:2cbd with SMTP id 5b1f17b1804b1-459d3ce2e7cmr39876995e9.13.1754309311771;
        Mon, 04 Aug 2025 05:08:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2p0Hzw8PhvQqO6TN7HsM4e2SSRxpXLCkMQhtXMrvz0d+PvdnVidFNhWbD9QimC/lSRgVGWg==
X-Received: by 2002:a05:600c:1c1e:b0:459:d3ce:2cbd with SMTP id 5b1f17b1804b1-459d3ce2e7cmr39876665e9.13.1754309311301;
        Mon, 04 Aug 2025 05:08:31 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589ee4f239sm163962675e9.21.2025.08.04.05.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 05:08:30 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 04 Aug 2025 14:08:15 +0200
Subject: [PATCH v2 2/3] xfs: add .fileattr_set and fileattr_get callbacks
 for symlinks
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250804-xfs-xattrat-v2-2-71b4ead9a83e@kernel.org>
References: <20250804-xfs-xattrat-v2-0-71b4ead9a83e@kernel.org>
In-Reply-To: <20250804-xfs-xattrat-v2-0-71b4ead9a83e@kernel.org>
To: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=973; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=+9pE0msIOVxUWErFY4H4swlZ9Ocywde2UapClW+AhcA=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMiYs2vssIdbv45HXerqCcXE/f/Otv67704ZjgmvYy
 rvthTHRnk0dpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJjKTmeF/VIV2uPz5pdE7
 DuadeMr4Sf2KM3e5o+5vBtZv7l6ujzTuMvwz3qZkk6DizVVpzfJt84ss3UTl50xLV++YddaUQ4A
 p5jIXAICORXw=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

As there are now file_getattr() and file_setattr(), xfs_quota will
call them on special files. These new syscalls call ->fileattr_get/set.

Symlink inodes don't have callbacks to set file attributes. This
patch adds them. The attribute values combinations are checked in
fileattr_set_prepare().

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 149b5460fbfd..c1234aad11e9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1334,6 +1334,8 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.setattr		= xfs_vn_setattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.fileattr_get		= xfs_fileattr_get,
+	.fileattr_set		= xfs_fileattr_set,
 };
 
 /* Figure out if this file actually supports DAX. */

-- 
2.50.0

