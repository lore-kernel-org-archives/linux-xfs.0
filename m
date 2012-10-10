Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9A6qIba233318 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 01:52:19 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IBPJgDhSauUxhHCJ for
	<xfs@oss.sgi.com>; Tue, 09 Oct 2012 23:53:49 -0700 (PDT)
Date: Wed, 10 Oct 2012 08:53:42 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] 260: Add another corner case where length is zero
In-Reply-To: <20121009213913.GQ23644@dastard>
Message-ID: <alpine.LFD.2.00.1210100853100.2326@(none)>
References: <1349785012-28588-1-git-send-email-lczerner@redhat.com>
	<20121009194019.GJ23644@dastard>
	<alpine.LFD.2.00.1210092320480.2326@(none)>
	<20121009213913.GQ23644@dastard>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1105382229-1349852026=:2326"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1105382229-1349852026=:2326
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 10 Oct 2012, Dave Chinner wrote:

> Date: Wed, 10 Oct 2012 08:39:13 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: xfs@oss.sgi.com
> Subject: Re: [PATCH] 260: Add another corner case where length is zero
> 
> On Tue, Oct 09, 2012 at 11:23:13PM +0200, Lukáš Czerner wrote:
> > On Wed, 10 Oct 2012, Dave Chinner wrote:
> > 
> > > Date: Wed, 10 Oct 2012 06:40:19 +1100
> > > From: Dave Chinner <david@fromorbit.com>
> > > To: Lukas Czerner <lczerner@redhat.com>
> > > Cc: xfs@oss.sgi.com
> > > Subject: Re: [PATCH] 260: Add another corner case where length is zero
> > > 
> > > On Tue, Oct 09, 2012 at 02:16:52PM +0200, Lukas Czerner wrote:
> > > > This commit adds another corner case to test FITRIM argument handling.
> > > > In this case we set length to zero and we expect the number of discarded
> > > > bytes to be obviously zero, however we've had bug in both ext4 and xfs
> > > > where the internal variable would underflow. This test case will be able
> > > > to catch that in future.
> > > > 
> > > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > 
> > > I'd create another test for this, rather than making 260 suddenly
> > > fail for everyone....
> > 
> > Hmm, I am not sure what is the point. I've created 260 exactly for
> > this reason of testing FITRIM argument handling and it already
> > contains number of tests like this one. I am not strongly against
> > having this in separate test, however it seems rather unnecessary to
> > me.
> 
> IT's a regression test - it's only supposed to start failing when
> the kernel functionality is broken.  That is, someone who is
> tracking failures over time will suddenly see a new failure in 260
> and wonder what kernel code broke, when in fact nothing was changed
> in the kernel code. IOWs, changing the test invalidates all past
> history of running the test, and that in turn breaks historic
> regression tracking metrics...
> 
> This is why we historically have avoided changing existing tests and
> instead wrote new tests, no matter how similar the functionality
> between the old and new tests are.
> 
> Cheers,
> 
> Dave.
> 

Fair enough. I'll create a separate test for this.

Thanks!
-Lukas

--8323328-1105382229-1349852026=:2326
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-1105382229-1349852026=:2326--
