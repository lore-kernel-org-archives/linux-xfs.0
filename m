Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16MUDif169776 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 16:30:14 -0600
Message-ID: <4F305472.8070509@sgi.com>
Date: Mon, 06 Feb 2012 16:30:10 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] xfstests: introduce 280 for SEEK_DATA/SEEK_HOLE
	copy check
References: <4F2FE410.2040508@oracle.com>
In-Reply-To: <4F2FE410.2040508@oracle.com>
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

On 02/06/12 08:30, Jeff Liu wrote:
> Introduce 280 for SEEK_DATA/SEEK_HOLE copy check.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> ---

>
> diff --git a/src/seek_copy_tester.c b/src/seek_copy_tester.c
> new file mode 100644
> index 0000000..ddf683f
> --- /dev/null
> +++ b/src/seek_copy_tester.c

> +static size_t
> +full_write(int fd, const void *buf, size_t count)
> +{
> +	size_t total = 0;
> +	const char *ptr = (const char *) buf;
> +
> +	while (count>  0) {
> +		ssize_t n = write(fd, ptr, count);
> +		if (n<  0) {
> +			if (errno == EINTR)
> +				continue;

Wouldn't you want to stop the write loop if interrupted?

> +			error("full_write() failed as %s", strerror(errno));
> +			break;
> +		}
> +
> +		if (n == 0) {
> +			error("full_write() ZERO bytes transferred");

You can tell them how many (total) bytes were written before the error.
Same in full_pwrite()

> +create_data_and_holes(int fd, size_t nr_total_bytes, off_t start_offset,
> +		      uint64_t nr_skip_bytes, uint64_t nr_data_bytes,
> +		      int wrote_hole_at_eof)
> +{
> +	int ret = 0;
> +	off_t total = nr_total_bytes;
> +	off_t data_len = nr_data_bytes;
> +	off_t off = start_offset;
> +	char buf[BUF_SIZE];
> +
> +	memset(buf, 'A', sizeof(buf));
> +
> +	total -= start_offset;
> +	while (total>  0) {

+	data_len = nr_data_bytes; /* see below */

> +		do {
> +			size_t nr_write = MIN(total, BUF_SIZE);

There are 2 dependencies:
  1) The last nr_data_bytes does not exceed total (outer loop)
  2) The remaining data size (data_len) could be less than BUF_SIZE
     (if data_len is not a multiple of BUF_SIZE for example).

> +			if (full_pwrite(fd, buf, nr_write, off) != nr_write) {
> +				error("full_pwrite() failed as %s", strerror(errno));
> +				ret = -1;
> +				goto out;
> +			}
> +
> +			off += nr_write;
> +			data_len -= nr_write;
> +		} while (data_len>  0);

data_len is <= 0 so the inner loop will execute only once if you have 
more than one chunk of data.
> +
> +		off += (nr_skip_bytes + nr_data_bytes);
> +		total -= off;
> +	}
> +
> +	if (off<  nr_total_bytes) {
> +		if (wrote_hole_at_eof) {
> +			ret = ftruncate(fd, nr_total_bytes);
> +			if (ret<  0) {
> +				error("truncate source file to %lld bytes failed as %s",
> +				       (long long)nr_total_bytes, strerror(errno));
> +			}
> +		}
> +
> +		ret = write_zeros(fd, nr_total_bytes - off);
> +		if (ret<  0) {
> +			error("write_zeros to end of file failed as %s",
> +			       strerror(errno));
> +		}
> +	}
> +
> +out:
> +	return ret;
> +}

It is shaping up nicely.

--Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
