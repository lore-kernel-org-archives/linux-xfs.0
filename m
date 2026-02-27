Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819FF421F0A
	for <linux-xfs@vger.kernel.org>; Fri, 27 Feb 2026 14:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772201334; cv=none; b=Bv3LuB9dy7zlsPDxj+xJIyLaxNmM5l9VYQm759XhKsMIMdNS263JUQz/UwchaZLKpLJeDzgQeRFmDWyVz0EsiMYUJjGMA2lNamxQ63GxSRVP7ioTu8zYvMZcOBrtM72YrOAa1I7PjQa/pq1DFytu0QfOY00wfWvTb7GufKoFnB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772201334; c=relaxed/simple;
	bh=jevjgH3cJoY5u/CM6leg/1JHgTeHZ7SejjgxInlyq/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RTyw5t86HJbbKiwKoResEuKVfodnjky3P1Ig07Q1xp7IF9/TMg4fMwlIOwMMK052Cecg3lXoP8HQM+L9lIrjRNITWAMHG35bCrOJ/fJSL/LZ5obJp87hLd61XerH6EHUzylVFhV5n4k4qxVjfKZjbnjX+a8xMO6nN8xS4hCl8Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4fMqtn0Mb7z9t16;
	Fri, 27 Feb 2026 15:08:49 +0100 (CET)
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	dchinner@redhat.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	gost.dev@samsung.com,
	pankaj.raghav@linux.dev,
	andres@anarazel.de,
	cem@kernel.org,
	hch@infradead.org,
	lucas@herbolt.com
Subject: [RFC 0/2] add FALLOC_FL_WRITE_ZEROES support to xfs
Date: Fri, 27 Feb 2026 15:08:40 +0100
Message-ID: <20260227140842.1437710-1-p.raghav@samsung.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The benefits of FALLOC_FL_WRITE_ZEROES was already discussed as a part
of Zhang Yi's initial patches[1]. Postgres developer Andres also
mentioned they would like to use this feature in Postgres [2].

Lukas Herbolt sent a patch recently that adds this support but I found
some issues with them[3]. I independtly started working on these patches
a while back as well, so I thought maybe I will send a RFC version of
this support.

I have implemented this support similar to what ext4 is doing: write unwritten
extents first, increase the size of the file, then zero out those extents
with XFS_BMAPI_CONVERT with XFS_BMAPI_ZERO. This seems to be working
correctly without changing any of the core infrastructure. But I am not
sure if this is the most efficient way of doing it in XFS or if there
are some corner cases I am missing, so any feedback is welcome.

[1] https://lore.kernel.org/linux-fsdevel/20250619111806.3546162-1-yi.zhang@huaweicloud.com/
[2] https://lore.kernel.org/linux-fsdevel/20260217055103.GA6174@lst.de/T/#m7935b9bab32bb5ff372507f84803b8753ad1c814
[3] https://lore.kernel.org/linux-xfs/wmxdwtvahubdga73cgzprqtj7fxyjgx5kxvr4cobtl6ski2i6y@ic2g3bfymkwi/

=== Testing ===:

void test_fallocate(const char *filename, int mode, const char *mode_name) {
    int fd;

    printf("Testing %s on %s...\n", mode_name, filename);

    unlink(filename);

    fd = open(filename, O_RDWR | O_CREAT, 0666);
    if (fd < 0) {
        perror("open failed");
        return;
    }

    if (fallocate(fd, mode, 0, TEST_SIZE) == 0) {
        printf(" -> fallocate(%s) succeeded!\n", mode_name);
    } else {
        printf(" -> fallocate(%s) failed: %s\n", mode_name, strerror(errno));
    }

    close(fd);

    /* Dump extent info using xfs_io */
    char cmd[256];
    snprintf(cmd, sizeof(cmd), "xfs_io -c 'bmap -vvp' %s", filename);
    printf("=== Extents for %s ===\n", filename);
    system(cmd);
    printf("\n");
}

int main() {
    printf("Starting fallocate tests...\n");
    printf("------------------------------------------------\n\n");

    test_fallocate("test_zero_range.bin", FALLOC_FL_ZERO_RANGE, "FALLOC_FL_ZERO_RANGE");
    test_fallocate("test_write_zeroes.bin", FALLOC_FL_WRITE_ZEROES, "FALLOC_FL_WRITE_ZEROES");

    printf("Test complete.\n");
    return 0;
}

This is the output:

root@debian:/mnt# ~/home/write_zeroes /mnt/hello
Starting fallocate tests...
------------------------------------------------

Testing FALLOC_FL_ZERO_RANGE on test_zero_range.bin...
 -> fallocate(FALLOC_FL_ZERO_RANGE) succeeded!
=== Extents for test_zero_range.bin ===
test_zero_range.bin:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..20479]:      20672..41151      0 (20672..41151)   20480 010000
 FLAG Values:
    0100000 Shared extent
    0010000 Unwritten preallocated extent
    0001000 Doesn't begin on stripe unit
    0000100 Doesn't end   on stripe unit
    0000010 Doesn't begin on stripe width
    0000001 Doesn't end   on stripe width

Testing FALLOC_FL_WRITE_ZEROES on test_write_zeroes.bin...
 -> fallocate(FALLOC_FL_WRITE_ZEROES) succeeded!
=== Extents for test_write_zeroes.bin ===
test_write_zeroes.bin:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..20479]:      41152..61631      0 (41152..61631)   20480 000000
 FLAG Values:
    0100000 Shared extent
    0010000 Unwritten preallocated extent
    0001000 Doesn't begin on stripe unit
    0000100 Doesn't end   on stripe unit
    0000010 Doesn't begin on stripe width
    0000001 Doesn't end   on stripe width

Pankaj Raghav (2):
  xfs: add flags field to xfs_alloc_file_space
  xfs: add support for FALLOC_FL_WRITE_ZEROES

 fs/xfs/xfs_bmap_util.c |  5 ++--
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_file.c      | 64 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 64 insertions(+), 7 deletions(-)


base-commit: 4d750717498bbc1d8801281c32453a5f23d0bbe8
-- 
2.50.1

