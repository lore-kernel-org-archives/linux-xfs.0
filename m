Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D0FB7F55
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 05:01:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8152F30404E
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 03:01:43 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id pjAvHE6BJIi5jq4d (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 03:01:38 -0700 (PDT)
Date: Fri, 2 May 2014 03:01:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: initialize default acls for ->tmpfile()
Message-ID: <20140502100138.GA14028@infradead.org>
References: <1398951487-15462-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398951487-15462-1-git-send-email-bfoster@redhat.com>
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

On Thu, May 01, 2014 at 09:38:07AM -0400, Brian Foster wrote:
> The current tmpfile handler does not initialize default ACLs. Doing so
> within xfs_vn_tmpfile() makes it roughly equivalent to xfs_vn_mknod(),
> which is already used as a common create handler.
> 
> xfs_vn_mknod() does not currently have a mechanism to determine whether
> to link the file into the namespace. Therefore, further abstract
> xfs_vn_mknod() into a new xfs_generic_create() handler with a tmpfile
> parameter. This new handler passes a NULL xname to the create and calls
> d_tmpfile() on the dentry when called via ->tmpfile().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
