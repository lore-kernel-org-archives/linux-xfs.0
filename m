Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33364 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751778AbdHALCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2017 07:02:44 -0400
Date: Tue, 1 Aug 2017 04:02:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Message-ID: <20170801110241.GE6742@infradead.org>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170728093821.GB29433@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Andy Lutomirski <luto@kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, linux-xfs@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Fri, Jul 28, 2017 at 11:38:21AM +0200, Jan Kara wrote:
> Well, you are right I can make the implementation work with struct file
> flag as well - let's call it O_DAXDSYNC. However there are filesystem
> operations where you may need to answer question: Is there any fd with
> O_DAXDSYNC open against this inode (for operations that change file offset
> -> block mapping)? And in that case inode flag is straightforward while
> file flag is a bit awkward (you need to implement counter of fd's with that
> flag in the inode).

We can still keep and inode flag as the internal implementation
detail.  As mentioned earlier the right flag to control behavior
of a mapping is an mmap flag.  And the initial naive implementation
would simply mark the inode as sync once the first MAP_SYNC open happens
on it.  We could then move to more precise tracking if/when needed.
