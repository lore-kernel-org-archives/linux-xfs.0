Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE56318EE7
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 05:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773034480; cv=none; b=Q6f3+0UoZy+1iQJ4O9RE8UELXJ2oyf+CqkWYWt2TjX4+wVH5j/osUsSzkxWg3oI3TG/Z+28PXJi4pHkNQu86spXfn0qULjJOzw4UL4wWC02913+FLA7guwBDGL/0XXCtv3s48A2BEVFT3vdohcLEVJIFnWZZxnZiWgN/Dbnc5K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773034480; c=relaxed/simple;
	bh=dcTDETfygFgY31nYz2MmkOXBPxwM9zOma8rtmYXfBv4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=XkTrBSuqrsUnknPeLjMszhCOwYt7DTINaiUfBSvvrDW5Keoc17nc9TXy/Cz70wGwcvqnoMee0fnSGQQpNseSHy5eqI1MLGs1zsstc+6QqxUv5AKw4bYkXC2L5/+cH4cFgR0ThEkIVbBQ8L2Fna9D80S8J7A0cSwXbCFB8xh5bpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=obCllWkR; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="obCllWkR"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260309053427epoutp0268e93324b2560ec257820946f93b2bea~bFXRZ6AbU0829408294epoutp02u
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 05:34:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260309053427epoutp0268e93324b2560ec257820946f93b2bea~bFXRZ6AbU0829408294epoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773034467;
	bh=yTKf4+LS7yUv5hCO+q9A8/6HUSMgCNe6gK6jiDxJhpA=;
	h=From:To:Cc:Subject:Date:References:From;
	b=obCllWkRVjMnULaLtroMhxHX9dsuD2Y9mUPjQaWOqReZEhFM6fUpMGlxXz9oIGNm7
	 LvzRV3Usys671Zwz47yIFbgwyb7t9n0cX7mSW79Eh7kN4HpJ7gaD/2R20xJZMLm6tx
	 qN8gQm6ABFW56kPvQZ+UonFVY6t+k8Vmkv8MK19I=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260309053427epcas5p22311b6ddc825cae61023bdc1e8f6424f~bFXRAkhN31306813068epcas5p28;
	Mon,  9 Mar 2026 05:34:27 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4fTm0f2BZ5z2SSKv; Mon,  9 Mar
	2026 05:34:26 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260309053425epcas5p32886580a4fbe646ceee66f2864970e9f~bFXPmi4J43063730637epcas5p3C;
	Mon,  9 Mar 2026 05:34:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260309053424epsmtip283bb7f5dfc55f1341e55cfe535657e88~bFXOGQxIq2009320093epsmtip2B;
	Mon,  9 Mar 2026 05:34:23 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, jack@suse.cz,
	cem@kernel.org, kbusch@kernel.org, axboe@kernel.dk
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 0/5] write streams and xfs spatial isolation
Date: Mon,  9 Mar 2026 10:59:39 +0530
Message-Id: <20260309052944.156054-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260309053425epcas5p32886580a4fbe646ceee66f2864970e9f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260309053425epcas5p32886580a4fbe646ceee66f2864970e9f
References: <CGME20260309053425epcas5p32886580a4fbe646ceee66f2864970e9f@epcas5p3.samsung.com>

This series introduces a generic interface for write stream management,
enabling application to guide data placement on files that support it.
It also introduces spatial isolation and sofware write streams in xfs.

Write streams enable collaborative data placement, allowing the
abstraction provider to leverage application intent.
- application: sends grouping/isolation intent with a stream id.
- xfs: maps streams to AGs; allocates without interleaving; gains higher
  concurrency; less lock contention.
- hardware: maps streams to underlying  allocation unit; reduces device
  internal write amplification, improved life, predicable QoS.

### Changelog
since v1:
https://lore.kernel.org/linux-fsdevel/20260216052540.217920-1-joshi.k@samsung.com/
- swich from fcntl based to ioctl-based interface (Christian)
- new patch (#4) that makes xfs allocator use the write streams for AG
  selection
- new patch (#5) that introduces software write streams in xfs.

### Application interface

New vfs ioctl 'FS_IOC_WRITE_STEAM'.
Application communicates the intended operation using the 'op_flags'
field of the passed 'struct fs_write_stream'.
Valid flags are:
FS_WRITE_STREAM_OP_GET_MAX: Returns the number of available streams.
FS_WRITE_STREAM_OP_SET: Assign a specific stream value to the file.
FS_WRITE_STREAM_OP_GET: Query what stream value is set on the file.

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
	uint32_t stream_id;
	uint32_t max_streams;
	uint32_t __reserved;
};

#define FS_WRITE_STREAM_OP_GET			(1 << 1)
#define FS_WRITE_STREAM_OP_SET			(1 << 2)
#define FS_WRITE_STREAM_OP_GET_MAX		(1 << 0)

#define FS_IOC_WRITE_STREAM		_IOWR('f', 43, struct fs_write_stream)

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

Kanchan Joshi (5):
  fs: add generic write-stream management ioctl
  iomap: introduce and propagate write_stream
  xfs: implement write-stream management support
  xfs: steer allocation using write stream
  xfs: introduce software write streams

 fs/iomap/direct-io.c     |  1 +
 fs/iomap/ioend.c         |  3 ++
 fs/xfs/libxfs/xfs_bmap.c |  9 ++++
 fs/xfs/xfs_icache.c      |  1 +
 fs/xfs/xfs_inode.c       | 98 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.h       |  7 +++
 fs/xfs/xfs_ioctl.c       | 34 ++++++++++++++
 fs/xfs/xfs_iomap.c       |  1 +
 include/linux/iomap.h    |  2 +
 include/uapi/linux/fs.h  | 12 +++++
 10 files changed, 167 insertions(+), 1 deletion(-)


base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
-- 
2.25.1

