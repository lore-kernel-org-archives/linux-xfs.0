Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9B2UQ28239780 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 21:30:26 -0500
Date: Wed, 10 Oct 2012 21:31:55 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/14 V5]: xfs: remove the xfssyncd mess
Message-ID: <20121011023155.GX13214@sgi.com>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
	<20121008223921.GS13214@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121008223921.GS13214@sgi.com>
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

Hey Dave,

On Mon, Oct 08, 2012 at 05:39:21PM -0500, Ben Myers wrote:
> On Mon, Oct 08, 2012 at 09:55:58PM +1100, Dave Chinner wrote:
> > Hopefully the final version.
> 
> I am testing this new rev now... My v4 run over the weekend crashed but
> unfortunately I wasn't able to get a stack trace.  We'll see what shakes out.

I'm still not sure what happened with the v4 run I mentioned.  Subsequent
testing has shown this series to be solid with the new changes.  It is ready to
go.

However, pulling this in right now will result in a merge commit from the
upstream tree to ours later in the rc1 merge.  My understanding is that if
Linus were to subsequently pull from our tree, the merge commit would cause
some ugliness in upstream commit history.  See:

http://oss.sgi.com/archives/xfs/2009-04/msg00014.html

I haven't found a way around this, so that's why we're waiting until after the
-rc1 fast-forward to pull this in.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
