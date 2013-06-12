Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D417129DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 21:35:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B40798F8035
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 19:35:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	NQ6S1W8wVZA7KwBs for <xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 19:35:26 -0700 (PDT)
Date: Wed, 12 Jun 2013 12:35:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fsync-tester: fix pwrite() return check and
	disable direct for test 19
Message-ID: <20130612023515.GV29338@dastard>
References: <1370999583-16725-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370999583-16725-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 11, 2013 at 09:13:03PM -0400, Josef Bacik wrote:
> Test 19 in direct mode was failing on xfs because it was not actually doing the
> write because the writes were not sectorsize aligned.  This test is to test
> btrfs's inline extent fsync()ing so the writes won't be sectorsize aligned, and
> inline extents will fall back to buffered anyway so direct mode is meaningless
> for this test.  So just check if we are test 19 and disable direct mode so we
> don't have to change the golden output.  Also change test_five() to compare
> against a ssize_t instead of a size_t since apparently comparing against size_t
> makes it cast the return value of pwrite() to size_t which screws up the error
> case, so instead of seeing the pwrite() error on xfs which would have explained
> this all it appeared as if it was succeeding and screwing up the fsync(), which
> unfortunately wasted a bit of Daves time.  This patch should fix all this up.

You need to breathe when you type, Josef. ;)

> Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  src/fsync-tester.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/src/fsync-tester.c b/src/fsync-tester.c
> index f0875fc..1c03ed0 100644
> --- a/src/fsync-tester.c
> +++ b/src/fsync-tester.c
> @@ -230,7 +230,7 @@ static int test_five()
>  
>  	memset(buf, character, 3072);
>  	for (i = 0; i < runs; i++) {
> -		size_t write_size = (random() % 3072) + 1;
> +		ssize_t write_size = (random() % 3072) + 1;
>  
>  		if (pwrite(test_fd, buf, write_size, 0) < write_size) {
>  			fprintf(stderr, "Short write %d\n", errno);
> @@ -419,6 +419,14 @@ int main(int argc, char **argv)
>  	if (optind >= argc)
>  		usage();
>  
> +	/*
> +	 * test 19 is for smaller than blocksize writes to test btrfs's inline
> +	 * extent fsyncing, so direct_io doesn't make sense and in fact doesn't
> +	 * work for other file systems, so just disable direct io for this test.
> +	 */
> +	if (test == 19)
> +		direct_io = 0;
> +

Yup, looks good. Passes for me now ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
