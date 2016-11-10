Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45633 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935329AbcKJRUd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2016 12:20:33 -0500
Date: Thu, 10 Nov 2016 09:20:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] shared/006: improve the speed of case running
Message-ID: <20161110172026.GF16813@birch.djwong.org>
References: <1478795242-14022-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478795242-14022-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Nov 11, 2016 at 12:27:22AM +0800, Zorro Lang wrote:
> There're three problems of this case:
> 1. Thousands of threads will be created to create lots of files, then
>    kernel need to waste lots of system resource to schedule these
>    threads. Some poor performance machines will take long long time
>    on that.
> 2. Per thread try to create 1000 files by run 1000 times "echo >file".
> 
> For the 1st problem, I limit 2 threads per cpu, and the maximum is 20.
> For the 2nd problem, use "sed 1 1000 | xargs touch" to instead of
> the old way.
> 
> With this change, this case can run over in 2 mins on my x86_64
> virtual machine with 1 cpu and 1G memory. Before that, it was still
> running even a quarter passed.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> The performance of this case affect the test time of xfstests,
> especially on poor performance VM. I always doubt it hangs there,
> because it has run too long time.
> 
> After this improvement:
> It ran 105s on my virtual machine with 1 cpu and 1G memory.
> It ran 60s on my real machine with 8 cpu and 64G memory.
> 
> The difference of "for ((i=0;i<1000;i++)); echo -n > file$i;done"
> and "touch file{1..1000}" is:
> The 1st one will run 1000 times execve, open, close and so on. The
> execve() will take much time, especially on VM.
> But the 2nd one will run once execve, 1000 times open and once close.
> open() take much less time than execve().
> 
> Too many threads really waste too much time. For example, on my VM,
> when I use $((ncpus * 2)) threads to run this case, it ran 100s. But
> if I use $((ncpus * 4)) threads, the time increase to 130s. So too
> many threads is not helpful, in contrast it wastes more time.
> 
> Thanks,
> Zorro
> 
>  tests/shared/006 | 42 ++++++++++++++++++++++++++++--------------
>  1 file changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/tests/shared/006 b/tests/shared/006
> index 6a237c9..42cd34d 100755
> --- a/tests/shared/006
> +++ b/tests/shared/006
> @@ -43,13 +43,16 @@ create_file()
>  {
>  	local dir=$1
>  	local nr_file=$2
> -	local prefix=$3
> -	local i=0
>  
> -	while [ $i -lt $nr_file ]; do
> -		echo -n > $dir/${prefix}_${i}
> -		let i=$i+1
> -	done
> +	if [ ! -d $dir ]; then
> +		mkdir -p $dir
> +	fi
> +
> +	if [ ${nr_file} -gt 0 ]; then
> +		pushd $dir >/dev/null
> +		seq 1 $nr_file | xargs touch
> +		popd >/dev/null
> +	fi
>  }
>  
>  # get standard environment, filters and checks
> @@ -61,6 +64,9 @@ _supported_fs ext4 ext3 ext2 xfs
>  _supported_os Linux
>  
>  _require_scratch
> +_require_test_program "feature"
> +
> +ncpus=`$here/src/feature -o`
>  
>  rm -f $seqres.full
>  echo "Silence is golden"
> @@ -68,19 +74,27 @@ echo "Silence is golden"
>  _scratch_mkfs_sized $((1024 * 1024 * 1024)) >>$seqres.full 2>&1
>  _scratch_mount
>  
> -i=0
>  free_inode=`_get_free_inode $SCRATCH_MNT`
>  file_per_dir=1000
> -loop=$((free_inode / file_per_dir + 1))
> -mkdir -p $SCRATCH_MNT/testdir
> -
> -echo "Create $((loop * file_per_dir)) files in $SCRATCH_MNT/testdir" >>$seqres.full
> -while [ $i -lt $loop ]; do
> -	create_file $SCRATCH_MNT/testdir $file_per_dir $i >>$seqres.full 2>&1 &
> -	let i=$i+1
> +num_dirs=$(( free_inode / (file_per_dir + 1) ))
> +num_threads=$(( ncpus * 2 ))
> +[ $num_threads -gt 20 ] && num_threads=20

Only 20 threads?  Not much of a workout for my 40-cpu system. :P

Was also wondering if we wanted to scale by $LOAD_FACTOR here...

--D

> +loop=$(( num_dirs / num_threads ))
> +
> +echo "Create $((loop * num_threads)) dirs and $file_per_dir files per dir in $SCRATCH_MNT" >>$seqres.full
> +for ((i=0; i<ncpus*2; i++)); do
> +	for ((j=0; j<$loop; j++)); do
> +		create_file $SCRATCH_MNT/testdir_$i_$j $file_per_dir
> +	done &
>  done
>  wait
>  
> +free_inode=`_get_free_inode $SCRATCH_MNT`
> +if [ $free_inode -gt 0 ]; then
> +	echo "Create $((free_inode - 1)) files and 1 dir to fill all remaining free inodes" >>$seqres.full
> +	create_file $SCRATCH_MNT/testdir_$i_$j $((free_inode - 1))
> +fi
> +
>  # log inode status in $seqres.full for debug purpose
>  echo "Inode status after taking all inodes" >>$seqres.full
>  $DF_PROG -i $SCRATCH_MNT >>$seqres.full
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
