Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5CBFB7CBF
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 01:54:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 46B5C304032
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 23:54:43 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ITgRo0r3gVa9DUu3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 May 2013 23:54:42 -0700 (PDT)
Message-ID: <519F0EA8.8010305@oracle.com>
Date: Fri, 24 May 2013 14:54:32 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: fix src/seek_sanity_test -t option
References: <519EF4AE.60702@redhat.com> <519EF740.1000907@redhat.com>
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

On 05/24/2013 01:14 PM, Eric Sandeen wrote:
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

This looks good to me.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
