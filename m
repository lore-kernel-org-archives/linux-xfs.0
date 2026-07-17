Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD143C3449
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784292996; cv=none; b=A5boG+Jr+W267fmcDXP+M/IcJKbNXerd0u3FX6jhD9DHlDU/YSck81lTMfKUkmYUZB2zYLNTQvxPtmw9Kd75mzcEhGWUhmDOnc6yv4ly5AKfiE2TXLlSZwdXzg4EvWlhl812qXBW5jY8AxXHxW61BbgRTP+o6HcyqMA6xjYvr44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784292996; c=relaxed/simple;
	bh=u5A6Ob8A/lUf1OzDjonJL5GwQL6NJWCNDjeXa5kvdks=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=J1HcxbRCmuFcrRKEToHavk5pTqNFvdkNGin7wvZgzWtZ6dMLUn/P6j9Ofl77ME92SR+GwFRvk7l09/WGgOmtMtARn4B7+7nCxnN6bxlbzVOyyKcIKsAwHcTnlVjr+gtBI9sJ2QjSV5A3YJeTk5g1ilja0qJZZBHAw97TPyd55pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=vel0WVwb; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vel0WVwb"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260717125626epoutp04af6c335fde7bd626419c44e26949ddb1~DFQRoBfR62897128971epoutp04T
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:56:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260717125626epoutp04af6c335fde7bd626419c44e26949ddb1~DFQRoBfR62897128971epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784292986;
	bh=T6gnl694bL8sHjhZ8iBa4hrxVJcxHKLMq3kl2/UT8mc=;
	h=From:To:Cc:Subject:Date:References:From;
	b=vel0WVwbU14JvRhJtKPLSfLs9ymvyFbZWXQyC7EG0iRAxpdUDvnNbHazmJ4TeRu0z
	 jo1Ir5UPXc8WOjFNZ0jh/dzrYbBIi6No8IrCHRNlo8DquZY8AJi33/4+Xuxu+RorcD
	 mrC0MiAVBaKfa+UIL0VpWedmNjRli5jkQTQ+x4/s=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260717125625epcas5p3399d733662ce55b6fe13b66970443d8d~DFQRJpJZ30710307103epcas5p3K;
	Fri, 17 Jul 2026 12:56:25 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.86]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h1qfc3zwhz6B9m7; Fri, 17 Jul
	2026 12:56:24 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260717125624epcas5p3fefc5b8ff274260bf8fb2f1b225b4f9a~DFQP31FjG0710307103epcas5p3D;
	Fri, 17 Jul 2026 12:56:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260717125621epsmtip2a8dd074ef2c3d6140d8d35e34393182e~DFQNxvC7E1798717987epsmtip27;
	Fri, 17 Jul 2026 12:56:21 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v4 0/6] xfs write streams
Date: Fri, 17 Jul 2026 18:25:32 +0530
Message-Id: <20260717125538.508925-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260717125624epcas5p3fefc5b8ff274260bf8fb2f1b225b4f9a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260717125624epcas5p3fefc5b8ff274260bf8fb2f1b225b4f9a
References: <CGME20260717125624epcas5p3fefc5b8ff274260bf8fb2f1b225b4f9a@epcas5p3.samsung.com>

This series introduces a generic interface [1] for write stream management on
files. It enables spatial isolation and concurrency improvments [3] in xfs using
- generic AG-set (patch #4)
- write-stream based AG-set (patch #5)

In LSFMMBPF'26, we discussed write-stream as a mechanism to reduce
the filesystem allocator bottlenecks and improving direct/buffered IO
scalability.

Write streams allow the abstraction provider (fs, block, raid etc.) to
leverage application's intent (file relationships/lifecycle).
- application: sends grouping/isolation intent with a stream id.
- xfs: maps streams to AGs; allocates without interleaving; gains higher
  concurrency due to reduced lock contention.
- hardware: maps streams to underlying allocation unit; reduces device
  internal write amplification, improved life, predictable QoS.

Also:
- Since high-level write stream (in xfs) and logical placement can work
  without the low-level write streams (in block device), series has a general
value beyond hardware that provides spatial isolation.

- For hardware-only spatial isolation, first 3 patches are needed.

- write-stream is different from existing 'filestream' allocator which
  maintains directory-to-AG associations in a global MRU cache. That
requires state managment and memory (and its reclaim). Proposed AG-set
based steering relies on simple, statless/lockless airthmatic that aligns
more with the default allocator heuristics.

[3]
### Performance

1. On regular NVMe

a. Inter-stream concurrency
---------------------------
fio: 4k write, direct IO, 16 jobs, 1 directory, 16 files * 8GiB, iodepth 32
xfs: 16 AGs, 4 write-streams

base: 41 KIOPS
generic AG-set: 93 KIOPS (+126%)
write-stream AG-set: 227 KIOPS (+453%)
here, 16 files are assigned 4 unique write-streams (4 files/stream)

b. Intra-stream concurrency
----------------------------
fio: 4k write, direct IO, 4 jobs, 1 directory, 4 files * 8GiB, iodepth 32
xfs: 16 AGs, 4 write-streams, generic AG-set size = 2, write-stream AG-set size = 4

base: 59 KIOPS
generic AG-set: 94 KIOPS (+59%)
write-stream AG-set: 112 KIOPS (+89%)
here, 4 files are assigned single write-stream

2. On FDP-capable NVMe:
RocksDB YCSB
WAF (base vs write-stream): 35% Reduction


[1]
### Application interface

Four new ioctls:
      FS_IOC_WRITE_STREAM_GET_MAX  query the max streams supported
      FS_IOC_WRITE_STREAM_OPEN     open a stream id, returns a stream fd
      FS_IOC_WRITE_STREAM_SET      attach the stream fd to an open file
      FS_IOC_WRITE_STREAM_GET      query the stream id value set on a file

### Comparison with Write Hints (RWH_WRITE_LIFE_*)

- Semantics: Write Hints describe 'data temperature' (e.g.,
short/long/extreme), implying a lifetime. Write Streams describe 'data
placement' (e.g., Bin 1/Bin 2), implying only separation.

- Scalability: Write Hints are limited to a small, fixed enum (6
values). Write streams are dynamic, provider-dependent values that can
scale much higher (kernel limit: up to 255 due to u8 field).

- Discovery: The existing write-hint interface is advisory and decoupled
  from underlying capabilties; application has no way to probe support
and cannot deterministically know which hints are valid. OTOH, write-streams
provide explicit discovery.

- Usage model: application needs to get a handle (fd) for a write stream
  before being able to use it. This avoids multi-application conflicts.

Note: within the kernel, the separation between two constructs
(write-hint and write-stream) had started from 6.16 itself.

### Changelog

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

### Interface example

/* FD-based write-stream ioctl */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <string.h>
#include <errno.h>
#include <linux/types.h>

/* Duplicate the kernel UAPI definitions */
struct fs_write_stream_open {
	uint32_t	stream_id;	/* IN: desired id if OPEN_EXACT set; OUT: assigned id */
	uint32_t	flags;		/* IN: FS_WRITE_STREAM_OPEN_* */
};

#define FS_WRITE_STREAM_OPEN_EXACT      (1 << 0)

#define FS_IOC_WRITE_STREAM_GET_MAX     _IOR('f', 135, __u32)
#define FS_IOC_WRITE_STREAM_OPEN        _IOWR('f', 136, struct fs_write_stream_open)
#define FS_IOC_WRITE_STREAM_SET         _IOW('f', 137, __s32)
#define FS_IOC_WRITE_STREAM_GET         _IOR('f', 138, __u32)

static void usage(const char *prog)
{
	fprintf(stderr, "Usage:\n");
	fprintf(stderr, "  %s <file> max        - get max supported streams\n", prog);
	fprintf(stderr, "  %s <file> get        - get stream id set on file\n", prog);
	fprintf(stderr, "  %s <file> open [id]  - open a stream (EXACT if id given) and bind it to file\n", prog);
	exit(EXIT_FAILURE);
}

int main(int argc, char *argv[])
{
	const char *filepath, *cmd;
	int fd;

	if (argc < 3)
		usage(argv[0]);

	filepath = argv[1];
	cmd = argv[2];

	fd = open(filepath, O_RDWR);
	if (fd < 0) {
		perror("open(file)");
		return EXIT_FAILURE;
	}

	if (!strcmp(cmd, "max")) {
		uint32_t max;

		if (ioctl(fd, FS_IOC_WRITE_STREAM_GET_MAX, &max) < 0) {
			perror("ioctl(GET_MAX)");
			return EXIT_FAILURE;
		}
		printf("Max streams supported: %u\n", max);
	} else if (!strcmp(cmd, "get")) {
		uint32_t stream_id;

		if (ioctl(fd, FS_IOC_WRITE_STREAM_GET, &stream_id) < 0) {
			perror("ioctl(GET)");
			return EXIT_FAILURE;
		}
		printf("Stream id on file: %u\n", stream_id);
	} else if (!strcmp(cmd, "open")) {
		struct fs_write_stream_open wso = { 0 };
		int stream_fd;

		if (argc == 4) {
			wso.flags = FS_WRITE_STREAM_OPEN_EXACT;
			wso.stream_id = atoi(argv[3]);
		}

		/* OPEN can be called through any fd on the target filesystem. */
		stream_fd = ioctl(fd, FS_IOC_WRITE_STREAM_OPEN, &wso);
		if (stream_fd < 0) {
			perror("ioctl(OPEN)");
			return EXIT_FAILURE;
		}
		printf("Opened stream id %u (fd %d)\n", wso.stream_id, stream_fd);

		/* SET takes the stream fd directly as the ioctl argument. */
		if (ioctl(fd, FS_IOC_WRITE_STREAM_SET, (unsigned long)stream_fd) < 0) {
			perror("ioctl(SET)");
			close(stream_fd);
			return EXIT_FAILURE;
		}
		printf("Bound stream %u to %s\n", wso.stream_id, filepath);

		close(stream_fd);
	} else {
		fprintf(stderr, "Unknown command: %s\n", cmd);
		usage(argv[0]);
	}

	close(fd);
	return EXIT_SUCCESS;
}


Anuj Gupta (2):
  fs: add write-stream management ioctls
  xfs: implement write-stream management support

Kanchan Joshi (4):
  iomap: introduce and propagate write_stream
  xfs: generic AG set based steering
  xfs: write stream based AG placement
  xfs: introduce software write streams

 fs/iomap/direct-io.c     |   1 +
 fs/iomap/ioend.c         |   3 +
 fs/xfs/libxfs/xfs_bmap.c |  74 +++++++++++++++++
 fs/xfs/xfs_icache.c      |   1 +
 fs/xfs/xfs_inode.c       | 175 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h       |   8 ++
 fs/xfs/xfs_ioctl.c       |  69 +++++++++++++++
 fs/xfs/xfs_iomap.c       |   1 +
 fs/xfs/xfs_mount.h       |   5 ++
 fs/xfs/xfs_super.c       |  12 +++
 include/linux/iomap.h    |   2 +
 include/uapi/linux/fs.h  |  16 ++++
 12 files changed, 367 insertions(+)

-- 
2.25.1

