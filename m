Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5E1R6qV013123 for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 20:27:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C3AA1BDA31A
	for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 18:29:40 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	jCvHy3O6EqwW6mFh for <xfs@oss.sgi.com>;
	Sun, 13 Jun 2010 18:29:40 -0700 (PDT)
Date: Mon, 14 Jun 2010 11:29:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100614012933.GB6590@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<20100524011907.GC12087@dastard>
	<AANLkTinyt6V9phjXrzrxm67THdRwTiN6pOim3uBUbo1Z@mail.gmail.com>
	<20100613224752.GA2069@dastard>
	<AANLkTikA2d44tZF1TWZAjCqXkhsw0mzsAIaeCosZLqVq@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTikA2d44tZF1TWZAjCqXkhsw0mzsAIaeCosZLqVq@mail.gmail.com>
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
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Roman Kononov <roman@binarylife.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jun 13, 2010 at 07:10:30PM -0400, Ilia Mirkin wrote:
> On Sun, Jun 13, 2010 at 6:47 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sat, Jun 12, 2010 at 01:00:52AM -0400, Ilia Mirkin wrote:
> >> Sorry to pick up an old-ish thread, but I have a similar situation:
> >>
> >> On Sun, May 23, 2010 at 9:19 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Sun, May 23, 2010 at 09:23:44AM -0500, Roman Kononov wrote:
> >> >> On 2010-05-23, 20:18:56 +1000, Dave Chinner <david@fromorbit.com> wrote:
> >> >> > Can you find out what the application is triggering this?
> >>
> >> I noticed this happening with mysql and xtrabackup -- the latter opens
> >> up mysql's files while mysql is still running (and modifying its own
> >> files) and backs them up in a (hopefully) safe way.
> >
> > That's not safe at all - there's no guarantee you'll end up with a
> > consistent database image doing backups like this. Have you ever
> > tried to restore and use one of these backups?
> 
> Yep, works great. [Used it to initialize a slave, did the full
> checksums, so it's unlikely to have randomly corrupt data.]

You were lucky, I'd say.  xtrabackup is supposed to be tightly
integrated with mysql, so perhaps it should be using the same IO
methods that the admin has selected for their database. Maybe you
need to talk to the xtrabackup folks to get them to add a "backup
via direct IO" method if the mysql database is using direct IO so
that other uses don't have the same issues.

> >> Would it be safe to remove the warning at
> >> fs/xfs/linux-2.6/xfs_lrw.c:651 (which looks like it has moved to
> >> xfs_file.c in 2.6.34)? It seems undesirable to get a long stream of
> >> these (51 in this particular instance) every time we run a backup...
> >
> > You can if you want, but then you won't know when your backup or
> > database might have been corrupted, right?
> 
> No, but I wouldn't know that without the warnings either -- for all I
> know xtrabackup could be buggy in all kinds of ways. The only real way
> to check is to use the backup data in some way.

Yup, but you still can't rely on the backup for disaster recovery
without first doing a full application level consistency check it if
one of these warnings was generated while it was being taken.

> >> IOW, is the warning purely something along the lines of "Userspace is
> >> doing something wonky, but the underlying FS will still be fine no
> >> matter what" kind of deal, or could there be an actual problem with
> >> the XFS metadata itself?
> >
> > Nothing wrong with the filesystem metadata will occur - as I said
> > eariler in the thread that this is a warning to tell us that data
> > corruption is possible due to userspace doing something stupid, not
> > a filesystem bug.
> 
> OK, thanks for the clarification. Ideally these wouldn't taint the
> kernel either

Why not? Something has potentially compromised the integrity of the
system and that's exactly what the taint flag is there for.

> -- perhaps these can be downgraded to a message that
> explicitly suggests that nothing is wrong with kernel-space things,
> only user-space? The backtrace doesn't really get you much, so really
> all you want to show is the offending process...

They are there to be meaningful to the XFS developer, not the user,
and it conveys all the information we need to start a deeper
investigation.

IOWs, it's a defensive mechanism that we have in place because
direct IO is effectively handing responsibility for data integrity
to userspace. Hence when userspace is doing something obviously
dangerous to data integrity we want loud, noticable warnings so that
the filesystem is not blamed for the data corruption that will
inevitably occur.

And from a "I read it on the interwebs so it must be true"
perspective, without a loud obnoxious warning we'll never hear about
problems until someone flames us about silent data corruption on a
random blog that gets slashdotted and then referenced for the next
10 years as the next canonical "XFS eats my data!" reference for the
clueless....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
