Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 159157F8B
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2014 23:53:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA09530407F
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2014 21:53:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kPZx4QuCMtJyfqiS for
	<xfs@oss.sgi.com>; Wed, 19 Mar 2014 21:53:52 -0700 (PDT)
Date: Thu, 20 Mar 2014 12:53:47 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] shared: new test to use up free inodes
Message-ID: <20140320045347.GZ8312@dhcp-13-216.nay.redhat.com>
References: <1395221269-11085-1-git-send-email-eguan@redhat.com>
	<20140320001429.GI7072@dastard>
	<20140320040525.GX8312@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140320040525.GX8312@dhcp-13-216.nay.redhat.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 20, 2014 at 12:05:25PM +0800, Eryu Guan wrote:
> On Thu, Mar 20, 2014 at 11:14:29AM +1100, Dave Chinner wrote:
> > On Wed, Mar 19, 2014 at 05:27:49PM +0800, Eryu Guan wrote:
[snip]
> > 
> > On XFS, that will create at least 500 threads creating 1000 inodes each
> > all in the same directory. This doesn't give you any extra
> > parallelism at all over just creating $free_inode files in a single
> > directory with a single thread. Indeed, it will probably be slower
> > due to the contention on the directory mutex.
> > 
> > If you want to scale this in terms of parallelism to keep the
> > creation time down, each loop needs to write into a different
> > directory. i.e. something like:
> > 
> > 
> > echo "Create $((loop * 1000)) files in $SCRATCH_MNT/testdir" >>$seqres.full
> > while [ $i -lt $loop ]; do
> > 	mkdir -p $SCRATCH_MNT/testdir/$i
> > 	create_file $SCRATCH_MNT/testdir/$i 1000 $i >>$seqres.full 2>&1 &
> > 	let i=$i+1
> > done
> > wait

It turns out that creating files in different dirs is unable to
reproduce the bug that commit

d586858 xfs_repair: fix sibling pointer tests in verify_dir2_path()

fixed. I'll keep the files in one testdir.

Thanks,
Eryu

> > 
> > And even then I'd suggest that you'd be much better off with 10,000
> > files to a sub-directory....
> 
> Will do.
> 
> > 
> > > +# log inode status in $seqres.full for debug purpose
> > > +echo "Inode status after taking all inodes" >>$seqres.full
> > > +df -i $SCRATCH_MNT >>$seqres.full
> > > +
> > > +_check_scratch_fs
> > > +
> > > +# Check again after removing all the files
> > > +rm -rf $SCRATCH_MNT/testdir
> > 
> > That can be parallelised as well when you have multiple subdirs:
> > 
> > for d in $SCRATCH_MNT/testdir/*; do
> > 	rm -rf $d &
> > done
> > wait
> 
> Will do.
> 
> Thanks for the detailed review (as always)!
> 
> Eryu
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
