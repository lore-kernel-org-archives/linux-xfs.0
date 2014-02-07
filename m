Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 30F1D7F51
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 22:42:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B2A35AC001
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 20:41:59 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0CcM6LXyt8guTwZj for <xfs@oss.sgi.com>;
	Thu, 06 Feb 2014 20:41:57 -0800 (PST)
Date: Fri, 7 Feb 2014 15:41:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] Btrfs: add regression test for running snapshot and
	send concurrently
Message-ID: <20140207044153.GF13647@dastard>
References: <1391703008-2322-1-git-send-email-wangshilong1991@gmail.com>
	<20140206224337.GB13647@dastard>
	<D32F9438-DA80-41AF-9247-A81E6EC90497@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <D32F9438-DA80-41AF-9247-A81E6EC90497@gmail.com>
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
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Feb 07, 2014 at 12:18:31PM +0800, Wang Shilong wrote:
> 
> Hi Dave,
> 
> > On Fri, Feb 07, 2014 at 12:10:08AM +0800, Wang Shilong wrote:
> >> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
> >> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1
> >> +
> >> +do_snapshots &
> >> +snapshots_pid=$!
> >> +
> >> +$BTRFS_UTIL_PROG send $SCRATCH_MNT/snap_1 > /dev/null 2>&1 || echo "btrfs send failed"
> > 
> > Let's stop this anti-pattern before it takes hold.
> > 
> > If there's output from the send command it should be
> > filtered and captured in the golden image. Hence any deviation
> > caused by errors is automatically flagged as an error.
> > 
> > That's the whole point of using golden images for capturing errors -
> > you don't need to capture return values from binaries and it
> > guarantees that users are informed about failures through error
> > messages. IOWs:
> > 
> > $BTRFS_UTIL_PROG send $SCRATCH_MNT/snap_1 | _btrfs_send_filter
> > 
> > is what you should be doing here.
> 
> I knew what you mean here, in fact, i did this on purpose.

Ok, then you need to explain why you did it on purpose with a comment.
It's just as important to explain the reason for doing something in
test code as it is in the kernel code. i.e. so when we are looking
at the test in 5 years time we know the reason for it being that
way.

> for this test failure, btrfs-prog did not output failure
> information from the beginning. 

I have nothing good to say about that state of affairs, but...

> So to make older progs can also
> detect the test failure, i dropped into this way.

.. it's going to have to stay like it. Please insert an
appropriately sarcastic comment about the usefulness of a silent
send command here, because if I write it I'm going to offend lots of
people. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
