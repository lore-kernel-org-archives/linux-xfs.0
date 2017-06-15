Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:38820 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751908AbdFOLMD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 07:12:03 -0400
Date: Thu, 15 Jun 2017 12:11:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/10 v11] No wait AIO
Message-ID: <20170615111157.GL31671@ZenIV.linux.org.uk>
References: <20170606111939.27272-1-rgoldwyn@suse.de>
 <20170608073910.GB9292@infradead.org>
 <20170610053441.GD6365@ZenIV.linux.org.uk>
 <58bbe95e-5a4a-4387-3a00-16ed2e861bd3@suse.de>
 <20170613061431.GA11432@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170613061431.GA11432@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com

On Mon, Jun 12, 2017 at 11:14:31PM -0700, Christoph Hellwig wrote:
> On Mon, Jun 12, 2017 at 05:38:13PM -0500, Goldwyn Rodrigues wrote:
> > We had FS_NOWAIT in filesystem type flags (in v3), but retracted it
> > later in v4.
> 
> A per-fs flag is wrong as file_operation may have different
> capabilities.
> 
> > I will work on adding FMODE_AIO_NOWAIT in the meantime.
> 
> If Al prefers that let's go with it for now.  One other thing I'd
> love is a supported flags field in struct file_operations that we
> can compare the flags against.  Al, does that sound good as well?

Which flags are you talking about?  aio ones?  AFAICS, it's the same
kind of thing as "can we lseek?" or "can we read/pread?", etc.
What would that field look like?  Note that some of those might depend
upon the flags passed to open(), so shoving them into file_operations
might mean splitting file_operations instances...  Details, please.
