Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751383AbdFZIXX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jun 2017 04:23:23 -0400
Date: Mon, 26 Jun 2017 10:23:15 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v7 05/22] jbd2: don't clear and reset errors after
 waiting on writeback
Message-ID: <20170626082315.kun5momxqodrrm67@eorzea.usersys.redhat.com>
References: <20170616193427.13955-1-jlayton@redhat.com>
 <20170616193427.13955-6-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170616193427.13955-6-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Jun 16, 2017 at 03:34:10PM -0400, Jeff Layton wrote:
> Resetting this flag is almost certainly racy, and will be problematic
> with some coming changes.
> 
> Make filemap_fdatawait_keep_errors return int, but not clear the flag(s).
> Have jbd2 call it instead of filemap_fdatawait and don't attempt to
> re-set the error flag if it fails.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/jbd2/commit.c   | 15 +++------------
>  include/linux/fs.h |  2 +-
>  mm/filemap.c       | 16 ++++++++++++++--
>  3 files changed, 18 insertions(+), 15 deletions(-)
> 
I'm not too experienced with jbd2 internals, but this patch is clear enough:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos
