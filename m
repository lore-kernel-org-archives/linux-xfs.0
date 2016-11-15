Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51882 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755600AbcKOKOD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:14:03 -0500
Date: Tue, 15 Nov 2016 02:14:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/16] xfs_repair: fix some potential null pointer
 deferences
Message-ID: <20161115101400.GA1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830448375.26713.12061252375252670165.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830448375.26713.12061252375252670165.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:08:03PM -0700, Darrick J. Wong wrote:
> Fix some potential NULL pointer deferences that Coverity pointed out,
> and remove a trivial dead integer check.
> 
> Coverity-id: 1375789, 1375790, 1375791, 1375792
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
