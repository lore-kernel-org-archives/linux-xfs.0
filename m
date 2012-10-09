Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99LLmUp107354 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 16:21:48 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MAYKREGoAk4orvL5 for
	<xfs@oss.sgi.com>; Tue, 09 Oct 2012 14:23:19 -0700 (PDT)
Date: Tue, 9 Oct 2012 23:23:13 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] 260: Add another corner case where length is zero
In-Reply-To: <20121009194019.GJ23644@dastard>
Message-ID: <alpine.LFD.2.00.1210092320480.2326@(none)>
References: <1349785012-28588-1-git-send-email-lczerner@redhat.com>
	<20121009194019.GJ23644@dastard>
MIME-Version: 1.0
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
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Wed, 10 Oct 2012, Dave Chinner wrote:

> Date: Wed, 10 Oct 2012 06:40:19 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: xfs@oss.sgi.com
> Subject: Re: [PATCH] 260: Add another corner case where length is zero
> 
> On Tue, Oct 09, 2012 at 02:16:52PM +0200, Lukas Czerner wrote:
> > This commit adds another corner case to test FITRIM argument handling.
> > In this case we set length to zero and we expect the number of discarded
> > bytes to be obviously zero, however we've had bug in both ext4 and xfs
> > where the internal variable would underflow. This test case will be able
> > to catch that in future.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> I'd create another test for this, rather than making 260 suddenly
> fail for everyone....

Hmm, I am not sure what is the point. I've created 260 exactly for
this reason of testing FITRIM argument handling and it already
contains number of tests like this one. I am not strongly against
having this in separate test, however it seems rather unnecessary to
me.

Thanks!
-Lukas

> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
