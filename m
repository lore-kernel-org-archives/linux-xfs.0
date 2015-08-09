Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0D3BF29DF5
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 03:03:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8F02EAC008
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 01:03:39 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gqos4upuRWj8nrjO (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Aug 2015 01:03:37 -0700 (PDT)
Date: Sun, 9 Aug 2015 01:03:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/11] xfs: fix btree cursor error cleanups
Message-ID: <20150809080337.GC4253@infradead.org>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-12-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438883072-28706-12-git-send-email-bfoster@redhat.com>
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

On Thu, Aug 06, 2015 at 01:44:32PM -0400, Brian Foster wrote:
> The btree cursor cleanup function takes an error parameter that affects
> how buffers are released from the cursor. All buffers are released in
> the event of error. Several callers do not specify the XFS_BTREE_ERROR
> flag in the event of error, however. This can cause buffers to hang
> around locked or with an elevated hold count and thus lead to umount
> hangs in the event of errors.
> 
> Fix up the xfs_btree_del_cursor() callers to pass XFS_BTREE_ERROR if the
> cursor is being torn down due to error.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

I wonder if we should change the second parameter of
xfs_btree_del_cursor to "int error" to make the life esier for the
callers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
