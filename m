Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S4x8RM178832 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 23:59:09 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03CF9E30CF8
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 21:59:06 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PrpGgD7HhaYKc9t1 for <xfs@oss.sgi.com>;
	Mon, 27 Jun 2011 21:59:06 -0700 (PDT)
Date: Tue, 28 Jun 2011 14:59:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3 v2] XFS TESTS: Fix 252 Failure: Relax fiemap filter
Message-ID: <20110628045903.GK32466@dastard>
References: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309235247-32650-2-git-send-email-achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309235247-32650-2-git-send-email-achender@linux.vnet.ibm.com>
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jun 27, 2011 at 09:27:25PM -0700, Allison Henderson wrote:
> The current test 252 tests punch hole by collecting fiemap information
> on the test file.  However this does not work for all file systems since
> not all file systems layout their extents in the same way.
> 
> This patch corrects this by adding a -h flag to the fiemap filter that ignores
> the extent types in the fiemaps.  The result is that the fiemap contains only
> "extent" or "hole", instead of "unwritten", "data" or "hole".  A checksum has
> also been added to each test to help ensure the file contents are correct.
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
> ---
> v1 -> v2
> Moved new golden output for 252 into a seperate patch to help make the set
> easier to read
> 
> :100755 100755 5efa243... 1289094... M	252
> :100644 100644 ddf63b0... d3c89eb... M	common.punch
>  252          |    8 ++++----
>  common.punch |   38 ++++++++++++++++++++++++++++++++++++--
>  2 files changed, 40 insertions(+), 6 deletions(-)
> 
> diff --git a/252 b/252
> index 5efa243..1289094 100755
> --- a/252
> +++ b/252
> @@ -53,15 +53,15 @@ _require_xfs_io_fiemap
>  testfile=$TEST_DIR/252.$$
>  
>  # Standard punch hole tests
> -_test_generic_punch falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
> +_test_generic_punch falloc fpunch fpunch fiemap "_filter_fiemap -h" $testfile -F
>  
>  # Delayed allocation punch hole tests
> -_test_generic_punch -d falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
> +_test_generic_punch -d falloc fpunch fpunch fiemap "_filter_fiemap -h" $testfile -F
>  
>  # Multi hole punch tests
> -_test_generic_punch -k falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
> +_test_generic_punch -k falloc fpunch fpunch fiemap "_filter_fiemap -h" $testfile -F
>  
>  # Delayed allocation multi punch hole tests
> -_test_generic_punch -d -k falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
> +_test_generic_punch -d -k falloc fpunch fpunch fiemap "_filter_fiemap -h" $testfile -F
>  
>  status=0 ; exit
> diff --git a/common.punch b/common.punch
> index ddf63b0..d3c89eb 100644
> --- a/common.punch
> +++ b/common.punch
> @@ -203,17 +203,34 @@ _coalesce_extents()
>  
>  _filter_fiemap()
>  {
> +
> +	UNWRITTEN_EX="\"unwritten\""
> +	DATA_EX="\"data\""
> +	OPTIND=1
> +	while getopts 'h' OPTION
> +	do
> +		case $OPTION in
> +		h)      UNWRITTEN_EX="\"extent\""
> +			DATA_EX="\"extent\""
> +		;;
> +		?)      echo Invalid flag
> +		exit 1
> +		;;
> +		esac
> +	done
> +	shift $(($OPTIND - 1))
> +
>  	awk --posix '
>  		$3 ~ /hole/ {
>  			print $1, $2, $3;
>  			next;
>  		}
>  		$5 ~ /0x[[:digit:]]*8[[:digit:]]{2}/ {
> -			print $1, $2, "unwritten";
> +			print $1, $2, '$UNWRITTEN_EX';
>  			next;
>  		}
>  		$5 ~ /0x[[:digit:]]+/ {
> -			print $1, $2, "data";
> +			print $1, $2, '$DATA_EX';
>  		}' |
>  	_coalesce_extents
>  }

I seriously dislike conditional parameter passing in shell scripts
at the best of times, but for filter functions I really think it is
the wrong thing to do. It significantly obfuscates the working of
the function for no really good reason.

Just write a new filter function, and factor out the common parts of
them if the amount of code duplication is sufficient to make it
desirable to do so.

> +	md5sum $testfile | cut -d ' ' -f1

Why cut out the file name? It's not like it changes at all....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
