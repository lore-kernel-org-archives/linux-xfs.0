Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E2077F7B
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 22:32:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2666AC004
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 20:32:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MsSObZ1agBQrsIjO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 20:32:43 -0700 (PDT)
Date: Thu, 31 Jul 2014 11:32:38 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/2] xfs: new case to test inode allocations in
	post-growfs disk space
Message-ID: <20140731033238.GY7382@dhcp-13-216.nay.redhat.com>
References: <1405529554-31225-1-git-send-email-eguan@redhat.com>
	<20140721134638.GA45794@bfoster.bfoster>
	<20140724103658.GB6210@dhcp-13-216.nay.redhat.com>
	<20140724130646.GA37832@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140724130646.GA37832@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>, Eric Sandeen <esandeen@redhat.com>, Boris Ranto <branto@redhat.com>, xfs@oss.sgi.com

On Thu, Jul 24, 2014 at 09:06:47AM -0400, Brian Foster wrote:
> On Thu, Jul 24, 2014 at 06:36:58PM +0800, Eryu Guan wrote:
> > On Mon, Jul 21, 2014 at 09:46:38AM -0400, Brian Foster wrote:
> > > On Thu, Jul 17, 2014 at 12:52:33AM +0800, Eryu Guan wrote:
> > [snip]
> > > > +
> > > > +create_file()
> > > > +{
> > > > +	local dir=$1
> > > > +	local i=0
> > > > +
> > > > +	while echo -n >$dir/testfile_$i; do
> > > > +		let i=$i+1
> > > > +	done
> > > > +}
> > > > +
> > > > +# get standard environment, filters and checks
> > > > +. ./common/rc
> > > > +. ./common/filter
> > > > +
> > > > +# real QA test starts here
> > > > +_supported_fs xfs
> > > > +_supported_os Linux
> > > > +
> > > > +_require_scratch
> > > > +
> > > > +rm -f $seqres.full
> > > > +echo "Silence is golden"
> > > > +
> > > > +_scratch_mkfs_sized $((128 * 1024 * 1024)) | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> > > > +# get original data blocks number
> > > > +. $tmp.mkfs
> > > > +_scratch_mount
> > > > +
> > > 
> > 
> > Hi Brian,
> > 
> > Thanks for the review, and sorry for the late response..
> > 
> > > You could probably even make this smaller and make the test quicker.
> > > E.g., I can create an fs down to 20M or so without any problems.  Also,
> > > setting imaxpct=0 might be a good idea so you don't hit that artificial
> > > limit.
> > 
> > Yes, a smaller fs could make the test much more quicker. I tested with
> > 16M fs and the test time reduced from 70s to ~10s on my test host.
> > 
> 
> That sounds great.
> 
> > But setting imaxpct=0 could increase the total available inode number
> > which could make test run longer. So I tend to use default mkfs
> > options here.
> >
> 
> True... I don't really want to make a big deal out of imaxpct. I think
> the consensus now is that it's a useless relic and will probably be
> removed. That does mean this test will eventually use the full fs space
> by default and we should make sure it runs in a reasonable amount of
> time. FWIW, it seems to in my tests, running in under 2 minutes on a
> single spindle.
> 
> The other issue is that if I set imaxpct=1 in my mkfs options, the test
> passes. Should it? Is it actually testing what it should be in that
> scenario? ;) Note that when imaxpct is set, the 'df -i' information will
> be based on the cap that imaxpct sets. E.g., it will show 100% usage
> even though we've only used a few MB for inodes.

Yes, I can pass the test too with imaxpct=1 set. But I'm not really
sure about imaxpct impact on the test result.

Eric, do you have any suggestions here? Because I saw you send out the
kernel patch to fix this problem :)

Thanks,
Eryu
> 
> Brian
> 
> > > 
> > > > +# Create files to consume free inodes in background
> > > > +(
> > > > +	i=0
> > > > +	while [ $i -lt 1000 ]; do
> > > > +		mkdir $SCRATCH_MNT/testdir_$i
> > > > +		create_file $SCRATCH_MNT/testdir_$i &
> > > > +		let i=$i+1
> > > > +	done
> > > > +) >/dev/null 2>&1 &
> > > > +
> > > > +# Grow fs at the same time, at least x4
> > > > +# doubling or tripling the size couldn't reproduce
> > > > +$XFS_GROWFS_PROG -D $((dblocks * 4)) $SCRATCH_MNT >>$seqres.full
> > > > +
> > > 
> > > Even though this is still relatively small based on what people probably
> > > typically test, we're still making assumptions about the size of the
> > > scratch device. It may be better to create the fs as a file on TEST_DEV.
> > > Then you could do something like truncate to a fixed starting size, mkfs
> > > at ~20MB and just growfs to the full size of the file. A 4x grow at that
> > > point is then still only ~80MB, though hopefully it still doesn't run
> > > too long on slower machines.
> > 
> > I'll use _require_fs_space here as Dave suggested.
> > 
> > > 
> > > > +# Wait for background create_file to hit ENOSPC
> > > > +wait
> > > > +
> > > > +# log inode status in $seqres.full for debug purpose
> > > > +echo "Inode status after growing fs" >>$seqres.full
> > > > +$DF_PROG -i $SCRATCH_MNT >>$seqres.full
> > > > +
> > > > +# Check free inode count, we expect all free inodes are taken
> > > > +free_inode=`_get_free_inode $SCRATCH_MNT`
> > > > +if [ $free_inode -gt 0 ]; then
> > > > +	echo "$free_inode free inodes available, newly added space not being used"
> > > > +else
> > > > +	status=0
> > > > +fi
> > > 
> > > This might not be the best metric either. I believe the free inodes
> > > count that 'df -Ti' returns is a somewhat artificial calculation based
> > > on the number of free blocks available, since we can do dynamic inode
> > > allocation. It doesn't necessarily mean that all blocks can be allocated
> > > to inodes however (e.g., due to alignment or extent length constraints),
> > > so it might never actually read 0 unless the filesystem is perfectly
> > > full.
> > > 
> > > Perhaps consider something like the IUse percentage over a certain
> > > threshold?
> > 
> > I'm not sure about the proper percentage here, I'll try %99. But in my
> > test on RHEL6 the free inode count is always 0 after test.
> > 
> > Will send out v2 soon.
> > 
> > Thanks,
> > Eryu
> > 
> > > 
> > > Brian
> > > 
> > > > +
> > > > +exit
> > > > diff --git a/tests/xfs/015.out b/tests/xfs/015.out
> > > > new file mode 100644
> > > > index 0000000..fee0fcf
> > > > --- /dev/null
> > > > +++ b/tests/xfs/015.out
> > > > @@ -0,0 +1,2 @@
> > > > +QA output created by 015
> > > > +Silence is golden
> > > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > > index d5b50b7..0aab336 100644
> > > > --- a/tests/xfs/group
> > > > +++ b/tests/xfs/group
> > > > @@ -12,6 +12,7 @@
> > > >  012 rw auto quick
> > > >  013 auto metadata stress
> > > >  014 auto enospc quick quota
> > > > +015 auto enospc growfs
> > > >  016 rw auto quick
> > > >  017 mount auto quick stress
> > > >  018 deprecated # log logprint v2log
> > > > -- 
> > > > 1.9.3
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > > _______________________________________________
> > > xfs mailing list
> > > xfs@oss.sgi.com
> > > http://oss.sgi.com/mailman/listinfo/xfs
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
