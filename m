Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7QMBE8G046263 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 17:11:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 830A1154E78D
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 15:12:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7jzg2vqXFbDc1O12 for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2009 15:12:06 -0700 (PDT)
Date: Wed, 26 Aug 2009 18:12:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add ext2/3/4-specific _check_extN_filesystem function
Message-ID: <20090826221201.GC18119@infradead.org>
References: <1250607467-15085-1-git-send-email-tytso@mit.edu>
	<20090818161116.GA2162@infradead.org>
	<20090818170456.GF28560@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090818170456.GF28560@mit.edu>
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
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Aug 18, 2009 at 01:04:56PM -0400, Theodore Tso wrote:
> > Looks like the only difference between the generic and the extN
> > check routine is the addition of -f to the fsck command line.  What
> > about just introducing a _fsck_args similar to _mount_opts where
> > filesystems can set their additional required mount options?
> 
> That would work, yeah, and would be result in far less code
> duplication in common.rc.  I'll take a whack at it and resubmit.

Are you still going to look at it realtively soon?  If not I'll just
put this version in to imrove the test coverage on extN and we can
clean it up later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
