Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4019D7F88
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 19:45:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2F128304062
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 17:45:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vsZ3MbeenD6TMUsn for <xfs@oss.sgi.com>;
	Tue, 30 Sep 2014 17:45:19 -0700 (PDT)
Date: Wed, 1 Oct 2014 10:45:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Happened again, 20140930 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
Message-ID: <20141001004514.GH24490@dastard>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<alpine.LSU.2.11.1410010001350.17407@minas-tirith.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1410010001350.17407@minas-tirith.valinor>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Wed, Oct 01, 2014 at 12:27:20AM +0200, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> 
> 
> >Subject: Subject : Happened again,
> >    20140811 -- Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
> >     reformatting to correct issue.
> >Date: Mon, 11 Aug 2014 16:23:01 +0200 (CEST)
> 
> >Happened again, I'm on middle of recovery procedures, and using my laptop
> >to post.
> 
> And again.

We've already got the fix in our upstream repository:

8018ec0 xfs: mark all internal workqueues as freezable

It's currently in linux-next, queued for the next merge window. You
shoul dprobably talk to your distro about getting it backported.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
