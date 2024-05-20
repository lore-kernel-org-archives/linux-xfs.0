Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6C1E552
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716223604; cv=none; b=hkec72jRXWl8S2dj/i5R0axK/AFTi9khd9/nTPA9gxgaEiI1wlhXCMEiaTCjVrKMJgd4Ji9Foq6l0DsdDcVusYI9UwdRuCDsdE9gdYk04I3GeOoA/4Lva0dQWPFcDY8zRSasLAChW+nDGPARMnDal95GDN4/LpNsl8K1QtO4WNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716223604; c=relaxed/simple;
	bh=kPk3zRp6sal4sEPBw/DjMZNpEA5ZgGLpyEIBZKHS/js=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rzq+j633s0Ht/UT2xbvNFgtpSpLicmyYYN066NriojkfdqFke8V26m8PeO351AHRh5VazYXrZVtup0HLmJ2rtU2e9V4TWRPMxCotrDVkypuDGJJK+2ghnv3HhWU40aNHzNZzG5+9aIc3wMW2mzoezJ4OIkXVlLbUqTL420c+S8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aGg1zaOU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aGg1zaOU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716223602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xxY/q10BWQglrGn++ucuAjMzDaHamN2CmPng0TjhAfw=;
	b=aGg1zaOUNHqVnAvgmFlQqQuXGvzWf1sn8fDMtHFcEWwsmUx4E7RzhyZKoMLkpQd9AjBQfr
	tqxtWo6i9aOWXVFNbtDXu3lOt77S5xLtkHD9+7FKzGXHKhql827yIH8PObB2Ks7Dlw6xCK
	wzN8dcB4Xsa3uFDc9D7XMlFZnfOtYvM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367--ALDDZeoPRG2aglVVzyk5g-1; Mon, 20 May 2024 12:46:40 -0400
X-MC-Unique: -ALDDZeoPRG2aglVVzyk5g-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a5a812308daso500329266b.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 09:46:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716223599; x=1716828399;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xxY/q10BWQglrGn++ucuAjMzDaHamN2CmPng0TjhAfw=;
        b=Gwuq7VmdTQTsm+7fkuGsI/jB0TK+/3zDtc+cXGLGj50lWVdpNoB+mHV7bAxn+fPGoF
         bSS/DwG+ULcA68x9DUCtae2ItYMAU6ic9n3UQgcDiKAQ6sddCWeoxsepcN3deKUjL3pA
         0Z52yj2swuD5RLShgmEdVL+cM2d+oMBLJygg4yzXrSzXUuosLKWIOOAyf85sxsQ8Zzgz
         ajkpm5xIng0zs2TDexYH5nIwTz72mvgaQJPrsfSIf+gU5aKNJmEZCJ4edqv4A7DHCW+s
         X8Qil2ZNgoaQscHe6heyrWxRlAlZoomP7Dv2ATCqP5vPvYWGd2Sbg5QZlv5OzR9Ecsh6
         ExXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQaD9yvyd56icQHGKkmXBMTJI/hsKCG3rpI6PyHx1Y5llaM0fqF5La+lG0Ln65K1gy/c+zX+juacnNl1VJqcHNU7mqp/TAOXjR
X-Gm-Message-State: AOJu0YwAfeJXOe6tYoBlP6aJHOmFG6858Nxyo3TZwlEdhklbn4XNXFt8
	t4Qexy5Rj7diKa8Xva6RAx+W/APBa0QVxEwvsr7aFBqSf9/JnP92VNLzw6BGjpA+fEauU4zH1vY
	56Eyskq5HDBGNQSXS2M1xSqmPjyhdjvylPUKa/9E7Kq/g/bQmh8thzt4D
X-Received: by 2002:a17:906:7011:b0:a59:a895:3ee with SMTP id a640c23a62f3a-a5a2d5cca0fmr1940570266b.45.1716223599545;
        Mon, 20 May 2024 09:46:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGcdoQ6KxQjPGSwGIqMLmk1eL+vZgVHqQUGdGQU5uOw5WgNHluG43J6afMnHd/NKtYDsXFyA==
X-Received: by 2002:a17:906:7011:b0:a59:a895:3ee with SMTP id a640c23a62f3a-a5a2d5cca0fmr1940567966b.45.1716223598889;
        Mon, 20 May 2024 09:46:38 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5df00490cfsm318872066b.159.2024.05.20.09.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 09:46:38 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-fsdevel@vgre.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 0/4] Introduce FS_IOC_FSSETXATTRAT/FS_IOC_FSGETXATTRAT ioctls
Date: Mon, 20 May 2024 18:46:19 +0200
Message-ID: <20240520164624.665269-2-aalbersh@redhat.com>
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
attributes on fs inodes, useful for special files which return VFS
inode on open() and therefore FS_IOC_FSSETXATTR can not be used.
This roots from xfs_quota not being able to set project IDs on
special files [1].

[1]: https://lore.kernel.org/linux-xfs/20240314170700.352845-3-aalbersh@redhat.com/

Andrey Albershteyn (4):
  xfs: allow renames of project-less inodes
  fs: add FS_IOC_FSSETXATTRAT and FS_IOC_FSGETXATTRAT
  xfs: allow setting xattrs on special files
  xfs: add fileattr_set/get for symlinks

 fs/ioctl.c              | 93 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c      | 64 +++++++++++++++-------------
 fs/xfs/xfs_ioctl.c      |  6 ---
 fs/xfs/xfs_iops.c       |  2 +
 include/uapi/linux/fs.h | 11 +++++
 5 files changed, 140 insertions(+), 36 deletions(-)

-- 
2.42.0

