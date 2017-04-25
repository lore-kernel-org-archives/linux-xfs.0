Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56765 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S980459AbdDYHgJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Apr 2017 03:36:09 -0400
Date: Tue, 25 Apr 2017 00:36:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Deadlock between block allocation and block truncation
Message-ID: <20170425073608.GA7311@infradead.org>
References: <800468eb-3ded-9166-20a4-047de8018582@gmail.com>
 <20170412161017.GA16590@infradead.org>
 <af73ca2f-5840-1399-9902-8f7482e29e49@gmail.com>
 <20170414074244.GA18519@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170414074244.GA18519@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

FYI, I've been testing with the patch quite a bit and it seems to
be doing fine.

But I fear it's not the complete fix:  if we do truncates, hole
punches or other complicated operations the bmap btree blocks
might be from different AGs than the data blocks and we could
still run into these issues in theory.  So I fear we might have
to come up with a solution where we roll into a new chained transaction
everytime we encounter a new AG instead.
