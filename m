Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33533 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbdFMGOg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jun 2017 02:14:36 -0400
Date: Mon, 12 Jun 2017 23:14:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/10 v11] No wait AIO
Message-ID: <20170613061431.GA11432@infradead.org>
References: <20170606111939.27272-1-rgoldwyn@suse.de>
 <20170608073910.GB9292@infradead.org>
 <20170610053441.GD6365@ZenIV.linux.org.uk>
 <58bbe95e-5a4a-4387-3a00-16ed2e861bd3@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58bbe95e-5a4a-4387-3a00-16ed2e861bd3@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com

On Mon, Jun 12, 2017 at 05:38:13PM -0500, Goldwyn Rodrigues wrote:
> We had FS_NOWAIT in filesystem type flags (in v3), but retracted it
> later in v4.

A per-fs flag is wrong as file_operation may have different
capabilities.

> I will work on adding FMODE_AIO_NOWAIT in the meantime.

If Al prefers that let's go with it for now.  One other thing I'd
love is a supported flags field in struct file_operations that we
can compare the flags against.  Al, does that sound good as well?

> 
> Thanks,
> 
> -- 
> Goldwyn
---end quoted text---
