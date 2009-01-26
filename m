Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0QMNjCd258255 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 16:23:46 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E94FAC00F
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 14:23:03 -0800 (PST)
Message-Id: <A6AA2321-2556-4376-A5D7-60F125EA66CC@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090126073200.781644000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 04/17] xfs: tiny cleanup for xfs_link
Date: Mon, 26 Jan 2009 16:23:02 -0600
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073200.781644000@bombadil.infradead.org>
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

> The source and target inodes are guaranteed to never be the same by  
> the VFS,
> so no need to check for that (and we would get into bad trouble  
> later anyway
> if that were the case).  Also clean up the error handling to use two  
> gotos
> instead of nested conditions.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
