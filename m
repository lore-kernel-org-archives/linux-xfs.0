Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0J3NbiE024085 for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 21:23:37 -0600
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B33A5181C059
	for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 19:23:34 -0800 (PST)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net
	[203.16.214.57]) by cuda.sgi.com with ESMTP id MAIFTzreYo7jC1HB
	for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 19:23:34 -0800 (PST)
Date: Mon, 19 Jan 2009 14:17:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090119031743.GN8071@disturbed>
References: <20090109061043.GA31450@dth.net>
	<20090109194445.GA28759@infradead.org>
	<20090109195144.GA19857@dth.net>
	<20090109195852.GA6362@infradead.org>
	<20090109214206.GA2901@dth.net>
	<20090109220138.GA5282@infradead.org>
	<20090113200414.GA21013@dth.net> <20090116204346.GA5117@dth.net>
	<20090117073824.GK8071@disturbed> <20090117232511.GA8443@dth.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090117232511.GA8443@dth.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Danny ter Haar <dth@dth.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, Jan 18, 2009 at 12:25:11AM +0100, Danny ter Haar wrote:
> Quoting Dave Chinner (david@fromorbit.com):
> > Sorry for not getting back to you sooner.
> 
> No problem. I initally posted to LKLM, git redirected by Christoph to this
> list. I'm so stupid that i didn't check the other messages from this list.
> Sorry.
> 
> > I think that Alexander tripped over this same problem during his bisect.
> > If you follow the thread from here:
> > http://oss.sgi.com/archives/xfs/2009-01/msg00496.html
> 
> Yep! [cheer] i'm not alone! :-)
> But why only us two ? there must be thousands of users out there using
> XFS. Why did it bite us ? large filesystem together with slow hardware ?

No idea - I can't reproduce it either so there's some state
that your filesystem is getting into that trips over it.

> > You'll see that Alexander had the same problem and managed
> > to continue the bisect once he copied the xfs_btree_trace.h
> > header file from top-of-tree back into the broken commits.
> 
> Grwat.
> 
> > I hope this helps (and I hope that the bisect lands on the
> > same commit that it did for Alexander).
> 
> Do you want me to still try it ?
> I think you allready figured out where the culprit is ?!

Yes, i think we have, but it wasn't totally conclusive. Can you
continue your bisect to see if it narrows down to the same commit
on your machine?

I'm still trying to reproduce it but I haven't worked out what the
initial state is. One thing that might be useful is to put a printk
into the kernel on the failure path that prints the inode number
out (e.g. at the goto that the WANT_CORRUPTED_GOTO jumps to). Then
we can use xfs_db to find the file that is causing the problem and
then use xfs_db or xfs_bmap to look at the extent tree prior to
the corruption. That might help me set up the initial state needed
to trip the problem.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
