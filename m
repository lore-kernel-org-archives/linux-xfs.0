Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794962937;
	b=juvD0gI4GpOa24c76pzjIH1FMbF2izlCR7Z1ma8V1NE5T077J4dOa/RnfgpT5rb2nPob
	 kM3lNUszNj0aChOCevZljRg8RrOg6YxrLVVlCStU+U9MpL1RjLwFvjEFNL8IfcUsdxg0X
	 kLDQQN+d9x7DivdKi7h+NiR7+UlYedwG1u6mgLEAf01ZmE5479KCpM22O+BwHMsQLtCmP
	 sN7GK/NsSIKWSJ+i59ebZhU8I8Hm0XBo2ZE3qkVLUmYCsXqJXToG4FI+PvqgyvI3ykf7e
	 4V5LuVzht7T38sJ37PPNq64Eu7U/rGcK86iKMh6fdUuoyXnyAU/vfZrqtwjBeDYQ4tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962937;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8V2XOZmn0Vctd6GGoq9tH0tWyX2ZAclwzJyrOF4lr5s=;
	b=1T/+tFEXkKa/5aBoRLtdFn79OLfXK5YS3LEtYBLR502A7bSpurdF/HJyECwJnqH59Zxh
	 EuKbqw8cNAOq5snU+eiAFYVlLu5i7Ucr2RQv7AKaxIIVnaguirOZdLz5x2kD2DQ2areOj
	 pnQ6J5o1Ya8FQsJi/mokFTCvCSzwQFbGsWk0fGBbhhaDIUw0UZ+L4urFfXWraQFvBdK7N
	 pBnUKOSFMNzBKUw58hVSNU3vQcMqSKmN4jGxu+9Te8DXefwDapV6T4STgTzlvgWbyddlR
	 cewL0bHOmnnI++OcnJmlwmWyzN8cYssA/6lH5wVJNeheYL1tHf6GsDF8vyI+wjc+HKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dubeyko.com;
	spf=pass smtp.mailfrom=dubeyko.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=j5niG9jT;
	arc=none smtp.remote-ip=74.125.224.44
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BEF606A886
	for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 00:48:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19BEF606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=j5niG9jT
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-67c6a0abc2eso366180d50.0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 16:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20260707.gappssmtp.com; s=20260707; t=1794962936; x=1795567736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8V2XOZmn0Vctd6GGoq9tH0tWyX2ZAclwzJyrOF4lr5s=;
        b=j5niG9jTnJN1+gZWK21jVz+cw+yHDsYF54ZwSy+ffCeVmvhUtigihjzMA3Mx/izRsI
         /fZJgCpHIIkkY5Wf1lmBFZ+Xe3paQzu3YFRsTVJyq7eVhJ6kqpBhSocstjZb7M11xhbh
         3WlkURETSQgnt/vNwX8lpuJcDbb2BuCoCXjQjs9GaHZcER53/T0+PJmZD0EutNvY67P7
         I2L+M2GDcmp4rGU+5p53p6w9sYjfjw+kkZAfFDv0qc9Eh0iECvt+7tLG+asujOUE5UTg
         NTb9cCWZGl9BCi2FGlAKXt5SDnOw5zR7Y0jnh7rD3cPAZV0I5b2KoDTK2BcZMcQqoLyw
         bf4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794962936; x=1795567736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8V2XOZmn0Vctd6GGoq9tH0tWyX2ZAclwzJyrOF4lr5s=;
        b=OWYCgWIlfGdbnU8sKwbeD5GWNSHCQiY28miQ9MHgWAIRCvJGgBTZ6Vz99LNRErgdfQ
         KDIc7EEtfGS7BHmiyPlg0JaeI7fnR9k4LrlCbqhmA/lQ5Fg2gWt57HPqdgCUuyroyQAr
         L8E/8yB0nQp+S7iV6IoN2xzOc+LAIQ/Kls4BzOakBNvT6QkKUTbtIbUeP4Wy5ioPEZ94
         3wTMMi2NDxqrFUNda3jCR27ogn8q8b5FPIMwjwFOKMJbFPLkP/XZJ1zNMWTvkLtQdPM5
         OlMWsxipbLGUObFbivmd7Gh+28el1GhyyLJdod+UYhsPPTaAWY0HVMWi8VggviSShSiH
         4+AQ==
X-Forwarded-Encrypted: i=1; AL+hErHTmXcjT0pTJ0t8MmHF8TjIVcGRquJKnLoWQSV/eXpqeVuzI7lAjbfAPPqhTEpT7wNQ0NA0dpKCtHc=@vger.kernel.org
X-Gm-Message-State: APuU4Z8xeOqqJR66g/09P2VCRnyF9+O+N03wvMOwoUQToUKOa5W/LAEe
	cKe1/OHcsQ3XoteJFD36LUXRSu8g0tNB/SasDFufUqzihcv24gSJemb/4LeLbJPfErM=
X-Gm-Gg: AZFdTZcK2MRP7MQ1jWAhKELCnJA1mIeXddCjG67DyuCL0CxjuyLvTuXYBQb6828Ns1m
	/dDj68k0Xr/KLbj5WPYV4qWAuL8LkJFmNZo7PyR6i/RCkP9crLl6LSYLidYCDYy67FUzZlRvbhn
	VVYX31WHFL/hy7KI2ge8SWfv2HLjBXOh4MWAOrqPWct4bTMgEkb+VyuqgYulOb4fPslvlTk+tBk
	tR1quoTmUtin0GVx70oyvASdQO+cpOTp4I/14UYrbSATND7ZBMUwCatCzSfOWEkpb5sx1WIqJeR
	Y7gy/e4hurak+8JzxUJ0lbWSVCKVu9fLN3o1W8h0sIv+Qne/0+UylzxuVV2yA6WpUws+Cy4dPAD
	frxpuxAREMJrakn6MLxl+FoiBerWWpis5FMVNkpmoLH7O/41hjiWJ0qGXHjrVI8/EFZUyfFUsc8
	yjToW4vuBBxInGtbxJSYuRQ8VmHgkDTu0aKqOVwfTJfZ5YZ+Zjec5oijHI9gFdevgdEY/VzsJlN
	6eRkZRpC6qgByhpYN5mxMvQv45/zsLIpSjq0ASwoLYFYmmjn/7X2/tb0GMyT0p/lM9D/OvYWe/8
	tyBZ3Fx5kHgxCrD5ci6mg8hpDIWLWnLuc0ABo36PmkYX7z+EdLJnVxmfwlvH0aetKKOoEHjnFq2
	SmWgbbIx+LzvZ6VPIsdEk0HLAfgctDG02liX6Xdr6fs2LeKk+ATDAlktg2O8rjqvmabrkCcFL6m
	DC3CyS85GHfN6hmyx5
X-Received: by 2002:a05:690c:6f84:b0:8b3:4b09:f4ef with SMTP id 00721157ae682-8b4febd981dmr3810477b3.13.1794962935978;
        Tue, 17 Nov 2026 16:48:55 -0800 (PST)
Received: from system76-laptop.attlocal.net ([2600:1700:6476:1430:5fae:4d02:7055:94ad])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67dd56ead87sm729575d50.1.2026.11.17.16.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:48:55 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: glaubitz@physik.fu-berlin.de,
	frank.li@vivo.com,
	hch@lst.de
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	vdubeyko@coreweave.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v5 0/5] hfsplus: convert regular file I/O to iomap
Date: Tue, 17 Nov 2026 16:48:39 -0800
Message-ID: <20261118004844.3849979-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch the HFS+ regular file data path from buffer heads and
blockdev_direct_IO() to iomap.

(1) adds a generic iomap_dio_end_io() helper to
include/linux/iomap.h: a direct write ->end_io callback that updates
i_size when the write goes beyond the end-of-file. It can be used by
file systems that issue all extending direct writes synchronously
under inode_lock.

(2) moves the file related operations (open, release, fsync and
file_operations) from inode.c into the new file.c, without functional
changes, to prepare the place for the iomap-based file operations.

(3) splits the extent lookup/allocation logic out of
hfsplus_get_block() into hfsplus_map_extent(), which reports the
mapping without a buffer_head, so that the iomap path can use it
directly. No functional change for the buffer_head path.

(4) makes hfsplus_map_extent() return -EIO when no extent covers
the requested block. On a corrupted volume, hfsplus_get_block() mapped
such a block to allocation block 0, i.e. the boot blocks and the volume
header. The iomap path relies on this check, since a zero-length extent
would otherwise produce a zero-length mapping.

(5) adds the HFS+ iomap operations, implements iomap-based
llseek/read_iter/write_iter, switches hfsplus_aops to iomap (removing
hfsplus_direct_IO() and the LEGACY_DIRECT_IO dependency), and rolls
back i_size and the allocated blocks when the zero-filling extension
or the data write fails. HFS+ doesn't support holes, so extending
writes and truncates zero-fill the gap up to the new end-of-file.

Changes since v4:
- iomap_dio_end_io() is extracted into a dedicated patch 1.
- Rebased on top of "hfsplus: don't take inode_lock in
  hfsplus_file_fsync()", "hfsplus: set s_maxbytes from the volume
  capacity" and "hfsplus: release preallocated blocks in
  hfsplus_file_truncate()", which are already applied.
- v5 patches 04, 06, 07 and 10 are squashed into patch 5.
- The -EIO check in hfsplus_map_extent() is moved out of the iomap
  conversion into the separate, documented patch 4.
- The phys_size change in hfsplus_get_block() is dropped: it is not
  related to iomap, since after the conversion hfsplus_get_block() only
  allocates blocks when phys_size is block-aligned.
- hfsplus_write_iomap_end() keeps fs_blocks and the inode byte count in
  whole blocks, as hfsplus_inode_read_fork() and hfsplus_file_truncate()
  do, while phys_size stays byte-granular for a partially written block.
- __hfsplus_iomap_begin() ends a mapping of initialized blocks at the
  block boundary above phys_size instead of at phys_size itself. With
  an unaligned on-disk size this used to produce a mapping length that
  is not a multiple of the logical block size, and an aligned O_DIRECT
  overwrite failed with -EINVAL.
- The fsync locking change is dropped from this series, since it is
  handled by the separate prep patch.
- The volume capacity check in hfsplus_file_write_iter() is dropped,
  since generic_write_checks() enforces s_maxbytes, which is set from
  the volume capacity.

Viacheslav Dubeyko (5):
  iomap: add iomap_dio_end_io() helper
  hfsplus: move file related operations to file.c
  hfsplus: rework hfsplus_get_block() logic
  hfsplus: return -EIO from hfsplus_map_extent() if no extent covers the
    block
  hfsplus: convert regular file I/O to iomap

 fs/hfsplus/Kconfig      |   2 +-
 fs/hfsplus/Makefile     |   5 +-
 fs/hfsplus/extents.c    | 163 +++++++++++++++------
 fs/hfsplus/file.c       | 308 ++++++++++++++++++++++++++++++++++++++++
 fs/hfsplus/hfsplus_fs.h |  26 +++-
 fs/hfsplus/inode.c      | 274 +++++++++++------------------------
 fs/hfsplus/iomap.c      | 254 +++++++++++++++++++++++++++++++++
 fs/hfsplus/iomap.h      |  17 +++
 include/linux/iomap.h   |  20 +++
 9 files changed, 823 insertions(+), 246 deletions(-)
 create mode 100644 fs/hfsplus/file.c
 create mode 100644 fs/hfsplus/iomap.c
 create mode 100644 fs/hfsplus/iomap.h

-- 
2.53.0

