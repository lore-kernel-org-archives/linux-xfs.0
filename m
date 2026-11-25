Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595737;
	b=A/zK48+ruB+XrJvUMINmhz6m3Cw8Vx5HiQqVI0+u3JYsKqotf7oIHUkor2Jwxb+TThAx
	 7nOtwDSh5rPD+py0wXsoFpWDTbOUJJEPFkO8VDFIJxwdR0MAOo+1hGuLkVFNCTuvjGQJN
	 1PFVj4li7PUgOkizQYQHoZqU3IhirDRpsoJrtkAdgtiy3vkORVZVR3mQ5fu0woEj5cES4
	 EeeQ8fK8NLgd817KafeT4CajjxRjSOYlOPN0f/lDHencedmcY/Mrl4kd7p8iaf0ex0zLE
	 LUAjCyedii8E0ECsG9irAPzNggnaY4seATgiY1KWIlcgaZKoQ6LEYCGLGM6GxQU89pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595737;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:
	 References;
	bh=5biYlmWL+LsN0KSimYePxRJQ9Mg3Az0anU6/+zvH050=;
	b=cfqOeemSRs7bauxhSgpdpjquCBQEvFYB2PR6gLoOA3QgUmk8jcnH/WTI6bXhWRCoiqr1
	 4v0rIPG0MkZ8IwvECYnNzuYxCaIzrZha8IhJdhmyTn6PYMpCcYr31fKEWX3F8W9fChs3J
	 Ylb66juOr0006RMlcUwuoIGTjEwTX7KjGTcWICSsnCskPNbcLX3V8pFQ66/cs35OTG+Nq
	 dz1c8BWdYVLcLGQz+9DO4SZZt1yneDtRFUPprow/GuZgFYrcmc2PeTVVii0XMdD8HOc6E
	 W46XDqNnf2qAwxdtMTxHhTyKElRMGz/TR6VTtHPUefun+Ox7zjEZNu2QJ8vSyOeETXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=d5HSKKvw;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51132606A326
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51132606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=d5HSKKvw
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261125083534epoutp012377b9845820bdadc8a523908e54d221~rPM6LoWkc2114521145epoutp01h
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261125083534epoutp012377b9845820bdadc8a523908e54d221~rPM6LoWkc2114521145epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795595734;
	bh=5biYlmWL+LsN0KSimYePxRJQ9Mg3Az0anU6/+zvH050=;
	h=From:To:Cc:Subject:Date:References:From;
	b=d5HSKKvwLohXghBFmIDNGiZcK2rboIxh+H99wvPRmHhgMio7xNCDllKpiyb4sp/Jn
	 Lr43GUuqm1Zj0jUr4rcOqbBaFgyzOI8YMEt/iR4tCAlzj8CSF1x03cEuHSQ09AmGct
	 k9ktat9TCo/UmU08CqGVc/7yJ5hNRtZUQMFgBCXY=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20261125083533epcas5p1ced569ab8fe620f68990d85af3666c6a~rPM5lgqmb2416424164epcas5p1a;
	Wed, 25 Nov 2026 08:35:33 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.88]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jZCg85vX5z2SSKZ; Wed, 25 Nov
	2026 08:35:32 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20261125083532epcas5p452c938702f2d2e1c4ac4e3efce23e39c~rPM4eyvpU1948419484epcas5p4_;
	Wed, 25 Nov 2026 08:35:32 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261125083530epsmtip110648a4ff229da4c8bf46aa99c087e02~rPM276cEZ0450004500epsmtip1W;
	Wed, 25 Nov 2026 08:35:30 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, hans.holmberg@wdc.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	anuj20.g@samsung.com, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v8 0/9] write streams and xfs support
Date: Wed, 25 Nov 2026 14:03:04 +0530
Message-Id: <20261125083313.106334-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
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
X-CMS-MailID: 20261125083532epcas5p452c938702f2d2e1c4ac4e3efce23e39c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261125083532epcas5p452c938702f2d2e1c4ac4e3efce23e39c
References: <CGME20261125083532epcas5p452c938702f2d2e1c4ac4e3efce23e39c@epcas5p4.samsung.com>

This series introduces a generic interface [2,3] for write stream management on
files.
It enables spatial isolation (at sw and hw level) and concurrency improvments [1]
in xfs by
(a) steering each write stream to its own set of allocation groups (patch #6)
    and realtime groups (patch #7).
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
  value beyond the hardware that provides spatial isolation. Patches 1-8 are
  software only and work on any block device; patch 9 aligns the stream
  count to the hardware streams when the device has them.

- write-stream is different from existing 'filestream' allocator which
  maintains directory-to-AG associations in a global MRU cache. That
  requires state managment and memory (and its reclaim). Proposed AG-set
  based steering relies on simple, statless/lockless airthmatic that aligns
  more with the default allocator heuristics.

[1]
### Benchmarks

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
base does not use write life time hints; on non-zoned xfs they change
neither the allocation nor what the device sees, as the NVMe driver
places FDP data by write stream only.

3. On Zoned Backend:
Hans has posted zoned xfs suppport and benchmarks [5] on top of this interface.
It needs no changes to the interface.

[2]
### Application interface

Three new ioctls:
      FS_IOC_WRITE_STREAM_GET_MAX  number of streams the filesystem offers
      FS_IOC_WRITE_STREAM_ALLOC    reserve a stream, returns fd for that
      FS_IOC_WRITE_STREAM_SET      set stream, given its fd, on a file

ALLOC requires CAP_SYS_ADMIN. A per-user limit on the number of
streams, suggested by Christoph [4], is the planned follow-up to relax
this; it does not change the uapi.

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

since v7:
https://lore.kernel.org/linux-xfs/20261103110640.1000095-1-anuj20.g@samsung.com/

- handle the three ioctls in common code: new patch 4 (Hans)
- make directory with realtime inherit flag report and allocate from the
  realtime pool (Hans)
- refuse FS_IOC_WRITE_STREAM_SET on an immutable file with EPERM, as
  F_SET_RW_HINT does.
- honor stream AG based steering for a file on inode32 mounts,
  earlier the allocator rotor used to override it (Sashiko)
- rebase on vfs-7.5.misc

Hans has posted zoned xfs support on top of this series [5]; it needs no
change to the generic interface.

since v6:
https://lore.kernel.org/linux-xfs/20261015063246.103433-1-joshi.k@samsung.com/

- add a VFS helper for write-stream/write-hint exclusion (Darrick)
- use WRITE_STREAM_NOT_SET for an unset stream (Darrick)
- do not pass software stream ids to devices without hardware streams
  (Sashiko)
- rebase on 7.4-rc1

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

[4] https://lore.kernel.org/all/20260819071137.GD1541@lst.de/
[5] https://lore.kernel.org/linux-xfs/20261110103540.46876-1-hans.holmberg@wdc.com/



Anuj Gupta (4):
  fs: add write-stream management ioctls
  fs: add generic write-stream management
  xfs: implement software write-stream management
  xfs: support write streams on realtime volumes

Kanchan Joshi (5):
  fs: add i_write_stream, exclusive with the write life time hint
  fs: handle the write-stream ioctls in common code
  xfs: write stream based AG placement
  iomap: introduce and propagate write_stream
  xfs: support hardware write streams

 fs/Makefile                   |   2 +-
 fs/fcntl.c                    |   7 +
 fs/inode.c                    |   2 +
 fs/internal.h                 |   9 ++
 fs/iomap/direct-io.c          |   2 +
 fs/iomap/ioend.c              |   3 +
 fs/write_streams.c            | 279 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.c      |  61 +++++++-
 fs/xfs/xfs_buf.c              |  37 +++++
 fs/xfs/xfs_buf.h              |   6 +
 fs/xfs/xfs_ioctl.c            |  42 +++++
 fs/xfs/xfs_iomap.c            |   5 +
 fs/xfs/xfs_rtalloc.c          |  28 ++++
 fs/xfs/xfs_super.c            |  12 ++
 include/linux/fs.h            |   2 +-
 include/linux/iomap.h         |   1 +
 include/linux/write_streams.h |  38 +++++
 include/uapi/linux/fs.h       |  15 ++
 18 files changed, 547 insertions(+), 4 deletions(-)
 create mode 100644 fs/write_streams.c
 create mode 100644 include/linux/write_streams.h

-- 
2.25.1

