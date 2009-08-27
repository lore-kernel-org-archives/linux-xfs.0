Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7R27wDN056367 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 21:08:09 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F304A1552356
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 19:08:47 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id MACOpr3RWBVLoSs4 for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2009 19:08:47 -0700 (PDT)
Date: Wed, 26 Aug 2009 22:05:33 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Add ext2/3/4-specific _check_extN_filesystem function
Message-ID: <20090827020533.GL6997@mit.edu>
References: <1250607467-15085-1-git-send-email-tytso@mit.edu>
	<20090818161116.GA2162@infradead.org>
	<20090818170456.GF28560@mit.edu>
	<20090826221201.GC18119@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090826221201.GC18119@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Aug 26, 2009 at 06:12:01PM -0400, Christoph Hellwig wrote:
> On Tue, Aug 18, 2009 at 01:04:56PM -0400, Theodore Tso wrote:
> > > Looks like the only difference between the generic and the extN
> > > check routine is the addition of -f to the fsck command line.  What
> > > about just introducing a _fsck_args similar to _mount_opts where
> > > filesystems can set their additional required mount options?
> > 
> > That would work, yeah, and would be result in far less code
> > duplication in common.rc.  I'll take a whack at it and resubmit.
> 
> Are you still going to look at it realtively soon?  If not I'll just
> put this version in to imrove the test coverage on extN and we can
> clean it up later.
> 

Sorry, work has gotten busy and I'm trying to get some last patches
whipped into shape before the merge window opens.  I probably won't
have time to look at this for at least a week or two.  So if you want
to merge this version in for now, I'll try to clean it up when I have
a chance.

     	     	     	      	 - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
