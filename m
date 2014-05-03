Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F5DC7F37
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 19:05:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5D89030405F
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 17:05:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ueIrxnkRROD6yAW0 for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 17:05:27 -0700 (PDT)
Date: Sat, 3 May 2014 10:05:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs umount hang in xfs_ail_push_all_sync on i/o error
Message-ID: <20140503000512.GH26353@dastard>
References: <CALjwKZDsGBxTDLvy7-W76FRpHRuki_ZjOXLWZ70fut4hmDkTSQ@mail.gmail.com>
	<20140428234558.GD18672@dastard>
	<CALjwKZCZrpHNnqCWyotiYvLNa8yJMRoBgNp4NShSj0j2hLJ9DQ@mail.gmail.com>
	<20140429010121.GE18672@dastard>
	<CALjwKZBj0f_y7MPp-PLqhLDOnfmf2OWsvv_vbnX08ubevqM+Bg@mail.gmail.com>
	<20140430032209.GA22353@dastard>
	<CALjwKZDeTcOSJDtRcNa3KtLraPKvWUB0jvQrwSANxB0RHds0Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALjwKZDeTcOSJDtRcNa3KtLraPKvWUB0jvQrwSANxB0RHds0Rg@mail.gmail.com>
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
To: Bob Mastors <bob.mastors@solidfire.com>
Cc: xfs@oss.sgi.com

On Fri, May 02, 2014 at 11:32:19AM -0600, Bob Mastors wrote:
> On Tue, Apr 29, 2014 at 9:22 PM, Dave Chinner <david@fromorbit.com> wrote:
> > Well, I guess I should been more specific. ftrace is pretty much
> > useless here - we need the information taht is recorded by the
> > events, not the timing of the events.
> >
> Heh, I have been trying to bluff my way through this.
> I have hacked on file systems but am new to linux and xfs.

I wouldn't have guessed that. Most of the time the response is
"trace events? what are they?". :)

> Output file attached but it all looks like this:
> 
>      xfsaild/sdb-3613  [001]   445.757616: xfs_ail_flushing:     dev 8:16
> lip 0x0xffff88001d3017b8 lsn 32/3573 type XFS_LI_INODE flags IN_AIL
>      xfsaild/sdb-3613  [001]   445.757617: xfs_ail_flushing:     dev 8:16
> lip 0x0xffff88001d301850 lsn 32/3573 type XFS_LI_INODE flags IN_AIL
>      xfsaild/sdb-3613  [001]   445.757618: xfs_ail_flushing:     dev 8:16
> lip 0x0xffff88001de63ed8 lsn 32/3573 type XFS_LI_INODE flags IN_AIL
>      xfsaild/sdb-3613  [001]   445.757618: xfs_ail_flushing:     dev 8:16
> lip 0x0xffff88001cd24720 lsn 32/3573 type XFS_LI_INODE flags IN_AIL
>      xfsaild/sdb-3613  [001]   445.757618: xfs_ail_flushing:     dev 8:16
> lip 0x0xffff88001cd248e8 lsn 32/3573 type XFS_LI_INODE flags IN_AIL
>      xfsaild/sdb-3613  [001]   445.757619: xfs_ail_flushing:     dev 8:16
> lip 0x0xffff88002c435ab0 lsn 32/3573 type XFS_LI_INODE flags IN_AIL

That's very enlightening - a bunch of inodes returning
XFS_ITEM_FLUSHING from attempts to push them.

> The addresses repeat.
> I started the record as soon as I noticed the umount hanging, probably
> within 20 seconds or so.
> Also attached is the console output.
> 
> This was done with your patch applied.
> 
> Seems like xfsaild_push is missing a check that the file system is
> XFS_FORCED_SHUTDOWN.

It might look that way, but what is supposed to happen is that
everything else is supposed to handle shutdown situations and empty
the AIL. i.e. the act of issuing IO by the AIL is supposed to
trigger shutdown processing on the objects, and so having the AIL
shut down itself won't help.

So, what's the problem? Well, the inodes have been flushed,
triggering the inode buffer to be written. However, then inode
buffer has had an IO error (i.e. the async write error), is retried,
and then we stop retrying the IO. The idea is that the AIL will push
it again soon and the IO will be retried.

What is happening is that the inodes in the buffer are already
marked as "being flushed" and hence the AIL does not push the inode
buffer again, and hence the IO completion callbacks on the buffer
that will remove the inodes from the AIL are never called. Not sure
how to fix this one yet....

> Let me know if there is any other info I can capture that would be
> interesting.

I know what the problem is now, so testing a fix will be the next
step. But I need to think about how to fix this, and that can wait
till Monday. ;)

Thanks for following up with the trace information, Bob!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
