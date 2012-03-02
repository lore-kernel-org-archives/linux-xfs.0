Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q227ig6A006965 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 01:44:42 -0600
Date: Fri, 2 Mar 2012 02:44:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] repair: fix the variable-width nlink array
Message-ID: <20120302074433.GA4117@infradead.org>
References: <20120228174223.GA6148@infradead.org>
	<20120301212822.GM7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120301212822.GM7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Mar 01, 2012 at 03:28:22PM -0600, Ben Myers wrote:
> Hey Christoph,
> 
> On Tue, Feb 28, 2012 at 12:42:24PM -0500, Christoph Hellwig wrote:
> > It looks like we currently never grow the variable-width nlink array
> > if only the on-disk nlink size overflows 8 bits.  This leads to a major
> > mess in nlink counting, and eventually an assert in phase7.
> > 
> > Replace the indirect all mess with a union that allows doing proper
> > array arithmetics while we're at it.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This looks good to me.  I enjoyed the fallthrus in set_inode_disk_nlinks
> and add_inode_ref.
> 
> I haven't tested with this many links though... Are there any xfstests
> that would exercise this?

There is none yet.  I've tested it with Arekm's test metadump, which
I've added to my nasty images collection.  I'll create a testcase
reproducing this artifically.

> On my machine test 030 has regressed.  It passed on 3.1.7.

That's an older change.  I have a fix in my local tree, but it needs
polishing so that it still works with older repair versions.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
