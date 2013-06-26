Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 800187F50
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 10:50:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2BDA2AC003
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 08:50:15 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id RSmnwIOSlNHbmFfY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 08:50:14 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id D6C0B9A0320
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 09:50:13 -0600 (MDT)
Date: Wed, 26 Jun 2013 11:50:11 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [BULK]  Re: [PATCH] xfstests: unmount scratch mnt in test 307
Message-ID: <20130626155011.GN4288@localhost.localdomain>
References: <1367611895-6852-1-git-send-email-jbacik@fusionio.com>
	<51841AC5.3090309@redhat.com> <20130503232721.GA19978@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130503232721.GA19978@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Josef Bacik <JBacik@fusionio.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, May 03, 2013 at 07:27:21PM -0400, Dave Chinner wrote:
> On Fri, May 03, 2013 at 03:15:01PM -0500, Eric Sandeen wrote:
> > On 5/3/13 3:11 PM, Josef Bacik wrote:
> > > So if you have a mount command that doesn't use /etc/mtab then it will spit out
> > > a different device for the mounted device.  So say we have
> > > 
> > > SCRATCH_DEV_POOL="/dev/sda /dev/sdb /dev/sdc"
> > > 
> > > we will turn this into
> > > 
> > > SCRATCH_DEV="/dev/sda"
> > > SCRATCH_DEV_POOL="/dev/sdb /dev/sdc"
> > > 
> > > and then when you mkfs this you do _scratch_mkfs $SCRATCH_DEV_POOL which turns
> > > into this
> > > 
> > > mkfs.btrfs /dev/sdb /dev/sdc /dev/sda
> > > 
> > > becuase we do
> > > 
> > > mkfs $* $SCRATCH_DEV
> > > 
> > > Then btrfs will always show the lowest devid in /proc/mounts to maintain
> > > consistency, so even though we do mount /dev/sda $SCRATCH_MNT, you will see
> > > /dev/sdb as the mounted device in /proc/mounts.  So then say the next test wants
> > > to just use $SCRATCH_DEV, it will do _require_scratchdev which will check to see
> > > if $SCRATCH_DEV is mounted, which it will look like it is not because
> > > /proc/mounts shows /dev/sdb instead of /dev/sda, and so it won't umount
> > > $SCRATCH_MNT, and then that test will fail because we can't mkfs the device
> > > because it is busy.  I reproduced this on a box that doesn't use /etc/mtab by
> > > doing
> > > 
> > > ./check btrfs/307 generic/015
> > > 
> > > and 015 would fail.  With this patch it passes now.  Thanks,
> > > 
> > > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > > ---
> > >  tests/btrfs/307 |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/tests/btrfs/307 b/tests/btrfs/307
> > > index 87314c6..15157b3 100644
> > > --- a/tests/btrfs/307
> > > +++ b/tests/btrfs/307
> > > @@ -35,6 +35,7 @@ _cleanup()
> > >  {
> > >      cd /
> > >      rm -f $tmp.*
> > > +    umount $SCRATCH_MNT
> > >  }
> > >  
> > >  # get standard environment, filters and checks
> > > 
> > 
> > This seems fine for this particular test.
> > 
> > Is it really a hard requirement that each test unmount SCRATCH_[DEV|MNT] if it used it?
> > If so, fine... the README does indicate this.
> > 
> > But I wonder if we can make it a little more foolproof by updating _require_scratch
> > to handle this situation more gracefully?
> 
> It already tries to unmount $SCRATCH_DEV, and will through an error
> if it's not mounted on $SCRATCH_MNT. I guess the opposite checks are
> necessary in this case i.e. check that SCRATCH_MNT is not mounted,
> and through an error if it's not SCRATCH_DEV that is mounted
> there...
> 

Just realized this never went in and I had forgotten to address y'alls comments,
so I've sent another patch that accomplishes what you asked for and fixes my
problem.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
