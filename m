Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11JOo0x005337 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 13:24:50 -0600
Message-ID: <4F299182.7010606@sgi.com>
Date: Wed, 01 Feb 2012 13:24:50 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Introduce a new SEEK_DATA/SEEK_HOLE tester
References: <4EFC6BC6.6020405@oracle.com>
In-Reply-To: <4EFC6BC6.6020405@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 01/-10/63 13:59, Jeff Liu wrote:
> Hello,
>
> This is another SEEK_DATA/SEEK_HOLE tester which is intended to cover multiple extents checking.
> I have ran it against btrfs to ensure the tester works, and ran it against XFS to ensure the SEEK_DATA/SEEK_HOLE patch works too.
>

> diff --git a/src/seek_copy_tester.c b/src/seek_copy_tester.c
> new file mode 100755
> index 0000000..4971f34
> --- /dev/null
> +++ b/src/seek_copy_tester.c
> @@ -0,0 +1,674 @@

Do you want to add Author/Copyright and description?

> +#include<stdio.h>
> +#include<stdlib.h>
> +#include<stdint.h>
> +#include<stdarg.h>

...

> +int
> +full_write(int fd, const void *buf, size_t count)
> +{
> +	int ret = 0;
> +	const char *ptr = (const char *) buf;
> +
> +	while (count>  0) {
> +		ssize_t n = write(fd, ptr, count);
> +		if (n<  0) {
> +			if (errno == EINTR)
> +				continue;
> +			error("full_write failed as %s", strerror(errno));
> +			ret = -1;
> +			break;
> +		}
> +
> +		if (n == 0)
> +			break;

Callers of this routine expect the count number of bytes to be written.
Write a message if leaving this routine early? An error?

> +
> +		ptr += n;
> +		count -= n;
> +	}
> +
> +	return ret;
> +}

...


> +int
> +create_data_and_holes(int fd, size_t nr_total_bytes, off_t start_offset,
> +		      uint64_t nr_skip_bytes, uint64_t nr_data_bytes,
> +		      int wrote_hole_at_eof)
> +{
> +	int ret = 0;
> +	off_t total = nr_total_bytes;
> +	off_t data_len = nr_data_bytes;
> +	off_t off = start_offset;
> +	char buf[4096];
> +
> +	memset(buf, 'A', sizeof(buf));
> +
> +	total -= start_offset;
> +	while (total>  0) {
> +		do {

You can actually write more than total byte on the last data write.
If writing exact total is important, then give do_pwrite() the count:
cnt = MIN(total, sizeof(buf))

> +			ssize_t nr_write = do_pwrite(fd, buf, sizeof(buf), off);
> +			if (nr_write<  0) {
> +				error("do_pwrite() failed as %s", strerror(errno));
> +				ret = -1;
> +				goto out;
> +			}
> +			if (nr_write == 0)
> +				break;
> +
do_pwrite will return 0 if not an error.
> +			off += nr_write;
> +			data_len -= nr_write;
These are probably sizeof(buf0 or my cnt not nr_write
> +		} while (data_len>  0);
> +
> +		off += (nr_skip_bytes + nr_data_bytes);
> +		total -= off;

...

> +
> +/*
> + * Copy a data extent from source file to dest file.
> + * @data_off: data offset
> + * @hole_off: hole offset
> + * The length of this extent is (hole_off - data_off).
> + */
> +int
> +do_extent_copy(int src_fd, int dest_fd, off_t data_off, off_t hole_off)
> +{
> +	uint64_t len = (uint64_t)(hole_off - data_off);
> +	char buf[BUF_SIZE];
> +	int ret;
> +
> +	/* Seek to data_off for data reading */
> +	ret = lseek(src_fd, data_off, SEEK_SET);
> +	if (ret<  0) {
> +		error("seek source file to %llu failed as %s",
> +		       (uint64_t)data_off, strerror(errno));
> +		return ret;
> +	}
> +
> +	/* Seek to data_off for data writing, make holes as well */
> +	ret = lseek(dest_fd, data_off, SEEK_SET);
> +	if (ret<  0) {
> +		error("seek dest file to %llu failed as %s",
> +		       (uint64_t)data_off, strerror(errno));
> +		return ret;
> +	}
> +
> +	while (len>  0) {
> +		memset(buf, 0, sizeof(buf));
> +		ssize_t n_read = read(src_fd, buf, BUF_SIZE);
> +		if (n_read<  0) {
> +			if (errno == EINTR)
> +				continue;
> +
> +			error("read source file extent failed as %s",
> +			      strerror(errno));	
> +			return n_read;
> +		}
> +
> +		if (n_read == 0)
> +			break;

Message? Error?

--Mark Tinguely

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
