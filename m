Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0RHcHgx063058 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 11:38:17 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5C6530407E
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 09:37:32 -0800 (PST)
Message-Id: <DA349E86-62A1-46A3-ADF0-7519EE941DEB@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090126073202.588218000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 11/17] xfs: merge xfs_inode_flush into xfs_fs_write_inode
Date: Tue, 27 Jan 2009 11:37:31 -0600
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073202.588218000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Jan 26, 2009, at 1:31 AM, Christoph Hellwig wrote:

> Spliting the task for a VFS-induced inode flush into two functions  
> doesn't
> make any sense, so merge the two functions dealing with it.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems like nothing is taken or added, just the merge of two
functions. Looks good.

Reviewed-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
