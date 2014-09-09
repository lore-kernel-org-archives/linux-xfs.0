Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 979E57F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 20:46:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 82FD48F8040
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 18:46:21 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7R1zCsNFeubEoMeN for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 18:46:19 -0700 (PDT)
Date: Tue, 9 Sep 2014 11:46:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: mark all internal workqueues as freezable
Message-ID: <20140909014617.GT30012@dastard>
References: <1408388523-3684-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408388523-3684-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 18, 2014 at 03:02:03PM -0400, Brian Foster wrote:
> Workqueues must be explicitly set as freezable to ensure they are frozen
> in the assocated part of the hibernation/suspend sequence. Freezing of
> workqueues and kernel threads is important to ensure that modifications
> are not made on-disk after the hibernation image has been created.
> Otherwise, the in-memory state can become inconsistent with what is on
> disk and eventually lead to filesystem corruption. We have reports of
> free space btree corruptions that occur immediately after restore from
> hibernate that suggest the xfs-eofblocks workqueue could be causing
> such problems if it races with hibernation.
> 
> Mark all of the internal XFS workqueues as freezable to ensure nothing
> changes on-disk once the freezer infrastructure freezes kernel threads
> and creates the hibernation image.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reported-by: Carlos E. R. <carlos.e.r@opensuse.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
