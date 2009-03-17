Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2HDKjU3159338 for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 08:21:05 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FED91C4B6D2
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 06:20:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id Ga1wd2PFjp1r7u6m for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2009 06:20:23 -0700 (PDT)
Date: Tue, 17 Mar 2009 09:15:13 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 3/5] [XFS] Block callers of xfs_flush_inodes() correctly.
In-Reply-To: <20090316091331.GC2636@infradead.org>
Message-ID: <Pine.LNX.4.64.0903170911580.26754@hs20-bc2-1.build.redhat.com>
References: <1237116707-25793-1-git-send-email-david@fromorbit.com>
	<1237116707-25793-4-git-send-email-david@fromorbit.com>
	<20090316091331.GC2636@infradead.org>
MIME-Version: 1.0
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

On Mon, 16 Mar 2009, Christoph Hellwig wrote:

> On Sun, Mar 15, 2009 at 10:31:45PM +1100, Dave Chinner wrote:
> > xfs_flush_inodes() currently uses a magic timeout to wait for
> > some inodes to be flushed before returning. This isn't
> > really reliable but used to be the best that could be done
> > due to deadlock potential of waiting for the entire flush.
> > 
> > Now the inode flush is safe to execute while we hold page
> > and inode locks, we can wait for all the inodes to flush
> > synchronously. Convert the wait mechanism to a completion
> > to do this efficiently. This should remove all remaining
> > spurious ENOSPC errors from the delayed allocation reservation
> > path.
> 
> Why do we queue it up to a different thread if we synchronously wait
> for it anyway?

The good thing is that it saves a bit of stack space. ... And the bad 
thing of that it avoids lockdep warnings, because the lockdep engine 
cannot track dependence of processes via completions. (I tried to call it 
directly and there are none warnings, though for long-term development it 
would be better to allow the warnings so that deadlocks could be fixed 
before they hurt someone).

Mikulas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
