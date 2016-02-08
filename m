Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E67EA7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 03:31:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D602A304043
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 01:31:52 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4ddUpSD1UfkxQzu0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 01:31:51 -0800 (PST)
Date: Mon, 8 Feb 2016 01:31:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] xfs: move v1 inode conversion to xfs_inode_from_disk
Message-ID: <20160208093150.GD28146@infradead.org>
References: <1454905461-2773-1-git-send-email-david@fromorbit.com>
	<1454905461-2773-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454905461-2773-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Shouldn't we be able to kill off di_version as well?  version 3 inodes
only happen on crc enabled file systems, and version 2 only on
version 4 file systems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
