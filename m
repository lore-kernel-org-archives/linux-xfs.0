Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46952 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752274AbcKRIUt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Nov 2016 03:20:49 -0500
Date: Fri, 18 Nov 2016 09:20:47 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/14] xfs: use new extent lookup helpers
        xfs_file_iomap_begin_delay
Message-ID: <20161118082047.GC28286@lst.de>
References: <1479143565-30615-1-git-send-email-hch@lst.de> <1479143565-30615-8-git-send-email-hch@lst.de> <20161117183330.GI49658@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161117183330.GI49658@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Nov 17, 2016 at 01:33:30PM -0500, Brian Foster wrote:
> My cow prealloc series is going to end up adding this right back, fwiw.
> Though at that point it's not really "prev" as used throughout the
> extent manipulation code, but rather just an extent on which to base the
> initial prealloc size.

Oh, well.  I could keep the argument for now, but doing the lookups
in the caller just for the prev value that's not even always used
seems a little silly.
