Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 92B9D7F6D
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 13:21:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 00DA3304039
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 11:21:06 -0700 (PDT)
Received: from mail-yh0-f46.google.com (mail-yh0-f46.google.com
	[209.85.213.46]) by cuda.sgi.com with ESMTP id WU6UTwaVKXcGf9qu
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Jun 2014 11:21:04 -0700 (PDT)
Received: by mail-yh0-f46.google.com with SMTP id c41so2420354yho.5
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 11:21:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140613175955.GB9232@laptop.bfoster>
References: <CA+Bg6wd9CFKdHaAM-XyJx3royVb2-QdKqhmaamA-KMQk1TdieQ@mail.gmail.com>
	<20140611230706.GL9508@dastard>
	<CA+Bg6wdvZTYufmfK-U_6zwjKVDPVuQP_-Jwsqnh=1ayyB_EmEA@mail.gmail.com>
	<20140613000137.GV9508@dastard>
	<CA+Bg6weoSsNH=g7PJQfnafHk1TthCvzSQ9MRSsBWExyNhS1s9Q@mail.gmail.com>
	<20140613162235.GA9232@laptop.bfoster>
	<CA+Bg6weYm=FCuCen13FujWox3RiVH4M9DQ33kvDnH-a0Jk48xg@mail.gmail.com>
	<20140613175955.GB9232@laptop.bfoster>
Date: Fri, 13 Jun 2014 14:21:03 -0400
Message-ID: <CA+Bg6weD-fczFYgLYQUtBq31P1wVNAaocMW8dHOx_7tM6ZBOSg@mail.gmail.com>
Subject: Re: (Un)known issue with XFS group quotas on LVM?
From: John Desantis <desantis@mail.usf.edu>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Brian,

> Those are tracking how many blocks are accounted against each quota. As
> the output shows, the 5G from this file is being accounted against both.
> This means that for an allocation on this file to succeed, both quotas
> must have enough room for the allocation.

This is what I had did earlier to satisfy users while the confusion
lingered.  I basically augmented whichever the smaller quota was.

> It sounds like the misunderstanding is viewing a quota as an "allowance"
> rather than a "limit?" In the scenario above, the group quota
> effectively becomes a no-op. You'll never hit that limit, but that has
> no effect on the enforcement of other quotas against which a particular
> file might also be accounted.
>
> For example, if you were to set a new project quota of 1GB on the root
> directory of this mount, you won't have the ability to allocate any more
> than 1GB regardless of the user/group of the underlying files.

I do believe this is from where my confusion was stemming.  A big
thanks to you and Dave for clearing this up!

John DeSantis


2014-06-13 13:59 GMT-04:00 Brian Foster <bfoster@redhat.com>:
> On Fri, Jun 13, 2014 at 01:00:41PM -0400, John Desantis wrote:
>> Brian,
>>
>> > This all seems like normal behavior to me. What gives you the impression
>> > that you are hitting the 10G quota? The fact that the quota is reset and
>> > writing continues? Note that dd will truncate a file before it starts
>> > writing unless notrunc is specified.
>>
>> Yes, I am aware of the truncating, but not that particular option - thanks!
>>
>> I had experienced the "issue" when a user quota was set while the
>> group quota was unlimited.  See below.
>>
>> xfs_quota> limit -u bsoft=5G bhard=5G desantis.admin
>>
>> xfs_quota> quota -uh desantis.admin
>> Disk quotas for User desantis.admin (663800172)
>> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
>> /dev/mapper/vg_drbd-shares
>>                256K     5G     5G  00 [------] /export/shares
>>
>> xfs_quota> limit -g bsoft=unlimited bhard=unlimited rcadm
>>
>> xfs_quota> quota -gh rcadm
>> Disk quotas for Group rcadm (1034)
>> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
>> /dev/mapper/vg_drbd-shares
>>               43.5G    16E    16E  00 [------] /export/shares
>>
>>
>
> Ok, so a 5G user quota and effectively unlimited group quota.
>
>> # sudo -u desantis.admin -g rcadm dd if=/dev/zero
>> of=/export/shares/rcadm/testfile_morethan5G bs=1024M count=10
>> dd: writing `/export/shares/rcadm/testfile_morethan5G': Disk quota exceeded
>> 5+0 records in
>> 4+0 records out
>> 5368442880 bytes (5.4 GB) copied, 10.5371 s, 509 MB/s
>>
>
> And you can write to the 5G quota.
>
>> xfs_quota> quota -uh desantis.admin
>> Disk quotas for User desantis.admin (663800172)
>> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
>> /dev/mapper/vg_drbd-shares
>>                5.0G     5G     5G  00 [------] /export/shares
>>
>>
>> xfs_quota> quota -gh rcadm
>> Disk quotas for Group rcadm (1034)
>> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
>> /dev/mapper/vg_drbd-shares
>>               48.5G    16E    16E  00 [------] /export/shares
>>
>> As you can see, although the group quota did augment 5 GB, the user
>> quota was enforced over the group quota.  This is what led to my
>> confusion.  I had thought that the group quota would be respected over
>> the user quota because I was specifying the group for the file being
>> created.
>>
>
> Those are tracking how many blocks are accounted against each quota. As
> the output shows, the 5G from this file is being accounted against both.
> This means that for an allocation on this file to succeed, both quotas
> must have enough room for the allocation.
>
> It sounds like the misunderstanding is viewing a quota as an "allowance"
> rather than a "limit?" In the scenario above, the group quota
> effectively becomes a no-op. You'll never hit that limit, but that has
> no effect on the enforcement of other quotas against which a particular
> file might also be accounted.
>
> For example, if you were to set a new project quota of 1GB on the root
> directory of this mount, you won't have the ability to allocate any more
> than 1GB regardless of the user/group of the underlying files.
>
> Brian
>
>> John DeSantis
>>
>>
>>
>> 2014-06-13 12:22 GMT-04:00 Brian Foster <bfoster@redhat.com>:
>> > On Fri, Jun 13, 2014 at 10:50:19AM -0400, John Desantis wrote:
>> >> Dave,
>> >>
>> >> > Order doesn't matter because the filesystem is supposed to check
>> >> > against all enforced quotas, not just the first one.
>> >>
>> >> Thanks for confirming.
>> >>
>> >> > Again, you need to post the commands and output that demonstrate the
>> >> > problem you are describing. I'm having trouble understanding what
>> >> > your problem is because I can't see the raw output that you are
>> >> > seeing...
>> >>
>> >> Ok, here are the default user and group quotas of my test account:
>> >>
>> >> xfs_quota> quota -uh desantis.admin
>> >> Disk quotas for User desantis.admin (663800172)
>> >> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
>> >> /dev/mapper/vg_drbd-shares
>> >>                256K      0      0  00 [------] /export/shares
>> >>
>> >> xfs_quota> quota -gh rcadm
>> >> Disk quotas for Group rcadm (1034)
>> >> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
>> >> /dev/mapper/vg_drbd-shares
>> >>               43.5G      0      0  00 [------] /export/shares
>> >>
>> >> Now, we'll limit them and then re-display the quotas:
>> >>
>> >> xfs_quota> limit -g bsoft=50G bhard=50G rcadm
>> >> xfs_quota> limit -u bsoft=10G bhard=10G desantis.admin
>> >>
>> >> xfs_quota> quota -uh desantis.admin
>> >> Disk quotas for User desantis.admin (663800172)
>> >> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
>> >> /dev/mapper/vg_drbd-shares
>> >>                256K    10G    10G  00 [------] /export/shares
>> >>
>> >> xfs_quota> quota -gh rcadm
>> >> Disk quotas for Group rcadm (1034)
>> >> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
>> >> /dev/mapper/vg_drbd-shares
>> >>               43.5G    50G    50G  00 [------] /export/shares
>> >>
>> >
>> > So you've got 10G quota with about as much available and a 50G quota
>> > with ~6.5GB available.
>> >
>> >> Here come the tests:
>> >>
>> >> # sudo -u desantis.admin -g rcadm dd if=/dev/zero
>> >> of=/export/shares/rcadm/testfile_1 bs=1024M count=11
>> >> dd: writing `/export/shares/rcadm/testfile_1': Disk quota exceeded
>> >> 7+0 records in
>> >> 6+0 records out
>> >> 6933651456 bytes (6.9 GB) copied, 19.7811 s, 351 MB/s
>> >>
>> >
>> > It looks like you've hit the 50G quota.
>> >
>> >> xfs_quota> quota -uh desantis.admin
>> >> Disk quotas for User desantis.admin (663800172)
>> >> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
>> >> /dev/mapper/vg_drbd-shares
>> >>                6.5G    10G    10G  00 [------] /export/shares
>> >>
>> >> xfs_quota> limit -u bsoft=0 bhard=0 desantis.admin
>> >>
>> >
>> > Now the 10G quota is gone.
>> >
>> >> xfs_quota> quota -uh desantis.admin
>> >> Disk quotas for User desantis.admin (663800172)
>> >> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
>> >> /dev/mapper/vg_drbd-shares
>> >>                6.5G      0      0  00 [------] /export/shares
>> >>
>> >> # sudo -u desantis.admin -g rcadm dd if=/dev/zero
>> >> of=/export/shares/rcadm/testfile_1 bs=1024M count=5
>> >> 5+0 records in
>> >> 5+0 records out
>> >> 5368709120 bytes (5.4 GB) copied, 10.8275 s, 496 MB/s
>> >>
>> >
>> > You overwrite the previously written 6.5G file to 5.4G (dd will
>> > truncate).
>> >
>> >> # sudo -u desantis.admin -g rcadm dd if=/dev/zero
>> >> of=/export/shares/rcadm/testfile_2 bs=1024M count=5
>> >> dd: writing `/export/shares/rcadm/testfile_2': Disk quota exceeded
>> >> 1+0 records in
>> >> 0+0 records out
>> >> 1028136960 bytes (1.0 GB) copied, 4.60859 s, 223 MB/s
>> >>
>> >
>> > Then create a new file and run into the 50G limit again.
>> >
>> >> xfs_quota> quota -gh rcadm
>> >> Disk quotas for Group rcadm (1034)
>> >> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
>> >> /dev/mapper/vg_drbd-shares
>> >>               50.0G    50G    50G  00 [------] /export/shares
>> >>
>> >>
>> >> As you can see with the output, my user quota of 10 GB was enforced
>> >> over the higher group quota of 50 GB.  My original thought process was
>> >> that since the file being created was specified for the group with the
>> >> larger quota, that XFS would enforce that limit over the user quota.
>> >> After reading over several pieces of quota documentation (RTFM!) from
>> >> different O.S. distributions, it looks like you can either have a user
>> >> or group quota getting enforced, but not both in the sense I was
>> >> originally thinking.
>> >>
>> >
>> > This all seems like normal behavior to me. What gives you the impression
>> > that you are hitting the 10G quota? The fact that the quota is reset and
>> > writing continues? Note that dd will truncate a file before it starts
>> > writing unless notrunc is specified.
>> >
>> > Brian
>> >
>> >> That being said, I really do appreciate the responses and extra set of
>> >> eyes and apologize if I've wasted too much time.
>> >>
>> >> John DeSantis
>> >>
>> >> 2014-06-12 20:01 GMT-04:00 Dave Chinner <david@fromorbit.com>:
>> >> > On Thu, Jun 12, 2014 at 10:04:29AM -0400, John Desantis wrote:
>> >> >> Dave,
>> >> >>
>> >> >> Thanks for your reply.  Let me address your questions and replies.
>> >> >>
>> >> >> > That doesn't sound like a filesystem problem. Sounds more like the
>> >> >> > remote user/group configuration is getting squashed. Do the systems
>> >> >> > have the same user/group configurations, or are the clients sending
>> >> >> > group IDs the server doesn't recognise?
>> >> >>
>> >> >> Stracing shows that the group and user ID's are not being squashed and
>> >> >> they are resolving each time to their respective UID/GID's.
>> >> >>
>> >> >> > As it is, describing the problem in text doesn't tell me anything
>> >> >> > about the problem. You need to cut-n-paste the CLI and the output
>> >> >> > showing the incorrect behaviour so we can attempt to reproduce the
>> >> >> > same behaviour you are seeing.
>> >> >>
>> >> >> Busted.  I figured before sending the usual gamut of console "action",
>> >> >> I'd "save" time by simply presenting the symptoms.
>> >> >>
>> >> >> > I can't see how that is related to the filesystem - the filesystem
>> >> >> > will either account for group quota usage or it won't. It doesn't
>> >> >> > care what primary gid the process uses, it will simply account usage
>> >> >> > to that...
>> >> >>
>> >> >> You're correct (but you already knew this!).  I can tell you that
>> >> >> running the quota report does show the group block count changing.
>> >> >>
>> >> >> It looks like this "issue" is  my misunderstanding of how XFS is
>> >> >> checking the quota.  Perhaps you could shed some light?
>> >> >>
>> >> >> When you're using active user and group quotas on the same file system
>> >> >> and the user quota is lower than the group quota, does XFS first check
>> >> >> against the user quota and then the group quota?  Is the order of
>> >> >> operations user, group, and then project or does it depend on the
>> >> >> mounting order of quotas?
>> >> >
>> >> > Order doesn't matter because the filesystem is supposed to check
>> >> > against all enforced quotas, not just the first one.
>> >> >
>> >> >> In the case I presented yesterday, the user in question had a quota of
>> >> >> 25 GB, but the group had an unlimited quota.  Each time that I used
>> >> >> sudo -u user -g group or logged into the user's account, the quota was
>> >> >> always exceeded.  Now that I have removed the user's quota, the group
>> >> >> quota is now being respected properly.
>> >> >
>> >> > Again, you need to post the commands and output that demonstrate the
>> >> > problem you are describing. I'm having trouble understanding what
>> >> > your problem is because I can't see the raw output that you are
>> >> > seeing...
>> >> >
>> >> > Cheers,
>> >> >
>> >> > Dave.
>> >> > --
>> >> > Dave Chinner
>> >> > david@fromorbit.com
>> >>
>> >> _______________________________________________
>> >> xfs mailing list
>> >> xfs@oss.sgi.com
>> >> http://oss.sgi.com/mailman/listinfo/xfs
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
