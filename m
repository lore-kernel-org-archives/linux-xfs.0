Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 952E67F4E
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:34:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73950304039
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 16:34:33 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	a7uFUcGS1ywCk1ig for <xfs@oss.sgi.com>;
	Wed, 27 Nov 2013 16:34:29 -0800 (PST)
Date: Thu, 28 Nov 2013 11:34:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add a new test case to test i_size updated
	properly under dio
Message-ID: <20131128003416.GL10988@dastard>
References: <1385013394-20379-1-git-send-email-wenqing.lz@taobao.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385013394-20379-1-git-send-email-wenqing.lz@taobao.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Zheng Liu <wenqing.lz@taobao.com>, Rich Johnston <rjohnston@sgi.com>, xfs@oss.sgi.com

On Thu, Nov 21, 2013 at 01:56:34PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In this commit a new test case is added to test that i_size is updated
> properly under dio reads/writes.  We add a program in /src dir, which
> has a writer to issue some append dio writes.  Meanwhile it has a
> reader in this test do some dio reads.  As we expect, reader should read
> nothing or data with 'a'.  But it might read some data with '0'.
> 
> This program is used to simulate binary log operations of database
> application.  In these applications it implements an master/slave
> synchronziation for database.
> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Rich Johnston <rjohnston@sgi.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  src/Makefile          |    2 +-
>  src/diotest.c         |  166 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/321     |   56 +++++++++++++++++
>  tests/generic/321.out |    1 +
>  tests/generic/group   |    1 +
>  5 files changed, 225 insertions(+), 1 deletion(-)
>  create mode 100644 src/diotest.c
>  create mode 100755 tests/generic/321
>  create mode 100644 tests/generic/321.out
> 
> diff --git a/src/Makefile b/src/Makefile
> index 84c8297..8c4f592 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -18,7 +18,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
>  	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
>  	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
> -	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec
> +	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec diotest

Fails to compile:

/tmp/cc54N2JC.o: In function `main':
/home/dave/src/xfstests-dev/src/diotest.c:120: undefined reference to `pthread_create'
/home/dave/src/xfstests-dev/src/diotest.c:135: undefined reference to `pthread_join'

It needs to be linked against libpthread, I think, so that needs to
be added to the LLDLIBS line, and the appropriate autoconf detection
macros added. You shoul dbe able to just copy the some
detection/infrastructure macros across from xfsprogs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
