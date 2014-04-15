Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 95FBB7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:51:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47CDFAC002
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 10:51:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id bKKR43tOUuO29iyv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 10:51:30 -0700 (PDT)
Date: Tue, 15 Apr 2014 10:51:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 4/4] xfs: fold xfs_create_tmpfile() into xfs_create()
Message-ID: <20140415175130.GD26404@infradead.org>
References: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
	<1397578706-5385-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397578706-5385-5-git-send-email-bfoster@redhat.com>
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

On Tue, Apr 15, 2014 at 12:18:26PM -0400, Brian Foster wrote:
> xfs_create_tmpfile() duplicates most of xfs_create() with the exception
> of a couple minor differences. We use a unique transaction reservation
> and place the allocated inode on the unlinked list rather than create a
> directory entry for it.
> 
> Fold xfs_create_tmpfile() into xfs_create() to reduce some of this
> duplication. The name parameter that represents the name of the
> directory entry to create is now conditional and its existence dictates
> whether a directory entry is created for the inode or not.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks correct although I still can't get excited about it..

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
