Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB573A0EB3
	for <linux-xfs@vger.kernel.org>; Thu, 26 Feb 2026 14:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772117060; cv=none; b=CKlO7B0eShwEm8RrHhse6FrEvjRFPQB+J8eHI/3R3YEKnfqS310DQ2RYizWfCiVPYXfGbgCsUb5kbe0ebBr8APpvW4SHVZUpgp+gm15BSsSO/WvJl2KEtTXPRKGrJwsAm+9gLCiOkqa/fOO1vjBgvjQFfG7VPhbOjly1ozfXVxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772117060; c=relaxed/simple;
	bh=Gae+h045LDZGeAHgAWfGnBE74AuphkLsw4hVxEOQPhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eAlZKfhdg/ECnHc/UGARzLZw72WfP+1Vniuxuy2rOmAUg6ryAfxW7V9ptaLzdvYZMOwriKApUDmlMPdf9WZKX6gO52JC/GQtHKBSrkwJqw2ivdUS8E+Rn0C+i7VX8mLyigE+VwBxcKkHqZufpq1lYTr60/zQIc0aqpJjhfIIRAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tzx/01/O; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tzx/01/O"
Date: Thu, 26 Feb 2026 14:44:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772117054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=np9xQQrV63VoGu7jrM5DyORvNYsLaL9VUNRwSBaJHOM=;
	b=Tzx/01/OJ3Mjk2ZF5irOKB2imQbhcdHgDV7bu/r3kZUSgE2jB6Szecb6IyqrQiRHUvLg7C
	PK1DIL38S2oWx8tCvWBiEG43pfHjespKviLI4IdAW64SWwE86CAF3CKgwxEmocQKUgScu4
	RpzxKbSg0MvMEIhaooQA/2JzB9YcqJc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, cem@kernel.org, 
	hch@infradead.org, p.raghav@samsung.com, pankaj.raghav@linux.dev
Subject: Re: [PATCH v10] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <wmxdwtvahubdga73cgzprqtj7fxyjgx5kxvr4cobtl6ski2i6y@ic2g3bfymkwi>
References: <20260225083932.580849-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225083932.580849-2-lukas@herbolt.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 25, 2026 at 09:39:33AM +0100, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.
> 
Hi Lukas,

I independently started implmenting this feature as well. I ran a test case
on your patches and it resulted in a warning in iomap_zero_range.
iomap_zero_range has a check for folios outside eof, and it is being
called as a part of setsize, i.e, before we change the size of the file.

I think we need to do a PREALLOC and then do a XFS_BMAPI_ZERO with
XFS_BMAPI_CONVERT. Or I don't know if we should change the warning in
iomap_zero_range.

Doing unwritten extents first and then converting them to written with
zeroes is what ext4 does as well. Maybe it is better this way because we
can quickly allocate the blocks and return while holding the aglocks and
then do the actually write. I guess someone more experienced with XFS
can comment on that.

I can send what I have and I will CC you in the series.

This is the warning I get when I test your patch:

WARNING:

[  112.551102] WARNING: fs/iomap/buffered-io.c:1525 at iomap_zero_range+0x42d/0x7b0, CPU#2: write_zeroes/411
[  112.560073] RIP: 0010:iomap_zero_range+0x42d/0x7b0
[  112.593471]  xfs_zero_range+0x86/0xd0 [xfs]
<snip>
[  112.594100]  xfs_setattr_size+0x5c2/0xd90 [xfs]
<snip>
[  112.598895]  xfs_falloc_setsize+0x158/0x200 [xfs]


This is the test case:
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

#ifndef FALLOC_FL_ZERO_RANGE
#define FALLOC_FL_ZERO_RANGE 0x10
#endif

#ifndef FALLOC_FL_WRITE_ZEROES
#define FALLOC_FL_WRITE_ZEROES 0x80
#endif

#define TEST_SIZE (10 * 1024 * 1024)

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
    snprintf(cmd, sizeof(cmd), "xfs_io -c 'bmap -vp' %s", filename);
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

--
Pankaj
