Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60681 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389538AbfFJUmC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 16:42:02 -0400
Date: Mon, 10 Jun 2019 16:41:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/8] mm/fs: don't allow writes to immutable files
Message-ID: <20190610204154.GA5466@mit.edu>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
 <155552787330.20411.11893581890744963309.stgit@magnolia>
 <20190610015145.GB3266@mit.edu>
 <20190610044144.GA1872750@magnolia>
 <20190610131417.GD15963@mit.edu>
 <20190610160934.GH1871505@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610160934.GH1871505@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

On Mon, Jun 10, 2019 at 09:09:34AM -0700, Darrick J. Wong wrote:
> > I was planning on only taking 8/8 through the ext4 tree.  I also added
> > a patch which filtered writes, truncates, and page_mkwrites (but not
> > mmap) for immutable files at the ext4 level.
> 
> *Oh*.  I saw your reply attached to the 1/8 patch and thought that was
> the one you were taking.  I was sort of surprised, tbh. :)

Sorry, my bad.  I mis-replied to the wrong e-mail message  :-)

> > I *could* take this patch through the mm/fs tree, but I wasn't sure
> > what your plans were for the rest of the patch series, and it seemed
> > like it hadn't gotten much review/attention from other fs or mm folks
> > (well, I guess Brian Foster weighed in).
> 
> > What do you think?
> 
> Not sure.  The comments attached to the LWN story were sort of nasty,
> and now that a couple of people said "Oh, well, Debian documented the
> inconsistent behavior so just let it be" I haven't felt like
> resurrecting the series for 5.3.

Ah, I had missed the LWN article.   <Looks>

Yeah, it's the same set of issues that we had discussed when this
first came up.  We can go round and round on this one; It's true that
root can now cause random programs which have a file mmap'ed for
writing to seg fault, but root has a million ways of killing and
otherwise harming running application programs, and it's unlikely
files get marked for immutable all that often.  We just have to pick
one way of doing things, and let it be same across all the file
systems.

My understanding was that XFS had chosen to make the inode immutable
as soon as the flag is set (as opposed to forbidding new fd's to be
opened which were writeable), and I was OK moving ext4 to that common
interpretation of the immmutable bit, even though it would be a change
to ext4.

And then when I saw that Amir had included a patch that would cause
test failures unless that patch series was applied, it seemed that we
had all thought that the change was a done deal.  Perhaps we should
have had a more explicit discussion when the test was sent for review,
but I had assumed it was exclusively a copy_file_range set of tests,
so I didn't realize it was going to cause ext4 failures.

     	    	       	   	 - Ted
