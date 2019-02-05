Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43138 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbfBER5E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Feb 2019 12:57:04 -0500
Date: Tue, 5 Feb 2019 09:57:02 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/10] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190205175702.GA5951@infradead.org>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930320519.31814.7868551876308474527.stgit@magnolia>
 <20190205142458.GD51421@bfoster>
 <20190205175309.GJ7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205175309.GJ7991@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Feb 05, 2019 at 09:53:09AM -0800, Darrick J. Wong wrote:
> Good point, we could be much more resilient to backref cache failures
> since we do have the option of doing it the slow way.

I don't think there is any failure that can happen during normal
operation as long as we use KM_SLEEP..
