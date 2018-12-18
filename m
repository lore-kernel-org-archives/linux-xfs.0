Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43332 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbeLRST2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 13:19:28 -0500
Date: Tue, 18 Dec 2018 10:19:20 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] iomap: use SECTOR_SIZE instead of 512 in iomap_page
Message-ID: <20181218181920.GA27208@magnolia>
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
 <1544739929-21651-2-git-send-email-sandeen@sandeen.net>
 <20181215105155.GD1575@lst.de>
 <37aec6a5-d846-eca1-1708-bf80ea63c463@sandeen.net>
 <20181218180617.GB15138@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218180617.GB15138@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Dec 18, 2018 at 07:06:17PM +0100, Christoph Hellwig wrote:
> On Mon, Dec 17, 2018 at 05:45:10PM -0600, Eric Sandeen wrote:
> > Then we should hard code "512" in iomap_page_create I guess.  Just need
> > consistency.
> 
> Fine with me.

Please don't just hardcode 512 here.  AFAICT the usage in iomap.c seems
to be "minimum expected fs block size" so that the iop's uptodate bitmap
is sized to handle the worst case blocks-per-page.

Can we please have a "#define IOMAP_MIN_FS_BLOCKSIZE SECTOR_SIZE" to
capture the intent behind the 512?  Or, if you don't want to require all
includers of iomap.h to also have to include blkdev.h, define it to 512
and have a BUILD_BUG_ON somewhere so that we don't leave a subtle bug if
we ever change SECTOR_SIZE?

--D
