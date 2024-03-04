Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8FD7D413
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579558; cv=none; b=oV3ImlRmx/zpkmf9E7MvN1cIBGqAsZGJfs9t1f+mz5Ep53C0K5mEvjS3Q8qKrDcmQzohUcovTtr5KELS2kDry29u9MQ+JQwEG1oxErtf6ZVVXYPBSOtjZyPhwRoJnsg84PxXD8vVMArGIBHVl3R+uRKSG2b8UzoD44MuCefp5Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579558; c=relaxed/simple;
	bh=QdzJQ1kBU4GhtNmWFv/v5q2u9OPK6bqQ8YoEEN+UHm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TG6mtDwvX0UITs+b2PD6uHM6AGIebhzoyE/4gBfdQyirIVH3X6P+0DyZiISbGUFc8LK6WE03Yw00VD+TVMTPsDnyFLSV2dW7OUhgbvibLrABjaqvNrjMZMabmjguwnTbsRCF8cv2fetxaeCvqe87b5Y7m+qVCxG96HN/XmrY/8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W2Vly+cg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W2Vly+cg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CCVu6C3sA7ElU4nB0aYXUKm+yvCdjGTpJNzXHRX3ZOA=;
	b=W2Vly+cgTvJFwABpz2Q4alNVcN7q57wpRXD2wciN/YMv2iC35AcnYW1OkuB0BjGftkS6Zy
	dl0AEiq5PWIxrX+HZOJWkfbLFyHTu8uz0ZDSNz5AZdCmIU6Gt4xIDh19eWXPmAaeYQbNMl
	WGQd8JYCcPhZqPqJ2orzT3vm+f8TDzE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-fzSskHVYOPKjY5YdbxpQ-g-1; Mon, 04 Mar 2024 14:12:33 -0500
X-MC-Unique: fzSskHVYOPKjY5YdbxpQ-g-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-567384077c1so973509a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579552; x=1710184352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CCVu6C3sA7ElU4nB0aYXUKm+yvCdjGTpJNzXHRX3ZOA=;
        b=XfNdkcrYIGu2HEO15cPidoYemwXXMcRobvYfpaCAetOLpYpEVGaw9NQq/yRniC4o2o
         GOUGHJ66l6F64/UF9cAhLgkQmRHNsQL3muM8SELfIGN4DkNcCt1cHvuqqp922TnFBove
         ogu7momnV/VRe7Bccv6fPtHchKidxV+fMYlvxvb3XcfRT/l1hxBpFjZt3lfydHAYL9oP
         WG5+4WPEMkDuuccBiHiU4+NZpN8gWt9vxMoS9sqmMPXZK/3N0xLy8FVfKDUGdsaNuXzF
         ShDwFRhQj9R+mWqz5xKFqjHf4VYsLzRBnf1aco2ysGynTwhMDu3MDGtxS/a2b6z9ydUE
         LL+g==
X-Forwarded-Encrypted: i=1; AJvYcCXjYJt/HQ/kTNNF0ibgYjWDnqgfBGjVNKNMuTVirn3vODL6u/3Z/w6d+DdzM62LFTDJb+CxaZSF1hLXlfzZcSKXv8OZISvYHjrx
X-Gm-Message-State: AOJu0Yy20qcY0853ckKYcjJwyX0uuZHVD0irYaeuQKJzyPo1TPFVGZp1
	39TwmD8qPWcYD3tk0/qnhcC4n9c1JfeF7uVElHebSyPN10ixpU8O//N7znm19SIwFfcR7d/K0of
	JYJ8Ek09lXzVqNGPYuWPOcRVdXQzC+yhGpfrLvqmhjcQl8exNMkYue8ps
X-Received: by 2002:a17:906:ca46:b0:a3e:8223:289a with SMTP id jx6-20020a170906ca4600b00a3e8223289amr6658574ejb.31.1709579551774;
        Mon, 04 Mar 2024 11:12:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGwEVH/LAIuJqd047oj/TDNuXhBpSOEKAD5TItZIL/0FSEVj2eqhjgA+Kb1gdJhwoiOZ/4iBg==
X-Received: by 2002:a17:906:ca46:b0:a3e:8223:289a with SMTP id jx6-20020a170906ca4600b00a3e8223289amr6658560ejb.31.1709579551268;
        Mon, 04 Mar 2024 11:12:31 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:30 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 22/24] xfs: make scrub aware of verity dinode flag
Date: Mon,  4 Mar 2024 20:10:45 +0100
Message-ID: <20240304191046.157464-24-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity adds new inode flag which causes scrub to fail as it is
not yet known.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 9a1f59f7b5a4..ae4227cb55ec 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -494,7 +494,7 @@ xchk_xattr_rec(
 	/* Retrieve the entry and check it. */
 	hash = be32_to_cpu(ent->hashval);
 	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
-			XFS_ATTR_INCOMPLETE | XFS_ATTR_PARENT);
+			XFS_ATTR_INCOMPLETE | XFS_ATTR_PARENT | XFS_ATTR_VERITY);
 	if ((ent->flags & badflags) != 0)
 		xchk_da_set_corrupt(ds, level);
 	if (ent->flags & XFS_ATTR_LOCAL) {
-- 
2.42.0

