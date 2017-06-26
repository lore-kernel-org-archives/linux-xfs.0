Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33618 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbdFZJuK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2017 05:50:10 -0400
Date: Mon, 26 Jun 2017 02:50:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/6] SEEK_HOLE / SEEK_DATA via iomap
Message-ID: <20170626095010.GA14057@infradead.org>
References: <1498224884-346-1-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498224884-346-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>

On Fri, Jun 23, 2017 at 03:34:38PM +0200, Andreas Gruenbacher wrote:
> These patches, on top of the page_cache_seek_hole_data patches posted earlier
> today, convert xfs to implement SEEK_HOLE / SEEK_DATA via iomap, and implement
> SEEK_HOLE / SEEK_DATA via iomap in gfs2.

Please send those as one series - in fact to me the previous
series doesn't even make sense - just introduce page_cache_seek_hole_data
for the iomap code only as everyone shoulkd be using that.

> ext4 doesn't implement IOMAP_REPORT, so it can't be switched to use the iomap
> based SEEK_HOLE / SEEK_DATA or fiemap code so far.

Just treat it as a no-op, it only really matters for the reflink case.
