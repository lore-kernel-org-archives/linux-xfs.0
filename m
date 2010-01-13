Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0D64VHP125104 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 00:04:31 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18CD61C49DFF
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 22:05:25 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id xTYWGKVxApoOjPBW for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2010 22:05:25 -0800 (PST)
Date: Wed, 13 Jan 2010 17:05:18 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <99724068.1731191263362718752.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20100113054152.GL17483@discord.disaster>
Subject: Re: [TuxOnIce-devel] Latest updates.
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: TuxOnIce Devel List <tuxonice-devel@lists.tuxonice.net>, xfs@oss.sgi.com

[Looks like tuxonice is a subscriber-only list...]

----- "Dave Chinner" <david@fromorbit.com> wrote:

> On Wed, Jan 13, 2010 at 02:09:14PM +1100, Nathan Scott wrote:
> > > 
> Agreed that it is trivial to implement but there are still some
> definite traps - like the fact the sb change transaction may be
> logged
> immediately but the physical superblock may not get written for some
> time after the mount.

*nod* ... it will be written when unmounted though...

> 
> Really it comes down to the interface used to read the mount time
> fromt eh superblock at suspend and resume - can anyone tell me what
> that is or point me at the code?

(not me!)

> Personally I don't see why this needs to be in the superblock - an
> extended attribute on the root directory of the root filesystem that
> is written:

Yeah, that was my first thought too, but I suspect they want to be
able to query this when the filesystem is unmounted; in which case
the interface is probably "read a fs-specific magic spot ondisk".
For this not-mounted query, the EA route would be incredibly painful.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
