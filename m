Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:32847 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751123AbdDLNwc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Apr 2017 09:52:32 -0400
Date: Wed, 12 Apr 2017 15:52:31 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: transaction reservations for deleting of shared extents
Message-ID: <20170412135231.GA3891@lst.de>
References: <20170220072945.GA17608@lst.de> <20170221014356.GA5844@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221014356.GA5844@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

I think the problem is that t_log_res just contains the log reservation
when the transaction was created.  But each item processed by
xfs_defer_finish uses up some of it, but in some cases these might
be different operations and not just more refcount updates, e.g. for
xfs_itruncate_extents which I see the issues with we mix EFI/EFD
items with refcount updates.

I still don't have a good idea how to fix this, though.  One idea
would be to prevent mixing different items, but I think being able
to mix them was one of your goals with the defer infrastructure rewrite.
