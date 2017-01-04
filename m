Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40543 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935538AbdADIuw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 03:50:52 -0500
Date: Wed, 4 Jan 2017 09:50:50 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] xfs: fix bogus minleft manipulations
Message-ID: <20170104085050.GA17788@lst.de>
References: <1481644767-9098-1-git-send-email-hch@lst.de> <1481644767-9098-2-git-send-email-hch@lst.de> <20161215220938.GV4219@dastard> <20161216082044.GB32288@lst.de> <20170104063239.GF14031@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170104063239.GF14031@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, eguan@redhat.com

> > Yes.  And I actually had that in a previous iteration, and it got
> > dropped at some point.
> 
> I see the diff hunk in question hasn't changed in the v2 patchset...
> Did Dave's suggestion not work?

We don't need it anymore.  The previous iteration set minleft to the
worst case indirect blocks for the requested extent length.  This series
instead sticks to the old minleft value for just a single extent
allocation and thus doesn't need the fallback as the minleft value
can't get any smaller.
