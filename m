Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o74EtxIp037429 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 09:55:59 -0500
Received: from e9.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B63A493E46
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 07:56:19 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id v2A3GHvZ1FxJJQvn for
	<xfs@oss.sgi.com>; Wed, 04 Aug 2010 07:56:19 -0700 (PDT)
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o74EdFmG020406
	for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 10:39:15 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	o74EuFV7385956 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 10:56:16 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id o74Eu24f028801
	for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 08:56:03 -0600
Subject: Re: [PATCH] dio: track and serialise unaligned direct IO
From: Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <20100804033718.GU7362@dastard>
References: <1280443516-14448-1-git-send-email-david@fromorbit.com>
	<1280880678.2334.27.camel@mingming-laptop>
	<20100804033718.GU7362@dastard>
Date: Wed, 04 Aug 2010 07:55:52 -0700
Message-ID: <1280933752.4676.6.camel@mingming-laptop>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, sandeen@sandeen.net, xfs@oss.sgi.com

On Wed, 2010-08-04 at 13:37 +1000, Dave Chinner wrote:
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

while there are multiple applications running on the same filesystem,
they could possible touching the same files concurrently. How could
applications know there is other apps to change the same file at the
same time?

> The bug I'm fixing is for *non-overlapping* concurrent unaligned IOs
> where the kernel direct IO code causes the data corruption, not the
> application. The application is not doing something stupid, and as
> such needs to be fixed.
> 

For the case I refering to here, it's the kernel direct IO who zero out
the block for 2).  The application did 2) did not do zero-out it self,
but it will result in loose data the application write in 1). It's the
same as what you are trying to fix.


Mingming


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
