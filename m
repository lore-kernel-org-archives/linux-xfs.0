Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="fGfkLpjI"
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85846C4
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:34:14 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6bd32d1a040so5065203b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701149654; x=1701754454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yppdPakpPj/hSLJ9uZBVv46+PUQYqbzCgWp1lHeXxis=;
        b=fGfkLpjItIfWDyLNc/yBvAmWdQFixpU3BXrR9zcmm3PnEtVMnK2QucsZtT0AK3dmtd
         vZi0kdojw9PjqxAKUrLHTTNnxU0cQRp5pySKmft4XRoc+WG93GTSSfFy21jLysySEcvp
         qRMJoEzEnoiVWJwVar+SZu5E+bymzHsWOhL/Wv+e0/iv0p0bjKjl9GgN8lrMuJEty2x+
         EYkdql0EMDWOmgHD5r8uv5NCeHN7gylmQObm5euHBpgnAQHSlyQnP47qZmSGcE0ngVPP
         TcnaZYYBO4C6GwccJJaCRb7rGSsKoTU9NkZYiBZDsh9Qw1tBfvW4k6bw7zggA82YxgRd
         R5MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701149654; x=1701754454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yppdPakpPj/hSLJ9uZBVv46+PUQYqbzCgWp1lHeXxis=;
        b=LBi1YLvWUU3o7mlwhOAc0dThC0MlsLqTdBnnNOvhtZ74OdGN7FOqVneLfdJmh/eCwB
         +FtuxfyQKu/1UKNhSmpMuVtbY15lJmazxfSDH9zhK60+WoGzGz5fo8Yr6gkO8VM5lwN7
         mjR7882T6he4aPaehcTn4IWMJ7A046+0EnCVSTXW/vaN9YVxwwQOvHIgG8rjgUt7DLf4
         mSHOd/R9hLtY/pLrssjEa2M7BbgQXEsVUfAUdJzh+uJ/C+7NdgLvmqqnv6UzRsagGy29
         Kw7fcflTtun63MSl9hNsOCF/wvn1I5GA4DM9T6mXmZqHvLqITeZ95fTA8ciTTpiVmZs2
         9qqQ==
X-Gm-Message-State: AOJu0YyfLSK04pBqdZxgAWTBqVnFFXpMeoL0WVKA4+edYpUKLYfKkt37
	9y7Eyl5AuV68YgX1lDZvonzCww==
X-Google-Smtp-Source: AGHT+IGGEgtU/0QNfhR0VuWj+6MjlDH0aKxEm/b7PHGugXgt1r/1AySGlMTOGnp8qDgQ2pyVd5sWYg==
X-Received: by 2002:a05:6a20:12d3:b0:18b:d3db:7048 with SMTP id v19-20020a056a2012d300b0018bd3db7048mr18160990pzg.23.1701149654057;
        Mon, 27 Nov 2023 21:34:14 -0800 (PST)
Received: from localhost.localdomain ([61.213.176.14])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090341cc00b001cfb6bef8fesm5372899ple.186.2023.11.27.21.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 21:34:13 -0800 (PST)
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>,
	Ben Myers <bpm@sgi.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com,
	me@jcix.top,
	Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Subject: [PATCH 0/2] Fixes for ENOSPC xfs_remove
Date: Tue, 28 Nov 2023 13:32:00 +0800
Message-Id: <20231128053202.29007-1-zhangjiachen.jaycee@bytedance.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Recently, our use-case ran into 2 bugs in case doing xfs_remove when the
disk space is in-pressure, which may cause xfs shutdown and kernel crash
in the xfs log recovery procedure. Here are 2 patches to fix the problem.

The 1st patch fixes an uninitialized variable issue.

The 2nd patch ensures the blkno in the xfs_buf is updated when doing
xfs_da3_swap_lastblock().

Thanks,
Jiachen

Jiachen Zhang (1):
  xfs: ensure tmp_logflags is initialized in xfs_bmap_del_extent_real

Zhang Tianci (1):
  xfs: update dir3 leaf block metadata after swap

 fs/xfs/libxfs/xfs_bmap.c     |  6 ++++--
 fs/xfs/libxfs/xfs_da_btree.c | 12 +++++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

-- 
2.20.1

