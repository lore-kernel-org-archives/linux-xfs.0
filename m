Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51169 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752839AbdF0PVZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2017 11:21:25 -0400
Date: Tue, 27 Jun 2017 08:20:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 16/22] block: convert to errseq_t based writeback
 error tracking
Message-ID: <20170627152000.GA29664@infradead.org>
References: <20170616193427.13955-1-jlayton@redhat.com>
 <20170616193427.13955-17-jlayton@redhat.com>
 <20170620123544.GC19781@infradead.org>
 <1497980684.4555.16.camel@redhat.com>
 <20170624115946.GA22561@infradead.org>
 <1498310166.4796.4.camel@redhat.com>
 <1498487658.5168.8.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498487658.5168.8.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Mon, Jun 26, 2017 at 10:34:18AM -0400, Jeff Layton wrote:
> The bigger question is -- what about more complex filesystems like
> ext4?  There are a couple of cases where we can return -EIO or -EROFS on
> fsync before filemap_write_and_wait_range is ever called. Like this one
> for instance:
> 
>         if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
>                 return -EIO;
> 
> ...and the EXT4_MF_FS_ABORTED case.
> 
> Are those conditions ever recoverable, such that a later fsync could
> succeed? IOW, could I do a remount or something such that the existing
> fds are left open and become usable again? 

This looks copied from the xfs forced shutdown code, and in that
case it's final and permanent - you'll need an unmount to
clear it.

> If so, then we really ought to advance the errseq_t in the file when we
> catch those cases as well. If we have to do that, then it probably makes
> sense to leave the ext4 patch as-is.

I think it can switch to the new file helper.
