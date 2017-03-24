Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41652 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752310AbdCXKb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Mar 2017 06:31:57 -0400
Date: Fri, 24 Mar 2017 03:31:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Request 5c6863019e45 ("cancel the setfilesize transation when io
 error happen") for 3.12 stable inclusion
Message-ID: <20170324103155.GA4234@infradead.org>
References: <48c85015-5520-bd42-dca7-cfb9634dcc39@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48c85015-5520-bd42-dca7-cfb9634dcc39@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, bfoster@redhat.com, david@fromorbit.com

On Thu, Mar 23, 2017 at 05:19:56PM +0200, Nikolay Borisov wrote:
> Hello,
> 
> 
> I'd like to request the above patch be included into the 3.12 stable
> tree. I've attached a backport and have run xfstest and no regressions
> were observed. This fixes hang in generic/361 test.

The backport looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
