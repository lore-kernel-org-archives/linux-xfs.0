Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q21LSHZk188990 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 15:28:17 -0600
Date: Thu, 1 Mar 2012 15:28:22 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/2] repair: fix the variable-width nlink array
Message-ID: <20120301212822.GM7762@sgi.com>
References: <20120228174223.GA6148@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120228174223.GA6148@infradead.org>
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

Hey Christoph,

On Tue, Feb 28, 2012 at 12:42:24PM -0500, Christoph Hellwig wrote:
> It looks like we currently never grow the variable-width nlink array
> if only the on-disk nlink size overflows 8 bits.  This leads to a major
> mess in nlink counting, and eventually an assert in phase7.
> 
> Replace the indirect all mess with a union that allows doing proper
> array arithmetics while we're at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks good to me.  I enjoyed the fallthrus in set_inode_disk_nlinks
and add_inode_ref.

I haven't tested with this many links though... Are there any xfstests
that would exercise this?

Reviewed-by: Ben Myers <bpm@sgi.com>

On my machine test 030 has regressed.  It passed on 3.1.7.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
