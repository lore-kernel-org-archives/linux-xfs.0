Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Feb 2007 09:58:10 -0800 (PST)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l17Hw2m7016092
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 09:58:03 -0800
Message-ID: <45CA1327.2030005@sgi.com>
Date: Wed, 07 Feb 2007 17:57:59 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] fix sparse warning in xfs_da_btree.c
References: <20061129154441.GA6400@lst.de> <20070207125437.GA7740@lst.de>
In-Reply-To: <20070207125437.GA7740@lst.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph,

I merged this change a while ago but it looks like the take message
didn't make it to oss.

mod xfs-linux-melb:xfs-kern:27702a TAKE message
================================================
Subject: TAKE 954580 -

fix sparse warning in xfs_da_btree.c

Date:  Tue Dec 12 13:15:55 AEDT 2006
Workarea:  vpn-emea-sw-emea-160-4.emea.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
   longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27702a
fs/xfs/xfs_da_btree.c - 1.173 - changed

Lachlan

Christoph Hellwig wrote:
> On Wed, Nov 29, 2006 at 04:44:41PM +0100, Christoph Hellwig wrote:
> 
>>The first use in xfs_da_node_lookup_int would have to be __be32.
>>But we can just remove this temporary variable use completely and
>>make sparse happy.  The variable is used later in the function for
>>a native endian variable so we'll have to keep it.
> 
> 
> ping?
> 
> 
>>
>>Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>>diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
>>index a68bc1f..cccf69e 100644
>>--- a/fs/xfs/xfs_da_btree.c
>>+++ b/fs/xfs/xfs_da_btree.c
>>@@ -1090,8 +1090,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *s
>> 		if (blk->magic == XFS_DA_NODE_MAGIC) {
>> 			node = blk->bp->data;
>> 			max = be16_to_cpu(node->hdr.count);
>>-			btreehashval = node->btree[max-1].hashval;
>>-			blk->hashval = be32_to_cpu(btreehashval);
>>+			blk->hashval = be32_to_cpu(node->btree[max-1].hashval);
>> 
>> 			/*
>> 			 * Binary search.  (note: small blocks will skip loop)
> 
> ---end quoted text---
> 
> 
