Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8RG5VH9194146 for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 11:05:31 -0500
Subject: Re: [PATCH 12/16] xfs: implement batched inode lookups for AG walking
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100924091522.GT2614@dastard>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-13-git-send-email-david@fromorbit.com>
	<1285262225.1973.60.camel@doink>  <20100924091522.GT2614@dastard>
Date: Mon, 27 Sep 2010 11:05:04 -0500
Message-ID: <1285603504.2380.14.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Fri, 2010-09-24 at 19:15 +1000, Dave Chinner wrote:
> On Thu, Sep 23, 2010 at 12:17:05PM -0500, Alex Elder wrote:
> > On Wed, 2010-09-22 at 16:44 +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > With the reclaim code separated from the generic walking code, it is
> > > simple to implement batched lookups for the generic walk code.

. . .

> > The gang lookup should never return
> > anything beyond the end of the AG.  It seems
> > like you ought to be able to detect when you've
> > covered all the whole AG elsewhere,
> 
> AFAICT, there are only two ways - the gang lookup returns nothing,
> or we see the last valid inode number in the AG. If you can come up
> with something that doesn't invlove a tree or inode number lookup,
> I'm all ears....

I didn't have anything specific in mind and was basing
this somewhat on gut feeling so you probably have the
best solution as-is.  But I'll look at your new code
and if I come up with any bright ideas I'll let you
know.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
