Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 522527F58
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 16:31:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E314FAC001
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 14:30:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IyeHmctQKbBTZOqe for
	<xfs@oss.sgi.com>; Fri, 30 May 2014 14:30:55 -0700 (PDT)
Date: Fri, 30 May 2014 17:30:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: What to do when... xfs_repair hangs?
Message-ID: <20140530213051.GB26314@bfoster.bfoster>
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

I assume you've reasonably verified that the files that have been backed
up at this point have valid content.

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
> 

You might want to include a bit more information about your storage and
filesystem geometry, if possible. See here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

In terms of the hang, does the process appear to be active and spinning
via top, or is it idle? If the latter, have you any hung task messages
in dmesg or the system logs? A blocked tasks dump might also be
informative here (see the sysrq-trigger bit in the link). In either
case, I suppose some information of the runtime state of xfs_repair
could be useful.

> Interestingly when we ran a dry run of xfs_repair (-L) it got all the way
> through; it never hung up at any point. Not sure why it would start to hang
> up, once it gets run "for real".
> 

Perhaps writing to storage is problematic..? Have you encountered any
other errors related to the storage?

> This machine is in single-user-mode, I have exactly 24 lines of console
> with no scrollback buffer, no other tty available besides that which I'm
> running xfs_repair on, the system console.
> 
> Running Linux kernel 3.4.61, Ubuntu 12.04 LTS 64-bit with whatever their
> current xfsprogs is.
> 
> This is a bit of an exceptional situation for me; I've never seen
> xfs_repair just hang outright. I hoped I could maybe get some feedback from
> the experts here... what should I do?
> 
> Try to Control-C out of the xfs_repair and ... re-run it?
> 
> Should I just quit wasting time at this point, wipe out the filesystem,
> reformat, then just start the long process of restoring from the backups?
> 

I'm not totally sure, but I think if you include some more of this data,
others might have some suggestions. If there really is something about
the filesystem causing repair to choke/spin/fall-over, a metadump of the
fs might be useful (beforehand, if you do happen to go this route).

Brian

> Original plan was just to run xfs_repair, see what happened and pull from
> backups as required to fix damage. Perhaps we should just cut to the chase,
> rebuild, and restore everything? Probably the file system would be
> ultimately healthier starting from scratch, than what xfs_repair leaves
> behind?
> 
> Any insight would be very much appreciated!
> 
> Thanks,
> 
> Sean

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
