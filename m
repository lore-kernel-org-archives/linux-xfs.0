Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:32773 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751819AbdF2UcN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2017 16:32:13 -0400
Received: by mail-qk0-f196.google.com with SMTP id p21so13097305qke.0
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2017 13:32:10 -0700 (PDT)
Message-ID: <1498768325.5710.6.camel@poochiereds.net>
Subject: Re: [PATCH v8 18/18] btrfs: minimal conversion to errseq_t
 writeback error reporting on fsync
From: Jeff Layton <jlayton@poochiereds.net>
Date: Thu, 29 Jun 2017 16:32:05 -0400
In-Reply-To: <20170629141741.GC17251@infradead.org>
References: <20170629131954.28733-1-jlayton@kernel.org>
         <20170629131954.28733-19-jlayton@kernel.org>
         <20170629141741.GC17251@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, jlayton@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Liu Bo <bo.li.liu@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Thu, 2017-06-29 at 07:17 -0700, Christoph Hellwig wrote:
> On Thu, Jun 29, 2017 at 09:19:54AM -0400, jlayton@kernel.org wrote:
> > From: Jeff Layton <jlayton@redhat.com>
> > 
> > Just check and advance the errseq_t in the file before returning.
> > Internal callers of filemap_* functions are left as-is.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  fs/btrfs/file.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index da1096eb1a40..1f57e1a523d9 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -2011,7 +2011,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> >  	struct btrfs_root *root = BTRFS_I(inode)->root;
> >  	struct btrfs_trans_handle *trans;
> >  	struct btrfs_log_ctx ctx;
> > -	int ret = 0;
> > +	int ret = 0, err;
> >  	bool full_sync = 0;
> >  	u64 len;
> >  
> > @@ -2030,7 +2030,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> >  	 */
> >  	ret = start_ordered_ops(inode, start, end);
> >  	if (ret)
> > -		return ret;
> > +		goto out;
> >  
> >  	inode_lock(inode);
> >  	atomic_inc(&root->log_batch);
> > @@ -2227,6 +2227,9 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> >  		ret = btrfs_end_transaction(trans);
> >  	}
> >  out:
> > +	err = file_check_and_advance_wb_err(file);
> > +	if (!ret)
> > +		ret = err;
> >  	return ret > 0 ? -EIO : ret;
> 
> This means that we'll lose the exact error returned from
> start_ordered_ops.  Beyond that I can't really provide good feedback
> as the btrfs fsync code looks so much different from all the other
> fs fsync code..

Well, no...we'll keep the error from start_ordered_ops if there was one.
 We just advance the cursor past any stored error in that case without
returning it.

I have another fix for this patch too: there's a call to
filemap_check_errors in this function that I think should probably use
filemap_check_wb_err instead. Fixed in my tree.

I do agree though that while this works in my testing I'd like the btrfs
guys to ACK this as I don't fully grok the btrfs fsync code at all.
-- 
Jeff Layton <jlayton@poochiereds.net>
