Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57939 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbdAXTuw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 14:50:52 -0500
Date: Tue, 24 Jan 2017 20:50:50 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: use per-AG reservations for the finobt
Message-ID: <20170124195050.GA1025@lst.de>
References: <1485194742-23185-1-git-send-email-hch@lst.de> <20170123192847.GM12985@birch.djwong.org> <20170124140247.GA26149@lst.de> <20170124164837.GI4780@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124164837.GI4780@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 08:48:37AM -0800, Darrick J. Wong wrote:
> I'd just print out:
> 
> "Per-AG reservation for AG ${agno} failed.  Filesystem may run out of space."

Sure, I can do that.

> 
> if any of the (now three) invocations of __xfs_ag_resv_init() returns
> ENOSPC, since the AG is more than 98% full.  Some day, a sysadmin could
> then use the fsmap data to identify which inodes are using the most
> space in that AG and arrange to migrate/remove/etc the data to another
> AG.

But for all but the reflink one this can't happen as the reservations
have been there since the beginning.  And if they fail neverless we fail
the mount.  Or am I missing something here?
