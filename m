Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 74D6429E30
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 17:01:37 -0600 (CST)
Date: Wed, 6 Nov 2013 17:01:33 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/5] xfs: more patches for 3.13
Message-ID: <20131106230133.GX1935@sgi.com>
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383280040-21979-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 01, 2013 at 03:27:15PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> The following series follows up the recently committed series of
> patches for 3.13. The first two patches are the remaining
> uncommitted patches from the previous series.
> 
> The next two patches are tracing patches, one for AIL manipulations
> and the other for AGF and AGI read operations. Both of these were
> written during recent debugging sessions, and both proved useful so
> should be added to the menagerie of tracepoints we already have
> avaialble.
> 
> The final patch is the increasing of the inode cluster size for v5
> filesystems. I'd like to get this into v5 filesystems for 3.13 so we
> get wider exposure of it ASAP so we have more data available to be
> able to make informed decisions about how to bring this back to v4
> filesystems in a safe and controlled manner.

Applied 3 and 4.  I still don't understand why the locking on patch 2 is
correct.  Seems like the readers of i_version hold different locks than we do
when we log the inode.  Maybe Christoph can help me with that.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
