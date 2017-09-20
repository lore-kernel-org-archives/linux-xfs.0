Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27679 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751729AbdITRDJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 13:03:09 -0400
Date: Wed, 20 Sep 2017 10:03:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: rewrite getbmap using the xfs_iext_* helpers
Message-ID: <20170920170301.GF7112@magnolia>
References: <20170918152630.24592-1-hch@lst.de>
 <20170918152630.24592-2-hch@lst.de>
 <20170920132318.GB16481@bfoster.bfoster>
 <20170920144130.GA3610@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920144130.GA3610@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Sep 20, 2017 at 04:41:30PM +0200, Christoph Hellwig wrote:
> On Wed, Sep 20, 2017 at 09:23:18AM -0400, Brian Foster wrote:
> > I couldn't quite tell from your previous response, so just to be sure...
> > is the expectation to set BMV_OF_LAST on the last real extent of the
> > file, even though we might report a hole entry just below the file ends
> > with a hole? If so, this seems fine:
> 
> Yes.  That's what the old code does.  Note that there isn't anything
> in xfsprogs or xfstests that ever looks at BMV_OF_LAST to start with.

FWIW xfs_scrub tool has a phase that reads all the file data blocks
(having sorted them in disk order) to look for read errors, and uses
nftw+bmap to map bad blocks back to (file path, offset).  So long as
there are never any real extents returned after the BMV_OF_LAST record,
this semantic is fine...

(Will try to review this series and the one before it today.)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
