Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1N1pYxX011453 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 19:51:34 -0600
Subject: Re: [PATCH 2/2] xfs: more sensible inode refcounting for ialloc
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110213132642.GB18279@infradead.org>
References: <20110213132642.GB18279@infradead.org>
Date: Tue, 22 Feb 2011 19:52:40 -0600
Message-ID: <1298425960.1960.116.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Sun, 2011-02-13 at 08:26 -0500, Christoph Hellwig wrote:
> Currently we return iodes from xfs_ialloc with just a single reference held.
> But we need two references, as one is dropped during transaction commit and
> the second needs to be transfered to the VFS.  Change xfs_ialloc to use
> xfs_iget plus xfs_trans_ijoin_ref to grab two references to the inode,
> and remove the now superflous IHOLD calls from all callers.  This also
> greatly simplifies the error handling in xfs_create and also allow to remove
> xfs_trans_iget as no other callers are left.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

So the first inode reference we get is the one that
gets handed back to the VFS.  The second reference is
for the transaction, and it's now added precisely
at the point at which the inode is joined to the
transaction.  Nice.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
