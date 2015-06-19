Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 410597F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 10:14:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE2DDAC001
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:14:22 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 5hzv3qfm13f6YHc4 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 08:14:21 -0700 (PDT)
Date: Fri, 19 Jun 2015 08:14:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: don't truncate attribute extents if no extents
	exist
Message-ID: <20150619151421.GC22842@infradead.org>
References: <1434631741-50856-1-git-send-email-bfoster@redhat.com>
	<1434631741-50856-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1434631741-50856-2-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

> A '-p 2' fsstress run to ENOSPC on a relatively small fs (1GB)
> reproduces these problems.

Any chance to add this test case to xfstests?

>  	/* invalidate and truncate the attribute fork extents */
> -	if (dp->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
> +	if (xfs_inode_hasattr(dp) &&
> +	    dp->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {

And please add a comment describing the condition here, especially
as xfs_inode_hasattr doesn't have a very descriptive name.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
