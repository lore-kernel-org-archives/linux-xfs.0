Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55008 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751886AbdGEPXF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jul 2017 11:23:05 -0400
Date: Wed, 5 Jul 2017 17:22:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: generic/232 regression - bda250db ("xfs: rewrite
        xfs_dq_get_next_id using xfs_iext_lookup_extent")
Message-ID: <20170705152259.GA2593@lst.de>
References: <20170705151158.GC51285@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170705151158.GC51285@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>

Thanks Brian,

your fix looks correct to me.  I usually got for curly braces on
both sides of the else if they are needed, but thay might be a bit
too nitpicky..
