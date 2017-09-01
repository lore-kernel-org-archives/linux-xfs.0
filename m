Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60286 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752451AbdIATsD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 15:48:03 -0400
Date: Fri, 1 Sep 2017 12:48:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] xfs: fix compiler warnings
Message-ID: <20170901194803.GA3615@infradead.org>
References: <20170901171327.GG3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901171327.GG3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>

On Fri, Sep 01, 2017 at 10:13:27AM -0700, Darrick J. Wong wrote:
> Fix up all the compiler warnings that have crept in.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: fix everything that comes up with a W=1 build
> v2: get more aggressive with the refactoring variables out

Looks ok (ok because I don't like the ifdef mess, but lets fix the
warnings for now..)

Reviewed-by: Christoph Hellwig <hch@lst.de>
