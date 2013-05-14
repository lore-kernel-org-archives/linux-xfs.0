Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AF5FD7F37
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 13:54:24 -0500 (CDT)
Message-ID: <5192887E.6070205@sgi.com>
Date: Tue, 14 May 2013 13:54:54 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: add _require_seek_data_hole to check seek
	data/hole
References: <1368350670-9499-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1368350670-9499-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On 05/12/2013 04:24 AM, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> In xfstest 285/286 we don't check whether the target file system
> supports seek data/hole operation or not.  Here _require_seek_data_hole
> is defined to do this work.
>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Rich Johnston <rjohnston@sgi.com>
> ---
> changelog:
>   * rebase against the latest master branch of xfstests tree
>
> Hi Rich,
>
> Sorry for the late.  Could you please look at this patch?
>
> Thanks,
> 						- Zheng
>
>   common/rc              | 12 ++++++++++++
>   src/seek_sanity_test.c | 18 ++++++++++++++++--
>   tests/generic/285      |  2 ++
>   tests/generic/286      |  2 ++
>   4 files changed, 32 insertions(+), 2 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index f97924a..f24a6aa 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1283,6 +1283,18 @@ _require_fail_make_request()
>    not found. Seems that CONFIG_FAIL_MAKE_REQUEST kernel config option not enabled"
>   }
>
> +#
> +# Check if the file system supports seek_data/hole
> +#
> +_require_seek_data_hole()
> +{
> +    testfile=$TEST_DIR/$$.seek
> +    testseek=`$here/src/seek_sanity_test -t $testfile 2>&1`
> +    rm -f $testfile &>/dev/null
> +    echo $testseek | grep -q "Kernel does not support" && \
> +        _notrun "File system does not support llseek(2) SEEK_DATA/HOLE"
> +}
> +
>   # check that a FS on a device is mounted
>   # if so, return mount point
>   #
> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> index 3897f02..4275a84 100644
> --- a/src/seek_sanity_test.c
> +++ b/src/seek_sanity_test.c
> @@ -660,6 +660,8 @@ int main(int argc, char **argv)
>   {
>   	int ret = -1;
>   	int i = 0;
> +	int opt;
> +	int check_support = 0;
>   	int numtests = sizeof(seek_tests) / sizeof(struct testrec);
>
>   	if (argc != 2) {
> @@ -667,10 +669,22 @@ int main(int argc, char **argv)
>   		return ret;
>   	}
>
> -	base_file_path = (char *)strdup(argv[1]);
> +	while ((opt = getopt(argc, argv, "t")) != -1) {
> +		switch (opt) {
> +		case 't':
> +			check_support++;
> +			break;
> +		default:
> +			fprintf(stderr, "Usage: %s [-t] base_file_path\n",
> +				argv[0]);
> +			return ret;
> +		}
> +	}
> +
> +	base_file_path = (char *)strdup(argv[optind]);
>
>   	ret = test_basic_support();
> -	if (ret)
> +	if (ret || check_support)
>   		goto out;
>
>   	for (i = 0; i < numtests; ++i) {
> diff --git a/tests/generic/285 b/tests/generic/285
> index 22b4a08..b700a15 100644
> --- a/tests/generic/285
> +++ b/tests/generic/285
> @@ -40,6 +40,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>   _supported_fs generic
>   _supported_os Linux
>
> +_require_seek_data_hole
> +
>   BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
>
>   [ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
> diff --git a/tests/generic/286 b/tests/generic/286
> index a0d4df9..5ab174f 100644
> --- a/tests/generic/286
> +++ b/tests/generic/286
> @@ -38,6 +38,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>   _supported_fs generic
>   _supported_os Linux
>
> +_require_seek_data_hole
> +
>   src=$TEST_DIR/seek_copy_testfile
>   dest=$TEST_DIR/seek_copy_testfile.dest
>
>
Hi Zheng, this has been committed:

commit 92449b7f36aba627adc3b2f11c1184292c5e43c7
Author: Zheng Liu <wenqing.lz@taobao.com>
Date:   Tue May 14 13:25:44 2013 -0500

     In xfstest 285/286 we don't check whether the target file system
     supports seek data/hole operation or not.  Here _require_seek_data_hole
     is defined to do this work.

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
