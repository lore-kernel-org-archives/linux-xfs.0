Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Dec 2007 17:55:29 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBL1tMdT027100
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 17:55:25 -0800
Received: from email.msoe.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B911AB8F2AC
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 17:55:35 -0800 (PST)
Received: from email.msoe.edu (email.msoe.edu [155.92.194.61]) by cuda.sgi.com with ESMTP id n83GoDDegsoLHZFv for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 17:55:35 -0800 (PST)
Date: Thu, 20 Dec 2007 19:55:33 -0600
From: "Jonathan C. Detert" <Jonathan.Detert@msoe.edu>
Subject: Re: mount prob: "log inconsistent or not a log"
Message-ID: <20071221015533.GH6476@msoe.edu>
References: <20071220000144.GQ19770@msoe.edu> <4769BD13.5040303@sgi.com> <20071220011848.GV19770@msoe.edu> <20071220015425.GL4612@sgi.com> <20071220024453.GX19770@msoe.edu> <20071220175512.GA6023@msoe.edu> <476B0D29.4050504@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476B0D29.4050504@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

* Timothy Shimmin <tes@sgi.com> [071220 18:49]:
> Jonathan C. Detert wrote:
> >
> >I just want to clarify - I mean to ask:
> >
> >	Is it possible that an xfs filesystem which is in use by an o.s.,
> >	last mounted by the o.s. months ago, could have a corrupted log, and
> >	yet keep functioning until such time as a remount of it is attempted?
> >
> Yes.
> The log is read on every mount. I don't believe we read it otherwise.
> On a mount we look for the log head and an unmount record etc. to decide
> whether to do a replay or not.
> So it could be corrupted and we would not know and we don't really care
> until the next mount.
> However, if we are modifying metadata in the filesystem (with some 
> exceptions)
> then we will be continuing to write to the log and we will continue to
> wrap the log. And hence if someone corrupted the log at a point in the past,
> we may very well be able to overwrite the log and effectively lose that
> corruption.
> 
> Do you understand the basic idea?

I think so.

> We just write to the log while the file-system is mounted and we are writing
> to the filesystem (particularly changing metadata); and
> we read from the log during (just prior) mounting of the filesystem.
> 
> >	I.e. if a log gets corrupted while the f.s. is in use, will anyone
> >	notice, until such time as an attempt to remount the f.s. is made?
> No I don't think anyone will notice.
> No-one has cause to read it, so noone cares.
> 
> If you unmount it cleanly. Run repair on it before mounting it again.
> Then repair may find corruption when it tries to find the log head etc...
> to work out if the log is clean or not.
> i.e. in this case repair will try to read the log before you've tried
> to do a mount.

So, how do you recover from a situation like i have, namely:

1) the xfs file system is not currently mounted
2) an attempt to mount the xfs fs fails, complaining about log being
   inconsistent or not a log

You say noone cares if the log is corrupt, but it seems to be a
fatal problem if you want to mount the fs.

Bottom line: how do you recover when trying to remount an xfs fs whose
log happens to be corrupt?
-- 
Jon Detert
IT Systems Administrator, Milwaukee School of Engineering
1025 N. Broadway, Milwaukee, Wisconsin 53202, U.S.A.
--
"Solitary trees, if they grow at all, grow strong."
~ Winston Churchill
