Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0H7caGv031424 for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 01:38:36 -0600
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4A57180FFB7
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2009 23:38:28 -0800 (PST)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net
	[203.16.214.57]) by cuda.sgi.com with ESMTP id GCUPFWGBO95UWxYc
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2009 23:38:28 -0800 (PST)
Date: Sat, 17 Jan 2009 18:38:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090117073824.GK8071@disturbed>
References: <20090109012610.GA23075@dth.net> <20090109020800.GO9448@disturbed>
	<20090109061043.GA31450@dth.net>
	<20090109194445.GA28759@infradead.org>
	<20090109195144.GA19857@dth.net>
	<20090109195852.GA6362@infradead.org>
	<20090109214206.GA2901@dth.net>
	<20090109220138.GA5282@infradead.org>
	<20090113200414.GA21013@dth.net> <20090116204346.GA5117@dth.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090116204346.GA5117@dth.net>
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

On Fri, Jan 16, 2009 at 09:43:46PM +0100, Danny ter Haar wrote:
> Quoting Danny ter Haar (dth@dth.net):
> > I'm stuck in trying to bisect the problem.
> > I restarted from scratch and same result:
> 
> [SNIP for bravery] 
> 
> > In the mean time i compiled/ran 2.6.29-rc1-git3 but it (as expected) barfed:
> > 
> > Al netconsole loggins are in my directory: http://www.dth.net/kernel/c3/
> > 
> > [F1] ;-)
> 
> This was to my way to say "HELP"

Sorry for not getting back to you sooner. I think that Alexander
tripped over this same problem during his bisect.  If you follow the
thread from here:

http://oss.sgi.com/archives/xfs/2009-01/msg00496.html

You'll see that Alexander had the same problem and managed
to continue the bisect once he copied the xfs_btree_trace.h
header file from top-of-tree back into the broken commits.

I hope this helps (and I hope that the bisect lands on the
same commit that it did for Alexander).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
