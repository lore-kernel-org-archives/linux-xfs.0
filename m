Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53214 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfBEGzU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Feb 2019 01:55:20 -0500
Date: Mon, 4 Feb 2019 22:55:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/10] xfs: track unlinked inode counts in per-ag data
Message-ID: <20190205065518.GA1868@infradead.org>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930315478.31814.9792968910867944759.stgit@magnolia>
 <20190204192451.GB47560@bfoster>
 <20190204205310.GB30334@infradead.org>
 <20190205002638.GE7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205002638.GE7991@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 04:26:38PM -0800, Darrick J. Wong wrote:
> I decided to leave the unlinked counter so that we could have a
> debugging check.  I will make it more explicit that anyone accessing the
> counter needs to hold the AGI buffer lock or otherwise assured that
> there aren't any other threads.

Don'we already have a debug check by the fact that the rhashtable
destroy function throws an assert if it finds anything?
