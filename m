Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC46446C838
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353396; cv=none; b=bX2n8pkSJX6Jaej0MOMjksDytGnHjd61x9pevH+ygTA2CF6srIzBaUupRwxTRK5UndL8i1T8ryKNvIqR3Klj/vOUeDk0uyxZEKCcAqDoF+tp9WwzwbLUezU7hs+HhkQ9OpywisTVqHA8JbJbIC4GQ5SvhuAPcOzjNyJNlLE2k7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353396; c=relaxed/simple;
	bh=/kCEApx1GUiQ4M2nyPM46Cj/bUTisD+vHILiLyuC+4M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gplyuZeWWMH9T/OTMvmpbACIx1xHsJKmK59Mauh56yfSw+ABuTNGVj+8iGpm8GHtw0CTYdCCmXiqCzl2a+8ECfffFTjwDU2D2GPF+vyEK0JIxTRs9M8Nf14BK1Ky6GQYyi/7fAG9ADAfEWh4S0yEjY83NNhO7UsxUi2jQ2uOVrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mXM6Jv8h; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mXM6Jv8h"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-382ef647e20so1372998a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353382; x=1785958182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ovZABv9yoc1Q8/xxLQmvxzzbEKSvbmvmRNSZrpsZp4g=;
        b=mXM6Jv8h6bvfcalBi+Qoni3+kpjKtfTv6cBpsu2fBlvXGpOROCWn+OVsoNk1Lv7AlJ
         nsYUiA8bT4v8s9RmIcSTfQApgRmpNXaD6lLOtH0KGDhziZxRlp03LvAzsWHUebkCRXeg
         vdmmRIuydqHqt/O3wuWrltAvHy1DR0EXajpLiJTaGlCzW+Kg+fYAssJdKpBtsE+Bl2GD
         7SgqOrqpfaBWDYPC6h3x4Bocmeyfzc8HPEnXKgx+xQ8i46ALLuWCnFMT3A7ZAQsWv5Ux
         51qWXPtpjABh5/WVqkr+IdPKHXXEPSqjcrzgHhyVPfE3qEtJctttMG6fBEL8tQdnFiy2
         B3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353382; x=1785958182;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ovZABv9yoc1Q8/xxLQmvxzzbEKSvbmvmRNSZrpsZp4g=;
        b=BgDleXu9i4yE+fn6/5FCNC2rS4w/a5RZmkRF25Y5nSkhtW0Kwr+2g1gvWGWvBOF5Kc
         WwM224Mazy11auhsQ8KAqjDsl3UbxEbl1q9KroFrqPVqQ8jRlXgyeeDkZFXINg43C1r0
         AQT0gaSjVl2rVQyhhTb1QPRd/ZJBk5CJUiVUPwaFyxW5iJ2Wkiz3GGzTkYxWtLs/AJZ6
         KfB2ajyiOpREujiEFzfu+SYME+go0I3ffjdrXO1pIua4aYxakBYJOn+mzG5M9fhk/gDF
         h0ZJtK2nUFDwW9YusUfzlhp8FaDKC/eqB8PN0lnmv3wfrOTPMoIvwLUGuECAXI79/CS+
         ZYVw==
X-Forwarded-Encrypted: i=1; AHgh+RrO+tCOk89YCC73UakMZTyZV0f87rHNnRy6H+o0SDyBRL47LJvTp3Sw3pXkE6KfvXxPn4OZzndT6xc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgqqgh0Dw/tUrUM9EqB9Pc6XgMnnQBrMWOocJsCPyUWIJfDrV0
	/qVKaiqaCicL1msY06UENZbSBOgvklwbD/92ATzdg7XDzHdjbdhG5RJ2
X-Gm-Gg: AR+sD12FKyhMZwX5ML6hA+1XEta5JEg3Si9sG9ERzbIi6hr+ed1+rJPgbYRDrGcqTtY
	T8AZ2ukL6SLBJnobuyMf4dX1QtiVa75THltcHMHKO5evr87C1YbpSeLUgKVIj4oV0J1PGoVEvJV
	L8sMpLycqFZExdycGq7vyiznnSsSD3Z9djm5AuypwCx55cA/XVvzcs58rFgP6ccT6wXqj5ctwmt
	h63tpf40EgRtjVVf2GRKoEEh++fEVO4cHTPzMMTke1hH4q6x7x9FEDv4GGkNxtXq3YP7NpNwYkn
	W0zm5+HklufsRCu0PlMZLEvM/+PX1F37s3gnwMclvXPyb6UuSBunLOMKRpWcb94GyAd2LpKibE8
	HuOozOVmqzg8589sKBs1i0+92AjHXt5E1F5vMlylfEsw0wy8/lGYbqOEQdWCmobNztu+4eFEl8a
	kjzN0aUcMIAxxnoQcm5W8hWd9BpGG3Pv9GHDVZKO021/vXwkmT9/Apkq5On/uEMfSnjjajntnlp
	Fbk1ZPfmpvJPRS4MxPIa4z0jGjBN/LqcTpM58/8
X-Received: by 2002:a17:90b:4d11:b0:384:8a11:33eb with SMTP id 98e67ed59e1d1-38f99257d04mr170061a91.24.1785353381687;
        Wed, 29 Jul 2026 12:29:41 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:50::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f642e33cesm3188955a91.14.2026.07.29.12.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:29:41 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v5 00/22] iomap: convert to in-iter iomap_next() model
Date: Wed, 29 Jul 2026 12:27:15 -0700
Message-ID: <20260729192737.3190206-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series implements a suggestion by Christoph for finishing the conversion
of iomap to an iterator model. This revives Matthew's previous RFC [1], which
had the same intention.

Every iomap operation currently drives its iteration through a struct
iomap_ops, which contains two callbacks, ->iomap_begin() and ->iomap_end().
iomap_iter() only ever sees these as pointers, so every step of every
iteration is an indirect call, including on the hottest paths. 

This series replaces the begin/end pair with a single ->iomap_next() callback
that finishes the previous mapping (if any) and produces the next one.
Collapsing to one callback lets a performance-critical caller inline its
iteration loop and pass its ->iomap_next() function as a compile-time
constant, where the compiler can devirtualize the callback into a direct and
inlineable call rather than an indirect one. It also allows future callers
more flexibility in expressing custom logic in the IO path for driving the
iteration forward.

This series has no functional changes intended. The patches are broken down as
follows:

1) Patch 1: Brian's fix for folio batch release on iomap callback failures.
The bug was reported by Sashiko and is an unlikely/second order error scenario
[2] that doesn't need backporting to stable.

2) Patch 2: refactors existing iomap_iter() logic into an iomap_iter_next()
function. Sets up DEFINE_IOMAP_ITER_NEXT/DEFINE_IOMAP_ITER_NEXT_END macro.

3) Patch 3 and 4: Christoph's patches for decoupling simple direct i/o reads
from iomap_dio_rw and improvement for using GFP_NOWAIT for non-blocking iocbs
[3]

4) Patch 5: Adds ->iomap_next() callback as an iomap op

5) Patches 6 to 19: converts each filesystem to ->iomap_next() model

6) Patch 20: Removes the legacy ->iomap_begin()/->iomap_end() path

7) Patch 21: At this point, struct iomap_ops only has one item in it, the
->iomap_next() callback. Gets rid of struct iomap_ops and passes
iomap_iter_next_fn directly.

8) Patch 22: Updates the iomap documentation to match.

This series is submitted against the vfs tree on top of the vfs-7.3.iomap
branch (head commit f166f2d0a0ae "Merge patch series "iomap/fuse: add helper
to keep..."). The changes can also be found in this github link [4]. This
series was run through an ai review system for additional sanity-checking.

As discussed in v2 about the merge logistics [5], the plan is for patches 1 to
19 to be merged in the v7.3-rc1 cycle and for patches 20 to 22 to be merged
after v7.3-rc1 has been tagged, in order to minimize disruption to filesystems
that are currently landing iomap conversions during the 7.3 merge window.
Patches 20 to 22 are included in this series for upstream review, so that they
can be approved / all ready to go when the 7.3 merge window closes.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20200728173216.7184-1-willy@infradead.org/T/#u
[2] https://lore.kernel.org/linux-fsdevel/amjztG-DisHYbV9W@bfoster/
[3] https://lore.kernel.org/linux-fsdevel/20260723050201.3381045-1-hch@lst.de/
[4] https://github.com/joannekoong/linux/tree/iomap_iter_next_v5
[5] https://lore.kernel.org/linux-fsdevel/20260703-nachrangig-gegeben-befestigen-8219a53648c7@brauner/ 

Changelog
---------
v4: https://lore.kernel.org/linux-fsdevel/20260727211758.1116539-1-joannelkoong@gmail.com/
v4 -> v5:
* Add Brian's release batch fix, modify patch 2 ("split iomap_iter() logic
  into...") to work with this
* Add DECLARE_IOMAP_ITER_NEXT macro to patch 21 for forward declarations (Darrick)
* Kept reviewed-bys for the patches changed, but Darrick/Christoph/Fengnan, if
  you don't like the change and want to revoke your name, please let me know
* Add Reviewed-bys from Darrick and Fengnan

v3: https://lore.kernel.org/linux-fsdevel/20260720210202.1163861-1-joannelkoong@gmail.com/
v3 -> v4:
* Fold in Christoph's "decouple simple direct I/O reads from iomap_dio_rw v2"
  series and drop v3's simple dio patch/changes
* Add reviewed-bys

v2: https://lore.kernel.org/linux-fsdevel/20260701000949.1666714-1-joannelkoong@gmail.com/
v2 -> v3:
* Rename iomap_next_fn to iomap_iter_next_fn and iomap_process() to
  iomap_iter_next() (Darrick)
* Add integration with dio simple path, add Fengnan's patch
* Reconstruct patch that adds iomap_iter_next() logic as a refactoring of
  existing code (Christoph)
* Add DEFINE_IOMAP_ITER_NEXT{_END} macro, which nicely simplifies things
  (Christoph)
* Make documentation wording changes and a rename from dops -> next (Darrick)
* Update tracepoint in patch 19 to reflect taking iomap_iter_next_fn instead
  of ops. iomap tracepoints are explicitly called out as non-stable ABI so I
  kept Christoph's reviewed-by for this, but if that should be revoked, please
  let me know
* Add reviewed-bys

v1: https://lore.kernel.org/linux-fsdevel/20260625024723.1611000-1-joannelkoong@gmail.com/
v1 -> v2:
* Implement conversion for all callers

Brian Foster (1):
  iomap: release the folio batch on iomap callback failures

Christoph Hellwig (2):
  iomap: decouple simple direct I/O reads from iomap_dio_rw
  iomap: use GFP_NOWAIT when application for iomap_dio_simple
    allocations

Joanne Koong (19):
  iomap: split iomap_iter() logic into iomap_iter_next()
  iomap: add ->iomap_next()
  xfs: convert iomap ops to ->iomap_next()
  btrfs: convert iomap ops to ->iomap_next()
  ntfs3: convert iomap ops to ->iomap_next()
  ntfs: convert iomap ops to ->iomap_next()
  ext4: convert iomap ops to ->iomap_next()
  erofs: convert iomap ops to ->iomap_next()
  zonefs: convert iomap ops to ->iomap_next()
  ext2: convert iomap ops to ->iomap_next()
  block: convert iomap ops to ->iomap_next()
  f2fs: convert iomap ops to ->iomap_next()
  gfs2: convert iomap ops to ->iomap_next()
  hpfs: convert iomap ops to ->iomap_next()
  fuse: convert iomap ops to ->iomap_next()
  exfat: convert iomap ops to ->iomap_next()
  iomap: remove ->iomap_begin()/->iomap_end() legacy path
  iomap: pass iomap_iter_next_fn directly instead of struct iomap_ops
  Documentation: iomap: update docs to reflect iomap_iter_next model

 Documentation/filesystems/iomap/design.rst    | 140 ++++++++---
 .../filesystems/iomap/operations.rst          |  68 +++---
 Documentation/filesystems/iomap/porting.rst   |  16 +-
 block/fops.c                                  |  10 +-
 fs/btrfs/direct-io.c                          |  10 +-
 fs/dax.c                                      |  48 ++--
 fs/erofs/data.c                               |  30 ++-
 fs/erofs/internal.h                           |   2 +-
 fs/erofs/zmap.c                               |   4 +-
 fs/exfat/file.c                               |  18 +-
 fs/exfat/inode.c                              |   6 +-
 fs/exfat/iomap.c                              |  12 +-
 fs/exfat/iomap.h                              |   6 +-
 fs/ext2/ext2.h                                |   3 +-
 fs/ext2/file.c                                |   4 +-
 fs/ext2/inode.c                               |   7 +-
 fs/ext4/ext4.h                                |   8 +-
 fs/ext4/extents.c                             |   8 +-
 fs/ext4/file.c                                |  16 +-
 fs/ext4/inode.c                               |  16 +-
 fs/f2fs/data.c                                |   4 +-
 fs/f2fs/f2fs.h                                |   3 +-
 fs/f2fs/file.c                                |   4 +-
 fs/fuse/dax.c                                 |  12 +-
 fs/fuse/file.c                                |  10 +-
 fs/fuse/virtio_fs.c                           |   3 +-
 fs/gfs2/aops.c                                |   6 +-
 fs/gfs2/bmap.c                                |   7 +-
 fs/gfs2/bmap.h                                |   2 +-
 fs/gfs2/file.c                                |   6 +-
 fs/gfs2/inode.c                               |   6 +-
 fs/hpfs/file.c                                |   6 +-
 fs/internal.h                                 |   1 -
 fs/iomap/buffered-io.c                        |  40 +--
 fs/iomap/direct-io.c                          | 219 +++++------------
 fs/iomap/fiemap.c                             |   8 +-
 fs/iomap/iter.c                               | 123 +++++-----
 fs/iomap/seek.c                               |   8 +-
 fs/iomap/swapfile.c                           |   4 +-
 fs/iomap/trace.h                              |  12 +-
 fs/ntfs/aops.c                                |   6 +-
 fs/ntfs/file.c                                |  24 +-
 fs/ntfs/inode.c                               |   2 +-
 fs/ntfs/iomap.c                               |  34 +--
 fs/ntfs/iomap.h                               |  10 +-
 fs/ntfs3/file.c                               |  16 +-
 fs/ntfs3/inode.c                              |  11 +-
 fs/ntfs3/ntfs_fs.h                            |   3 +-
 fs/remap_range.c                              |   6 +-
 fs/xfs/xfs_aops.c                             |   8 +-
 fs/xfs/xfs_file.c                             |  58 ++---
 fs/xfs/xfs_iomap.c                            |  50 ++--
 fs/xfs/xfs_iomap.h                            |  20 +-
 fs/xfs/xfs_iops.c                             |   4 +-
 fs/xfs/xfs_reflink.c                          |   6 +-
 fs/zonefs/file.c                              |  23 +-
 include/linux/dax.h                           |  18 +-
 include/linux/fs.h                            |   7 +-
 include/linux/iomap.h                         | 231 ++++++++++++++----
 59 files changed, 771 insertions(+), 682 deletions(-)

-- 
2.52.0

