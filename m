Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0908d38085735 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 18:08:40 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 808E4EE3337
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 16:09:31 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	gA0JtgCjSp4nCvfv for <xfs@oss.sgi.com>;
	Fri, 08 Jan 2010 16:09:31 -0800 (PST)
Date: Sat, 9 Jan 2010 11:09:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: Don't flush stale inodes
Message-ID: <20100109000927.GE8654@discord.disaster>
References: <1262399980-19277-1-git-send-email-david@fromorbit.com>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A693A@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A693A@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 08, 2010 at 05:14:25PM -0600, Alex Elder wrote:
> Dave Chinner wrote:
> > Because inodes remain in cache much longer than inode buffers do
> > under memory pressure, we can get the situation where we have stale,
> > dirty inodes being reclaimed but the backing storage has been freed.
> > Hence we should never, ever flush XFS_ISTALE inodes to disk as
> > there is no guarantee that the backing buffer is in cache and
> > still marked stale when the flush occurs.
> >
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> 
> Dave, I'm putting this patch in before your perag radix tree
> patch series, so I had to port it.  I am submitting here on
> your behalf, but would like you to review it if possible.
> It builds fine, and I've run it through a quick test.
> I will retain all of your original commentary, etc.  I did
> *not* implement Christoph's recommendation that you change
> the "for" loop in xfs_alloc_search_busy() to a more typical
> form.
> 
> For reference, the original patch is here:
>     http://patchwork.xfs.org/patch/382/
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Ah, which patch are you talking about? The title says stale inodes,
the patch is searching busy extents.

Assuming you meant the busy extent search fix, you've ported the
wrong version of the busy extent search fix. I posted an updated
version after Christoph reviewed that one (in my response to
Christoph's review).

Because it was a new patch, patchwork doesn't add the email to the
original thread - it starts a new one. It's a real PITA, IMO, but
that is the way patchwork does stuff. The patch that should be
checked in is this one:

http://patchwork.xfs.org/patch/387/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
