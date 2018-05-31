Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36643 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753825AbeEaG6A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 02:58:00 -0400
Date: Thu, 31 May 2018 09:04:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/18] xfs: do not set the page uptodate in
        xfs_writepage_map
Message-ID: <20180531070426.GB32051@lst.de>
References: <20180530100013.31358-1-hch@lst.de> <20180530100013.31358-18-hch@lst.de> <20180530180839.GU837@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530180839.GU837@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 11:08:39AM -0700, Darrick J. Wong wrote:
> > and isn't present in other writepage implementations.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks ok, assuming that reads or buffered writes set the page
> uptodate...

Reads have to by definition, as do buffered writes that bring in
data / overwrite data.
