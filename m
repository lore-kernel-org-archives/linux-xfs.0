Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 15:13:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m53MDqE2026923
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 15:13:52 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 812921E45B5
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2008 15:14:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id vFcgoE8gmW1xGNDq for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 15:14:43 -0700 (PDT)
Message-ID: <4845C254.6050104@sandeen.net>
Date: Tue, 03 Jun 2008 17:14:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Questions for article
References: <13033.143.166.226.57.1212526129.squirrel@tomslinux.homelinux.org>
In-Reply-To: <13033.143.166.226.57.1212526129.squirrel@tomslinux.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas King <kingttx@tomslinux.homelinux.org>
Cc: xfs@oss.sgi.com

Thomas King wrote:

> -Concerning the block-size limit, will this eventually be a thing of the past?
> Mr. Newman's contention is massive filesystems should have much larger block
> sizes, but he also contends that OSD is the eventual answer instead of using
> block allocation.

Just to reiterate what I already put on the ext4 list... :)

ftp://ftp.kernel.org/pub/linux/kernel/people/christoph/largeblocksize/4/patches/
http://kerneltrap.org/Linux/Large_Blocksize_Performance

Not sure where those patches are headed.

It's also not clear to me that this is really a critical feature for
large filesystems; space allocation is not done block by block per se in
xfs, as Mr. Newman seems (?) to imply (?)  The block granularity is
there throughout the fs but I'm not sure how much it matters in
practice.  Dave...?

OSDs may have their place, we'll see.  It's pretty new stuff (unless you
count Lustre, I guess, but I thought he didn't want to talk lustre...)
I don't think this relates to a linux shortcoming in any way (or to
xfs...), it's  awfully new stuff that just about nobody really has in
production.

> -Is there anything else y'all would like folks to understand about XFS and
> massive implementations?

I already pointed him at the xfs_repair paper, since he seems concerned
about fsck (and pointed out that yes, xfs_repair really *DOES* check all
filesystem data and does not simply replay the log...)

http://mirror.linux.org.au/pub/linux.conf.au/2008/slides/135-fixing_xfs_faster.pdf

Maybe some of the folks on the list with said massive implementations
can speak up too.  :)

-Eric
