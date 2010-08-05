Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7512cGP055067 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 20:02:39 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14EF7496305
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 18:02:57 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	gnggZeO5m86apioB for <xfs@oss.sgi.com>;
	Wed, 04 Aug 2010 18:02:57 -0700 (PDT)
Date: Thu, 5 Aug 2010 11:02:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dio: track and serialise unaligned direct IO
Message-ID: <20100805010242.GA7362@dastard>
References: <1280443516-14448-1-git-send-email-david@fromorbit.com>
	<1280880678.2334.27.camel@mingming-laptop>
	<20100804033718.GU7362@dastard>
	<1280933752.4676.6.camel@mingming-laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280933752.4676.6.camel@mingming-laptop>
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

On Wed, Aug 04, 2010 at 07:55:52AM -0700, Mingming Cao wrote:
> On Wed, 2010-08-04 at 13:37 +1000, Dave Chinner wrote:
> > On Tue, Aug 03, 2010 at 05:11:18PM -0700, Mingming Cao wrote:
> > > This seems to address both two IOs are unaligned direct IO. If the first
> > > IO is aligned direct IO, then it is not tracked?
> > > 
> > > I am also concerned about the aligned direct IO case...
> > > 
> > > 1) first thread aio+dio+aligned write to a hole, there is no zero-out
> > > submitted from kernel. But the hole remains initialized before all IO
> > > complete and convert it from uninitialized extent to initialized.
> > > 2) second thread aio+dio+unalign write to the same hole, this time it is
> > > unaligned. since buffer is still new (not converted yet), the new
> > > incoming thread zero out port of data that first thread has written to
> > 
> > That is clearly and unmistakably an application bug - it should not
> > be issuing concurrent, overlapping IO to the same block(s)
> > regardless of whether they are unaligned, aligned or a mixture of
> > both. By using direct IO, the application has assumed responsibility
> > for preventing data corruption due to overlapping IOs - they are
> > inherently racy and nothing in the dio code prevents that from
> > occurring.
> 
> while there are multiple applications running on the same filesystem,
> they could possible touching the same files concurrently. How could
> applications know there is other apps to change the same file at the
> same time?

That's for the applications to figure out.  A typical way of
acheiving serialisation at application level is for all the
applications doing dio to the same files is to use byte-range
locking...

Remember, DIO abdicates all responsibility for IO coherency to the
applications. If userspace is issuing concurrent direct IOs to the
same block _no matter how_, then that is an application problem, not
a kernel problem.

If you want the kernel to avoid overlapping DIO, then we have to
track _every single DIO_. We clearly do not do that, have never done
that, and no OS that implements direct IO has ever done that. It is,
quite simply, not the responsibility of the kernel to prevent
userspace from doing stupid stuff with DIO and it never has been.
If you want POSIX IO coherency semantics, then *don't use DIO*.

> > The bug I'm fixing is for *non-overlapping* concurrent unaligned IOs
> > where the kernel direct IO code causes the data corruption, not the
> > application. The application is not doing something stupid, and as
> > such needs to be fixed.
> 
> For the case I refering to here, it's the kernel direct IO who zero out
> the block for 2).  The application did 2) did not do zero-out it self,
> but it will result in loose data the application write in 1). It's the
> same as what you are trying to fix.

No it isn't. Overlapping vs non-overlapping DIO are two very different
cases.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
