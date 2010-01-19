Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J1JTWg145256 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 19:19:29 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC95811F8B0B
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 17:08:06 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	hSBweH7FC0PosJlF for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 17:08:06 -0800 (PST)
Date: Tue, 19 Jan 2010 12:08:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsteststs: get fsstress DIO working on non-xfs
	filesystems
Message-ID: <20100119010803.GL7264@discord.disaster>
References: <4B54C8AB.6080607@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B54C8AB.6080607@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jan 18, 2010 at 02:46:35PM -0600, Eric Sandeen wrote:
> Pretty sure all DIO IO fails in fsstress today since XFS_IOC_DIOINFO
> fails.  If so, rather than just bailing out on the op, assign
> some sane default DIO parameters.
> 
> This falls down for 4k sector devices but not really sure how to get
> the underlying sector size easily from here; I think we can live
> with this for now.

ioctl(fd, BLKSSZGET, ...) perhaps? And then if that fails, just hard
code it?

> hch suggested moving XFS_IOC_DIOINFO up higher in the vfs, that's
> probably a good idea in the long run.

Yeah, that makes sense to do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
