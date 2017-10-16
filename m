Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52738 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752743AbdJPSuc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Oct 2017 14:50:32 -0400
Date: Mon, 16 Oct 2017 14:50:21 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: kernel BUG at fs/xfs/xfs_aops.c:853! in kernel 4.13 rc6
Message-ID: <20171016185021.vfvktef45cjai4te@thunk.org>
References: <CABXGCsMorRzy-dJrjTO6sP80BSb0RAeMhF3QGwSkk50m7VYzOA@mail.gmail.com>
 <CABXGCsOeex62Y4qQJwvMJ+fJ+MnKyKGDj9eRbKemeMVWo5huKw@mail.gmail.com>
 <20171009000529.GY3666@dastard>
 <20171009183129.GE11645@wotan.suse.de>
 <87wp442lgm.fsf@xmission.com>
 <8729041d-05e5-6bea-98db-7f265edde193@suse.de>
 <20171015130625.o5k6tk5uflm3rx65@thunk.org>
 <87efq4qcry.fsf@xmission.com>
 <20171016011301.dcam44qylno7rm6a@thunk.org>
 <87zi8rkmha.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zi8rkmha.fsf@xmission.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Aleksa Sarai <asarai@suse.de>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Dave Chinner <david@fromorbit.com>, =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?= <mikhail.v.gavrilov@gmail.com>, Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@infradead.org>, linux-mm@kvack.org, Oscar Salvador <osalvador@suse.com>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>, linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 12:53:53PM -0500, Eric W. Biederman wrote:
> I would prefer that we start with what we can do easily.  There is a
> danger in working on revoke like actions that a high cost will be paid
> to get nice semantics for a rare case.

Users wanting to remove a USB thumb drives do *not* seem like a rare
case to me....  and disconnecting from the backing store without
corrupting the file system is not necessarily trivial.

> We can easily before that request that the filesystem be remounted
> read-only.  We may not succeed (as someone may have something open for
> write) but that code path exists and it is easy to use.
> 
> Tracking down all instances of struct file and all instances of struct
> path that reference a filesystem is expensive today, and expensive to
> add a list to do.  So I don't know that we want to do that.

It's not that expensive.  After all, system administsrators are
running lsof all the time to work around this sort of problem.  And
doing this kind forced unmount is not a high-performance critical
path.  And just like what a human system administrator will be doing,
if there are no struct files holding the file system open, we won't
need to scan all of the struct files.  If there is something holding
the file system busy, either the kernel is going to have to scan all
of struct files, or we are going to be forcing the system
adminsitrator to paw through all of /proc/*/fd/* and /proc/*/mounts
looking for the needle in the haystack.

I claim it's ***always*** going to be faster to do it in the kernel
than forcing the system administrator to suck the information through
the thin straw which is /proc/*/mounts and /proc/*/fd/*.

    	       	     		       	   - Ted
