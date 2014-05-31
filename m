Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 66F6C7F62
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 19:01:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F186FAC001
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 17:01:24 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UukFsRVQUVM1lqH0 for <xfs@oss.sgi.com>;
	Fri, 30 May 2014 17:01:19 -0700 (PDT)
Date: Sat, 31 May 2014 10:01:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: What to do when... xfs_repair hangs?
Message-ID: <20140531000117.GM6677@dastard>
References: <CAA43vkVzWRTqNQh2VSi5yvFLtstmVOKRJUnYw_ZSkYJGsex8Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA43vkVzWRTqNQh2VSi5yvFLtstmVOKRJUnYw_ZSkYJGsex8Uw@mail.gmail.com>
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
To: Sean Caron <scaron@umich.edu>
Cc: xfs@oss.sgi.com

On Fri, May 30, 2014 at 03:49:13PM -0400, Sean Caron wrote:
> Hi all,
> 
> Long story short, we have a big array formatted as XFS, we had a machine go
> down hard maybe a month, month and a half ago... when it came back up, XFS
> faulted out when we attempted to mount the filesystem; it complained the
> log was bad or something... I did a dry run of xfs_repair (-L) and it
> looked pretty bad, so we mounted up the filesystem read-only, ran a
> backup... I think we got pretty much everything out OK except maybe files
> that were open at the time of the crash.
> 
> Now with a backup in hand, we kicked off xfs_repair "for real"... it ran
> for a while and did its thing, but now it appears to be stuck at the stage -
> 
> - agno = 436
> rebuilding directory inode ...
> rebuilding directory inode ...
> rebuilding directory inode ...
> ...
> - traversal finished ...
> - moving disconected inodes to lost+found ...
> disconnected inode 1109099673,
> 
> and then it just stops. I don't know how long its been sitting like that,
> but it hasn't moved in the last hour or two. I assume that's not good...

Is that the total of the last line of output? If so, it's likely
stuck creating the lost+found directory. It's possible there's a
corruption in the inode AVL tree (e.g. endless loop) that is causing
it to spin doing an inode record lookup, but otherwise I can't see
any reason for it getting stuck here.

The information that Brian asked for will be a good start in
tracking this down, as will the complete output of xfs_repair...

> Interestingly when we ran a dry run of xfs_repair (-L) it got all the way
> through; it never hung up at any point. Not sure why it would start to hang
> up, once it gets run "for real".

That's because a dry-run skips the "move to lost_found" phase.

> This machine is in single-user-mode, I have exactly 24 lines of console
> with no scrollback buffer, no other tty available besides that which I'm
> running xfs_repair on, the system console.

$ man script

or 

$ man tee

> Running Linux kernel 3.4.61, Ubuntu 12.04 LTS 64-bit with whatever their
> current xfsprogs is.

Upgrading xfsprogs to 3.2.0 would be a good idea.

> This is a bit of an exceptional situation for me; I've never seen
> xfs_repair just hang outright. I hoped I could maybe get some feedback from
> the experts here... what should I do?
> 
> Try to Control-C out of the xfs_repair and ... re-run it?

That's fine - the next time repair runs it will start again and
repair anything that wasn't repaired in the last run.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
