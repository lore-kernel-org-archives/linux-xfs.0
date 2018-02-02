Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48423 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751625AbeBBJvc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 04:51:32 -0500
Date: Fri, 2 Feb 2018 01:51:31 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't allow DAX on reflink filesystems
Message-ID: <20180202095131.GB17952@infradead.org>
References: <20180131222324.GH4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180131222324.GH4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>

On Wed, Jan 31, 2018 at 02:23:24PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that reflink is no longer experimental, reject attempts to mount
> with DAX until that whole mess gets sorted out.

Didn't I send exactly the same patch about a week ago?
