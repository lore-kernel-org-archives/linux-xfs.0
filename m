Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60852 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbcLFNt1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 08:49:27 -0500
Date: Tue, 6 Dec 2016 05:48:47 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161206134847.GA10181@infradead.org>
References: <20161205092112.GS29149@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161205092112.GS29149@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

Hi Eryu,

my attempts at reproducing this are still not very reliable, someimes
it takes three iterations, sometimes it's doing fine for 100+.

Can you try reverting commit 0af32fb46 ("xfs: fix bogus space
reservation in xfs_iomap_write_allocate") and give this a spin on your
test setup?  I wonder if somehow our accounting for the case where
we convert from inline extents to the btree format is not correct,
and the code before that commit was papering over that fact.
