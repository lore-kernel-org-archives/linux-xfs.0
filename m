Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MNfxfX136295 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 18:41:59 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04FA326F44
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 16:41:58 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id SZY2gUvCp13mHLeX
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 16:41:58 -0700 (PDT)
Received: by fxm8 with SMTP id 8so1053579fxm.26
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 16:41:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110622232418.GV32466@dastard>
References: <BANLkTi=gS5iO9R9pVk_df-4ofkkb0ZJgfw@mail.gmail.com>
	<4E026C42.2030500@sandeen.net> <20110622232418.GV32466@dastard>
Date: Wed, 22 Jun 2011 16:41:57 -0700
Message-ID: <BANLkTinu03WnKTL=SzoWt+Sd9YHjy0_w6g@mail.gmail.com>
Subject: Re: xfs_repair: "fatal error -- ran out of disk space!"
From: "Patrick J. LoPresti" <lopresti@gmail.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Hi, Dave and Eric.  And thank you for the quick reply.

I blew away a couple of files (200-300 megabytes; I did not write it
down) and then xfs_repair succeeded.  And now "df" shows the partition
as 100% full (265M free out of 5.1T), not 93% full (399G free).

I think the file system actually was full, but corrupted.  The reason
I was trying to run xfs_repair is that the system was acting...
"funny" (but not "ha ha" funny).  Specifically, a nfsd task was
consuming 100% CPU even though no NFS traffic was visible on the
network.  cat /proc/task_id/stack suggested the nfsd was in an
infinite loop calling into XFS trying to allocate an extent or
something.  This nfsd held a lock making it impossible to umount the
partition (among other things).

My guess is that nfsd was fooled much like df into thinking there was
space available, but when it tried to actually obtain that space, it
was told "please try again".  Which it did, forever.

I guess one question is how xfs_repair should behave in this case.  I
mean, what if the file system had been full, but too corrupt for me to
delete anything?

Anyway, my problem is fixed.  Well, until the filesystem gets
corrupted again, anyway; I still have not identified the underlying
cause of that...

Thank you again for the prompt response.

 - Pat


On Wed, Jun 22, 2011 at 4:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jun 22, 2011 at 05:27:14PM -0500, Eric Sandeen wrote:
>> On 6/22/11 4:32 PM, Patrick J. LoPresti wrote:
>> > I have a 5.1TB XFS file system that is 93% full (399G free according t=
o "df").
>> >
>> > I am trying to run "xfs_repair" on it.
>> >
>> > The output is appended.
>> >
>> > Question: =A0What am I supposed to do about this? =A0"xfs_repair -V" s=
ays
>> > "xfs_repair version 3.1.5". =A0(I downloaded and built the latest
>> > version hoping it would fix the issue, but no luck.) =A0Should I just
>> > start deleting files at random?
>>
>> You could start by removing a few files you know you don't need, rather =
than
>> at random. =A0:)
>>
>> TBH I've not seen this one before, and the error message is not all that
>> helpful. =A0It'd be nice to know how many blocks it was trying to reserve
>> when it ran out of space; I guess you'd need to use gdb, or instrument
>> all the calls to res_failed() in phase6.c to know for sure...
>
> Also, the number of inodes and directories in your filesystem might
> tell us whether we should expect an ENOSPC, as well. I suspect that
> there's an accounting error, because 400GB of transaction
> reservations is an awful lot of directory rebuilds....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
