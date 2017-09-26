Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:47425 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754506AbdIZVGs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Sep 2017 17:06:48 -0400
Date: Tue, 26 Sep 2017 15:06:45 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 6/7] mm, fs: introduce file_operations->post_mmap()
Message-ID: <20170926210645.GA7798@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-7-ross.zwisler@linux.intel.com>
 <CAPcyv4jtO028KeZK7SdkOUsgMLGqgttLzBCYgH0M+RP3eAXf4A@mail.gmail.com>
 <20170926185751.GB31146@linux.intel.com>
 <CAPcyv4iVc9y8PE24ZvkiBYdp4Die0Q-K5S6QexW_6YQ_M0F4QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iVc9y8PE24ZvkiBYdp4Die0Q-K5S6QexW_6YQ_M0F4QA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-xfs@vger.kernel.org

On Tue, Sep 26, 2017 at 12:19:21PM -0700, Dan Williams wrote:
> On Tue, Sep 26, 2017 at 11:57 AM, Ross Zwisler
<>
> > This decision can only be made (in this
> > proposed scheme) *after* the inode->i_mapping->i_mmap  tree has been
> > populated, which means we need another call into the filesystem after this
> > insertion has happened.
> 
> I get that, but it seems over-engineered and something that can also
> be safely cleaned up after the fact by the code path that is disabling
> DAX.

I don't think you can safely clean it up after the fact because some thread
might have already called ->mmap() to set up the vma->vm_flags for their new
mapping, but they haven't added it to inode->i_mapping->i_mmap.

The inode->i_mapping->i_mmap tree is the only way (that I know of at least)
that the filesystem has any idea about about the mapping.  This is the method
by which we would try and clean up mapping flags, if we were to do so, and
it's the only way that the filesystem can know whether or not mappings exist.

The only way that I could think of to make this safely work is to have the
insertion into the inode->i_mapping->i_mmap tree be our sync point.  After
that the filesystem and the mapping code can communicate on the state of DAX,
but before that I think it's basically indeterminate.
