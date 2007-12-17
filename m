Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 23:15:44 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBH7FaqZ004379
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 23:15:39 -0800
Date: Mon, 17 Dec 2007 07:15:46 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [review] Remove the xfs refcache
Message-ID: <20071217071546.GB11462@infradead.org>
References: <4765EC66.5020202@sgi.com> <4765F444.8010705@sgi.com> <47660DB7.5000104@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47660DB7.5000104@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: lachlan@sgi.com, Donald Douwsma <donaldd@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Sun, Dec 16, 2007 at 11:48:39PM -0600, Eric Sandeen wrote:
> Lachlan McIlroy wrote:
> > Hey hold on there buddy!  We may need to reactivate this code to fix some
> > performance issues.  I've acttually got this code working and proven that
> > it is one way to fix some of the NAS/NFS issues we have.
> > 
> > The little comment that reads "reference cache not needed for NFS in 2.6"
> > is wrong - we do need it or something like it.
> 
> So, the whole reason this was not built for 2.6 was that ostensibly the
> 2.6 kernel already did this sort of caching for nfs.  But, last time I
> looked I didn't see anything obvious.  Anybody know? :)

nfsd in 2.6 keeps the inodes around, which is 90% of what the open files
cache did.  Now what it also does is to not release preallocations
everytime but keep them while the inode is in the refcache.  For that
we'll need some additional support, and the best would be an open files
cache like the one Greg has been hacking on for quite a while.
