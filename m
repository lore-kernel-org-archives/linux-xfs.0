Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CBD0C7F81
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 22:50:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA7B0304039
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 20:50:41 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RDCqVXd7q6IKpBEl for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 20:50:40 -0800 (PST)
Date: Tue, 26 Feb 2013 15:50:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: FYI: better workaround for updating 'df' info after 'rm' on
	xfs-vols
Message-ID: <20130226045038.GN5551@dastard>
References: <512C12B5.3070908@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <512C12B5.3070908@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 25, 2013 at 05:41:09PM -0800, Linda Walsh wrote:
> Some time ago I reported that after I deleted
> some large amount of space from one of my xfs volumes,
> 'df' still showed the original, pre-delete space, though
> 'du' only showed the expected amount.

Sure, because unlinked files might not have their second phase of
processing (which releases the disk space) done immediately.

> Mentioned that I had tried 'sync' to no avail, and had
> only found umount/mount to cause the figures to synchronize.

sync doesn't cause unlinked inodes to be reclaimed and processed,
unlike remount,ro, unmount or freeze.

> Someone suggested cat [1|3] >/proc/sys/vm/drop_caches.

echo, not cat. It does work every time, whether you see anything
obvious or not. And if you want to reclaim inodes, then you want
"echo 2 > ..."

> seemed to do the trick and cause the disk space to update without
> me having to stop processes with FD's open on the vol.

freeze/thaw should do what you want without affecting anything
running on the fs at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
