Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC8167F52
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 16:20:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B942A8F8050
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 14:20:55 -0700 (PDT)
Received: from mail-yh0-f54.google.com (mail-yh0-f54.google.com
	[209.85.213.54]) by cuda.sgi.com with ESMTP id HdSvHKhyV4FkQnmw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Apr 2013 14:20:54 -0700 (PDT)
Received: by mail-yh0-f54.google.com with SMTP id i21so598759yha.27
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 14:20:53 -0700 (PDT)
Message-ID: <5169CC34.9080902@gmail.com>
Date: Sat, 13 Apr 2013 17:20:52 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix s_max_bytes to MAX_LFS_FILESIZE if needed
References: <5167E160.3020800@oracle.com>
In-Reply-To: <5167E160.3020800@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Update:  My tests on my original hardware go exactly as they did in my 
Pentium 4 test.  xfstests shared/[0-9][0-9][0-9] and xfs/003 through 
xfs/136 were run against it.  No problems.  Good job.  I'm keeping the 
patch.

My final version of the bug summary goes like this:

On a 32-bit x86 PC, with a Linux kernel that has CONFIG_LBDAF=y...

xfstests generic/308, by writing to a file at an address just before 
2**32, causes the following conditions on an XFS filesystem:

1) CPU usage becomes very high,

2) The xfs_io process cannot be killed,

3) The best way to shut down the PC is through use of the magic SysRq keys.

4) Afterwards, attempts to mount the filesystem result in a soft oops.

5) After an `xfs_repair -L` on the filesystem, all is OK, other than for 
what was lost by zeroing the log.

J. Liu wrote a patch that solves this problem, but he found the answers 
with CONFIG_LBDAF=n, which is a condition for which xfstests generic/308 
passes on the two test PCs used.

Tests were conducted on a Pentium III (kernel 3.9-rc4 with numerous SGI 
patches) and on a Pentium 4 (kernel 3.9-rc6 with numerous SGI patches).

Could you verify these things by memory (no need to retest)?

a) With CONFIG_LBDAF=y, generic/308 caused filesystem corruption, and

b) With CONFIG_LBDAF=n, generic/308 passed the test.

c) Having CONFIG_LBDAF=n helped you to find the answers and write this 
fine patch.

Otherwise, the conclusion is "I don't know how you got there, but you 
got there.  Good job! and thanks for finding the root cause of the problem."

Thanks again!

Michael

On 04/12/2013 06:26 AM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
>
> On 32-bit machine, the s_maxbytes is larger than the MAX_LFS_FILESIZE limits if CONFIG_LBDAF is
> not enabled.  Hence it's possible to create a huge file via buffered-IO write with a given offset
> beyond this limitation. e.g.
>
> # block_size=4096
> # offset=$(((2**32 - 1) * $block_size))
> # xfs_io -f -c "pwrite $offset $block_size" /storage/test_file
>
> In this case, xfs_io will hang at the page writeback stage soon since the given offset would
> cause an overflow at xfs_vm_writepage():
>
> end_index = offset >> PAGE_CACHE_SHIFT;
> last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
> if (page->index >= end_index) {
>                  unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);
>
>                  /*
>                   * Just skip the page if it is fully outside i_size, e.g. due
>                   * to a truncate operation that is in progress.
>                   */
>                  if (page->index >= end_index + 1 || offset_into_page == 0) {
> 		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                          unlock_page(page);
>                          return 0;
>                  }
> end_index is unsigned long so that the max value is '2^32-1 = 4294967295', and it
> would be evaluated to the max value with the given offset(when writing the page offset
> up to s_max_bytes) for above test case.  As a result, (page->index >= end_index + 1) is
> ok as (end_index + 1) is overflowed to ZERO.
>
> Actually, create a file as above on 32-bit machine should be failed with EFBIG error returned
> because there has strict check up at generic_write_checks() against the given offset with a
> *correct* s_max_bytes.
>
> This patch fix the s_max_bytes to MAX_LFS_FILESIZE if the pre-calculated value is greater
> than it.
>
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>
> ---
>   fs/xfs/xfs_super.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ea341ce..0644d61 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -585,6 +585,7 @@ xfs_max_file_offset(
>   {
>   	unsigned int		pagefactor = 1;
>   	unsigned int		bitshift = BITS_PER_LONG - 1;
> +	__uint64_t		offset;
>
>   	/* Figure out maximum filesize, on Linux this can depend on
>   	 * the filesystem blocksize (on 32 bit platforms).
> @@ -610,7 +611,10 @@ xfs_max_file_offset(
>   # endif
>   #endif
>
> -	return (((__uint64_t)pagefactor) << bitshift) - 1;
> +	offset = (((__uint64_t)pagefactor) << bitshift) - 1;
> +
> +	/* Check against VM & VFS exposed limits */
> +	return (offset > MAX_LFS_FILESIZE) ? MAX_LFS_FILESIZE : offset;
>   }
>
>   xfs_agnumber_t
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
