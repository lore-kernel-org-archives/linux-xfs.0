Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58357 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750861AbdBTH3r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Feb 2017 02:29:47 -0500
Date: Mon, 20 Feb 2017 08:29:45 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: transaction reservations for deleting of shared extents
Message-ID: <20170220072945.GA17608@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Hi Darrick,

I got a bug report about running out of log reservations when deleting
heavily reflinked files.

We're hitting the ASSERT(tp->t_ticket->t_curr_res >= len) in
xlog_cil_insert_items and it seems we are way above the reservation.

I started auditing the issue and it seems like we don't account for
the refcountbt adjustments at all in tr_itruncate.  Do you have any
back of the napking math around for what amount of log reservations
we should need for them?  Otherwise I'll need to wade through the
code and recreate that math.
