Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24195 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752601AbdF2SsB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2017 14:48:01 -0400
Date: Thu, 29 Jun 2017 11:47:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: lseek SEEK_HOLE / SEEK_DATA fixes and switch to iomap V3.2-hch
Message-ID: <20170629184751.GH5874@birch.djwong.org>
References: <20170629135420.21357-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170629135420.21357-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Jun 29, 2017 at 06:54:15AM -0700, Christoph Hellwig wrote:
> Here is my take on all the current seek work.  It has my XFS quota changes

I think the quota change patch fell out of this series, but I can grab
it from the previous iteration if it hasn't changed.

--D

> (unmodified from last post), Andrea's page cache seek helper (unmodified
> except that the export is dropped), and Andreas iomap SEEK_HOLE / DATA,
> for which I've added a couple of cleanups and converted ext4 as well.
> 
> I've made sure both xfs and ext4 pass all the xfstests.
> 
> Changes since the previous posting:
>  - trivial cleanups of the iomap helper
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
