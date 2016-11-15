Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60158 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751971AbcKOQwp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Nov 2016 11:52:45 -0500
Date: Tue, 15 Nov 2016 17:52:44 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] xfs: use iomap_dio_rw
Message-ID: <20161115165244.GB1490@lst.de>
References: <1479064054-10474-1-git-send-email-hch@lst.de> <1479064054-10474-6-git-send-email-hch@lst.de> <20161115153418.GB65218@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161115153418.GB65218@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

> > -	/* DIO must be aligned to device logical sector size */
> > -	if ((iocb->ki_pos | count) & target->bt_logical_sectormask) {
> > -		if (iocb->ki_pos == isize)
> > -			return 0;
> > -		return -EINVAL;
> > -	}
> 
> Do we not still need this, or is it checked elsewhere?
> 
> The rest looks sane to me, but I need to test and I haven't grabbed your
> tree yet..

iomap_dio_actor checks it.
