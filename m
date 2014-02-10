Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3FF247F4E
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 21:33:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DBEDFAC002
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 19:33:28 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vlc9359SUtXos4sl for <xfs@oss.sgi.com>;
	Sun, 09 Feb 2014 19:33:27 -0800 (PST)
Date: Mon, 10 Feb 2014 14:33:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: add helper for verifying checksums on xfs_bufs
Message-ID: <20140210033323.GQ13647@dastard>
References: <52F83630.4020008@redhat.com>
 <52F8399B.3050204@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52F8399B.3050204@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Sun, Feb 09, 2014 at 08:29:47PM -0600, Eric Sandeen wrote:
> Many/most callers of xfs_update_cksum() pass bp->b_addr and
> BBTOB(bp->b_length) as the first 2 args.  Add a helper
> which can just accept the bp and the crc offset, and work
> it out on its own, for brevity.

The title of the patch is the same as the previous one - I think you
forgot to "update" it?

Other than that, same comments as for the previous patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
