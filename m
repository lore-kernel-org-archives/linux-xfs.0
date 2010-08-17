Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7H92vKM038234 for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 04:02:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 954766F4
	for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 02:03:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Z5pBRH5XPGZw71Eo for
	<xfs@oss.sgi.com>; Tue, 17 Aug 2010 02:03:26 -0700 (PDT)
Date: Tue, 17 Aug 2010 05:03:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsdump-3.0.4 problems
Message-ID: <20100817090319.GB1294@infradead.org>
References: <20100816182236.249a2a0f@x2.grafnetz>
	<20100816223021.GL10429@dastard>
	<20100817083227.06e23889@x2.grafnetz>
	<20100817071337.GN10429@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100817071337.GN10429@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mario Bachmann <mbachman@stud.uni-frankfurt.de>, xfs@oss.sgi.com

On Tue, Aug 17, 2010 at 05:13:37PM +1000, Dave Chinner wrote:
> > Testing List (on one machine only):
> > works:   x86_64, 2.6.34.4, xfsdump-3.0.1
> > works:   x86_64, 2.6.34.4, xfsdump-3.0.4
> > failure: x86_64, 2.6.35.2, xfsdump-3.0.1 (worked only one time)
> > failure: x86_64, 2.6.35.2, xfsdump-3.0.4
> 
> Ok, that makes more sense - we changed the way bulkstat works in
> from 2.6.34 to 2.6.35 to correctly validate inode numbers being
> passed in via bulkstat, and hence files unlinked during the dump run
> could return EINVAL when validating the directory structure (as they
> no longer exist). Is you system completely idle while the dump
> is running, or are files being removed while the dump is running?

I've also seen related issues in xfstests recently, but even going all
the way back to kernel 2.6.34 does not solve all of them for me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
