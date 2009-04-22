Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3M37UqV167779 for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 22:07:32 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C16DB22E970
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 20:07:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id b7xWsAH0DQA1rkkP for <xfs@oss.sgi.com>;
	Tue, 21 Apr 2009 20:07:24 -0700 (PDT)
Date: Tue, 21 Apr 2009 23:06:56 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <811197347.242901240369616266.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1416563271.242851240369384712.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: Oops at xfs_bmbt_get_startoff in SLES 10 2.6.16
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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

----- "Eric Sandeen" <sandeen@sandeen.net> wrote:

> Felix Blyakher wrote:
> > On Apr 21, 2009, at 9:32 PM, Eric Sandeen wrote:
> > 
> >> Felix Blyakher wrote:
> >>> On Apr 21, 2009, at 9:16 PM, Eric Sandeen wrote:
> >>>
> >>>> Kevin Jamieson wrote:
> >>>>> On Thu, March 12, 2009 4:13 pm, Kevin Jamieson wrote:
> >>>>>> On Thu, March 12, 2009 12:23 pm, Eric Sandeen wrote:
> >>>>>>
> >>>>>>> For SLES that usually is the best route...
> >>>>>>>
> >>>>>>> However,
> http://oss.sgi.com/archives/xfs/2009-02/msg00220.html
> >>>>>>> looks
> >>>>>>> applicable... don't think it ever got merged though.
> >>>>>>>
> >>>>>>> perhaps you could test it?
> >>>>>> Thanks, Eric. I will test Lachlan's patch on our system.
> >>>>> To follow this up, since applying the patch from the above
> thread
> >>>>> there
> >>>>> have been no re-occurrences of the issue on our test servers
> over
> >>>>> the past
> >>>>> month.
> >>>> And you hit it pretty reliably before, right?  Sounds like we
> need  
> >>>> to
> >>>> give that a pretty strong eyeball and get it merged, perhaps.
> >>> I was looking at this patch too.
> >>> But I could never reproduce the problem, even with Lachlan's test
> >>> program. Kevin, any idea what kind of io load triggered this
> problem?
> >>> The patch looks right, but I really want to prove the problem
> >>> exists, and the patch addresses it.
> >>>
> >>> Felix
> >>>
> >> FWIW I can't reproduce either, with the stated commandline.
> >>
> >> Should try it with a 1k blocksize, though - maybe Lachlan tested 4k
> on
> >> 16k page ia64?
> > 
> > That's what I've tested on.
> 
> Ah, well, I just spoke with Lachlan and he said he tested on x86_64,
> 4k/4k.  So hrm...
You'll probably need to tweak the arguments to the test program to
generate the precise senario to trigger the race.  I remember having
to play around with them until I got it to crash reliably.  It will
depend on how fast your CPUs are, how much of the file is cached before
it is paged to disk, how fast the disks are, etc...

The race requires a thread to be executing xfs_file_last_byte() while
another thread is modifying the file's extent map - in particular
shrinking the extent map by merging extents.

> 
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
