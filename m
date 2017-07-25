Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58373 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751515AbdGYMPY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 08:15:24 -0400
Date: Tue, 25 Jul 2017 14:15:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 1/5] mm: add vm_insert_mixed_mkwrite()
Message-ID: <20170725121522.GA13457@lst.de>
References: <20170724170616.25810-1-ross.zwisler@linux.intel.com> <20170724170616.25810-2-ross.zwisler@linux.intel.com> <20170724221400.pcq5zvke7w2yfkxi@node.shutemov.name> <20170725080158.GA5374@lst.de> <20170725093508.GA19943@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170725093508.GA19943@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, "Kirill A. Shutemov" <kirill@shutemov.name>, Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Tue, Jul 25, 2017 at 11:35:08AM +0200, Jan Kara wrote:
> On Tue 25-07-17 10:01:58, Christoph Hellwig wrote:
> > On Tue, Jul 25, 2017 at 01:14:00AM +0300, Kirill A. Shutemov wrote:
> > > I guess it's up to filesystem if it wants to reuse the same spot to write
> > > data or not. I think your assumptions works for ext4 and xfs. I wouldn't
> > > be that sure for btrfs or other filesystems with CoW support.
> > 
> > Or XFS with reflinks for that matter.  Which currently can't be
> > combined with DAX, but I had a somewhat working version a few month
> > ago.
> 
> But in cases like COW when the block mapping changes, the process
> must run unmap_mapping_range() before installing the new PTE so that all
> processes mapping this file offset actually refault and see the new
> mapping. So this would go through pte_none() case. Am I missing something?

Yes, for DAX COW mappings we'd probably need something like this, unlike
the pagecache COW handling for which only the underlying block change,
but not the page.
