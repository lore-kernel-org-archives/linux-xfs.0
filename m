Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584E93D8114
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634107; cv=none; b=owOU+IThokKU1ZytGrN5qgaJCsJpqilJ7R1hCPbbbAgjxVVj8R08TijP2A1c+EVlY1brZy+n/G4+8F2h3+0DGBbs/8Azgh23Yk0vAesEEXNY1jPrgichx7kx7d/MdMlLNs2oQinRH8VgoJhqnqDHO6GcilDmwOx881fZMUFuOzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634107; c=relaxed/simple;
	bh=JQyVGGCO+QXn1l2XkyJXdW/XC69rU46Zwp8XmRq9S/4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=tMvL9WsW6XxcuUbveqjgJEeiI4blDLKXbUG0S5S+J3haJZWVwi5LR8LaM2vVPTjNSlJ9WrzdZhn+/6O6QotMSRg4MK8AM2IJyJsHX39AoNLmL7MfmxIiGIeDYCzrogPwrEi7yCKJq8C6LGn5kOnA5BV0Sto14JklZhp/L/m96jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KzgqOvY+; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KzgqOvY+"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260616181242epoutp0311a15e6b2bea7dbac82d10d8f383b09d~5okk4L1Jj1757417574epoutp03F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260616181242epoutp0311a15e6b2bea7dbac82d10d8f383b09d~5okk4L1Jj1757417574epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1781633563;
	bh=nJzQs7slFagdz/F2QmdcMRyHRQrGzFulIfSO+nPReKg=;
	h=From:To:Cc:Subject:Date:References:From;
	b=KzgqOvY+jqPP9DDNTRKBQThWPnoJMyJwW4El1D5eJYOQ9V9qqG0pMqYRwMK4V9/IV
	 tdlyUEyjB+2odPWXt/XenbppbnoP8hhQpGBrRqm/W4/+qopb5gptGB15gzRfeCr/sV
	 v7Y9Nfc3WFDv+PrRF5nDUXgAUizwDTxUtcABmSZo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260616181242epcas5p17e63ff15c9dff9118c33e69159eec29d~5okkORWmq0207002070epcas5p1D;
	Tue, 16 Jun 2026 18:12:42 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4gfw7s28RFz6B9m6; Tue, 16 Jun
	2026 18:12:41 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260616181240epcas5p3f86fbb67f0d04cb0ee4b34839c9522b5~5okiH_3s_1246912469epcas5p3B;
	Tue, 16 Jun 2026 18:12:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260616181238epsmtip14cb51c5c5ece8abbbde916e4f8c44f9e~5okgR_IM00200902009epsmtip1a;
	Tue, 16 Jun 2026 18:12:37 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v3 0/6] xfs write streams
Date: Tue, 16 Jun 2026 23:35:49 +0530
Message-Id: <20260616180555.33338-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260616181240epcas5p3f86fbb67f0d04cb0ee4b34839c9522b5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260616181240epcas5p3f86fbb67f0d04cb0ee4b34839c9522b5
References: <CGME20260616181240epcas5p3f86fbb67f0d04cb0ee4b34839c9522b5@epcas5p3.samsung.com>

Hi All,

In LSFMMBPF'26, we discussed 'write stream' as a mechanism to reduce the
filesystem allocator bottlenecks and improving buffered/direct IO
scalability, in different sessions.

This series introduces a generic interface [1,2] for write stream management on
files. It achieves spatial isolation and concurrency improvments [3] in xfs using
- generic AG-set (patch #4)
- write-stream based AG-set (patch #5)

write streams allow the abstraction provider (fs, block device, raid etc.) to
leverage application's intent (file relationships/lifecycle).
- application: sends grouping/isolation intent with a stream id.
- xfs: maps streams to AGs; allocates without interleaving; gains higher
  concurrency due to reduced lock contention.
- hardware: maps streams to underlying allocation unit; reduces device
  internal write amplification, improved life, predictable QoS.

Also few other points:

- Since high level write streams (in xfs) can work without the
low-level write streams (in block device), the series has a general
value beyond hardware with a particular capability.

- For hardware-only spatial isolation, only first 3 patches are needed.

- write-stream is different from existing 'filestream' allocator which
  maintains directory-to-AG associations in a global MRU cache. That
requires state managment and memory (and its reclaim). Proposed AG-set
based steering relies on simple, statless/lockless airthmatic that aligns
more with the default allocator heuristics.

[3]
### Performance
1. On regular NVMe:
fio 4k write, direct IO, 16 jobs, 16 files * 8GiB, iodepth 32, XFS with 16 AGs

Base: 41 KIOPS
With generic ag-set: 93 KIOPS (+126%)
With write-stream ag-set: 227 KIOPS (+453%)

2. On FDP-capable NVMe:
RocksDB YCSB
WAF (base vs write-stream): 35% Reduction

[1]
### Application interface

New vfs ioctl 'FS_IOC_WRITE_STEAM'.
Application communicates the intended operation using the 'op_flags'
field of the passed 'struct fs_write_stream'.
Valid flags are:
FS_WRITE_STREAM_OP_GET_MAX: Returns the number of available streams.
FS_WRITE_STREAM_OP_SET: Assign a specific stream value to the file.
FS_WRITE_STREAM_OP_GET: Query what stream value is set on the file.

[2]
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

Note: within the kernel, the separation between two constructs
(write-hint and write-stream) had started from 6.16 itself.

### Changelog
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

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <string.h>
#include <errno.h>

/* Duplicate the kernel UAPI definitions */
struct fs_write_stream {
        uint32_t op_flags;
        union {
                uint32_t stream_id;
                uint32_t max_streams;
        };
        uint64_t __reserved;
};

#define FS_WRITE_STREAM_OP_GET                  (1 << 1)
#define FS_WRITE_STREAM_OP_SET                  (1 << 2)
#define FS_WRITE_STREAM_OP_GET_MAX              (1 << 0)

#define FS_IOC_WRITE_STREAM             _IOWR('f', 135, struct fs_write_stream)

void print_usage(const char *progname) {
        fprintf(stderr, "Usage:\n");
        fprintf(stderr, "  %s <file> max       - Get max supported streams\n", progname);
        fprintf(stderr, "  %s <file> get       - Get current stream ID\n", progname);
        fprintf(stderr, "  %s <file> set <id>  - Set stream ID\n", progname);
        exit(EXIT_FAILURE);
}

int main(int argc, char *argv[]) {
        if (argc < 3)
                print_usage(argv[0]);

        const char *filepath = argv[1];
        const char *cmd = argv[2];
        int fd = open(filepath, O_RDWR);
        if (fd < 0) {
                perror("Error opening file");
                return EXIT_FAILURE;
        }

        struct fs_write_stream req;
        memset(&req, 0, sizeof(req));

        if (strcmp(cmd, "max") == 0) {
                req.op_flags = FS_WRITE_STREAM_OP_GET_MAX;
                if (ioctl(fd, FS_IOC_WRITE_STREAM, &req) < 0) {
                        perror("ioctl(GET_MAX) failed");
                        close(fd);
                        return EXIT_FAILURE;
                }
                printf("Max streams supported: %u\n", req.max_streams);
        } else if (strcmp(cmd, "get") == 0) {
                req.op_flags = FS_WRITE_STREAM_OP_GET;
                if (ioctl(fd, FS_IOC_WRITE_STREAM, &req) < 0) {
                        perror("ioctl(GET) failed");
                        close(fd);
                        return EXIT_FAILURE;
                }
                printf("Current stream ID: %u\n", req.stream_id);
        } else if (strcmp(cmd, "set") == 0) {
                if (argc != 4)
                        print_usage(argv[0]);

                req.op_flags = FS_WRITE_STREAM_OP_SET;
                req.stream_id = atoi(argv[3]);

                if (ioctl(fd, FS_IOC_WRITE_STREAM, &req) < 0) {
                        perror("ioctl(SET) failed");
                        close(fd);
                        return EXIT_FAILURE;
                }
                printf("Set stream ID to: %u\n", req.stream_id);
        } else {
                fprintf(stderr, "Unknown command: %s\n", cmd);
                close(fd);
                print_usage(argv[0]);
        }

        close(fd);
        return EXIT_SUCCESS;
}

Kanchan Joshi (6):
  fs: add generic write-stream management ioctl
  iomap: introduce and propagate write_stream
  xfs: implement write-stream management support
  xfs: generic AG set based steering
  xfs: write stream based AG placement
  xfs: introduce software write streams

 fs/iomap/direct-io.c     |  1 +
 fs/iomap/ioend.c         |  3 ++
 fs/xfs/libxfs/xfs_bmap.c | 74 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c      |  1 +
 fs/xfs/xfs_inode.c       | 69 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h       |  6 ++++
 fs/xfs/xfs_ioctl.c       | 38 +++++++++++++++++++++
 fs/xfs/xfs_iomap.c       |  1 +
 include/linux/iomap.h    |  2 ++
 include/uapi/linux/fs.h  | 14 ++++++++
 10 files changed, 209 insertions(+)

-- 
2.25.1

