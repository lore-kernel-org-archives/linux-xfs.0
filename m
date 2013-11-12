Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EBEB87F5A
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 00:26:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 792E3AC008
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 22:26:23 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qTAMZNwq4ZjhDDZ4 for
	<xfs@oss.sgi.com>; Mon, 11 Nov 2013 22:26:22 -0800 (PST)
Date: Tue, 12 Nov 2013 14:26:15 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 RESEND] xfstests generic/320: heavy rm workload test
Message-ID: <20131112062615.GS8882@dhcp-13-216.nay.redhat.com>
References: <1384229890-30733-1-git-send-email-eguan@redhat.com>
	<20131112050249.GZ6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131112050249.GZ6188@dastard>
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

On Tue, Nov 12, 2013 at 04:02:50PM +1100, Dave Chinner wrote:
> On Tue, Nov 12, 2013 at 12:18:10PM +0800, Eryu Guan wrote:
> > This test is based on generic/273, a regression test for commit
> > 
> > 9a3a5da xfs: check for stale inode before acquiring iflock on push
> > 
> > On unpatched kernel, rm processes would hang.
> ....
> > +threads=50
> > +count=2
> > +fs_size=$((2 * 1024 * 1024 * 1024))
> > +ORIGIN=$SCRATCH_MNT/origin
> > +
> > +threads_set()
> > +{
> > +	cpu_num=`grep -c processor /proc/cpuinfo`
> 
> Please us src/feature for this. See commit:
> 
> 2dcf4a5 xfstests: src/feature.c: print a number of online CPUs
> 
> > +	threads=$(($cpu_num * 50))
> > +	if [ $threads -gt 200 ]
> > +	then
> > +		threads=200
> > +	fi
> > +}
> 
> Didn't we go through this before? Or was that the review that lead
> to the above commit? i.e. to use $LOAD_FACTOR to scale the workload,
> not the number of CPUs....

Sorry, I may miss that part of review, will revise the patch.

> 
> > +
> > +file_create()
> > +{
> > +	i=0
> > +	mkdir $ORIGIN
> > +
> > +	disksize=$(($fs_size / 3))
> > +	num=$(($disksize / $count / $threads / 4096))
> > +	while [ $i -lt $num ]; do
> > +		$XFS_IO_PROG -f -c "pwrite 0 $((4096*count))" $ORIGIN/file_$i >>$seqres.full 2>&1
> 
> Line too long.

Ok, will update.

Thanks for the review!

Eryu
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
