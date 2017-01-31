Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47089 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752482AbdAaNln (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2017 08:41:43 -0500
Date: Tue, 31 Jan 2017 05:41:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/7] xfs: mark speculative prealloc CoW fork extents
 unwritten
Message-ID: <20170131134135.GA10866@infradead.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582223303.12293.11053073799262731296.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148582223303.12293.11053073799262731296.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Hi Darrick,

from a quick look the code looks reasonable, but I'm worried about
yet another set of transactions that modify all extents again.

Do you have any measurements of the overhead?  I'll see if I
can prototype my always COW idea to see how the approaches compare.
