Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 480A17F5E
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 15:02:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 36D22304097
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 13:02:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 054YZJsZZli4fWhR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 13:02:00 -0800 (PST)
Date: Thu, 5 Dec 2013 13:01:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: use xfs_ilock_map_shared in xfs_attr_get
Message-ID: <20131205210159.GA30318@infradead.org>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.679310054@bombadil.infradead.org>
	<20131205205910.GD29897@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205205910.GD29897@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 07:59:10AM +1100, Dave Chinner wrote:
> I think the locking here should be moved inside xfs_attr_get_int()

Or we could just kill xfs_attr_get_int..

> so that it uses the same locking pattern as xfs_attr_set() and
> xfs_attr_remove().
> 
> Also, xfs_attr_list() needs this treatment (the attr version of
> readdir) as well (and it has the locking inside xfs_attr_list_int(),
> too ;).
>
> It looks like xfs_readlink needs fixing, too.

Haven't really done an in-depth audit, mostly just looking at
where the asserts kick in..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
