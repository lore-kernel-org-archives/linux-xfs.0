Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 05:49:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OCnj4p023883
	for <linux-xfs@oss.sgi.com>; Fri, 24 Aug 2007 05:49:47 -0700
Date: Fri, 24 Aug 2007 22:49:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: TAKE 969192: Default mount option "noikeep" makes the inode generation number non-persistent
Message-ID: <20070824124933.GS61154114@sgi.com>
References: <46CE581A.2000405@sgi.com> <20070824113631.GA26868@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824113631.GA26868@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Vlad Apostolov <vapo@sgi.com>, linux-xfs@oss.sgi.com

On Fri, Aug 24, 2007 at 12:36:31PM +0100, Christoph Hellwig wrote:
> On Fri, Aug 24, 2007 at 02:01:30PM +1000, Vlad Apostolov wrote:
> > To avoid the problem with identical DMAPI handles, the XFSMNT_IDELETE mount
> > option should be set as default, only if the filesystem is not mounted with
> > XFSMNT_DMAPI.
> 
> Note that we have the same problem with nfs exports aswell.  Dateo maybe we
> need a real fix insteead and keep a block of generation numbers around even
> if and inode cluster is freed or something similar.

Yes. NFS is less critical than dmapi, though - with NFS filehandles just a
change in generation number is usually good enough to catch most stale
filehandle issues. With DMAPI, there's applications that record inode
number/generation pairs and expect them never to repeat ever again.

We haven't had any reports of probelms with NFS servers due to this,
but as soon as our HSm was exposed to this code we started getting
strange coherency and corruption problems that have taken some time
to track down to this issue. Hence this change seems like the
best tradeoff while we work out a real solution.

At this point I suspect a deleted inode cluster btree in the AGI
is the best solution because it can share most of the btree
code with the current AGI btree and keeps the granularity of
shared generation numbers quite fine.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
