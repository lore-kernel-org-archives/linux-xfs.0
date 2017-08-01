Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45498 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751784AbdHAL0G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 07:26:06 -0400
Date: Tue, 1 Aug 2017 13:26:03 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Message-ID: <20170801112603.GG4215@quack2.suse.cz>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz>
 <20170801110241.GE6742@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170801110241.GE6742@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, linux-xfs@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Tue 01-08-17 04:02:41, Christoph Hellwig wrote:
> On Fri, Jul 28, 2017 at 11:38:21AM +0200, Jan Kara wrote:
> > Well, you are right I can make the implementation work with struct file
> > flag as well - let's call it O_DAXDSYNC. However there are filesystem
> > operations where you may need to answer question: Is there any fd with
> > O_DAXDSYNC open against this inode (for operations that change file offset
> > -> block mapping)? And in that case inode flag is straightforward while
> > file flag is a bit awkward (you need to implement counter of fd's with that
> > flag in the inode).
> 
> We can still keep and inode flag as the internal implementation
> detail.  As mentioned earlier the right flag to control behavior
> of a mapping is an mmap flag.  And the initial naive implementation
> would simply mark the inode as sync once the first MAP_SYNC open happens
> on it.  We could then move to more precise tracking if/when needed.

OK, makes sense and I like the MAP_SYNC proposal. I'll change it in my
implementation.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
