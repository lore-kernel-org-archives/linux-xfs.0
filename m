Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39701 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752915AbdICP40 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 3 Sep 2017 11:56:26 -0400
Date: Sun, 3 Sep 2017 17:56:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: test getbmap on reflinked files
Message-ID: <20170903155625.GA30509@lst.de>
References: <20170903121451.GA18274@lst.de> <20170903155415.GH4073@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903155415.GH4073@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 08:54:15AM -0700, Darrick J. Wong wrote:
> On Sun, Sep 03, 2017 at 02:14:51PM +0200, Christoph Hellwig wrote:
> > Test that we correctly report shared and unshared regions in a file.
> > 
> > To do so we also update _filter_bmap to include the shared flag.
> > 
> > Based on a test case from Darrick Wong.
> 
> Which test case is that?
> 
> Mostly I'm wondering how does this differ from xfs/280?

The one that you posted in reply to the getbmap patch.

It looks like that one is similar but doesn't look at the
detail shared vs unshared layout.
