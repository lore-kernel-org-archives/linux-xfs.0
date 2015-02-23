Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B2E2E7F50
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 14:48:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3454AAC004
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 12:48:39 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id QYBhwJZUxG23Ol4g (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 12:48:37 -0800 (PST)
Date: Mon, 23 Feb 2015 12:48:36 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: cancel failed transaction in
	xfs_fs_commit_blocks()
Message-ID: <20150223204836.GB13522@infradead.org>
References: <54EB782F.8020201@redhat.com>
 <54EB78CB.6050709@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54EB78CB.6050709@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 23, 2015 at 01:00:27PM -0600, Eric Sandeen wrote:
> If xfs_trans_reserve fails we don't cancel the transaction,
> and we'll leak the allocated transaction pointer.
> 
> Spotted by Coverity.

Thanks, looks good.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
