Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Dec 2007 16:44:25 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBL0iHPZ023336
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 16:44:21 -0800
Message-ID: <476B0D29.4050504@sgi.com>
Date: Fri, 21 Dec 2007 11:47:37 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: mount prob: "log inconsistent or not a log"
References: <20071220000144.GQ19770@msoe.edu> <4769BD13.5040303@sgi.com> <20071220011848.GV19770@msoe.edu> <20071220015425.GL4612@sgi.com> <20071220024453.GX19770@msoe.edu> <20071220175512.GA6023@msoe.edu>
In-Reply-To: <20071220175512.GA6023@msoe.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jonathan C. Detert" <Jonathan.Detert@msoe.edu>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Jonathan C. Detert wrote:
> 
> I just want to clarify - I mean to ask:
> 
> 	Is it possible that an xfs filesystem which is in use by an o.s.,
> 	last mounted by the o.s. months ago, could have a corrupted log, and
> 	yet keep functioning until such time as a remount of it is attempted?
> 
Yes.
The log is read on every mount. I don't believe we read it otherwise.
On a mount we look for the log head and an unmount record etc. to decide
whether to do a replay or not.
So it could be corrupted and we would not know and we don't really care
until the next mount.
However, if we are modifying metadata in the filesystem (with some exceptions)
then we will be continuing to write to the log and we will continue to
wrap the log. And hence if someone corrupted the log at a point in the past,
we may very well be able to overwrite the log and effectively lose that
corruption.

Do you understand the basic idea?
We just write to the log while the file-system is mounted and we are writing
to the filesystem (particularly changing metadata); and
we read from the log during (just prior) mounting of the filesystem.

> 	I.e. if a log gets corrupted while the f.s. is in use, will anyone
> 	notice, until such time as an attempt to remount the f.s. is made?
No I don't think anyone will notice.
No-one has cause to read it, so noone cares.

If you unmount it cleanly. Run repair on it before mounting it again.
Then repair may find corruption when it tries to find the log head etc...
to work out if the log is clean or not.
i.e. in this case repair will try to read the log before you've tried
to do a mount.

--Tim
