Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40210 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753504AbdHKQG7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Aug 2017 12:06:59 -0400
Date: Fri, 11 Aug 2017 18:06:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: fix integer truncation issues in the zeroing
        and dirtying helpers
Message-ID: <20170811160658.GA8956@lst.de>
References: <20170811151805.22896-1-hch@lst.de> <20170811160443.GA24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811160443.GA24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, pmenzel@molgen.mpg.de, stockhausen@collogia.de

On Fri, Aug 11, 2017 at 09:04:43AM -0700, Darrick J. Wong wrote:
> Looks fine to me,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> (Are you going to push this to Al yourself, or do you want me to drag it
> through the xfs tree?)

In general we've maintained iomap.c through the XFS tree so far.
I think it's easiest to stick to that.
