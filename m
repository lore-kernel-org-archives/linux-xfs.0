Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0UFUZad035149 for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 09:30:36 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 40D0DAC012
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 07:29:52 -0800 (PST)
Message-Id: <E7AB9F45-E23D-4BD9-8A47-9EC410CFD392@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090130074714.GA30377@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfs_db: exit on invalid magic number
Date: Fri, 30 Jan 2009 09:29:50 -0600
References: <20090130074714.GA30377@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Jan 30, 2009, at 1:47 AM, Christoph Hellwig wrote:

> Fail gracefully and with a useful error message when we detect an
> invalid superblock magic in xfs_db.  Add a new -F flag to continue
> when seeing the invalid magic number - that way xfs_check and
> xfs_metadump can be used on a filesystem that has a corrupted primary
> superblock.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
