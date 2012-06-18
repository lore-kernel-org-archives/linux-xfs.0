Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5IL6lW7240465 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 16:06:48 -0500
Date: Mon, 18 Jun 2012 16:07:13 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/9] xfs: convert internal buffer functions to pass maps
Message-ID: <20120618210713.GY4721@sgi.com>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-3-git-send-email-david@fromorbit.com>
	<20120618204325.GX4721@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120618204325.GX4721@sgi.com>
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

On Mon, Jun 18, 2012 at 03:43:25PM -0500, Ben Myers wrote:
> On Fri, Jun 08, 2012 at 03:38:27PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > While the external interface currently uses separate blockno/length
> > variables, we need to move internal interfaces to passing and
> > parsing vector maps. This will then allow us to add external
> > interfaces to support discontiguous buffer maps as the internal code
> > will already support them.
> 
> This also doesn't apply.  Do you have some additional patches onto which these
> need to be applied?

Ah.. it's Christoph's inode allocator refactoring.  Ok then.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
