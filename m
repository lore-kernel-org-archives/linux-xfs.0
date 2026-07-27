Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0947C3783AD
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187468; cv=none; b=UIj76QjO90DlKTjPbD05eKLZOnubkM9Zn3yg3fBH7palaW3iWi0uJHjttILYRAXfvI0aGpoYhaJaepZAoScEMGMU7+zpRAPz+Ruarxt4uAwi7bLUXkHupJvKT/Akuo1OjxKnUvsyPyDmaunWWE98Wl8xniZ4T0rqR+HHyK8fiY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187468; c=relaxed/simple;
	bh=6coMMzJvMlt96tUiQ+2wIJibJRmGZxsGHGesRSw6xlk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H8lyZyeDXQee/TMrauFZsmM71TLzTMiOCXWr/ZbjUZt1p784wYfxWd9CjxBpjlDKv2Z1G6OIR+/+L6ZAyF8fRbqAvLlv4sTP5V/B8Nq76R7cFDEIt3Gi8NN95ZfENZfTRSA74H7WEYXNKxWq5qeUFj3SwLtWllgDJWq0W7E9Glo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PElMfLzj; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PElMfLzj"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cca0c5799eso30055805ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187466; x=1785792266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nwQurP/2xKbuuU+V4mrpMPrFREANrf+WyvNyFFZA9r4=;
        b=PElMfLzjxIsI4Sx4DWhMJH8vVEQIZa52+cHiEW0Os3Rr+xKY40+OI3QKgv55C0AgBi
         ooAXi1uhGiPIDIoZBejv36ABtqxKj+mJMei79ObG/FDXKTaz8+zAp1tCgXwFvOkiXavU
         smKCnRzRKy5Hf0fjlXS7HrdY+Lkr3e7P+xmjofkN6N86uvD/XUsCa2Czd7vqsSr4Arzj
         RN3kEnX73Y1IJLu5+Pzv72OPUa7spL3ul5eJaFshTIbu5n1moOcImguL6Sl9o+1FzMzD
         T0J6evsMPZO/KYJaHo3y8evlAzmpxESPc7KjaTWOO9/yLkbqcvQnNbpwoiFrIAYZ/Igu
         +MNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187466; x=1785792266;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nwQurP/2xKbuuU+V4mrpMPrFREANrf+WyvNyFFZA9r4=;
        b=MC6LHByNKnlBBe0KDGfbUJaoau33PWsKXOKYuVdp+fjjx44Z2i3Eg+YRYqz8zSo4sd
         4dUjpuQw+9eVQcpMLi7rZTD8LT2JIk4+Rhpcf8kS5tE6VcvPhtB757lPkd7W+8qnLzc8
         zdbPkoV0dPX3HB+TARn1auqg6teIr51vwnkqk+U3fwrV1XuRF9XVZVqUp2z6ej5Ht9EU
         a5M78SP8gWGK98EPTRTJNfNMVYNyuc3nac7ZHCVRoczk/9BMsTKBfa7Dv+Dr/soYaGtN
         xHBMziBkmv82TyLKihGWt2FWYP6LuR7AG8dsfrmXef4cf/CHbBBUNlju0vdVQbJuZVT/
         Y0XA==
X-Forwarded-Encrypted: i=1; AHgh+RrikMGP9MV6MNYS3ne7DExL618Ad2XzFE0a6xQsJ/kZ5Yco5k/hF9ueLp89yznp9WFIeZM9RpLVfcY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVzA9urq30s+nfNZRZIli90B0F0LQA9XobJQbXzbcMEZHevqml
	pIzGOy6fTL5HTu1hKIyO368c62rlEkxV0xZV79QwRqna5WOO+z1zw1CI
X-Gm-Gg: AR+sD13ZcqEcJJHWljS7g+BxQAY2WxAdNIc85IsOst7GdPezVjUe0CnNh6YtEoHsgIK
	wlD9PbYb4fR2lxRPmumlNmR5HlGQUF+uZE3q0cbarEXw0UwWlyuiiYouLV4DxqiuS9fhTCTUHt0
	gyIGsReghI74lyKdD6rEHTQ/2tZTdRhjNMBeYF0QFRN0dXKj4RHOuARDAj9JUNq9wpmilMH2dhW
	5vU0egC5eT52HL/hTIMrwIQpVrZmxVk5gNCmrV/MnmL3Yrn1mg+V9//p51lUd8p0KMoN/3O7OKD
	iWgPkgmlTBjxaBoq/ipG1oNgw0OfcunEYW+RFU5qtm1pIL1A+tzYCVJn//jgq+8nfACCG/DWcvs
	aHEy1pOo1wgsSd1e71BGCMXwsZXVkdoMrPPWBIxK3QseIHDwT1QVsqMkDRCOOZnlzL28y6e6WuT
	QnyoXTuPULtnF1CJDzu0JbZuxSH+kR2KdxhQ3AcsE+n01WIfMYBk2/l5RHQWhKmgVOs3nSQdXi5
	ZA=
X-Received: by 2002:a17:902:ec81:b0:2cf:afa5:b19a with SMTP id d9443c01a7336-2cfde797554mr88864015ad.11.1785187466278;
        Mon, 27 Jul 2026 14:24:26 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde5e3e0asm40597175ad.29.2026.07.27.14.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:25 -0700 (PDT)
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
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 00/21] iomap: convert to in-iter iomap_next() model
Date: Mon, 27 Jul 2026 14:17:37 -0700
Message-ID: <20260727211758.1116539-1-joannelkoong@gmail.com>
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

1) Patch 1: refactors existing iomap_iter() logic into an iomap_iter_next()
function. Sets up DEFINE_IOMAP_ITER_NEXT/DEFINE_IOMAP_ITER_NEXT_END macro.

2) Patch 2 and 3: Christoph's patches for decoupling simple direct i/o reads
from iomap_dio_rw and improvement for using GFP_NOWAIT for non-blocking iocbs
[2]

3) Patch 4: Adds ->iomap_next() callback as an iomap op

4) Patches 5 to 18: converts each filesystem to ->iomap_next() model

5) Patch 19: Removes the legacy ->iomap_begin()/->iomap_end() path

6) Patch 20: At this point, struct iomap_ops only has one item in it, the
->iomap_next() callback. Gets rid of struct iomap_ops and passes
iomap_iter_next_fn directly.

7) Patch 21: Updates the iomap documentation to match.

This series is submitted against the vfs tree on top of the vfs-7.3.iomap
branch (head commit f166f2d0a0ae "Merge patch series "iomap/fuse: add helper
to keep..."). The changes can also be found in this github link [3]. This
series was run through an ai review system for additional sanity-checking.

As discussed in v2 about the merge logistics [4], the plan is for patches 1 to
18 to be merged in the v7.3-rc1 cycle and for patches 19 to 21 to be merged
after v7.3-rc1 has been tagged, in order to minimize disruption to filesystems
that are currently landing iomap conversions during the 7.3 merge window.
Patches 19 to 21 are included in this series for upstream review, so that they
can be approved / all ready to go when the 7.3 merge window closes.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20200728173216.7184-1-willy@infradead.org/T/#u
[2] https://lore.kernel.org/linux-fsdevel/20260723050201.3381045-1-hch@lst.de/
[3] https://github.com/joannekoong/linux/tree/iomap_iter_next_v4
[4] https://lore.kernel.org/linux-fsdevel/20260703-nachrangig-gegeben-befestigen-8219a53648c7@brauner/ 

Changelog
---------
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
 fs/erofs/internal.h                           |   3 +-
 fs/erofs/zmap.c                               |   4 +-
 fs/exfat/file.c                               |  18 +-
 fs/exfat/inode.c                              |   6 +-
 fs/exfat/iomap.c                              |  12 +-
 fs/exfat/iomap.h                              |   6 +-
 fs/ext2/ext2.h                                |   3 +-
 fs/ext2/file.c                                |   4 +-
 fs/ext2/inode.c                               |   7 +-
 fs/ext4/ext4.h                                |   9 +-
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
 fs/gfs2/bmap.h                                |   3 +-
 fs/gfs2/file.c                                |   6 +-
 fs/gfs2/inode.c                               |   6 +-
 fs/hpfs/file.c                                |   6 +-
 fs/internal.h                                 |   1 -
 fs/iomap/buffered-io.c                        |  40 ++--
 fs/iomap/direct-io.c                          | 219 +++++------------
 fs/iomap/fiemap.c                             |   8 +-
 fs/iomap/iter.c                               | 122 +++++-----
 fs/iomap/seek.c                               |   8 +-
 fs/iomap/swapfile.c                           |   4 +-
 fs/iomap/trace.h                              |  12 +-
 fs/ntfs/aops.c                                |   6 +-
 fs/ntfs/file.c                                |  24 +-
 fs/ntfs/inode.c                               |   2 +-
 fs/ntfs/iomap.c                               |  34 +--
 fs/ntfs/iomap.h                               |  15 +-
 fs/ntfs3/file.c                               |  16 +-
 fs/ntfs3/inode.c                              |  11 +-
 fs/ntfs3/ntfs_fs.h                            |   3 +-
 fs/remap_range.c                              |   6 +-
 fs/xfs/xfs_aops.c                             |   8 +-
 fs/xfs/xfs_file.c                             |  58 ++---
 fs/xfs/xfs_iomap.c                            |  50 ++--
 fs/xfs/xfs_iomap.h                            |  28 ++-
 fs/xfs/xfs_iops.c                             |   4 +-
 fs/xfs/xfs_reflink.c                          |   6 +-
 fs/zonefs/file.c                              |  23 +-
 include/linux/dax.h                           |  18 +-
 include/linux/fs.h                            |   7 +-
 include/linux/iomap.h                         | 223 ++++++++++++++----
 59 files changed, 772 insertions(+), 688 deletions(-)

-- 
2.52.0

