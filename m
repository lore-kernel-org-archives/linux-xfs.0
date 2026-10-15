Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82A7469850
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792046072; cv=none; b=DF78cOXZR2Ri2/KhN5qMJ8uwJ5fjnR3GZvbk4/7qQHPGMi2Vk3NgO6SzSWqfc+SZ4GD07cH9Ek5n2xyCLr2sRe72R3m2Gx8YKzNXHRK6wxbO8R/nWqQ+rlT66nZAt/6EJRhIOBqvBk3pAkGF2gFEkGUG66uOtvOAnHo1gDjJLMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792046072; c=relaxed/simple;
	bh=IR792nxMxHlccU8XcWdRC2/wzvm52uIVXjj+ZscwVDc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=Dhq2GpbDPka/HrMqj1VwidF8FtFhqqhrtHW51QjAgnboVoFN8W25pM7OS4Z9lXe51tCQaOpR7ukOm4ysNUVry98X+LezA9UzaWkQegmeg6izWPoqfGM+KzFKCTZ/XSq10yYh6P+87p/k3hgSMvDsYYzAivaE3Fkm3JYNHrhTSGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ih2NMhzA; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ih2NMhzA"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261015063427epoutp038c1a505ad2a7924004a6180a709a1ece~eoGdFTeP52402024020epoutp03c
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261015063427epoutp038c1a505ad2a7924004a6180a709a1ece~eoGdFTeP52402024020epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792046067;
	bh=pAdekcg45tOu2SndnRd+uVAMJl+R87BmrYqUT4A3iMQ=;
	h=From:To:Cc:Subject:Date:References:From;
	b=ih2NMhzAQpfB2AAAmYdx9lOkvMv8i+TpjX8pyExvkwdzl48NJ2D8ddcmTZR9H+Cu0
	 ivRnC1SnkPC+VFnT1U6ThLDLcJPKuzSallNd8B6bRjmqkC8/tWQQkYyIDJfwsqYFic
	 vP02IpKKzU7hxCZuonv/3mzqY3TYZzcc0mPcedQA=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20261015063426epcas5p194f2323e7917759f1d6377e0bb71b322~eoGcpaN0u3135831358epcas5p1X;
	Thu, 15 Oct 2026 06:34:26 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.89]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4j4ywL03Pcz2SSKX; Thu, 15 Oct
	2026 06:34:26 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20261015063425epcas5p23fd76d70af639f4bb138332ca3a575b0~eoGboaqXa1229812298epcas5p23;
	Thu, 15 Oct 2026 06:34:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261015063423epsmtip140b09531f0bb865848c2f050bd5a47ba~eoGZ1ryAb1215812158epsmtip1q;
	Thu, 15 Oct 2026 06:34:23 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v6 0/8] xfs write streams
Date: Thu, 15 Oct 2026 12:02:38 +0530
Message-Id: <20261015063246.103433-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261015063425epcas5p23fd76d70af639f4bb138332ca3a575b0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261015063425epcas5p23fd76d70af639f4bb138332ca3a575b0
References: <CGME20261015063425epcas5p23fd76d70af639f4bb138332ca3a575b0@epcas5p2.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

This series introduces a generic interface [2,3] for write stream management on
files.
It enables spatial isolation (at sw and hw level) and concurrency improvments [1]
in xfs by
(a) steering each write stream to its own set of allocation groups (patch #5)
    and realtime groups (patch #6).
(b) connecting xfs write streams to block write streams (FDP capable NVMe).

Write streams allow the abstraction provider (fs, block, raid etc.) to
leverage application's intent (file relationships/lifecycle).
- application: reserves a stream and sets it on the files it wants
  placed together.
- xfs: maps streams to AGs/RGs; allocates without interleaving; gains
  higher concurrency due to reduced lock contention.
- hardware: maps streams to underlying allocation unit; reduces device
  internal write amplification, improved life, predictable QoS.

Also
- A stream is handed out using an fd. The filesystem is free to map streams
  onto its own geometry, and the reservation/fd machinery is generic
 (fs/write_streams.c) so other filesystems can reuse it.

- Since high-level write stream (in xfs) and logical placement can work
  without the low-level write streams (in block device), series has a general
  value beyond the hardware that provides spatial isolation. Patches 1-7 are
  software only and work on any block device; patch 8 aligns the stream
  count to the hardware streams when the device has them.

- write-stream is different from existing 'filestream' allocator which
  maintains directory-to-AG associations in a global MRU cache. That
  requires state managment and memory (and its reclaim). Proposed AG-set
  based steering relies on simple, statless/lockless airthmatic that aligns
  more with the default allocator heuristics.

[1]
### Performance

1. On regular NVMe

a. Inter-stream concurrency
---------------------------
fio: 4k write, direct IO, 16 jobs, 1 directory, 16 files * 8GiB, iodepth 32
xfs: 16 AGs, 4 write-streams

base: 41 KIOPS
write-stream AG-set: 227 KIOPS (+453%)
here, 16 files are assigned 4 distinct write-streams (4 files/stream)

b. Intra-stream concurrency
----------------------------
fio: 4k write, direct IO, 4 jobs, 1 directory, 4 files * 8GiB, iodepth 32
xfs: 16 AGs, 4 write-streams, write-stream AG-set size = 4

base: 59 KIOPS
write-stream AG-set: 112 KIOPS (+89%)
here, 4 files are assigned single write-stream

2. On FDP-capable NVMe:
RocksDB YCSB
WAF (base vs write-stream): 35% Reduction


[2]
### Application interface

Three new ioctls:
      FS_IOC_WRITE_STREAM_GET_MAX  number of streams the filesystem offers
      FS_IOC_WRITE_STREAM_ALLOC    reserve a stream, returns fd for that
      FS_IOC_WRITE_STREAM_SET      set stream, given its fd, on a file

### Comparison with Write Hints (RWH_WRITE_LIFE_*)

- Semantics: Write Hints describe 'data temperature' (e.g.,short/long/extreme),
  implying a lifetime. Write Streams describe 'data placement'
  (e.g., Bin 1/Bin 2), implying only separation.

- Scalability: Write Hints are limited to a small, fixed enum (6 values).
  Write streams are dynamic, provider-dependent values that can scale much
  higher.

- Discovery: The existing write-hint interface is advisory and decoupled
  from underlying capabilties; application has no way to probe support
  and cannot deterministically know which hints are valid. OTOH, write-streams
  provide explicit discovery.

- Usage model: application needs to get a handle (fd) for a write stream
  before being able to use it. This avoids two unrelated applications
  ending up on the same stream.

Note: within the kernel, the separation between two constructs
(write-hint and write-stream) had started from 6.16 itself.

### Changelog

since v5:
https://lore.kernel.org/linux-xfs/20260921093147.59935-1-joshi.k@samsung.com/

Fixes for issues found by Sashiko review; no changes in UAPI
- fix 32-bit build: use do_div() for the inode-number hash in AG and
  rtgroup selection
- bound the stream pool to U16_MAX, the range of the stream id
- cap the hardware stream count at U8_MAX, the most streams the block
  layer can tag
- tag the iomap_dio_zero() bio with the write stream, so sub-block
  direct writes are not split across streams
- document that the stream pool must outlive the mount a stream pins;
  kernel-doc fixes
- rebase on 7.3-rc7

since v4:
https://lore.kernel.org/linux-xfs/20260717125538.508925-1-joshi.k@samsung.com/

- stream reservation and fd handling moved to generic code, and the
  stream id moved to struct inode from xfs inode (Darrick, Christoph)
- stream id no longer shows in uapi: OPEN becomes ALLOC and returns
  fd for any (unreserved) stream; OPEN_EXACT and GET are gone (Christoph)
- ALLOC requires CAP_SYS_ADMIN (Christoph)
- write stream and write life time hint are mutually exclusive at both
  setters
- stream pool lives on the buftarg (Christoph), which gives the realtime
  device streams of its own: new patch to enable RT support (Christoph, Darrick)
- software streams come first and work on any device; hardware streams
  are enabled in the last (Christoph)

since v3:
https://lore.kernel.org/linux-block/20260616180555.33338-1-joshi.k@samsung.com/
- add fd-based interface to open/set the write stream (Christoph)
- move from single multiplexed ioctl to 4 distinct ioctls (Christoph)
- add mutual exclusion checks against existing write-hint, filestream (Christoph)
- uint16_t for write-stream within iomap and other streamlining (Darrick)

since v2:
https://lore.kernel.org/linux-fsdevel/20260309052944.156054-1-joshi.k@samsung.com/
- xfs default allocator optimization using fixed-size generic AG set (Dave)
- reuse the above to simplify the write-stream AG set handling
- streamline the uapi; Use union for GET_MAX and GET/SET (Darrick)
- uint16_t for write-stream within xfs inode and other cleanups (Darrick)

since v1:
https://lore.kernel.org/linux-fsdevel/20260216052540.217920-1-joshi.k@samsung.com/
- swich from fcntl based to ioctl-based interface (Christian)
- new patch (#4) that makes xfs allocator use the write streams for AG
  selection
- new patch (#5) that introduces software write streams in xfs.

[3]
### Interface example
/*
 * Minimal write-stream example.
 *
 *      cc -Wall -o ws-example ws-example.c
 *      sudo ./ws-example /mnt/xfs        # data device
 *      sudo ./ws-example /mnt/xfs rt     # realtime volume
 *
 * Reserves two streams.  a.dat gets the first; b.dat and c.dat share the
 * second.  Each file then takes one 4K write, so a.dat is placed apart from
 * b.dat and c.dat, which are placed together.
 *
 * With "rt" the files are made realtime first.
 */

#include <sys/ioctl.h>
#include <err.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <linux/fs.h>

struct fs_write_stream_set {
        __s32   stream_fd;      /* IN: stream to set, -1 to clear */
        __u32   flags;          /* IN: FS_WRITE_STREAM_SET_* */
};

#define FS_WRITE_STREAM_SET_CLEAR       (1U << 0)

#define FS_IOC_WRITE_STREAM_GET_MAX     _IOR(0x15, 3, __u32)
#define FS_IOC_WRITE_STREAM_ALLOC       _IO(0x15, 4)    /* returns an fd */
#define FS_IOC_WRITE_STREAM_SET         _IOW(0x15, 5, struct fs_write_stream_set)

static char buf[4096];

/* create @name; with @rt, put it on the realtime volume */
static int create_file(const char *dir, const char *name, int rt)
{
        struct fsxattr fa;
        char path[512];
        int fd;

        snprintf(path, sizeof(path), "%s/%s", dir, name);

        fd = open(path, O_CREAT | O_TRUNC | O_RDWR, 0644);
        if (fd < 0)
                err(1, "%s", path);
        if (!rt)
                return fd;

        if (ioctl(fd, FS_IOC_FSGETXATTR, &fa))
                err(1, "FSGETXATTR %s", name);
        fa.fsx_xflags |= FS_XFLAG_REALTIME;
        if (ioctl(fd, FS_IOC_FSSETXATTR, &fa))
                err(1, "FSSETXATTR %s (no realtime volume?)", name);
        return fd;
}

/* set @stream_fd on @fd, write 4K */
static void write_on_stream(int fd, const char *name, int stream_fd)
{
        struct fs_write_stream_set set = { .stream_fd = stream_fd, .flags = 0 };

        if (ioctl(fd, FS_IOC_WRITE_STREAM_SET, &set))
                err(1, "SET %s", name);
        if (write(fd, buf, sizeof(buf)) != sizeof(buf))
                err(1, "write %s", name);
        fsync(fd);
        close(fd);
}

int main(int argc, char **argv)
{
        __u32 max = 0;
        int rt, fa, fb, fc, s1, s2;

        if (argc < 2 || argc > 3 || (argc == 3 && strcmp(argv[2], "rt")))
                errx(2, "usage: %s <dir-on-xfs> [rt]", argv[0]);
        rt = argc == 3;

        fa = create_file(argv[1], "a.dat", rt);
        fb = create_file(argv[1], "b.dat", rt);
        fc = create_file(argv[1], "c.dat", rt);

        /* query and reserve through a file on the device being placed on */
        if (ioctl(fa, FS_IOC_WRITE_STREAM_GET_MAX, &max))
                err(1, "GET_MAX");
        printf("max streams: %u\n", max);
        if (max < 2)
                errx(1, "need at least 2 streams");

        /* ALLOC returns the stream fd as the ioctl return value */
        s1 = ioctl(fa, FS_IOC_WRITE_STREAM_ALLOC);
        if (s1 < 0)
                err(1, "ALLOC");
        s2 = ioctl(fa, FS_IOC_WRITE_STREAM_ALLOC);
        if (s2 < 0)
                err(1, "ALLOC");

        write_on_stream(fa, "a.dat", s1);
        write_on_stream(fb, "b.dat", s2);
        write_on_stream(fc, "c.dat", s2);

        /* closing a stream fd releases the stream */
        close(s1);
        close(s2);

        puts("a.dat on stream 1; b.dat and c.dat on stream 2");
        puts("confirm AG/RG steering using xfs_bmap");
        return 0;
}
Anuj Gupta (4):
  fs: add write-stream management ioctls
  fs: add generic write-stream management
  xfs: implement software write-stream management
  xfs: support write streams on realtime volumes

Kanchan Joshi (4):
  fs: add i_write_stream, exclusive with the write life time hint
  xfs: write stream based AG placement
  iomap: introduce and propagate write_stream
  xfs: support hardware write streams

 fs/Makefile                   |   2 +-
 fs/fcntl.c                    |   7 ++
 fs/inode.c                    |   1 +
 fs/iomap/direct-io.c          |   2 +
 fs/iomap/ioend.c              |   3 +
 fs/write_streams.c            | 142 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.c      |  59 +++++++++++++-
 fs/xfs/xfs_buf.c              |  37 +++++++++
 fs/xfs/xfs_buf.h              |   6 ++
 fs/xfs/xfs_inode.c            |  69 +++++++++++++++++
 fs/xfs/xfs_inode.h            |   4 +
 fs/xfs/xfs_ioctl.c            |  80 +++++++++++++++++++
 fs/xfs/xfs_iomap.c            |   1 +
 fs/xfs/xfs_rtalloc.c          |  28 +++++++
 fs/xfs/xfs_super.c            |  12 +++
 include/linux/fs.h            |   2 +-
 include/linux/iomap.h         |   1 +
 include/linux/write_streams.h |  33 ++++++++
 include/uapi/linux/fs.h       |  15 ++++
 19 files changed, 500 insertions(+), 4 deletions(-)
 create mode 100644 fs/write_streams.c
 create mode 100644 include/linux/write_streams.h

-- 
2.25.1

