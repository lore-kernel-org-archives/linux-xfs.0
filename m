Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q870en2H223114 for <xfs@oss.sgi.com>; Thu, 6 Sep 2012 19:40:49 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SAmNIzBxPfGaYVg9 for <xfs@oss.sgi.com>;
	Thu, 06 Sep 2012 17:41:48 -0700 (PDT)
Date: Fri, 7 Sep 2012 10:41:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/13] xfs: rationalise xfs_mount_wq users
Message-ID: <20120907004125.GS15292@dastard>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-4-git-send-email-david@fromorbit.com>
	<504622C1.20201@sgi.com> <20120905043000.GE15292@dastard>
	<504750CB.2090907@sgi.com> <20120906004607.GN15292@dastard>
	<5048BC7F.3060607@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5048BC7F.3060607@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 06, 2012 at 10:08:47AM -0500, Mark Tinguely wrote:
> I misspoke, it is xfs test 179. I hit it doing a "check -g auto".
> 
> My test boxes had CONFIG_XFS_DEBUG=y which may be a factor. The
> test ran fine on a box without the debug enabled and assert as
> soon as I added it back.

It is - the assert doesn't exist on a non-DEBUG kernel, so it won't
fail. ;)

> The buffer with zero b_hold count is the freelist buffer (XAGF)
> for AG0. The buffer is marked STALE, it has already gone through
> the release code, so there is no transaction pointer nor log item
> pointer. The xlog_cil_committed() is being called with the
> XFS_LI_ABORTED flag.

It looks like another case of this problem:

http://oss.sgi.com/archives/xfs/2012-09/msg00021.html

Which appears to be another case of the failure that Eric reported
he was seeing on test 137:

http://oss.sgi.com/archives/xfs/2012-08/msg00019.html
http://oss.sgi.com/archives/xfs/2012-09/msg00017.html

i.e. what appears to be a double free of a buffer during a forced
shutdown. The b_hold assertion that is being hit here is just prior
to doing the second free of a buffer.  Given that Eric's case was
bisected down to the delwri queuing changes, I'd say this is the
same cause of this issue. i.e. unrelated to the patch set that was
posted.

What I can't work out is what reference is going missing, and I
can't reproduce it to be able to debug it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
