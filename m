Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 50AAE7CA1
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 21:00:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 242A9304032
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 19:00:08 -0700 (PDT)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id Y6Q2mGTP16B8sObU for <xfs@oss.sgi.com>;
	Thu, 31 Mar 2016 19:00:06 -0700 (PDT)
Date: Thu, 31 Mar 2016 22:00:05 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: fallocate mode flag for "unshare blocks"?
Message-ID: <20160401020005.GA25132@fieldses.org>
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<20160331011813.GJ30721@dastard>
	<20160331075440.GA4209@infradead.org>
	<20160331111850.GP11812@dastard>
	<20160331180821.GD22462@fieldses.org>
	<779E9BCF-8224-44FE-8AAE-E0341A7B475C@dilger.ca>
	<20160331222023.GR11812@dastard>
	<20160331223417.GA24069@fieldses.org>
	<20160401003300.GS11812@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160401003300.GS11812@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Fri, Apr 01, 2016 at 11:33:00AM +1100, Dave Chinner wrote:
> On Thu, Mar 31, 2016 at 06:34:17PM -0400, J. Bruce Fields wrote:
> > I haven't looked at the code, but I assume a JUKEBOX-returning write to
> > an absent file brings into cache the bits necessary to perform the
> > write, but stops short of actually doing the write.
> 
> Not exactly, as all subsequent read/write/truncate requests will
> EJUKEBOX until the absent file has been brought back onto disk. Once
> that is done, the next operation attempt will proceed.
> 
> > That allows
> > handling the retried write quickly without doing the wrong thing in the
> > case the retry never comes.
> 
> Essentially. But if a retry never comes it means there's either a
> bug in the client NFS implementation or the client crashed,

NFS clients are under no obligation to retry operations after JUKEBOX.
And I'd expect them not to in the case the calling process was
interrupted, for example.

> > I guess it doesn't matter as much in practice, since the only way you're
> > likely to notice that fallocate unexpectedly succeeded would be if it
> > caused you to hit ENOSPC elsewhere.  Is that right?  Still, it seems a
> > little weird.
> 
> s/succeeded/failed/ and that statement is right.

Sorry, I didn't explain clearly.

The case I was worrying about was the case were the on-the-wire ALLOCATE
call returns JUKEBOX, but the server allocates anyway.

That behavior violates the spec as I understand it.

The client therefore assumes there was no allocation, when in fact there
was.

So, technically a bug, but I wondered if it's likely to bite anyone.
One of the only ways it seems someone would notice would be if it caused
the filesystem to run out of space earlier than I expected.  But perhaps
that's unlikely.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
