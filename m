Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124A7C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 22:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E13A221848
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 22:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731167AbfIRWZT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 18:25:19 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56846 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730983AbfIRWZT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 18:25:19 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E6F0D43E455;
        Thu, 19 Sep 2019 08:25:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iAiNt-0002jo-1c; Thu, 19 Sep 2019 08:25:13 +1000
Date:   Thu, 19 Sep 2019 08:25:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove xfs_release
Message-ID: <20190918222513.GB16973@dread.disaster.area>
References: <20190916122041.24636-1-hch@lst.de>
 <20190916122041.24636-2-hch@lst.de>
 <20190916125311.GB41978@bfoster>
 <20190918164938.GA19316@lst.de>
 <20190918181204.GG29377@bfoster>
 <20190918182135.GO2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918182135.GO2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=UTMiwzgd9FDPotHWpxsA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 11:21:35AM -0700, Darrick J. Wong wrote:
> On Wed, Sep 18, 2019 at 02:12:04PM -0400, Brian Foster wrote:
> > On Wed, Sep 18, 2019 at 06:49:38PM +0200, Christoph Hellwig wrote:
> > > On Mon, Sep 16, 2019 at 08:53:11AM -0400, Brian Foster wrote:
> > > > The caller might not care if this call generates errors, but shouldn't
> > > > we care if something fails? IOW, perhaps we should have an exit path
> > > > with a WARN_ON_ONCE() or some such to indicate that an unhandled error
> > > > has occurred..?
> > > 
> > > Not sure there is much of a point.  Basically all errors are either
> > > due to a forced shutdown or cause a forced shutdown anyway, so we'll
> > > already get warnings.
> > 
> > Well, what's the point of this change in the first place? I see various
> > error paths that aren't directly related to shutdown. A writeback
> > submission error for instance looks like it will warn, but not
> > necessarily shut down (and the filemap_flush() call is already within a
> > !XFS_FORCED_SHUTDOWN() check). So not all errors are associated with or
> > cause shutdown. I suppose you could audit the various error paths that
> > lead back into this function and document that further if you really
> > wanted to go that route...
> 
> I agree with Brian, there ought to be some kind of warning that some
> error happened with inode XXX even if we do end up shutting down
> immediately afterwards.

FWIW, we have precedence for that - see xfs_inactive_ifree(), which
logs errors noisily because we can't return errors to the VFS inode
teardown path (i.e. evict -> destroy_inode -> xfs_fs_destroy_inode
-> xfs_inactive path).

These were originally added because a static error return checker
flagged xfs_inactive() as a place where errors were silently ignored
and users had no indication that somethign bad had happened to their
file. -> release -> xfs_file_release -> xfs_release is no different
in this respect....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
