Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42306 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfBEHHx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Feb 2019 02:07:53 -0500
Date: Mon, 4 Feb 2019 23:07:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/10] xfs: track unlinked inode counts in per-ag data
Message-ID: <20190205070738.GI7991@magnolia>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930315478.31814.9792968910867944759.stgit@magnolia>
 <20190204192451.GB47560@bfoster>
 <20190204205310.GB30334@infradead.org>
 <20190205002638.GE7991@magnolia>
 <20190205065518.GA1868@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205065518.GA1868@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 10:55:18PM -0800, Christoph Hellwig wrote:
> On Mon, Feb 04, 2019 at 04:26:38PM -0800, Darrick J. Wong wrote:
> > I decided to leave the unlinked counter so that we could have a
> > debugging check.  I will make it more explicit that anyone accessing the
> > counter needs to hold the AGI buffer lock or otherwise assured that
> > there aren't any other threads.
> 
> Don'we already have a debug check by the fact that the rhashtable
> destroy function throws an assert if it finds anything?

Yes.  If we're maintaining the backrefs correctly then we should never
have any left over and presumably we shouldn't ever need to fall back to
the bucket walk.

Ok, dropped.

--D
