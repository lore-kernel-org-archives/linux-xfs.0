Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67MNrwC197729 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 17:23:53 -0500
Received: from a.mail.sonic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D086E8B5ED
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 15:23:51 -0700 (PDT)
Received: from a.mail.sonic.net (a.mail.sonic.net [64.142.16.245]) by
	cuda.sgi.com with ESMTP id oU7dR8ZfBdA8y7j4 for
	<xfs@oss.sgi.com>; Thu, 07 Jul 2011 15:23:51 -0700 (PDT)
Date: Thu, 7 Jul 2011 15:23:50 -0700
From: Keith Keller <kkeller@sonic.net>
Subject: Re: xfs_growfs doesn't resize
Message-ID: <20110707222350.GA776@sonic.net>
References: <20110707182532.GA31319@sonic.net> <4E160A34.20902@sandeen.net>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E160A34.20902@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Thu, Jul 07, 2011 at 02:34:12PM -0500, Eric Sandeen wrote:
> 
> It seems like you need an "exit strategy" - you probably cannot leave
> your fs mounted -forever- ...

Yes, of course.  I didn't mean to imply that I'd leave it like this
indefinitely.  :)

I will be on vacation next week, and it's not really reschedulable.  So
my plan was to ride the filesystem through next week, hope for the best,
then fix it when I return, rather than attempt to start a fix now and
risk ending up with a broken filesystem.  Ideally I would preemptively
switch to a warm backup before I leave, but that won't be ready in time.
(I currently do have all the important data backed up, but it is to
various different spaces where I had free disk space.  The warm backup
should be ready early next week if the filesystem does go belly-up
before I return.)

> If it were me, if possible, I'd make backups of the fs as it's mounted
> now, then umount it and make an xfs_metadump of it, restore that metadump
> to a new sparse file, and point xfs_repair at that metadata image file,
> to see what repair might do with it.
>
> If repair eats it alive, then we can look into more xfs_db type surgery
> to fix things up more nicely...

This sounds like a reasonable plan.  It looks like xfs_metadump needs a
umounted or readonly filesystem in order to work properly; is there any
way to estimate how long such a dump would take, and how large it would
be from an almost-full 11TB fs with however many inodes it has (~19 million
IIRC)?  I want to plan downtime and usable disk space accordingly.

Would xfs_metadump create the same dump from a filesystem remounted ro
as from a filesystem not mounted?  I think you suggested this idea in
an earlier post.  In a very optimistic scenario, I could imagine
remounting the original filesystem ro, taking the metadump, then being
able to remount rw so that I could put it back into service while I
work with the metadump.  Then, once I knew more about the metadump, I
could do an actual umount and fix the filesystem using the information
gathered from the metadump testing.  If they will produce the same
metadump, then it could be a win-win if it's able to successfully
remount rw afterwards; and if it can't, it wasn't any additional effort
or risk to try.

Will xfsprogs 3.1.5 work with the older kernel, and will it make a
better dump than 2.9.4?  I have built xfsprogs from source, but if it
might have problems working with the kmod-xfs kernel module I can use
the 2.9.4 tools instead.  (Again, in keeping with the hope-for-the-best
scenario above, if avoiding a reboot won't be too harmful it'd be
convenient.)

I think you also mentioned that xfs_metadump can not dump frozen
filesystems, but the man page for 3.1.5 says it can.  FWIW xfs_metadump
refused to work on a frozen filesystem on my test machine, which is
version 2.9.4 (though from an older CentOS base).  (xfs_freeze does look
like a nice tool though!)

--keith


-- 
kkeller@sonic.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
