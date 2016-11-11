Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756042AbcKKJRy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Nov 2016 04:17:54 -0500
Date: Fri, 11 Nov 2016 17:17:51 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] shared/006: improve the speed of case running
Message-ID: <20161111091751.GG3327@dhcp12-143.nay.redhat.com>
References: <1478795242-14022-1-git-send-email-zlang@redhat.com>
 <20161110172026.GF16813@birch.djwong.org>
 <20161111083749.GF3327@dhcp12-143.nay.redhat.com>
 <20161111090949.GG16813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161111090949.GG16813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Nov 11, 2016 at 01:09:49AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 11, 2016 at 04:37:50PM +0800, Zorro Lang wrote:
> > On Thu, Nov 10, 2016 at 09:20:26AM -0800, Darrick J. Wong wrote:
> > > On Fri, Nov 11, 2016 at 12:27:22AM +0800, Zorro Lang wrote:
> > > > There're three problems of this case:
> > > > 1. Thousands of threads will be created to create lots of files, then
> > > >    kernel need to waste lots of system resource to schedule these
> > > >    threads. Some poor performance machines will take long long time
> > > >    on that.
> > > > 2. Per thread try to create 1000 files by run 1000 times "echo >file".
> > > > 
> > > > For the 1st problem, I limit 2 threads per cpu, and the maximum is 20.
> > > > For the 2nd problem, use "sed 1 1000 | xargs touch" to instead of
> > > > the old way.
> > > > 
> > > > With this change, this case can run over in 2 mins on my x86_64
> > > > virtual machine with 1 cpu and 1G memory. Before that, it was still
> > > > running even a quarter passed.
> > > > 
> > > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > > ---
> > > > 
> > > > Hi,
> > > > 
> > > > The performance of this case affect the test time of xfstests,
> > > > especially on poor performance VM. I always doubt it hangs there,
> > > > because it has run too long time.
> > > > 
> > > > After this improvement:
> > > > It ran 105s on my virtual machine with 1 cpu and 1G memory.
> > > > It ran 60s on my real machine with 8 cpu and 64G memory.
> > > > 
> > > > The difference of "for ((i=0;i<1000;i++)); echo -n > file$i;done"
> > > > and "touch file{1..1000}" is:
> > > > The 1st one will run 1000 times execve, open, close and so on. The
> > > > execve() will take much time, especially on VM.
> > > > But the 2nd one will run once execve, 1000 times open and once close.
> > > > open() take much less time than execve().
> > > > 
> > > > Too many threads really waste too much time. For example, on my VM,
> > > > when I use $((ncpus * 2)) threads to run this case, it ran 100s. But
> > > > if I use $((ncpus * 4)) threads, the time increase to 130s. So too
> > > > many threads is not helpful, in contrast it wastes more time.
> > > > 
> > > > Thanks,
> > > > Zorro
> > > > 
> > > >  tests/shared/006 | 42 ++++++++++++++++++++++++++++--------------
> > > >  1 file changed, 28 insertions(+), 14 deletions(-)
> > > > 
> > > > diff --git a/tests/shared/006 b/tests/shared/006
> > > > index 6a237c9..42cd34d 100755
> > > > --- a/tests/shared/006
> > > > +++ b/tests/shared/006
> > > > @@ -43,13 +43,16 @@ create_file()
> > > >  {
> > > >  	local dir=$1
> > > >  	local nr_file=$2
> > > > -	local prefix=$3
> > > > -	local i=0
> > > >  
> > > > -	while [ $i -lt $nr_file ]; do
> > > > -		echo -n > $dir/${prefix}_${i}
> > > > -		let i=$i+1
> > > > -	done
> > > > +	if [ ! -d $dir ]; then
> > > > +		mkdir -p $dir
> > > > +	fi
> > > > +
> > > > +	if [ ${nr_file} -gt 0 ]; then
> > > > +		pushd $dir >/dev/null
> > > > +		seq 1 $nr_file | xargs touch
> > > > +		popd >/dev/null
> > > > +	fi
> > > >  }
> > > >  
> > > >  # get standard environment, filters and checks
> > > > @@ -61,6 +64,9 @@ _supported_fs ext4 ext3 ext2 xfs
> > > >  _supported_os Linux
> > > >  
> > > >  _require_scratch
> > > > +_require_test_program "feature"
> > > > +
> > > > +ncpus=`$here/src/feature -o`
> > > >  
> > > >  rm -f $seqres.full
> > > >  echo "Silence is golden"
> > > > @@ -68,19 +74,27 @@ echo "Silence is golden"
> > > >  _scratch_mkfs_sized $((1024 * 1024 * 1024)) >>$seqres.full 2>&1
> > > >  _scratch_mount
> > > >  
> > > > -i=0
> > > >  free_inode=`_get_free_inode $SCRATCH_MNT`
> > > >  file_per_dir=1000
> > > > -loop=$((free_inode / file_per_dir + 1))
> > > > -mkdir -p $SCRATCH_MNT/testdir
> > > > -
> > > > -echo "Create $((loop * file_per_dir)) files in $SCRATCH_MNT/testdir" >>$seqres.full
> > > > -while [ $i -lt $loop ]; do
> > > > -	create_file $SCRATCH_MNT/testdir $file_per_dir $i >>$seqres.full 2>&1 &
> > > > -	let i=$i+1
> > > > +num_dirs=$(( free_inode / (file_per_dir + 1) ))
> > > > +num_threads=$(( ncpus * 2 ))
> > > > +[ $num_threads -gt 20 ] && num_threads=20
> > > 
> > > Only 20 threads?  Not much of a workout for my 40-cpu system. :P
> > 
> > Wow, you have a powerful machine. I think 20 threads is enough to end
> > this case in 1 min, if the test machine really have 20+ CPUs :)
> > 
> > There're some virtual machines has 100+ CPUs, but their performance
> > is really poor. If fork 200+ threads on those VMs, it'll run slowly.
> 
> I can only imagine.  The last time I had a machine with 100+ CPUs it
> actually had 100+ cores.
> 
> > > 
> > > Was also wondering if we wanted to scale by $LOAD_FACTOR here...
> > 
> > Hmm... this case isn't used to test multi-threads load, it test 0%
> > free inodes. So fill free inodes in short enough time is OK I think:)
> > 
> > But maybe I can change it as:
> > num_threads=$(( ncpus * (1 + LOAD_FACTOR) ))
> > [ $num_threads -gt 20 ] && num_threads=$((10 * (1 + LOAD_FACTOR) ))
> > 
> > Then if you have 40 CPUs, you can set LOAD_FACTOR=7 or bigger. That
> > gives you a chance to break the 20 limit. What do you think? 
> 
> Hrmm.  Now I'm have second thoughts; num_threads=$((nr_cpus * 2)) is
> enough, but without the [ $num_threads -gt 20 ] check.

Please check below xfstests-dev commit:
eea42b9 generic/072: limit max cpu number to 8

We really have some poor performance VMs have 100+ CPUs. Maybe
someone real machine has 100+ CPU, then someone built lots
of VMs with 100+ vmCPUs.

Thanks,
Zorro

> 
> --D
> 
> > 
> > Thanks,
> > Zorro
> > 
> > > 
> > > --D
> > > 
> > > > +loop=$(( num_dirs / num_threads ))
> > > > +
> > > > +echo "Create $((loop * num_threads)) dirs and $file_per_dir files per dir in $SCRATCH_MNT" >>$seqres.full
> > > > +for ((i=0; i<ncpus*2; i++)); do
> > > > +	for ((j=0; j<$loop; j++)); do
> > > > +		create_file $SCRATCH_MNT/testdir_$i_$j $file_per_dir
> > > > +	done &
> > > >  done
> > > >  wait
> > > >  
> > > > +free_inode=`_get_free_inode $SCRATCH_MNT`
> > > > +if [ $free_inode -gt 0 ]; then
> > > > +	echo "Create $((free_inode - 1)) files and 1 dir to fill all remaining free inodes" >>$seqres.full
> > > > +	create_file $SCRATCH_MNT/testdir_$i_$j $((free_inode - 1))
> > > > +fi
> > > > +
> > > >  # log inode status in $seqres.full for debug purpose
> > > >  echo "Inode status after taking all inodes" >>$seqres.full
> > > >  $DF_PROG -i $SCRATCH_MNT >>$seqres.full
> > > > -- 
> > > > 2.7.4
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
