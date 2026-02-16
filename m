Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301C11E00B4
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 05:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771219823; cv=none; b=kfP+yvoIxFeLugIUO/TNVuuJ3Clooz/jbMwVj76Y1YqLC1y+X37wr463jDz5uZ+h3ii40Zu9bBPTmpMXb5u2P4DDs3qJ3xy7J6SqsJvxkXik+3U+iFvkUlYMfaYwYvGrHhcIClV0CEqrdvoiCyvBFr/k7l+fJA1+0Tgmm1vkW4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771219823; c=relaxed/simple;
	bh=v3po6HqXnP9XNEwTzzQncPi8k6bGVsTBZ/yyaMQRcnE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=kVc9iFcDjinvvvBHWERGDCMnjGVWmfiZh56Wvlq7P2JiBxqIbypjKLa9y1JB21PYYwK3J14geftkpz/tPyDb3MERf3xdSfJgfKYPUTfnTS7k7h1ZBTnCtP675bGD9X7RxNyNFayUwiZPTzaMHXqr/WDe6g/D8SGc+pU3DGlTKc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cMd4d41r; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cMd4d41r"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260216053012epoutp03733e59efc710c25433a9c7c02ca66021~UowkFgyUK0328603286epoutp03L
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 05:30:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260216053012epoutp03733e59efc710c25433a9c7c02ca66021~UowkFgyUK0328603286epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1771219812;
	bh=+2Q9cs81mGLZ6eNq/6YqlmRX8CoeWDDw0BcNeK1YJgs=;
	h=From:To:Cc:Subject:Date:References:From;
	b=cMd4d41rnK3/osF2biJElC2MoKEttaRiVJPoSOcqDNMfLnJFA+yDZoKIANEW1jC77
	 /+y16wYJ3SYAcWxMc9VKVdx7BXlfu7WUJ8PZS61PjMDqmjqWu6iUKPHn7DuG7NwWFu
	 8jD//VbXC0XNZJetXU44PMNN+X7P4Ta7HdVSlBwo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260216053012epcas5p4c5bf1a92444f946b69b05d714c83e0da~Uowjq53Kw2729427294epcas5p4-;
	Mon, 16 Feb 2026 05:30:12 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4fDrvR39TWz6B9mJ; Mon, 16 Feb
	2026 05:30:11 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260216053011epcas5p127f51074dc05c5dc6e6df56f5a564721~Uowinycbe1714217142epcas5p19;
	Mon, 16 Feb 2026 05:30:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260216053009epsmtip1658b1edf49d24a134f8dc157e75640e7~UowhKU4zo1594915949epsmtip1G;
	Mon, 16 Feb 2026 05:30:09 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: hch@lst.de, brauner@kernel.org, jack@suse.cz, djwong@kernel.org,
	axboe@kernel.dk, kbusch@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH 0/4] write-stream for file I/O
Date: Mon, 16 Feb 2026 10:55:36 +0530
Message-Id: <20260216052540.217920-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260216053011epcas5p127f51074dc05c5dc6e6df56f5a564721
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260216053011epcas5p127f51074dc05c5dc6e6df56f5a564721
References: <CGME20260216053011epcas5p127f51074dc05c5dc6e6df56f5a564721@epcas5p1.samsung.com>

This patch series introduces a generic interface for 'Write Stream
Management', enabling applications to guide physical data placement
on files that support it.

### Changes since RFC [1]

- Move stream-management to file operations (Christoph)
- Stop adding "write-stream" in vfs inode but use FS-specific inode (Christoph)
- Iomap based write-stream propagation (Christoph)

### Motivation

Maybe LSFMM session [2] repetition;
Standard SSDs abstract physical data placement, limiting the Host to
logical data placement.
FDP-capable NVMe SSDs allow the Host to physically separate data into
distinct "streams" or "buckets." This separation reduces
device-internal write amplification, yielding tangible benefits to the
drive users: improved life, predictable QoS, and better energy
efficiency.

While Linux supports write-stream based placement for block IO path
(since 6.16), the capability remains inaccessible to standard file-based
applications. The series fills that gap and enables application-driven
placement on files.

### Implementation

The series implements generic write-stream management via:

- VFS: New `fcntl` user interface for write-stream discovery and assignment.
- Iomap: Infrastructure to propagate file-level write-streams to the block layer.
- XFS: Initial filesystem support implementing the write-stream interface.

The application interface involves three new `fcntl` commands:

F_GET_MAX_WRITE_STREAMS: Query the number of available streams.
F_SET_WRITE_STREAM: Assign a specific stream to a file.
F_GET_WRITE_STREAM: Retrieve the stream currently assigned to a file.

### Comparison with Write Hints (RWH_WRITE_LIFE_*)

- Semantics: Write Hints describe 'data temperature' (e.g.,
short/long/extreme), implying a lifetime. Write Streams describe 'data
placement' (e.g., Bin 1/Bin 2), implying only separation.

- Scalability: Write Hints are limited to a small, fixed enum (6
values). Write streams are dynamic, device-dependent values that can
scale much higher (kernel limit: up to 255 due to u8 field).

- Discovery: The existing write-hint interface is advisory and decoupled
  from underlying capabilties; application has no way to probe support
and cannot deterministically know which hints are valid. Write-streams
provide explicit discovery via `F_GET_MAX_WRITE_STREAMS`.

Note: within the kernel, the separation between two constructs
(write-hint and write-stream) had started from 6.16 itself.

### Interface example

An example program for the new write-stream interface is attached below [3].
New interface has also worked fine when integrated with RockDB.


[1] https://lore.kernel.org/linux-fsdevel/20250729145135.12463-1-joshi.k@samsung.com/
[2] https://lwn.net/Articles/1018642/
[3]
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <linux/fcntl.h>

#define BUF_SIZE        (4096)

int write_fd(int fd, int st) {

        char buf[BUF_SIZE];
        int ret, set, get;

        if (fd < 0) {
                printf("[!]invalid fd\n");
                return fd;
        }

        ret = fcntl(fd, F_GET_MAX_WRITE_STREAMS);
        if (ret < 0) {
                printf("F_GET_MAX_WRITE_STREAMS: failed (%s)\n",
strerror(errno));
                return ret;
        }
        if (st > ret) {
                printf("error in setting stream, available upto %d\n", ret);
                return -1;
        }

        ret = fcntl(fd, F_SET_WRITE_STREAM, st);
        if (ret < 0) {
                printf("F_SET_WRITE_STREAM: failed (%s)\n", strerror(errno));
                return ret;
        }
        set = st;

        ret = fcntl(fd, F_GET_WRITE_STREAM);
        if (ret < 0) {
                printf("F_GET_WRITE_STREAM: failed (%s)\n", strerror(errno));
                return ret;
        }
        get = ret;

        if (get != set)
                printf("unexpected, set %d but get %d\n", set, get);

        ret = write(fd, buf, BUF_SIZE);
        if (ret < BUF_SIZE) {
                printf("failed, wrote %d bytes (expected %d)\n", ret, BUF_SIZE);
                return ret;
        }
        return 0;
}

int main(int argc, char *argv[])
{
        int ret, regfd;

        /* two file writes, one buffered another direct */
        regfd = open("/mnt/f_buffered", O_CREAT | O_RDWR, 0644);
        ret = write_fd(regfd, 7);
        close(regfd);

        regfd = open("/mnt/f_direct", O_CREAT | O_RDWR| O_DIRECT, 0644);
        ret = write_fd(regfd, 6);
        close(regfd);
        return ret;
}

Kanchan Joshi (4):
  fs: add write-stream management file_operations
  fcntl: expose write-stream management to userspace
  iomap: introduce and propagate write_stream
  xfs: enable userspace write stream support

 fs/fcntl.c                 | 33 +++++++++++++++++++++++
 fs/iomap/direct-io.c       |  1 +
 fs/iomap/ioend.c           |  3 +++
 fs/xfs/xfs_file.c          | 54 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c        |  1 +
 fs/xfs/xfs_inode.h         |  3 +++
 fs/xfs/xfs_iomap.c         |  1 +
 include/linux/fs.h         |  6 +++++
 include/linux/iomap.h      |  2 ++
 include/uapi/linux/fcntl.h |  4 +++
 10 files changed, 108 insertions(+)

-- 
2.25.1

