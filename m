Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1T0ru8n231157 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 18:53:56 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9JBAyIUNgcdjS96k for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 16:53:54 -0800 (PST)
Date: Wed, 29 Feb 2012 11:53:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Warning from unlock_new_inode
Message-ID: <20120229005351.GV3592@dastard>
References: <20120222220137.GB3650@quack.suse.cz>
	<20120228083444.GB22995@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120228083444.GB22995@infradead.org>
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
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue, Feb 28, 2012 at 03:34:44AM -0500, Christoph Hellwig wrote:
> On Wed, Feb 22, 2012 at 11:01:37PM +0100, Jan Kara wrote:
> >   Hello,
> > 
> >   while running fsstress on XFS partition with 3.3-rc4 kernel + my freeze
> > fixes (they do not touch anything relevant AFAICT) I've got the following
> > warning:
> 
> That's stressing including freezes or without?  Do you have a better
> description of te workload?
> 
> Either way it's an odd one, I can't see any obvious way how this would
> happen.

FWIW, I'm trying to track down exactly the same warning on a RHEL6.2
kernel being triggered by NFS filehandle lookup. The problem is
being being reproduced reliably by a well known NFS benchmark, but
this gives more a bit more information on where a race condition in
the inode lookup may exist.

That is, the only common element here in these two lookup paths is
that they are the only two calls to xfs_iget() with
XFS_IGET_UNTRUSTED set in the flags. I doubt this is a coincidence.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
