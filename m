Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o743wM00007808 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 22:58:22 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E45874923D6
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 20:58:40 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	acK11QgAOjWXmtMG for <xfs@oss.sgi.com>;
	Tue, 03 Aug 2010 20:58:40 -0700 (PDT)
Date: Wed, 4 Aug 2010 13:58:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dio: track and serialise unaligned direct IO
Message-ID: <20100804035834.GV7362@dastard>
References: <1280443516-14448-1-git-send-email-david@fromorbit.com>
	<1280880678.2334.27.camel@mingming-laptop>
	<20100804033718.GU7362@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100804033718.GU7362@dastard>
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
To: Mingming Cao <cmm@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, sandeen@sandeen.net, xfs@oss.sgi.com

On Wed, Aug 04, 2010 at 01:37:18PM +1000, Dave Chinner wrote:
> On Tue, Aug 03, 2010 at 05:11:18PM -0700, Mingming Cao wrote:
> > On Fri, 2010-07-30 at 08:45 +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > If we get two unaligned direct IO's to the same filesystem block
> > > that is marked as a new allocation (i.e. buffer_new), then both IOs will
> > > zero the portion of the block they are not writing data to. As a
> > > result, when the IOs complete there will be a portion of the block
> > > that contains zeros from the last IO to complete rather than the
> > > data that should be there.
> > > 
> > > This is easily manifested by qemu using aio+dio with an unaligned
> > > guest filesystem - every IO is unaligned and fileystem corruption is
> > > encountered in the guest filesystem. xfstest 240 (from Eric Sandeen)
> > > is also a simple reproducer.
> > > 
> > > To avoid this problem, track unaligned IO that triggers sub-block zeroing and
> > > check new incoming unaligned IO that require sub-block zeroing against that
> > > list. If we get an overlap where the start and end of unaligned IOs hit the
> > > same filesystem block, then we need to block the incoming IOs until the IO that
> > > is zeroing the block completes. The blocked IO can then continue without
> > > needing to do any zeroing and hence won't overwrite valid data with zeros.
> > > 
> > 
> > This seems to address both two IOs are unaligned direct IO. If the first
> > IO is aligned direct IO, then it is not tracked?
> > 
> > I am also concerned about the aligned direct IO case...
> > 
> > 1) first thread aio+dio+aligned write to a hole, there is no zero-out
> > submitted from kernel. But the hole remains initialized before all IO
> > complete and convert it from uninitialized extent to initialized.
> > 2) second thread aio+dio+unalign write to the same hole, this time it is
> > unaligned. since buffer is still new (not converted yet), the new
> > incoming thread zero out port of data that first thread has written to
> 
> That is clearly and unmistakably an application bug - it should not
> be issuing concurrent, overlapping IO to the same block(s)
> regardless of whether they are unaligned, aligned or a mixture of
> both. By using direct IO, the application has assumed responsibility
> for preventing data corruption due to overlapping IOs - they are
> inherently racy and nothing in the dio code prevents that from
> occurring.
> 
> The bug I'm fixing is for *non-overlapping* concurrent unaligned IOs
> where the kernel direct IO code causes the data corruption, not the
> application. The application is not doing something stupid, and as
> such needs to be fixed.
   ^^^^^^
   the kernel bug needs to be fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
