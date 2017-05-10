Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41035 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753597AbdEJNqq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 09:46:46 -0400
Date: Wed, 10 May 2017 15:46:36 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 14/27] fs: new infrastructure for writeback error
 handling and reporting
Message-ID: <20170510134636.GA3883@quack2.suse.cz>
References: <20170509154930.29524-1-jlayton@redhat.com>
 <20170509154930.29524-15-jlayton@redhat.com>
 <20170510114840.GF25137@quack2.suse.cz>
 <1494418790.2688.7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494418790.2688.7.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

On Wed 10-05-17 08:19:50, Jeff Layton wrote:
> On Wed, 2017-05-10 at 13:48 +0200, Jan Kara wrote:
> > On Tue 09-05-17 11:49:17, Jeff Layton wrote:
> > > diff --git a/fs/file_table.c b/fs/file_table.c
> > > index 954d510b765a..d6138b6411ff 100644
> > > --- a/fs/file_table.c
> > > +++ b/fs/file_table.c
> > > @@ -168,6 +168,7 @@ struct file *alloc_file(const struct path *path, fmode_t mode,
> > >  	file->f_path = *path;
> > >  	file->f_inode = path->dentry->d_inode;
> > >  	file->f_mapping = path->dentry->d_inode->i_mapping;
> > > +	file->f_wb_err = filemap_sample_wb_error(file->f_mapping);
> > 
> > Why do you sample here when you also sample in do_dentry_open()? I didn't
> > find any alloc_file() callers that would possibly care about writeback
> > errors... 
> > 
> > 								Honza
> 
> I basically used the setting of f_mapping as a guideline as to where to
> sample it for initialization. My thinking was that if f_mapping ever
> ended up different then you'd probably also want f_wb_err to be
> resampled anyway.

OK, makes sense.

> I can drop this hunk if you think we don't need it.

I don't really care. I was just wondering whether I'm missing something...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
