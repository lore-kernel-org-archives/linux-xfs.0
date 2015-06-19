Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C13A7F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 10:45:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88EE0304032
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:45:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pXCvtZGIsBUxcQ7E (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 08:45:25 -0700 (PDT)
Date: Fri, 19 Jun 2015 11:45:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: don't truncate attribute extents if no extents
	exist
Message-ID: <20150619154522.GH12833@bfoster.bfoster>
References: <1434631741-50856-1-git-send-email-bfoster@redhat.com>
	<1434631741-50856-2-git-send-email-bfoster@redhat.com>
	<20150619151421.GC22842@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150619151421.GC22842@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jun 19, 2015 at 08:14:21AM -0700, Christoph Hellwig wrote:
> > A '-p 2' fsstress run to ENOSPC on a relatively small fs (1GB)
> > reproduces these problems.
> 
> Any chance to add this test case to xfstests?
> 

I think so. I'll look into it.

> >  	/* invalidate and truncate the attribute fork extents */
> > -	if (dp->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
> > +	if (xfs_inode_hasattr(dp) &&
> > +	    dp->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
> 
> And please add a comment describing the condition here, especially
> as xfs_inode_hasattr doesn't have a very descriptive name.
> 

How about this?

        /*
         * Invalidate and truncate the attribute fork extents. Make sure the
         * fork actually has attributes as otherwise the invalidation has no
         * blocks to read and returns an error. In this case, just do the fork
         * removal below.
         */

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
