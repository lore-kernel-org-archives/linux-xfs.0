Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B6647CBF
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 02:44:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 587EE304059
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 00:44:38 -0700 (PDT)
Received: from mail-pa0-f54.google.com (mail-pa0-f54.google.com
	[209.85.220.54]) by cuda.sgi.com with ESMTP id kpDCdqU6rupuwrCQ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 May 2013 00:44:37 -0700 (PDT)
Received: by mail-pa0-f54.google.com with SMTP id kx1so3988694pab.13
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 00:44:36 -0700 (PDT)
Date: Fri, 24 May 2013 16:02:32 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH V2] xfstests: fix src/seek_sanity_test -t option
Message-ID: <20130524080232.GA32562@gmail.com>
References: <519EF4AE.60702@redhat.com>
 <519EF740.1000907@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <519EF740.1000907@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, May 24, 2013 at 12:14:40AM -0500, Eric Sandeen wrote:
> _require_seek_data_hole() does not work because
> the -t (test) option of seek_sanity_test is broken,
> because of an early check for (argc != 2):
> 
> # src/seek_sanity_test -t foo
> Usage: src/seek_sanity_test base_file_path
> 
> So _require_seek_data_hole() doesn't see the
> "Kernel does not support" string it's looking for,
> and passes the check.
> 
> So rather than _notrun-ing the test, it proceeds to
> fail with noisy errors.
> 
> Fix that, make a common usage() function, and check for
> too many args as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Sorry, my apologies.  I made a mistake when I rebased the patch.  Thanks
for fixing it.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
> 
> V2: saner test for too many args
> 
> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> index 4275a84..f957178 100644
> --- a/src/seek_sanity_test.c
> +++ b/src/seek_sanity_test.c
> @@ -656,6 +656,12 @@ out:
>  	return ret;
>  }
>  
> +void usage(char *cmd)
> +{
> +	fprintf(stdout, "Usage: %s [-t] base_file_path\n", cmd);
> +	exit(1);
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	int ret = -1;
> @@ -664,23 +670,20 @@ int main(int argc, char **argv)
>  	int check_support = 0;
>  	int numtests = sizeof(seek_tests) / sizeof(struct testrec);
>  
> -	if (argc != 2) {
> -		fprintf(stdout, "Usage: %s base_file_path\n", argv[0]);
> -		return ret;
> -	}
> -
>  	while ((opt = getopt(argc, argv, "t")) != -1) {
>  		switch (opt) {
>  		case 't':
>  			check_support++;
>  			break;
>  		default:
> -			fprintf(stderr, "Usage: %s [-t] base_file_path\n",
> -				argv[0]);
> -			return ret;
> +			usage(argv[0]);
>  		}
>  	}
>  
> +	/* should be exactly one arg left, the filename */
> +	if (optind != argc - 1)
> +		usage(argv[0]);
> +
>  	base_file_path = (char *)strdup(argv[optind]);
>  
>  	ret = test_basic_support();
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
