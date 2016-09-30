Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50971 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751420AbcI3I11 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:27:27 -0400
Date: Fri, 30 Sep 2016 01:27:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 59/63] xfs: simulate per-AG reservations being critically
 low
Message-ID: <20160930082727.GL32335@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520512357.29434.13990134651991752941.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520512357.29434.13990134651991752941.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:12:03PM -0700, Darrick J. Wong wrote:
> Create an error injection point that enables us to simulate being
> critically low on per-AG block reservations.  This should enable us to
> simulate this specific ENOSPC condition so that we can test falling back
> to a regular file copy.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
