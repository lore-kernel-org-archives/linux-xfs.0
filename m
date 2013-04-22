Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F83E7F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 14:17:15 -0500 (CDT)
Message-ID: <51758CC1.7040400@sgi.com>
Date: Mon, 22 Apr 2013 14:17:21 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] capture the failure result of 310
References: <516B75E9.40605@huawei.com>
In-Reply-To: <516B75E9.40605@huawei.com>
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
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hi Zhao Hongjiang,

Eryu Guan submitted a cleanup patch for test 310, will you please 
include them with your next version?

1. add one space between # and test description
2. remove creator/owner info
3. fix common/rc and common/filter path so they can be sourced correctly
4. no need to remove $seq.full cause it's not used(or if verbose output
    is needed, $seqres.full should be used)

Here is the link to the thread.
http://oss.sgi.com/archives/xfs/2013-04/msg00128.html

On 04/14/2013 10:37 PM, Zhao Hongjiang wrote:
> Capture the failuer by the way of count error dmesg and give the description
> how i run the test to trigger problems.
>
> Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>

Please add the following line when you include the cleanup patch.
[eguan@redhat.com fix common file path and other cleanups]

> ---
>   tests/generic/310 |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 files changed, 56 insertions(+), 1 deletions(-)
>   mode change 100644 => 100755 tests/generic/310
>
> diff --git a/tests/generic/310 b/tests/generic/310
> old mode 100644
> new mode 100755
> index ef51422..f44799a
> --- a/tests/generic/310
> +++ b/tests/generic/310
> @@ -4,6 +4,17 @@

Please add one space between # and test description.

>   #Check if there are two threads,one keeps calling read() or lseek(), and
>   #the other calling readdir(), both on the same directory fd.
>   #

Try to keep personal pronouns out of any comments i.e.

> +#When I ran this on ext3 (can be replaced with ext2/ext4) which has dir_index
> +#feature disabled, I got this:

# Testing on ext3: with dir_index disabled results in the following
# dmesg output: (also occurs when testing ext2 and ext4)

> +#
> +#EXT3-fs error (device sdb): ext3_readdir: bad entry in directory #1134241:
> +#rec_len % 4 != 0 - offset=2704, inode=16973836, rec_len=12850, name_len=52
> +#EXT3-fs error (device sdb): ext3_readdir: bad entry in directory #1134241:
> +#directory entry across blocks - offset=1672, inode=16973836, rec_len=14132,
> +#name_len=57
> +#

> +#If we configured errors=remount-ro, the filesystem will become read-only.

# The filesystem mount option 'errors=' will define the behavior
# when an error is encountered. (see mount manpage)


> +#
>   # Based on a testcase from Li Zefan <lizefan@huawei.com>.
>   #
>   # http://marc.info/?l=linux-kernel&m=136123703211869&w=2
> @@ -47,6 +58,37 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>   _supported_fs generic
>   _supported_os Linux
>
> +dmesg -c > /dev/null
> +
> +nr_bug=`dmesg | grep -c "kernel BUG"`
> +nr_error=`dmesg | grep -c "error"`
> +nr_null=`dmesg | grep -c "kernel NULL pointer dereference"`
> +nr_warning=`dmesg | grep -c "^WARNING"`
> +nr_lockdep=`dmesg | grep -c "possible recursive locking detected"`
> +
> +#check if some kind of kernel bug happened
> +check_kernel_bug()
> +{
> +	new_bug=`dmesg | grep -c "kernel BUG"`	
> +	new_error=`dmesg | grep -c "error"`
> +	new_null=`dmesg | grep -c "kernel NULL pointer dereference"`
> +	new_warning=`dmesg | grep -c "^WARNING"`
> +	new_lockdep=`dmesg | grep -c "possible recursive locking detected"`
> +
> +
> +	# no kernel bug is detected
> +	if [ $new_bug -eq $nr_bug -a $new_error -eq $nr_error -a \
> +	     $new_null -eq $nr_null -a $new_warning -eq $nr_warning -a \
> +	     $new_lockdep -eq $nr_lockdep ]; then
> +		return 1
> +	fi
> +
> +	nr_bug=$new_bug
> +	nr_error=$new_error
> +	nr_null=$new_null
> +	nr_warning=$new_warning
> +	nr_lockdep=$new_lockdep
> +}
>   mkdir $TEST_DIR/tmp
>   for n in {1..4096}; do
>   	touch $TEST_DIR/tmp/$n
> @@ -57,6 +99,13 @@ _test_read()
>   	src/t_readdir_1 $TEST_DIR/tmp &
>   	sleep 100
>   	killall src/t_readdir_1
> +	check_kernel_bug
> +	if [ $? -eq 1 ]; then
> +		status=0
> +	else
> +		echo "error: kernel bug was found, you can see the
> +			dmesg for more infomation."
> +	fi
>   }
>
>   _test_lseek()
> @@ -64,6 +113,13 @@ _test_lseek()
>   	src/t_readdir_2 $TEST_DIR/tmp &
>   	sleep 100
>   	killall src/t_readdir_2
> +	check_kernel_bug
> +	if [ $? -eq 1 ]; then
> +		status=0
> +	else
> +		echo "error: kernel bug was found, you can see the
> +			dmesg for more infomation."
> +	fi
>   }
>
>   _test_read
> @@ -72,5 +128,4 @@ _test_lseek
>   # success, all done
>   echo "*** done"
>   rm -f $seq.full
> -status=0
>   exit
>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
