Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 71A347F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 16:09:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1DB66AC001
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 14:08:57 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vbDk9y7knBrfnvoh for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 14:08:56 -0800 (PST)
Date: Tue, 24 Feb 2015 09:08:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] xfsprogs: a couple metadump fixes and sb logging
	backports
Message-ID: <20150223220854.GW4251@dastard>
References: <1424706709-21594-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424706709-21594-1-git-send-email-bfoster@redhat.com>
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

On Mon, Feb 23, 2015 at 10:51:45AM -0500, Brian Foster wrote:
> Hi all,
> 
> Patches 1 and 2 are a couple metadump fixes that fell out from playing
> around with large block size filesystems (e.g., 64k on ppc64), similar
> to the repair patches I had sent recently. Patches 3 and 4 are backports
> of a couple of the sb logging rework fixes.

I'll pull the fixes into the current branch - we've probably got
enough fixes queued up now to justify a 3.2.3 release.

> Dave,
> 
> I'm not sure what the workflow here is wrt to the sb logging backports.
> FWIW, these are the only patches I need on top of the libxfs-3.19-update
> branch to get most of the sparse inode bits to backport cleanly. Do you
> want to include them in that branch? Otherwise, I'll just keep them in
> my sparse inodes branch for now.

What needs to happen is a full sync up to 4.0-rc1 - the libxfs
kernel side is a moving target. Hopefully that's not a huge amount
of work right now - I'll see if I can get it done by the end of the
week.

But, really, the biggest roadblock right now is getting some review
of the major updates and build changes that are in that branch so
we can move it towards a 3.3. release sooner rather than later.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
