Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBE4fDE9068971 for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 22:41:14 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAC18143C89D
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 20:43:02 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	Q4AgH2kcdYJCHROt for <xfs@oss.sgi.com>;
	Mon, 13 Dec 2010 20:43:02 -0800 (PST)
Date: Tue, 14 Dec 2010 15:42:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: pwrite hang when writing from mmaped
	buffer of the same page
Message-ID: <20101214044259.GA16267@dastard>
References: <1292295652-9508-1-git-send-email-xin.zhong@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292295652-9508-1-git-send-email-xin.zhong@intel.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Zhong, Xin" <xin.zhong@intel.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 14, 2010 at 11:00:52AM +0800, Zhong, Xin wrote:
> The problem is found in meego testing on btrfs:
> http://bugs.meego.com/show_bug.cgi?id=6672
> 
> Reviewed-by: Hellwig, Christoph <hch@infradead.org>
> Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
> ---
>  248                       |   58 +++++++++++++++++++++++++++++++++
>  248.out                   |    2 +
>  group                     |    1 +
>  src/Makefile              |    2 +-
>  src/pwrite_mmap_blocked.c |   78 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 140 insertions(+), 1 deletions(-)
>  create mode 100755 248
>  create mode 100644 248.out
>  create mode 100644 src/pwrite_mmap_blocked.c
> 
> diff --git a/248 b/248
> new file mode 100755
> index 0000000..a4664d9
> --- /dev/null
> +++ b/248
> @@ -0,0 +1,58 @@
> +#! /bin/bash
> +# FS QA Test No. 248
> +#
> +# Test for pwrite hang problem when writing from mmaped buffer of the same page 
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2010 YOUR NAME HERE.  All Rights Reserved.
                        ^^^^^^^^^^^^^^

Needs updating, I think. ;)

While I'm here, a two minute review...

....

> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +
> +TESTFILE=$TEST_DIR/test_file
> +TEST_PROG=$here/src/pwrite_mmap_blocked
> +
> +$TEST_PROG $TESTFILE
> +rm -f $TESTFILE

This rm should be in the _cleanup() function so that it is removed
even when the test is aborted.

.....

> diff --git a/group b/group
> index 0f94dd9..ddda26c 100644
> --- a/group
> +++ b/group
> @@ -361,3 +361,4 @@ deprecated
>  245 auto quick dir
>  246 auto quick rw
>  247 auto quick rw
> +248 other quick rw 

Why not the auto group?

> +char *progname;
> +loff_t size;
> +int fd;
> +void *mapped_mem;

None of these need to be global.

> +
> +
> +int main(int argc, char *argv[])
> +{
> +	int ret;
> +
> +	progname = argv[0];
> +	size = 5;
> +	fd = open(argv[1], O_RDWR|O_TRUNC|O_CREAT, 0666);
> +	if (fd < 0) {
> +		fprintf(stderr, "%s: Cannot open `%s': %s\n",
> +			progname, argv[1], strerror(errno));
> +		exit(1);
> +	}
> +
> +	char *cc = "01234";

Don't mix declarations in the the code. Better would be:

	int ret;
	char *cc = "01234";

	progname = argv[0];
	size = strlen(cc);
	....


> +	if ((ret = pwrite(fd, (const char *)cc,
> +				size, 0)) != size) {

	ret = pwrite(fd, cc, size, 0);
	if (ret != size) {

> +		fprintf(stderr, "%s: pwrite returned %d\n",
> +			__FUNCTION__, ret);
> +		perror("pwrite");
> +		exit(1);
> +	}

No need for both fprintf and perror calls.

> +
> +	mapped_mem = mmap(0, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> +	if (mapped_mem == MAP_FAILED) {
> +		perror("mmap");
> +		exit(1);
> +	}
> +	loff_t amount = 1;
> +	loff_t from = 2;
> +	loff_t to = 3;
> +	printf("pwrite %Ld bytes from %Ld to %Ld\n", amount, from, to);
> +	if ((ret = pwrite(fd, (char *)mapped_mem + from, amount, to)) != amount) {

	ret = pwrite(fd, (char *)mapped_mem + from, amount, to));
	if (ret != amount) {

> +		printf("%s: pwrite returned %d, not %Ld\n",
> +					__FUNCTION__, ret, amount);
> +		if (errno == EFAULT) {
> +			printf("pwrite: EFAULT\n");
> +		} else if (ret < 0) {
> +			perror("pwrite");
> +			exit(1);
> +		}

A single call to perror() will be sufficient here...

> +	}
> +	munmap(mapped_mem,0);
> +	close(fd);
> +	exit(0);
> +}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
