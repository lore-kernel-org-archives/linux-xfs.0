Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7IH7UFW153456 for <xfs@oss.sgi.com>; Tue, 18 Aug 2009 12:07:40 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90F713DC94C
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2009 10:08:10 -0700 (PDT)
Received: from thunker.thunk.org (THUNK.ORG [69.25.196.29]) by cuda.sgi.com
	with ESMTP id JF6lgaSncA095bxW for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2009 10:08:10 -0700 (PDT)
Date: Tue, 18 Aug 2009 13:04:56 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Add ext2/3/4-specific _check_extN_filesystem function
Message-ID: <20090818170456.GF28560@mit.edu>
References: <1250607467-15085-1-git-send-email-tytso@mit.edu>
	<20090818161116.GA2162@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090818161116.GA2162@infradead.org>
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

On Tue, Aug 18, 2009 at 12:11:16PM -0400, Christoph Hellwig wrote:
> On Tue, Aug 18, 2009 at 10:57:47AM -0400, Theodore Ts'o wrote:
> > The _check_generic_filesystem function doesn't force a full filesystem
> > check, so filesystem inconsistencies after a test wouldn't be noticed.
> > To fix this, I added an extN specific check filesystem function.
> 
> Looks like the only difference between the generic and the extN
> check routine is the addition of -f to the fsck command line.  What
> about just introducing a _fsck_args similar to _mount_opts where
> filesystems can set their additional required mount options?

That would work, yeah, and would be result in far less code
duplication in common.rc.  I'll take a whack at it and resubmit.

Thanks,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
