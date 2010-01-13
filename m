Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0D5f1oS121186 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 23:41:01 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B462A160DB1
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 21:41:55 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	Bki03FOfwbPuJEP6 for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2010 21:41:55 -0800 (PST)
Date: Wed, 13 Jan 2010 16:41:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [TuxOnIce-devel] Latest updates.
Message-ID: <20100113054152.GL17483@discord.disaster>
References: <2097834991.1721031263351861134.JavaMail.root@mail-au.aconex.com>
	<643097034.1721341263352154340.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <643097034.1721341263352154340.JavaMail.root@mail-au.aconex.com>
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
To: Nathan Scott <nscott@aconex.com>
Cc: TuxOnIce Devel List <tuxonice-devel@lists.tuxonice.net>, xfs@oss.sgi.com

On Wed, Jan 13, 2010 at 02:09:14PM +1100, Nathan Scott wrote:
> 
> ----- "Martin Steigerwald" <Martin@lichtvoll.de> wrote:
> 
> > Please keep CC to TuxOnIce devel list.
> > 
> > 
> > Hi!
> > 
> > Nigel, who develops the alternative TuxOnIce hibernation / snapshot 
> > infrastructure, implemented checking last mount time of filesystem as
> > a 
> > safety feature for Ext 2, 3 and 4.
> > 
> > He would like this also for XFS. Does XFS record the last mount time 
> > somewhere?
> 
> Nope.
> 
> > If not, could this be added?
> 
> Anythings possible ... its a relatively trivial change, and there's room
> in the superblock.  Could probably even be done without a superblock version
> bump - if you were prepared to live with the possibility of finding zero in
> the ondisk location & dealing with it appropriately (i.e. last mount time
> unknown).
> 
> Guess you'd have to convince the XFS folks doing most of the work these
> days, but really it'd be quite trivial to implement.  xfs_mount_log_sb()
> would be the place to start looking...

Agreed that it is trivial to implement but there are still some
definite traps - like the fact the sb change transaction may be logged
immediately but the physical superblock may not get written for some
time after the mount.

Really it comes down to the interface used to read the mount time
fromt eh superblock at suspend and resume - can anyone tell me what
that is or point me at the code?

Personally I don't see why this needs to be in the superblock - an
extended attribute on the root directory of the root filesystem that is
written:

	a) by a startup script at boot time;
	b) by the suspend code;
	c) copied into the suspend image; and
	d) read and verified during resume

seems sufficient to me to provide what you want. This has the
benefit of being completely filesystem independent and doesn't
require on-disk format changes for every filesystem that ppl want
TuxOnIce to supprt.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
