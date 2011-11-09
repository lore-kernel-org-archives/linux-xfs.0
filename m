Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA9MrQTA001417
	for <linux-xfs@oss.sgi.com>; Wed, 9 Nov 2011 16:53:27 -0600
Received: from exprod7og108.obsmtp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id ECF7E232C30
	for <linux-xfs@oss.sgi.com>; Wed,  9 Nov 2011 14:52:16 -0800 (PST)
Received: from exprod7og108.obsmtp.com (exprod7og108.obsmtp.com [64.18.2.169])
	by cuda.sgi.com with SMTP id OkKCATQFgdvaZlOy for
	<linux-xfs@oss.sgi.com>; Wed, 09 Nov 2011 14:52:16 -0800 (PST)
Received: by mail-yx0-f178.google.com with SMTP id q8so1647038yen.23
	for <linux-xfs@oss.sgi.com>; Wed, 09 Nov 2011 14:52:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111109223314.GQ5534@dastard>
References: <loom.20111108T180925-222@post.gmane.org>
	<20111109080133.GB20604@infradead.org>
	<CAGedfzmcmfLXhBEzm9yhpRQTf-7dnMenXqe0FABAzJgP0rxSUA@mail.gmail.com>
	<20111109223314.GQ5534@dastard>
Date: Wed, 9 Nov 2011 17:52:15 -0500
Message-ID: <CAGedfznrW4c9Bf3D-7+CEUUa-_u5iVzh+KskwFS9bom0s=C=gQ@mail.gmail.com>
Subject: Re: XFS realtime O_DIRECT failures
From: Alan Cook <acook@visionpointsystems.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com

On Wed, Nov 9, 2011 at 5:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> I'm not sure from that description just why the realtime volume adds
> any benefit to your workflow. Separation of data and metadata is
> does not provide you with data compression, so you must be doing
> something different with the real time device to acheive
> compression. Any details on that aspect of your setup?

The compression is done via hardware that sits between the block layer
and the actual storage device (in this case it is a solid state
drive).  Having both the data and meta data reside on the same device
creates a problem, as the block layer has no idea whether it has data
or meta data, and so will compress the meta data along with the
regular data, which is very bad.  Splitting the meta data to a
separate device eliminated that problem.

> I'm really only trying to understand why you need such a setup - it
> helps to understand the full use case you have before trying to
> determine if there is a better way of acheiving your end goal....

The use of a realtime volume is a means to an end, with the end being
separated data and meta data.

> As to your current problem, it's got a NULL pointer dereference
> trying to lock the per-ag structure. That means the per-ag lookup
> failed, which implies that the RT freespace bitmap may be corrupt
> and it's tried to read a bitmap block that is apparently beyond the
> end of the filesystem.  What does xfs_check/xfs_repair -n tell you
> about the filesystem state?

Unfortunately they do not tell a lot.  Running xfs_check/xfs_repair -n
prior to running the test reports no errors.  However, attempting to
run it after the test fails results in an indefinite I/O block (state
of D+ for the process).  In fact, if I run the test utility twice, it
results in a hung system.

Some form of corruption makes sense, at least to me, given the
different behavior between the first run and the second run.  It gives
me a place to start looking anyway.  Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
