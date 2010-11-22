Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAMN5uwK122884 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 17:05:56 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD03613E1A4B
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 15:07:31 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	hGBapbuCKtVpZqs5 for <xfs@oss.sgi.com>;
	Mon, 22 Nov 2010 15:07:31 -0800 (PST)
Date: Tue, 23 Nov 2010 10:07:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Is xfs defrag *reliably* aligned to stripes?
Message-ID: <20101122230728.GI13830@dastard>
References: <4CEAC203.9040800@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CEAC203.9040800@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: xfs@oss.sgi.com

On Mon, Nov 22, 2010 at 08:18:27PM +0100, Spelic wrote:
> Hello xfs people,
> 
> does the xfs defrag (xfs_fsr, I think) reliably aligns files to stripes?

No, the allocator does best effort attempts only.

> Does it do that? Will it do that in the future?

If the filesystem has large enough contiguous free space extents, it
will align the initial allocation to stripe unit, but once you age
the filesystem there is no guarantee this will be possible. use
"xfs_bmap -vvp" to look at the alignment of files.

Of course, this all only works if you mkfs your filesystem with
sunit/swidth or su/sw parameters....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
