Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751248AbdGMIPA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jul 2017 04:15:00 -0400
Date: Thu, 13 Jul 2017 16:14:58 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic: test negative SEEK_HOLE/SEEK_DATA offsets
Message-ID: <20170713081458.GE2478@eguan.usersys.redhat.com>
References: <20170712173923.GD4212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170712173923.GD4212@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Wed, Jul 12, 2017 at 10:39:23AM -0700, Darrick J. Wong wrote:
> Check that we get -ENXIO if the user calls SEEK_HOLE/SEEK_DATA with
> a negative file offset.

A minor nit, this might be confusing, lseek returns -1 on error, and set
errno to ENXIO, no one actually returns -ENXIO.

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  src/seek_sanity_test.c |   25 +++++++++++++++++
>  tests/generic/702      |   70 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/702.out  |    2 +
>  tests/generic/group    |    1 +
>  4 files changed, 98 insertions(+)
>  create mode 100755 tests/generic/702
>  create mode 100644 tests/generic/702.out
> 
> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> index a58ec36..547f0a4 100644
> --- a/src/seek_sanity_test.c
> +++ b/src/seek_sanity_test.c
> @@ -274,6 +274,30 @@ static int huge_file_test(int fd, int testnum, off_t filsz)
>  	return ret;
>  }
>  
> +/* Make sure we get ENXIO if we pass in a negative offset. */
> +static int test18(int fd, int testnum)
> +{
> +	int ret = 0;
> +	off_t pos;
> +
> +	errno = 0;
> +	pos = lseek(fd, -1, SEEK_HOLE);
> +	if (pos != -1 || errno != ENXIO) {
> +		printf("%02d.1 SEEK_HOLE expected -1 with errno %d, got %jd and %d.\n",
> +		       testnum, -ENXIO, pos, -errno);
> +		ret++;
> +	}
> +
> +	errno = 0;
> +	pos = lseek(fd, -1, SEEK_DATA);
> +	if (pos != -1 || errno != ENXIO) {
> +		printf("%02d.1 SEEK_DATA expected -1 with errno %d, got %jd and %d.\n",
> +		       testnum, -ENXIO, pos, -errno);
> +		ret++;
> +	}
> +	return ret;

Seems cleaner to use do_lseek() helper, e.g.

static int test18(int fd, int testnum)
{
	int ret = 0;

	/* file size doesn't matter in this test, set to 0 */
	ret += do_lseek(testnum, 1, fd, 0, SEEK_HOLE, -1, -1);
	ret += do_lseek(testnum, 2, fd, 0, SEEK_DATA, -1, -1);
	
	return ret;
}

And test reports "succ" or "FAIL" as what other subtests do

18. Test file with negative SEEK_{HOLE,DATA} offsets  
18.01 SEEK_HOLE expected -1 or -1, got 0.                         FAIL
18.02 SEEK_DATA expected -1 with errno -6, got -1.                FAIL

Thanks,
Eryu
