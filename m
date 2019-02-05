Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfBESRs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Feb 2019 13:17:48 -0500
Date: Tue, 5 Feb 2019 10:17:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/10] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190205181733.GK7991@magnolia>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930320519.31814.7868551876308474527.stgit@magnolia>
 <20190205142458.GD51421@bfoster>
 <20190205175309.GJ7991@magnolia>
 <20190205175702.GA5951@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205175702.GA5951@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Feb 05, 2019 at 09:57:02AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 05, 2019 at 09:53:09AM -0800, Darrick J. Wong wrote:
> > Good point, we could be much more resilient to backref cache failures
> > since we do have the option of doing it the slow way.
> 
> I don't think there is any failure that can happen during normal
> operation as long as we use KM_SLEEP..

I dug even deeper into the rhashtable code it looks like it can fail a
GFP_ATOMIC allocation for new buckets, which will bubble ENOMEM up to
the caller, so Brian's right that we have to handle various errors, and
should do so in a manner that doesn't kill the filesystem.

Seeing as it's a backref cache and not critical to correct operation, I
think I can change add_backref to ignore errors other than EEXIST
(because having duplicate entries is a sign that we've screwed something
up).  change_backref can absorb all the error codes, though it'll have
to handle the case that lookup_fast returns ENOENT.

--D
