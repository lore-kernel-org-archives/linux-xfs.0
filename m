Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57997 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752852AbdF2OTv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2017 10:19:51 -0400
Date: Thu, 29 Jun 2017 07:19:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v8 03/18] fs: check for writeback errors after syncing
 out buffers in generic_file_fsync
Message-ID: <20170629141933.GE17251@infradead.org>
References: <20170629131954.28733-1-jlayton@kernel.org>
 <20170629131954.28733-4-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170629131954.28733-4-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jlayton@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, Liu Bo <bo.li.liu@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Thu, Jun 29, 2017 at 09:19:39AM -0400, jlayton@kernel.org wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> ext2 currently does a test+clear of the AS_EIO flag, which is
> is problematic for some coming changes.
> 
> What we really need to do instead is call filemap_check_errors
> in __generic_file_fsync after syncing out the buffers. That
> will be sufficient for this case, and help other callers detect
> these errors properly as well.
> 
> With that, we don't need to twiddle it in ext2.

Seems like much of this code is getting replaced later in the
series..
