Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35394 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfFKECF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 00:02:05 -0400
Date: Mon, 10 Jun 2019 21:01:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/8] mm/fs: don't allow writes to immutable files
Message-ID: <20190611040157.GC1872258@magnolia>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
 <155552787330.20411.11893581890744963309.stgit@magnolia>
 <20190610015145.GB3266@mit.edu>
 <20190610044144.GA1872750@magnolia>
 <20190610131417.GD15963@mit.edu>
 <20190610160934.GH1871505@magnolia>
 <20190610204154.GA5466@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610204154.GA5466@mit.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

On Mon, Jun 10, 2019 at 04:41:54PM -0400, Theodore Ts'o wrote:
> On Mon, Jun 10, 2019 at 09:09:34AM -0700, Darrick J. Wong wrote:
> > > I was planning on only taking 8/8 through the ext4 tree.  I also added
> > > a patch which filtered writes, truncates, and page_mkwrites (but not
> > > mmap) for immutable files at the ext4 level.
> > 
> > *Oh*.  I saw your reply attached to the 1/8 patch and thought that was
> > the one you were taking.  I was sort of surprised, tbh. :)
> 
> Sorry, my bad.  I mis-replied to the wrong e-mail message  :-)

Also ... after flailing around with the v2 series I decided that it
would be much less work to refactor all the current implementations to
call a common parameter-checking function, which will hopefully make the
behavior of SETFLAGS and FSSETXATTR more consistent across filesystems.

That makes the immutable series much less code and fewer patches, but
also means that the 8/8 patch isn't needed anymore.

I'm about to send both out.

--D

> > > I *could* take this patch through the mm/fs tree, but I wasn't sure
> > > what your plans were for the rest of the patch series, and it seemed
> > > like it hadn't gotten much review/attention from other fs or mm folks
> > > (well, I guess Brian Foster weighed in).
> > 
> > > What do you think?
> > 
> > Not sure.  The comments attached to the LWN story were sort of nasty,
> > and now that a couple of people said "Oh, well, Debian documented the
> > inconsistent behavior so just let it be" I haven't felt like
> > resurrecting the series for 5.3.
> 
> Ah, I had missed the LWN article.   <Looks>
> 
> Yeah, it's the same set of issues that we had discussed when this
> first came up.  We can go round and round on this one; It's true that
> root can now cause random programs which have a file mmap'ed for
> writing to seg fault, but root has a million ways of killing and
> otherwise harming running application programs, and it's unlikely
> files get marked for immutable all that often.  We just have to pick
> one way of doing things, and let it be same across all the file
> systems.
> 
> My understanding was that XFS had chosen to make the inode immutable
> as soon as the flag is set (as opposed to forbidding new fd's to be
> opened which were writeable), and I was OK moving ext4 to that common
> interpretation of the immmutable bit, even though it would be a change
> to ext4.
> 
> And then when I saw that Amir had included a patch that would cause
> test failures unless that patch series was applied, it seemed that we
> had all thought that the change was a done deal.  Perhaps we should
> have had a more explicit discussion when the test was sent for review,
> but I had assumed it was exclusively a copy_file_range set of tests,
> so I didn't realize it was going to cause ext4 failures.
> 
>      	    	       	   	 - Ted
