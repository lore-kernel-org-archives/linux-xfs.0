Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59103 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751368AbcJJKYU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 06:24:20 -0400
Date: Mon, 10 Oct 2016 03:24:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/7] xfs: clear reflink flag if setting realtime flag
Message-ID: <20161010102418.GG18359@infradead.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588168294.12127.1609759616316145097.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147588168294.12127.1609759616316145097.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Fri, Oct 07, 2016 at 04:08:03PM -0700, Darrick J. Wong wrote:
> Since we can only turn on the rt flag if there are no data extents,
> we can safely turn off the reflink flag if the rt flag is being
> turned on.

Why would the reflink flag ever be turned on if we have no data extents?
