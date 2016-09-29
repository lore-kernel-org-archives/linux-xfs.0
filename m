Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52004 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932469AbcI2Qsg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 12:48:36 -0400
Date: Thu, 29 Sep 2016 09:48:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/63] xfs: return an error when an inline directory is
 too small
Message-ID: <20160929164835.GB4546@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503122305.30303.17555276635568155992.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147503122305.30303.17555276635568155992.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>

On Tue, Sep 27, 2016 at 07:53:43PM -0700, Darrick J. Wong wrote:
> If the size of an inline directory is so small that it doesn't
> even cover the required header size, return an error to userspace
> instead of ASSERTing and returning 0 like everything's ok.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Jan Kara <jack@suse.cz>

Doesn't really belong into this series, but otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
