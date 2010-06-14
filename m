Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5E3POu4016745 for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 22:25:24 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FC0714CC22E
	for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 20:27:59 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id MFVXqZ6Lb9xAtDZk
	for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 20:27:59 -0700 (PDT)
Received: by vws19 with SMTP id 19so344450vws.26
	for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 20:27:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100614012933.GB6590@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<20100524011907.GC12087@dastard>
	<AANLkTinyt6V9phjXrzrxm67THdRwTiN6pOim3uBUbo1Z@mail.gmail.com>
	<20100613224752.GA2069@dastard>
	<AANLkTikA2d44tZF1TWZAjCqXkhsw0mzsAIaeCosZLqVq@mail.gmail.com>
	<20100614012933.GB6590@dastard>
Date: Sun, 13 Jun 2010 23:27:59 -0400
Message-ID: <AANLkTilqrYxnRzB3FNNE3k3hX2Sp1U63gyTo3T4CIzWV@mail.gmail.com>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Roman Kononov <roman@binarylife.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jun 13, 2010 at 9:29 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Jun 13, 2010 at 07:10:30PM -0400, Ilia Mirkin wrote:
>> On Sun, Jun 13, 2010 at 6:47 PM, Dave Chinner <david@fromorbit.com> wrot=
e:
>> > On Sat, Jun 12, 2010 at 01:00:52AM -0400, Ilia Mirkin wrote:
>> >> Sorry to pick up an old-ish thread, but I have a similar situation:
>> >>
>> >> On Sun, May 23, 2010 at 9:19 PM, Dave Chinner <david@fromorbit.com> w=
rote:
>> >> > On Sun, May 23, 2010 at 09:23:44AM -0500, Roman Kononov wrote:
>> >> >> On 2010-05-23, 20:18:56 +1000, Dave Chinner <david@fromorbit.com> =
wrote:
>> >> >> > Can you find out what the application is triggering this?
>> >>
>> >> I noticed this happening with mysql and xtrabackup -- the latter opens
>> >> up mysql's files while mysql is still running (and modifying its own
>> >> files) and backs them up in a (hopefully) safe way.
>> >
>> > That's not safe at all - there's no guarantee you'll end up with a
>> > consistent database image doing backups like this. Have you ever
>> > tried to restore and use one of these backups?
>>
>> Yep, works great. [Used it to initialize a slave, did the full
>> checksums, so it's unlikely to have randomly corrupt data.]
>
> You were lucky, I'd say. =A0xtrabackup is supposed to be tightly
> integrated with mysql, so perhaps it should be using the same IO
> methods that the admin has selected for their database. Maybe you
> need to talk to the xtrabackup folks to get them to add a "backup
> via direct IO" method if the mysql database is using direct IO so
> that other uses don't have the same issues.

Maybe. We've been using this technique, although on a different
physical machine and with ext3, for quite some time (and we verify all
backups). I did notice that there is a minor difference in
configuration, esp wrt direct IO, so I'll check it out in more detail.
[We're now setting innodb_flush_method to O_DIRECT whereas we weren't
before... although based on the documentation and a cursory
understanding of how xtrabackup works, this shouldn't be harmful.]

> And from a "I read it on the interwebs so it must be true"
> perspective, without a loud obnoxious warning we'll never hear about
> problems until someone flames us about silent data corruption on a
> random blog that gets slashdotted and then referenced for the next
> 10 years as the next canonical "XFS eats my data!" reference for the
> clueless....

Instead it will be "mysql works fine on ext3, but with xfs it spams
the logs with warnings, therefore xfs must be broken". I don't think
there's anything realistically that you can do about uninformed users
and FUD. Although I wasn't suggesting to get rid of the warning,
rather to make it more explicit as to what it's warning about. I
interpret a WARN as a BUG that can be recovered but where the
underlying system needs a careful look; my first inclination after
seeing a fs-related WARN would be to take the system down and run an
fsck. What's happening here seems more akin to getting a WARN when
calling an ioctl with invalid parameters.

---
Ilia Mirkin
imirkin@alum.mit.edu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
