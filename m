Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD3357CA0
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 17:48:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B2B60304059
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 15:48:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1p5dKjJxmt2salFI for <xfs@oss.sgi.com>;
	Mon, 11 Apr 2016 15:48:28 -0700 (PDT)
Date: Tue, 12 Apr 2016 08:47:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
	after disk failure/recovery
Message-ID: <20160411224755.GC9088@dastard>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<232dd85fde11d4ef1625f070eabfd167@mail.gmail.com>
	<20160408224648.GD567@dastard>
	<CAOcd+r0s3FfahxaqfJKuZ_D+0FbUHaKqi8b_bwGbXekCN3w_oQ@mail.gmail.com>
	<20160411012127.GF567@dastard>
	<1aa4e955d78e6932260fdfc55c83bb8e@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1aa4e955d78e6932260fdfc55c83bb8e@mail.gmail.com>
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
To: Shyam Kaushik <shyam@zadarastorage.com>
Cc: Brian Foster <bfoster@redhat.com>, Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Mon, Apr 11, 2016 at 08:22:14PM +0530, Shyam Kaushik wrote:
> Hi Dave,
> 
> Do you plan to post a patch for the bug you discovered in xfs_iflush() to
> goto abort_out when xfs_imap_to_bp() fails?

I'll get to it, but I can't do everything for everyone at once.

There is enough information in this thread that it shoul dbe
straight forward to write the two line patch to jump to the correct
error handling code, so the fact I haven't written the trivial
change yet should not be holding anyone up...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
