Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdALNxy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2017 08:53:54 -0500
Date: Thu, 12 Jan 2017 05:53:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs_io: prefix dedupe command error messages
 consistently
Message-ID: <20170112135352.GC5756@infradead.org>
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
 <148419040712.32674.16288936788225568096.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148419040712.32674.16288936788225568096.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 07:06:47PM -0800, Darrick J. Wong wrote:
> Prefix the perror output of the dedupe command consistently.  All the
> other perror calls reference the ioctl name directly, so we might as
> well do that for all the dedupe cases.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
