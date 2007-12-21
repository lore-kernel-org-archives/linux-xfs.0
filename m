Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Dec 2007 15:19:36 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBLNJTdI023431
	for <xfs@oss.sgi.com>; Fri, 21 Dec 2007 15:19:31 -0800
Received: from email.msoe.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 975D6B9ECEE
	for <xfs@oss.sgi.com>; Fri, 21 Dec 2007 15:19:42 -0800 (PST)
Received: from email.msoe.edu (email.msoe.edu [155.92.194.61]) by cuda.sgi.com with ESMTP id 1H6NXAudqByDye68 for <xfs@oss.sgi.com>; Fri, 21 Dec 2007 15:19:42 -0800 (PST)
Date: Fri, 21 Dec 2007 17:19:09 -0600
From: "Jonathan C. Detert" <Jonathan.Detert@msoe.edu>
Subject: Re: mount prob: "log inconsistent or not a log"
Message-ID: <20071221231909.GE4723@msoe.edu>
References: <20071220000144.GQ19770@msoe.edu> <4769BD13.5040303@sgi.com> <20071220011848.GV19770@msoe.edu> <20071220015425.GL4612@sgi.com> <20071220024453.GX19770@msoe.edu> <20071220175512.GA6023@msoe.edu> <476B0D29.4050504@sgi.com> <20071221015533.GH6476@msoe.edu> <476B5FE4.9030405@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476B5FE4.9030405@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

* Timothy Shimmin <tes@sgi.com> [071221 00:38]:
> Jonathan C. Detert wrote:
> >* Timothy Shimmin <tes@sgi.com> [071220 18:49]:
> >>Jonathan C. Detert wrote:
> >>>I just want to clarify - I mean to ask:
> >>>
> >>>	Is it possible that an xfs filesystem which is in use by an o.s.,
> >>>	last mounted by the o.s. months ago, could have a corrupted log, and
> >>>	yet keep functioning until such time as a remount of it is attempted?
> >>>
> >>Yes.
> >>The log is read on every mount. I don't believe we read it otherwise.
> >>On a mount we look for the log head and an unmount record etc. to decide
> >>whether to do a replay or not.
> >>So it could be corrupted and we would not know and we don't really care
> >>until the next mount.

-- snip --

> >>If you unmount it cleanly. Run repair on it before mounting it again.
> >>Then repair may find corruption when it tries to find the log head etc...
> >>to work out if the log is clean or not.
> >>i.e. in this case repair will try to read the log before you've tried
> >>to do a mount.
> >
> >So, how do you recover from a situation like i have, namely:
> >
> >1) the xfs file system is not currently mounted
> >2) an attempt to mount the xfs fs fails, complaining about log being
> >   inconsistent or not a log

-- snip --

> Without doing anything fancy, you are stuffed.
> You need to clear the log and repair it using "xfs_repair -L"
> (the -L will zero the log and for linux write a log record in there).
> 
> I was wondering that if only the end of the log was corrupted and that
> was not between the tail and the head, then one could write
> 0x00000255 (597 dec) at the start of each sector (which is the previous
> cycle#) where the corruption is.
> Then the recovery code would likely think that this was old
> data as it has the old cycle# (and hence ignore it).
> However, it is xmas breakup day and I'm too tired to try it out
> at the moment. :)

Merry Christmas, and have a good rest

> Was thinking of something like:
> xfs_io -c 'pwrite -b 512 -S 0x00000255 38889s 31s' sdb-xfs-log.fixup
> But that's not right. Sorry.
> And then I'm still not convinced about the tail numbers in many
> of the log records (particularly the head) anyway.

I have nothing to lose at this point.  If you work out a best guess
sometime before January 5th, I will try it.  If it works, there would be
much rejoicing around here.

Thanks for all your help so far.
-- 
Jon Detert
IT Systems Administrator, Milwaukee School of Engineering
1025 N. Broadway, Milwaukee, Wisconsin 53202, U.S.A.
--
Linus Torvalds doesn't die, he simply returns zero.
