Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40824 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751797AbdJYV4m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 17:56:42 -0400
Date: Thu, 26 Oct 2017 08:56:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [fstests PATCH v3] generic: add test for DAX MAP_SYNC support
Message-ID: <20171025215638.GA30335@dastard>
References: <CAOQ4uxh25JmAv3DjCp11fAfpHVP=d2sp+=Gk4SxYfBtmOgaUPw@mail.gmail.com>
 <20171025204704.3382-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171025204704.3382-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Josef Bacik <jbacik@fb.com>, Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Wed, Oct 25, 2017 at 02:47:04PM -0600, Ross Zwisler wrote:
> Add a test that exercises DAX's new MAP_SYNC flag.
> 
> This test creates a file and writes to it via an mmap(), but never syncs
> via fsync/msync.  This process is tracked via dm-log-writes, then replayed.
> 
> If MAP_SYNC is working the dm-log-writes replay will show the test file
> with 1MiB of on-media block allocations.  This is because each allocating
> page fault included an implicit metadata sync.  If MAP_SYNC isn't working
> (which you can test by fiddling with the parameters to mmap()) the file
> will be smaller or missing entirely.
> 
> Note that dm-log-writes doesn't track the data that we write via the
> mmap(), so we can't do any data integrity checking.  We can only verify
> that the metadata writes for the page faults happened.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
.....
> --- /dev/null
> +++ b/src/t_map_sync.c
> @@ -0,0 +1,92 @@
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/mman.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +
> +#define MiB(a) ((a)*1024*1024)
> +
> +/*
> + * These two defines were added to the kernel via commits entitled
> + * "mm: Define MAP_SYNC and VM_SYNC flags" and
> + * "mm: introduce MAP_SHARED_VALIDATE, a mechanism to safely define new mmap
> + * flags", respectively.
> + */
> +#ifndef MAP_SYNC
> +#define MAP_SYNC 0x80000
> +#endif
> +
> +#ifndef MAP_SHARED_VALIDATE
> +#define MAP_SHARED_VALIDATE 0x3
> +#endif

Autoconf rules for detecting supported functionality, please...

> +
> +void err_exit(char *op)
> +{
> +	fprintf(stderr, "%s: %s\n", op, strerror(errno));
> +	exit(1);
> +}
> +
> +void mark_log(char *logwrites_name, char *mark_name)
> +{
> +	char command[256];
> +
> +	snprintf(command, 256, "dmsetup message %s 0 mark %s",
> +			logwrites_name, mark_name);
> +
> +	if (system(command))
> +		err_exit("mark_log");
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int page_size = getpagesize();
> +	int len = MiB(1);
> +	int i, fd, err;
> +	char *data;
> +
> +	if (argc < 4) {
> +		printf("Usage: %s <file> <logwrites_name> <mark_name>\n",
> +				basename(argv[0]));
> +		exit(0);
> +	}
> +
> +	fd = open(argv[1], O_RDWR|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR);
> +	if (fd < 0)
> +		err_exit("fd");
> +
> +	ftruncate(fd, len);
> +
> +	data = mmap(NULL, len, PROT_READ|PROT_WRITE,
> +			MAP_SHARED_VALIDATE|MAP_SYNC, fd, 0);
> +	if (data == MAP_FAILED)
> +		err_exit("mmap");

As I say to all these sorts of one-off test prgrams: please add the
new MAP_SYNC flag to xfs_io rather than writing a one-off
test program to set it and write some data.

And if we're going to be adding special custom tests just because
we need to insert dm-log marks, add that functionality to xfs_io,
too.

That way we can create complex custom dm logwrite tests without
needing one-off test programs for them all...

> +#! /bin/bash
> +# FS QA Test No. 466
> +#
> +# Use md_log_writes to verify that MAP_SYNC actually syncs metadata during

dm_log_writes?

> +# We should see $SCRATCH_MNT/test as having 1MiB in block allocations
> +du -sh $SCRATCH_MNT/test | _filter_scratch | _filter_spaces

Perhaps stat -c %b $SCRATCH_MNT/test ?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
