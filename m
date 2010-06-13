Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5DN7uMP008721 for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 18:07:57 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71D5612ABE63
	for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 16:13:56 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id Sn0iF2qgAAT91Fj0
	for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 16:13:56 -0700 (PDT)
Received: by vws19 with SMTP id 19so94927vws.26
	for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 16:10:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100613224752.GA2069@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<20100524011907.GC12087@dastard>
	<AANLkTinyt6V9phjXrzrxm67THdRwTiN6pOim3uBUbo1Z@mail.gmail.com>
	<20100613224752.GA2069@dastard>
Date: Sun, 13 Jun 2010 19:10:30 -0400
Message-ID: <AANLkTikA2d44tZF1TWZAjCqXkhsw0mzsAIaeCosZLqVq@mail.gmail.com>
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
From: Ilia Mirkin <imirkin@alum.mit.edu>
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
Cc: Roman Kononov <roman@binarylife.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jun 13, 2010 at 6:47 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Jun 12, 2010 at 01:00:52AM -0400, Ilia Mirkin wrote:
>> Sorry to pick up an old-ish thread, but I have a similar situation:
>>
>> On Sun, May 23, 2010 at 9:19 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Sun, May 23, 2010 at 09:23:44AM -0500, Roman Kononov wrote:
>> >> On 2010-05-23, 20:18:56 +1000, Dave Chinner <david@fromorbit.com> wrote:
>> >> > Can you find out what the application is triggering this?
>>
>> I noticed this happening with mysql and xtrabackup -- the latter opens
>> up mysql's files while mysql is still running (and modifying its own
>> files) and backs them up in a (hopefully) safe way.
>
> That's not safe at all - there's no guarantee you'll end up with a
> consistent database image doing backups like this. Have you ever
> tried to restore and use one of these backups?

Yep, works great. [Used it to initialize a slave, did the full
checksums, so it's unlikely to have randomly corrupt data.] It's the
only credible way to backup a sizeable mysql db, since it works online
with InnoDB; the other options involve either only using MyISAM
(non-transactional) or locking the db for the duration (we couldn't
wait that long, but attempting to do it on a backup machine looked
like it was going to take somewhere between 3 and 7 days, although we
gave up after 24 hours... not something we can afford to do with any
kind of regularity).

>>
>> Would it be safe to remove the warning at
>> fs/xfs/linux-2.6/xfs_lrw.c:651 (which looks like it has moved to
>> xfs_file.c in 2.6.34)? It seems undesirable to get a long stream of
>> these (51 in this particular instance) every time we run a backup...
>
> You can if you want, but then you won't know when your backup or
> database might have been corrupted, right?

No, but I wouldn't know that without the warnings either -- for all I
know xtrabackup could be buggy in all kinds of ways. The only real way
to check is to use the backup data in some way.

>
>> IOW, is the warning purely something along the lines of "Userspace is
>> doing something wonky, but the underlying FS will still be fine no
>> matter what" kind of deal, or could there be an actual problem with
>> the XFS metadata itself?
>
> Nothing wrong with the filesystem metadata will occur - as I said
> eariler in the thread that this is a warning to tell us that data
> corruption is possible due to userspace doing something stupid, not
> a filesystem bug.

OK, thanks for the clarification. Ideally these wouldn't taint the
kernel either -- perhaps these can be downgraded to a message that
explicitly suggests that nothing is wrong with kernel-space things,
only user-space? The backtrace doesn't really get you much, so really
all you want to show is the offending process...

Thanks,

Ilia Mirkin
imirkin@alum.mit.edu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
