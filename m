Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:51506 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388848AbfFJNOd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 09:14:33 -0400
Date: Mon, 10 Jun 2019 09:14:17 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/8] mm/fs: don't allow writes to immutable files
Message-ID: <20190610131417.GD15963@mit.edu>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
 <155552787330.20411.11893581890744963309.stgit@magnolia>
 <20190610015145.GB3266@mit.edu>
 <20190610044144.GA1872750@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610044144.GA1872750@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

On Sun, Jun 09, 2019 at 09:41:44PM -0700, Darrick J. Wong wrote:
> On Sun, Jun 09, 2019 at 09:51:45PM -0400, Theodore Ts'o wrote:
> > On Wed, Apr 17, 2019 at 12:04:33PM -0700, Darrick J. Wong wrote:
>
> > Shouldn't this check be moved before the modification of vmf->flags?
> > It looks like do_page_mkwrite() isn't supposed to be returning with
> > vmf->flags modified, lest "the caller gets surprised".
> 
> Yeah, I think that was a merge error during a rebase... :(
> 
> Er ... if you're still planning to take this patch through your tree,
> can you move it to above the "vmf->flags = FAULT_FLAG_WRITE..." ?

I was planning on only taking 8/8 through the ext4 tree.  I also added
a patch which filtered writes, truncates, and page_mkwrites (but not
mmap) for immutable files at the ext4 level.

I *could* take this patch through the mm/fs tree, but I wasn't sure
what your plans were for the rest of the patch series, and it seemed
like it hadn't gotten much review/attention from other fs or mm folks
(well, I guess Brian Foster weighed in).

What do you think?

						- Ted
