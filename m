Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57406 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750824AbdGYICA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 04:02:00 -0400
Date: Tue, 25 Jul 2017 10:01:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 1/5] mm: add vm_insert_mixed_mkwrite()
Message-ID: <20170725080158.GA5374@lst.de>
References: <20170724170616.25810-1-ross.zwisler@linux.intel.com> <20170724170616.25810-2-ross.zwisler@linux.intel.com> <20170724221400.pcq5zvke7w2yfkxi@node.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170724221400.pcq5zvke7w2yfkxi@node.shutemov.name>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Tue, Jul 25, 2017 at 01:14:00AM +0300, Kirill A. Shutemov wrote:
> I guess it's up to filesystem if it wants to reuse the same spot to write
> data or not. I think your assumptions works for ext4 and xfs. I wouldn't
> be that sure for btrfs or other filesystems with CoW support.

Or XFS with reflinks for that matter.  Which currently can't be
combined with DAX, but I had a somewhat working version a few month
ago.
