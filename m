Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p212siGa170991 for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 20:54:44 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D35C1579DC6
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 18:57:31 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	c9pTugpHn6CsiTHo for <xfs@oss.sgi.com>;
	Mon, 28 Feb 2011 18:57:31 -0800 (PST)
Date: Tue, 1 Mar 2011 13:57:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel panic - stack-protector: kernel stack is corrupted in:
	f87aca93
Message-ID: <20110301025726.GF3087@dastard>
References: <4D6C28A5.60905@mnsu.edu> <4D6C372E.6030105@sandeen.net>
	<4D6C45EE.80203@mnsu.edu> <4D6C4CC5.5030909@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D6C4CC5.5030909@sandeen.net>
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
Cc: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>, xfs@oss.sgi.com

On Mon, Feb 28, 2011 at 07:32:53PM -0600, Eric Sandeen wrote:
> On 2/28/11 7:03 PM, Jeffrey Hundstad wrote:
> > Sadly, I didn't have the vmlinux file around anymore.  I'll be glad to recreate it when I get in tomorrow.  However, I have revered commit 3a3675b7f23f83ca8c67c9c2b6edf707fd28d1ba and the problem seems to have vanished.  I'm guessing the stack at this point is a little to fragile for a memset.  The patch is:
> 
> Ok, no worries, if the below commit is the culprit for sure, that's enough...
> 
> So, whoopsies.
> 
> STATIC int
> xfs_ioc_fsgeometry_v1(
>         xfs_mount_t             *mp,
>         void                    __user *arg)
> {
>         xfs_fsop_geom_v1_t      fsgeo;
>         int                     error;
> 
>         error = xfs_fs_geometry(mp, (xfs_fsop_geom_t *)&fsgeo, 3);
> 
> what we really have is an xfs_fsop_geom_v1_t, but cast to a xfs_fsop_geom_t.
> 
> xfs_fs_geometry() zeroes it out to the tune of sizeof (xfs_fsop_geom_t)
> 
> the latter is bigger, with the addition of
> 
> 	__u32           logsunit;
> 
> so we overwrite memory that's not ours.  :(  Seems like we should zero
> in the callers, when we know how much is really on the stack.  I'll follow
> up with a patch; pity this one was fast-tracked for security, I think :(

Fmeh - the differences in structure size, alignment and padding on
different platforms was why I suggested that memset() is a
preferable fix to just setting a single field. I didn't look any
further at the patch before it was committed so I didn't catch the
fact that it was busted in the first place...

Just another example of Occam's Eraser(*) in action, I'd say.

Cheers,

Dave

(*) From the Fortune Cookie database:

OCCAM'S ERASER:
  The philosophical principle that even the simplest solution is
  bound to have something wrong with it.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
