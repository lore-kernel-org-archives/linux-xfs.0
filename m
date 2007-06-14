Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 10:49:57 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5EHnoWt012880
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 10:49:51 -0700
Date: Thu, 14 Jun 2007 18:31:53 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: iov_iter_fault_in_readable fix
Message-ID: <20070614173153.GA14771@infradead.org>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru> <20070613135759.GD13815@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613135759.GD13815@localhost.sw.ru>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, npiggin@suse.de, mark.fasheh@oracle.com, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jun 13, 2007 at 05:57:59PM +0400, Dmitriy Monakhov wrote:
>  	Function prerform check for signgle region, with out respect to
>  	segment nature of iovec, For example writev no longer works :)

Btw, could someone please start to collect all sniplets like this in
a nice simple regression test suite?  If no one wants to start a new
one we should probably just put it into xfsqa (which should be useable
for other filesystems aswell despite the name)

> 
> 	/* TESTCASE BEGIN */
> 	#include <stdio.h>
> 	#include <sys/types.h>
> 	#include <sys/stat.h>
> 	#include <fcntl.h>
> 	#include <sys/uio.h>
> 	#include <sys/mman.h>
> 	#define SIZE  (4096 * 2)
> 	int main(int argc, char* argv[])
> 	{	
> 		char* ptr[4];
> 		struct iovec iov[2];
> 		int fd, ret;
> 		ptr[0] = mmap(NULL, SIZE, PROT_READ|PROT_WRITE,
> 			MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
> 		ptr[1] = mmap(NULL, SIZE, PROT_NONE,
> 			MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
> 		ptr[2] = mmap(NULL, SIZE, PROT_READ|PROT_WRITE,
> 			MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
> 		ptr[3] = mmap(NULL, SIZE, PROT_NONE, 
> 			MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
> 
> 		iov[0].iov_base = ptr[0] + (SIZE -1);
> 		iov[0].iov_len = 1;
> 		memset(ptr[0], 1, SIZE);
> 
> 		iov[1].iov_base = ptr[2];
> 		iov[1].iov_len = SIZE;
> 		memset(ptr[2], 2, SIZE);
> 
> 		fd = open(argv[1], O_CREAT|O_RDWR|O_TRUNC, 0666);
> 		ret = writev(fd, iov, sizeof(iov) / sizeof(struct iovec));
> 		return 0;
> 	}	
> 	/* TESTCASE END*/
> 	We will get folowing result:
> 		writev(3, [{"\1", 1}, {"\2"..., 8192}], 2) = -1 EFAULT (Bad address)
>  	
> 	this is hidden bug, and it was invisiable because XXXX_fault_in_readable
>  	return value was ignored before. Lets iov_iter_fault_in_readable
>  	perform checks for all segments.
> 
> Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index fef19fc..7e025ea 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -433,7 +433,7 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
>  size_t iov_iter_copy_from_user(struct page *page,
>  		struct iov_iter *i, unsigned long offset, size_t bytes);
>  void iov_iter_advance(struct iov_iter *i, size_t bytes);
> -int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes);
> +int iov_iter_fault_in_readable(struct iov_iter *i, size_t *bytes);
>  size_t iov_iter_single_seg_count(struct iov_iter *i);
>  
>  static inline void iov_iter_init(struct iov_iter *i,
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 8d59ed9..8600c3e 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1817,10 +1817,32 @@ void iov_iter_advance(struct iov_iter *i, size_t bytes)
>  }
>  EXPORT_SYMBOL(iov_iter_advance);
>  
> -int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
> +int iov_iter_fault_in_readable(struct iov_iter *i, size_t* bytes)
>  {
> -	char __user *buf = i->iov->iov_base + i->iov_offset;
> -	return fault_in_pages_readable(buf, bytes);
> +	size_t len = *bytes;
> +	int ret;
> +	if (likely(i->nr_segs == 1)) {
> +		ret = fault_in_pages_readable(i->iov->iov_base, len);
> +		if (ret)
> +			*bytes = 0;
> +	} else {
> +		const struct iovec *iov = i->iov;
> +		size_t base = i->iov_offset;
> +		*bytes = 0;
> +		while (len) {
> +			int copy = min(len, iov->iov_len - base);
> +			if ((ret = fault_in_pages_readable(iov->iov_base + base, copy)))
> +				break;
> +			*bytes += copy;
> +			len -= copy;
> +			base += copy;
> +			if (iov->iov_len == base) {
> +				iov++;
> +				base = 0;
> +			}
> +		}
> +	}
> +	return ret;	
>  }
>  EXPORT_SYMBOL(iov_iter_fault_in_readable);
>  
> @@ -2110,7 +2132,7 @@ static ssize_t generic_perform_write_2copy(struct file *file,
>  		 * to check that the address is actually valid, when atomic
>  		 * usercopies are used, below.
>  		 */
> -		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
> +		if (unlikely(iov_iter_fault_in_readable(i, &bytes) && !bytes)) {
>  			status = -EFAULT;
>  			break;
>  		}
> @@ -2284,7 +2306,7 @@ again:
>  		 * to check that the address is actually valid, when atomic
>  		 * usercopies are used, below.
>  		 */
> -		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
> +		if (unlikely(iov_iter_fault_in_readable(i, &bytes)&& !bytes)) {
>  			status = -EFAULT;
>  			break;
>  		}
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
