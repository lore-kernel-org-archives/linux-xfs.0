Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42425 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752524AbcKCQKW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Nov 2016 12:10:22 -0400
Date: Thu, 3 Nov 2016 17:10:20 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] allow enabling reflinks at runtime
Message-ID: <20161103161020.GA18032@lst.de>
References: <1464877150-20457-1-git-send-email-hch@lst.de> <20161026204940.GA32036@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026204940.GA32036@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

On Wed, Oct 26, 2016 at 01:49:40PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 02, 2016 at 04:19:07PM +0200, Christoph Hellwig wrote:
> > I've had some vocal user requests to allow enabling reflinks at run time,
> > which happens to be a mostly trivial feature.  The only caveat is that we
> > need a large enough log size to support the reflink requirements, but for
> > typical large file systems that's not an issue.
> 
> Just out of curiosity, are we still interested in this feature?
> A few people were asking on the irc channel today.

I still think it is useful, but it's dropped to the bottom of my priority
list as my customer found another way to deploy the feature.  So don't
expect a new version from me anytime soon.
