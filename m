Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48005 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164024AbdAIR4P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Jan 2017 12:56:15 -0500
Date: Mon, 9 Jan 2017 18:56:13 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/5] xfs: fix bogus minleft manipulations
Message-ID: <20170109175613.GA2863@lst.de>
References: <1482436822-31546-1-git-send-email-hch@lst.de> <1482436822-31546-4-git-send-email-hch@lst.de> <20170104181933.GC41989@bfoster.bfoster> <20170108103611.GC26451@lst.de> <20170108160935.GC62847@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170108160935.GC62847@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Sun, Jan 08, 2017 at 11:09:35AM -0500, Brian Foster wrote:
> In this particular case, I think it's probably safer to defer the
> removal of the entire bmbt_alloc_block() hunk to that audit that will
> take into consideration the broader context. IOWs, take the same
> approach in bmbt_alloc_block() as you have in xfs_bmap_btalloc().

Ok, will do.
