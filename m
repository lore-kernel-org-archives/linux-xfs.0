Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4CA15E811
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 15:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715267725; cv=none; b=Pf+RYY712v+PjD4EpiGo5bfRmnoPlYDG9h2JXrjVX15gPmYf4G++PtNWL4rUasGvlmeBtZUggedXYNMBHjAglxS9iXW4z2TMRQj4tfyqu3f61jcb1ndj3mOpdP02lovT2xgi0q9mA3fAd2bGuumwysIevPZqNPOFg/S4EkZt4I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715267725; c=relaxed/simple;
	bh=Sxcjn9B5kb2zt6rFh+EiuCUhN28uNMTcut9rDPMx8ro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Od98mhIHR6PQl/yVVARRbcPY9VUDCm5GG7iyrleIgP9X/NxlTsLGRaJdugKCww3x+/f7eF8uOxbnCMjjN2EuD6SZd6mFw+BvhUlwDrBQAm/uv4DMLvcye1nM5rUP+TCVzDCCBhNZpGdoaj2yk8JRt2YlGdG6N9plamtL8PSWRgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dx4hVCJm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dx4hVCJm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715267721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lWGlgXZwmfAxFsMP5r5cWbf48pDCZ5BKktkdQK61AY0=;
	b=dx4hVCJmNH0gShZVXZi7LndGO9Y0mx3dMnTlJxgnQ/fcmBo/sqtx5Q2Q/FKWhMMnmHtcDf
	1ThyP/EEDx1sBLla6TDho2O/4nXEho7/IIBSywgW/1bSpIUKhDQotexX+O2QcsnSuPDa2a
	DuSR1pjg9Gv2d/ZHNmold49iMwvJdp0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-vf8RKjANOUmuYrPcJFeqnw-1; Thu, 09 May 2024 11:15:15 -0400
X-MC-Unique: vf8RKjANOUmuYrPcJFeqnw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a59c3cf5f83so65526766b.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 May 2024 08:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715267714; x=1715872514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lWGlgXZwmfAxFsMP5r5cWbf48pDCZ5BKktkdQK61AY0=;
        b=SDSfFE59yEAo1XqLoUdZXyNlin5p9ldf2Hn9BV7h5q9IW4vEs076VLyHjymqE/Ke2z
         fKjhIuDLopQ9lWHlY/l97uomP3mG0Df6zPTDwF3U6t/SeUrA8Cfn6b5tS3dlewSKwc7d
         uWtEVYkP9FAHdKkyGwE0L0s/7+QCDScsqawKo9dS2A5nnSNDG9cR4sy2FD0q/DqXmDYo
         MCzqF87ymQZXIM+D70/3urlzVTbiQQyyRue2akWl1TRMAw7Ol2+g7op5qx6g8QhOmtBi
         scXPrGXOLsrKamR+Km7JmOjUD+Gp19jRfcAi6MLEKXwv0sFvJly3YbhYFdYkOYcMLKZ7
         8Tnw==
X-Forwarded-Encrypted: i=1; AJvYcCWZPj9CtEFTg/ouEFiDJ2uTeUL+oIaVMhV2uJH70e03KZZu4IO+w66vVe0iISm7m+r3x/h/eQX6zmJUBc76ncYoOiFrtrB9U3X5
X-Gm-Message-State: AOJu0YwE+210QemA2btk7s1p07z3DIpz0rzUryQN5HN2WyfE04iwfjEy
	0p45f21QlvWJTHdnpGxJ4YZlpz//NBhLj+AWe2UZ5zEtgj5AVV/N8t7SsmdFCyxw2Gwasp/AoQL
	vw/dfYWfhtVQn5i9gRH7ISZJc9JopvIQ5t/aZ/yYYDLsrJ75e2R4V1JIB5ARK0ORk
X-Received: by 2002:a17:906:6c92:b0:a59:aa68:99a0 with SMTP id a640c23a62f3a-a59fb941c53mr333106766b.18.1715267714245;
        Thu, 09 May 2024 08:15:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDawn/j+q0qMD07Y2Nj/5vzInindlqViBRbYF8HJ+vHS190v1r3BV02IEeYpT1/nN7IM/NWg==
X-Received: by 2002:a17:906:6c92:b0:a59:aa68:99a0 with SMTP id a640c23a62f3a-a59fb941c53mr333104866b.18.1715267713668;
        Thu, 09 May 2024 08:15:13 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17b01785sm82035866b.164.2024.05.09.08.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 08:15:13 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-fsdevel@vgre.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 0/4] Introduce XFS_IOC_SETFSXATTRAT/XFS_IOC_GETFSXATTRAT ioctls
Date: Thu,  9 May 2024 17:14:56 +0200
Message-ID: <20240509151459.3622910-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This patchset adds new ioctl for setting/getting inode extended
attributes on special files. This roots from xfs_quota not being
able to set project IDs on special files [1]. New XFS ioctl can be
used directly on filesystem inodes to set project ID.

Corresponding xfsprogs patch will follow.

[1]: https://lore.kernel.org/linux-xfs/20240314170700.352845-3-aalbersh@redhat.com/

Andrey Albershteyn (4):
  fs: export copy_fsxattr_from_user()
  xfs: allow renames of project-less inodes
  xfs: allow setting xattrs on special files
  xfs: add XFS_IOC_SETFSXATTRAT and XFS_IOC_GETFSXATTRAT

 fs/ioctl.c               |  11 ++-
 fs/xfs/libxfs/xfs_fs.h   |  11 +++
 fs/xfs/xfs_inode.c       |  15 +++-
 fs/xfs/xfs_ioctl.c       | 182 ++++++++++++++++++++++++++++++++++++++-
 include/linux/fileattr.h |   1 +
 5 files changed, 212 insertions(+), 8 deletions(-)

-- 
2.42.0

