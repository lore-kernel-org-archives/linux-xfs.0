Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PEkPvV207556 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 08:46:25 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E37D5A25BB2
	for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 06:49:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZoaSB9sZbUzmxSOs for
	<xfs@oss.sgi.com>; Fri, 25 Feb 2011 06:49:11 -0800 (PST)
Date: Fri, 25 Feb 2011 09:49:09 -0500
From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 2/2 V2] xfstests 225: add additional fiemap-tester run
	without sync
Message-ID: <20110225144908.GA2534@localhost.localdomain>
References: <4D66D5DB.5090203@redhat.com> <4D66D8F2.10501@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D66D8F2.10501@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Josef Bacik <jbacik@redhat.com>, xfs mailing list <xfs@oss.sgi.com>

On Thu, Feb 24, 2011 at 04:17:22PM -0600, Eric Sandeen wrote:
> Chris Mason pointed out that some filesystems were not doing
> the right thing on fiemap, in the face of delalloc extents.
> 
> Because test 225 ran with FIEMAP_FLAG_SYNC only, this didn't
> get caught.  Add a runtime option, and run it both ways.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Whoops, V2: actually call w/ the sync flag.
> 
> diff --git a/225 b/225
> index 6e879a4..6b203e6 100755
> --- a/225
> +++ b/225
> @@ -60,7 +60,10 @@ _cleanup()
>  }
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> -echo "fiemap run without preallocation"
> +echo "fiemap run without preallocation, with sync"
> +$here/src/fiemap-tester -q -S -p 0 -r 200 $fiemapfile 2>&1 | tee $fiemaplog
> +
> +echo "fiemap run without preallocation or sync"
>  $here/src/fiemap-tester -q -p 0 -r 200 $fiemapfile 2>&1 | tee $fiemaplog
>  
>  if grep -q "Operation not supported" $fiemaplog; then
> diff --git a/225.out b/225.out
> index 7bc9312..b4f6477 100644
> --- a/225.out
> +++ b/225.out
> @@ -1,2 +1,3 @@
>  QA output created by 225
> -fiemap run without preallocation
> +fiemap run without preallocation, with sync
> +fiemap run without preallocation or sync
> diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
> index 53d7a64..6320580 100644
> --- a/src/fiemap-tester.c
> +++ b/src/fiemap-tester.c
> @@ -418,7 +418,7 @@ static int query_fiemap_count(int fd, int blocks, int blocksize)
>  }
>  
>  static int
> -compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize)
> +compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfile)
>  {
>  	struct fiemap *fiemap;
>  	char *fiebuf;
> @@ -446,7 +446,7 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize)
>  			last_data = i;
>  	}
>  
> -	fiemap->fm_flags = FIEMAP_FLAG_SYNC;
> +	fiemap->fm_flags = syncfile ? FIEMAP_FLAG_SYNC : 0;
>  	fiemap->fm_extent_count = blocks_to_map;
>  	fiemap->fm_mapped_extents = 0;
>  
> @@ -519,9 +519,10 @@ main(int argc, char **argv)
>  	int	blocks = 0;	/* the number of blocks to generate */
>  	int	maxblocks = 0;	/* max # of blocks to create */
>  	int	prealloc = 1;	/* whether or not to do preallocation */
> +	int	syncfile = 0;	/* whether fiemap should  sync file first */
>  	int	seed = 1;
>  
> -	while ((opt = getopt(argc, argv, "m:r:s:p:q")) != -1) {
> +	while ((opt = getopt(argc, argv, "m:r:s:p:qS")) != -1) {
>  		switch(opt) {
>  		case 'm':
>  			map = strdup(optarg);
> @@ -538,13 +539,16 @@ main(int argc, char **argv)
>  		case 'q':
>  			quiet = 1;
>  			break;
> -		/* sync file before mapping */
>  		case 'r':
>  			runs = atoi(optarg);
>  			break;
>  		case 's':
>  			seed = atoi(optarg);
>  			break;
> +		/* sync file before mapping */
> +		case 'S':
> +			syncfile = 1;
> +			break;
>  		default:
>  			usage();
>  		}
> @@ -623,7 +627,7 @@ main(int argc, char **argv)
>  			exit(1);
>  		}
>  
> -		rc = compare_fiemap_and_map(fd, map, blocks, blocksize);
> +		rc = compare_fiemap_and_map(fd, map, blocks, blocksize, syncfile);
>  		if (rc) {
>  			printf("Problem comparing fiemap and map\n");
>  			free(map);
> 
> 

How about something in the usage() function to show we have this handy option
:).  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
