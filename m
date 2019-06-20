Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57887 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbfFTGJ2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 02:09:28 -0400
Date: Thu, 20 Jun 2019 08:08:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/20] xfs: move the log ioend workqueue to struct xlog
Message-ID: <20190620060858.GB20437@lst.de>
References: <20190603172945.13819-1-hch@lst.de> <20190603172945.13819-15-hch@lst.de> <20190619121908.GA11894@lst.de> <20190619225136.GU5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619225136.GU5387@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jun 19, 2019 at 03:51:36PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 19, 2019 at 02:19:08PM +0200, Christoph Hellwig wrote:
> > The build/test bot found an issue with this one leading to crashes
> > at unmount, and I think this incremental patch should fix it:
> 
> I have't see any crashes at unmount; would you mind sharing the report?

I'll forward you the report I got from the test bot.
