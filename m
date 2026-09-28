Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F8D47989A
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 08:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790585303; cv=none; b=MKCDTKmjNRS6r9TdVJGsYtHJCLUJ69VooG33FzcGRpHgxKfXr30pMo2Vk1mhHWGg2JPDEkkAur1pRaTnGHytW7lVkppGWU6oSdKaJ1MU0Tmj7ZGM3WW4CYh76GwaUcOTv7Zp6kJLXlE60QxLlubj9WGWlv1NWC1DfhrmQo3dWxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790585303; c=relaxed/simple;
	bh=nGNK4CJ7IAGxiLKQK5N1I+NN+hh0tDC50qXrF7zVWV0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KtwcyWF/0uaf7EJYWc3MNAdbhANLUfb3+c4YZAiRhApLZ3DO+Au1/ixhj8m2ncLHUT+Lc2SVgylIdGfGNy4LU9eTAMWK2+/g2KCH7MidiwqHgqfxjyPb0cwIDzP6KraswQhm3AcS90YcZ7YrJFHNA6FrNmSIZnW++Hw43krsw/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hJJpx8b+; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hJJpx8b+"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ff23af865so21114225e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 01:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790585300; x=1791190100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DlTyxrC5JLY4QSgeol6426LcGC8kkaxi4wrrxLeCtIs=;
        b=hJJpx8b+vD0TBgD70aw8kyrK35e9qxFjpsoSa7cSUq9slEeIEJDqY76u6bCmf7cCa6
         m3mZvs0nrJ0U2n+Xwmpl/4/x51CWtvg5d3GGJONzOqErG7sgTQegRZ5NzCGi2rm+15v8
         P7Yh4lEmPzI/aj1jCHFRDOXx4AbnL3UnimiEkhItQ/t7SMxTPT9MYwb6GPkyN2/YIibO
         S59G9QM4x0bFDBK/o4b4CWoWl0hNdNiAlxNOU+CuG8+7WA71rdVdT3Q1s15Q0HrFGhvT
         0ZSqWVnjER0SZMvv+GxxXRfGPS2xl0By6375Lrk8lpkUzXXDQCM9MVKxIx/Ko0wZHP5N
         PkWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790585300; x=1791190100;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DlTyxrC5JLY4QSgeol6426LcGC8kkaxi4wrrxLeCtIs=;
        b=n5fCefGSWy8r96tdaLNsT0M3qBDHZhOeaHNUZzI614qZZfv58KyX3VTCN6lT03EBhn
         8Zmlrh2o+YqnvRCKQ1hRGhzNrcCYOceeHTJ3s8P4DshpzCCcWiHURZdFQGqcAXhhujQs
         Bnwjx568j0E3WCZMra2NyzyvstGlv/DZuaqlkRyT9uTICtA7lOAJIkJ32//Scwa4uu4w
         9MJyR71o9TDiBwnpH2Q/27Sdek+adtE/OUECJS0Gxs+C0NGZA7zPvrULqk0391SKdcKW
         PS1hFGzdSAinK8nCZ4BSeKIKUsHUEPdGizUQAnb/pxzOzJ7A8OgU9r9y72ylL1c5cY5d
         QZew==
X-Forwarded-Encrypted: i=1; AKwUvBzx3LoWhp6OIzu79uj8E+jDlcMHJ1RVF4IUlGd8H3xK8y0yJ6Jy2Vz13trjsfmTnlgKNMX+87K68K4=@vger.kernel.org
X-Gm-Message-State: AFuF++mwf+3eNNVz0UE4T3217v2JKFmuRAMvr0zmzmfWaBWKa8dJ/Qx3
	ZmwJhG9ZcqGCqw/Qb2ucskc0zKzEjvDHJRWbWgPi92SygUktKLGtM2Ns
X-Gm-Gg: AYBFou3+3keUOQEvETKaYoKyu4KnmxoaOQOnHWVS1eK0IOKaNpUycauzK53CXLIS1j8
	JeeDxdXv+2Vse/TWhcA8oD8CCx+UYMq0JlwkEf62ordHPPqtB9/ONT2sMmjrgqNKfZQSM4S+qph
	X8dwXawlvUFEK4NRFQgFESaLdC9CZsHK4B45AcPlG/6NLaA90YPiP0j+yqMY++/4GjKzglyI4qL
	zZW1Ys7ATfmP6mDrMrZHpmciXwxOdNTEg5leQ+cwzdRP4eKhXYCUVspG6NThSnkIDSUNn9ML7P3
	6+4ERxqho34kAW7RHO4DfZM4uBWsQfb2KtQoTTuTekVHlkgFAM4iaKNJ4pueSFTyjkcW8oldm3s
	uSKRyDyqOD1S73bWtsSU/vvIhy+pTvT/WDB+FCdvCAmsYoBQTpyoAlFzjpnxf6ucavgNpBavoTW
	PmWZYhDFaf0OugGHePq7sv+vVtDikxn3VaU+TVxCDT4QDTrK2ttGh/tshodyvGdRAIpGQsmcTbq
	qlsX6k0ciBBXWovl0NFZLrsc9LR6PxVhrKCRjMxgwvTirGO51Z/+R8wTANHmUcFR5BCSui9b3Be
	0NDFQg==
X-Received: by 2002:a05:600c:310b:b0:49e:7862:c09e with SMTP id 5b1f17b1804b1-49fe66c6289mr211174025e9.14.1790585299451;
        Mon, 28 Sep 2026 01:48:19 -0700 (PDT)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0017652d1sm182584705e9.5.2026.09.28.01.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 01:48:18 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 0/4] iomap: fix error handling regressions
Date: Mon, 28 Sep 2026 10:48:05 +0200
Message-ID: <cover.1790342457.git.parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix three independent error handling regressions in iomap:

 - clear the writeback context after a failed ->writeback_submit() call,
   preventing an already completed ioend from being submitted again;
 - preserve an iomap iteration error when iomap_fiemap() has a pending
   extent to emit; and
 - preserve a direct I/O data path error when sub-block tail zeroing
   succeeds.

The three fixes have no ordering dependencies and can be applied or
backported independently.  Each issue was reproduced before and after
its respective fix.

Patch 2 is not a fix and carries no stable tag: it adds an XFS error
tag (requested by Christoph) that lets patch 1's ->writeback_submit()
failure be injected without the boot-param hack used for the original
reproduction.  The corresponding xfstest (list corruption caught via
CONFIG_LIST_HARDENED on an unfixed kernel, clean writeback failure on a
fixed one) was posted to fstests@vger.kernel.org:

  https://lore.kernel.org/all/20260924091338.198407-1-parri.andrea@gmail.com/

Changes since v2:
 - Patch 1: no code change; picked up Christoph's Reviewed-by.
 - Patch 2: fixed the alignment of the new XFS_ERRTAG_WB_COW_CONVERT_ERROR
   define; picked up Reviewed-by tags from Darrick and Christoph.
 - Patch 3: no change.
 - Patch 4: dropped the reformatting of the iomap_dio_zero() prototype,
   keeping the iomap two-tab indent style (Christoph); added the
   "# v6.12" stable version tag (Darrick); picked up Reviewed-by tags
   from Darrick and Pankaj.

Changes since v1:
 - Patch 1: reworded the added comment to fit 80 columns (Christoph);
   described the reproducer in the commit message (fault-injected
   ->writeback_submit() failure on a reflinked XFS file, reliably hits
   list_add double add on the unfixed kernel); documented why the final
   ->writeback_submit() call in iomap_writepages() needs no equivalent
   fix, since wpc is never reused after it; picked up the version-scoped
   stable tag Darrick suggested; picked up Brian's Reviewed-by.
 - Patch 2: new, added per Christoph's request.
 - Patch 3 (was 2/3): no code change; picked up the version-scoped
   stable tag Darrick suggested; picked up Reviewed-by tags from Brian,
   Darrick, and Christoph.
 - Patch 4 (was 3/3): reworked per Christoph's suggestion to make
   iomap_dio_zero() return void and drop the handling of its return
   value, since it can only fail via a can't-happen WARN_ON_ONCE()
   assert; this also resolves Darrick's question about the local
   variable's type.  Brian's v1 Reviewed-by was dropped due to the
   rework.

v2: https://lore.kernel.org/all/20260924091203.198225-1-parri.andrea@gmail.com/
v1: https://lore.kernel.org/all/20260921083133.2960-1-parri.andrea@gmail.com/

Andrea Parri (4):
  iomap: don't resubmit an ioend after ->writeback_submit() failed
  xfs: add an error tag to inject a ->writeback_submit() failure
  iomap: don't lose a fiemap iteration error when emitting the last
    extent
  iomap: don't lose a failed direct I/O bio's error when zeroing the
    tail

 fs/iomap/direct-io.c         | 16 +++++-----------
 fs/iomap/fiemap.c            |  8 ++++----
 fs/iomap/ioend.c             | 10 +++++++++-
 fs/xfs/libxfs/xfs_errortag.h |  6 ++++--
 fs/xfs/xfs_reflink.c         |  5 +++++
 5 files changed, 27 insertions(+), 18 deletions(-)


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.53.0

