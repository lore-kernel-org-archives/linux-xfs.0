Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43520 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753416AbdLNQ7t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 11:59:49 -0500
Date: Thu, 14 Dec 2017 08:57:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/5] xfs: add the ability to join a held buffer to a
 defer_ops
Message-ID: <20171214165719.GT19219@magnolia>
References: <151270433736.12194.14709247629624139846.stgit@magnolia>
 <151270434945.12194.16466347732765177795.stgit@magnolia>
 <20171214164220.GH32616@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171214164220.GH32616@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, libor.klepac@bcom.cz, bfoster@redhat.com, alex@zadarastorage.com, david@fromorbit.com

On Thu, Dec 14, 2017 at 08:42:20AM -0800, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Although I wonder if for both inodes and buffers we eventually
> want lists instead of arrays to hold the attached objects.

We will if we ever want more than two inodes/buffers held per dfops, but
for now it doesn't seem necessary (and has the same overhead for the
dfops as a list_head).

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
