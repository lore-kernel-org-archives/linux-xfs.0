Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9A1uLo2199589 for <xfs@oss.sgi.com>; Sat, 9 Oct 2010 20:56:21 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BDB2D76AB
	for <xfs@oss.sgi.com>; Sat,  9 Oct 2010 18:57:26 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	Eqet3NxT4pWYQ5rs for <xfs@oss.sgi.com>;
	Sat, 09 Oct 2010 18:57:26 -0700 (PDT)
Date: Sun, 10 Oct 2010 12:57:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: Fix some file permission.
Message-ID: <20101010015723.GM4681@dastard>
References: <4CAE483F.1020608@sgi.com>
 <1286660111.5392.6.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1286660111.5392.6.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com, Alain Renaud <arenaud@sgi.com>

On Sat, Oct 09, 2010 at 04:35:11PM -0500, Alex Elder wrote:
> On Thu, 2010-10-07 at 17:22 -0500, Alain Renaud wrote:
> > I notice that some of the test script do not have execute
> > permission. To be consistent I changed the permissions to be 755.
> > Can someone verify that this is valid.
> > 
> > Thanks.
> 
> This looks good to me but I'd like a second opinion,
> to make sure there's no reason any of these should
> be non-executable.

I don't think it matters. Consistency is good, though, and we've
taken patches like this in the past.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
