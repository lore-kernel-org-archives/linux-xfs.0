Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37828 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754521AbdHYHpj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 03:45:39 -0400
Date: Fri, 25 Aug 2017 00:45:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs/xfs/kmem.c: fix coding style, using 'unsigned int'
 instead of 'unsigned'
Message-ID: <20170825074538.GA26995@infradead.org>
References: <20170825052659.GA11087@fubar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825052659.GA11087@fubar>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Achilles Gaikwad <achillesgaikwad@gmail.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On Fri, Aug 25, 2017 at 10:56:59AM +0530, Achilles Gaikwad wrote:
> Fixes a warning given by checkpatch.pl to use 'unsigned int'
> instead of just 'unsigned'.
> 
> WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
> +	unsigned nofs_flag = 0;

NAK.  This is churn for a totally pointless warnings - there is
not quantifiable benefit of 'unsigned int' which unigned has one
clear advantage: it's shorter.
