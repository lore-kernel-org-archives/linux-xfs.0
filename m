Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57446 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750821AbeDQHJ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 03:09:57 -0400
Date: Tue, 17 Apr 2018 00:09:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: prevent creating negative-sized file via
 INSERT_RANGE
Message-ID: <20180417070956.GA18079@infradead.org>
References: <20180416204630.177682-1-ebiggers3@gmail.com>
 <20180417005218.GC5203@magnolia>
 <20180417053907.GE5203@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417053907.GE5203@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

>  	} else if (mode & FALLOC_FL_INSERT_RANGE) {
>  		unsigned int blksize_mask = i_blocksize(inode) - 1;
> +		loff_t		isize;
>  
> +		isize = i_size_read(inode);

Maybe move the assignment up:

		
		loff_t		isize = i_size_read(inode);

But functionally this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
