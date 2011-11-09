Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA9MXLC5260803
	for <linux-xfs@oss.sgi.com>; Wed, 9 Nov 2011 16:33:21 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C3C61CFABE6
	for <linux-xfs@oss.sgi.com>; Wed,  9 Nov 2011 14:33:18 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	j2h4qK3KfGm6bV8d for <linux-xfs@oss.sgi.com>;
	Wed, 09 Nov 2011 14:33:18 -0800 (PST)
Date: Thu, 10 Nov 2011 09:33:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS realtime O_DIRECT failures
Message-ID: <20111109223314.GQ5534@dastard>
References: <loom.20111108T180925-222@post.gmane.org>
	<20111109080133.GB20604@infradead.org>
	<CAGedfzmcmfLXhBEzm9yhpRQTf-7dnMenXqe0FABAzJgP0rxSUA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGedfzmcmfLXhBEzm9yhpRQTf-7dnMenXqe0FABAzJgP0rxSUA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alan Cook <acook@visionpointsystems.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com

On Wed, Nov 09, 2011 at 08:25:02AM -0600, Alan Cook wrote:
> On Wed, Nov 9, 2011 at 2:01 AM, Christoph Hellwig <hch@infradead.org> wro=
te:
> > It might sounda a bit harsh, but the problem is that use the realtime
> > subvolume.  It hasn't really been maintained or been part of the tested
> > setup, and most distros in the know ship with it disabled.  I went
> > through and fixed it when we got bug reports once in a while, and I'm
> > happy to look into your issues once I get a bit spare time, but in
> > general use is highly discouraged.   Is there any specific reason why
> > you want to use the RT subvolume?
> =

> I am streaming high-resolution images to be compressed through
> hardware and need to separate the data from the meta data for
> compression purposes.=A0 XFS gave that for free if I used a realtime
> subvolume.

I'm not sure from that description just why the realtime volume adds
any benefit to your workflow. Separation of data and metadata is
does not provide you with data compression, so you must be doing
something different with the real time device to acheive
compression. Any details on that aspect of your setup?

I'm really only trying to understand why you need such a setup - it
helps to understand the full use case you have before trying to
determine if there is a better way of acheiving your end goal....

> I originally started on kernel 2.6.27 (CentOS 5.5) which had no issues
> with the RT subvolume and direct writes.=A0 I was then moved to kernel
> 2.6.32 (SUSE 11) which does have the issue.
> =

> I appreciate your willingness to help.=A0 Are there any alternatives or
> suggestions for splitting the data and meta data?=A0 Any direction you
> can give on where to start looking or what I could do to track down
> the exact cause of the bug?

I have long term plans for metadata/data separation involving a
separate metadata device (i.e. so metadata space can be placed on
different media, grown separately from data space, we don't give up
any of the inherent parallelism in allocation like we do for the RT
device, etc), but that's a long way off yet so not a solution to
your problem.

As to your current problem, it's got a NULL pointer dereference
trying to lock the per-ag structure. That means the per-ag lookup
failed, which implies that the RT freespace bitmap may be corrupt
and it's tried to read a bitmap block that is apparently beyond the
end of the filesystem.  What does xfs_check/xfs_repair -n tell you
about the filesystem state?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
