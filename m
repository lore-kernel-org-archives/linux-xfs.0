Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60942 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdAXRaa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 12:30:30 -0500
Date: Tue, 24 Jan 2017 09:30:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/122: reduce xfs_dsb_t size
Message-ID: <20170124173027.GA30053@infradead.org>
References: <20170124170819.GP14033@birch.djwong.org>
 <20170124170930.GA24572@infradead.org>
 <cc480f83-5d14-fbeb-f56d-be4dbd002b01@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc480f83-5d14-fbeb-f56d-be4dbd002b01@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jan 24, 2017 at 11:11:35AM -0600, Eric Sandeen wrote:
> Philosophically (I'm good at that) how do we handle tests like this
> that really only work on the latest version of the code, but don't
> actually indicate a bug if it fails on something older?

That might be another argument for doing the smaller than check that
Darrick suggested.  Or an argument for simply stopping to check xfs_dsb,
it's growing constantly.  Checking the offsets of known fields IFF
present wold seem more useful.
