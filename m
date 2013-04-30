Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B0D1A7F54
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 17:16:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 50EA9AC002
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 15:16:32 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gG5UUyhk1BBEvMC0 for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 15:16:27 -0700 (PDT)
Date: Wed, 1 May 2013 08:16:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: Remote attr validation fixes and optimisations
Message-ID: <20130430221624.GG10481@dastard>
References: <1367321976-18268-1-git-send-email-david@fromorbit.com>
	<1367321976-18268-4-git-send-email-david@fromorbit.com>
	<20130430213109.GL29359@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130430213109.GL29359@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 30, 2013 at 04:31:09PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Tue, Apr 30, 2013 at 09:39:35PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > - optimise the calcuation for the number of blocks in a remote
> >   xattr.
> > - check attribute length against MAX_XATTR_SIZE, not MAXPATHLEN
> > - whitespace fixes
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
>   Signed-off-by:
> 
> I guess this is what you intended?

Er, yeah. Wrong vim paste macro....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
